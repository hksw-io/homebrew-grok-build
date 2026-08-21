#!/usr/bin/env python3

from __future__ import annotations

import argparse
import hashlib
import http.client
import json
import os
import re
import subprocess
import sys
import time
import urllib.error
import urllib.request
from concurrent.futures import ThreadPoolExecutor, as_completed
from dataclasses import dataclass
from pathlib import Path
from typing import Any


REPO_ROOT = Path(__file__).resolve().parents[1]
TAP_REPO = os.environ.get("TAP_REPO", "hksw-io/homebrew-grok-build")
GIT_BRANCH = os.environ.get("GIT_BRANCH", "main")
GH_TOKEN = os.environ.get("GH_TOKEN") or os.environ.get("GITHUB_TOKEN")
GIT_USER_NAME = os.environ.get("GIT_USER_NAME")
GIT_USER_EMAIL = os.environ.get("GIT_USER_EMAIL")
API_BASE = "https://api.github.com"
PRIMARY_BASE_URL = "https://x.ai/cli"
FALLBACK_BASE_URL = "https://storage.googleapis.com/grok-build-public-artifacts/cli"
STABLE_MARKER_URLS = (
    f"{PRIMARY_BASE_URL}/stable",
    f"{FALLBACK_BASE_URL}/stable",
)
RETRYABLE_HTTP_CODES = {403, 408, 429, 500, 502, 503, 504}
REQUIRED_ASSETS = {
    "arm": "macos-aarch64",
    "intel": "macos-x86_64",
    "arm64_linux": "linux-aarch64",
    "x86_64_linux": "linux-x86_64",
}
VERSION_RE = re.compile(r"^(?P<major>\d+)\.(?P<minor>\d+)\.(?P<patch>\d+)$")
CASK_VERSION_RE = re.compile(r'^\s*version "([^"]+)"', re.MULTILINE)


@dataclass(frozen=True)
class ReleaseInfo:
    version: str
    sha256: dict[str, str]

    @property
    def tag_name(self) -> str:
        return f"v{self.version}"

    @property
    def cask_token(self) -> str:
        return "grok-build"

    @property
    def cask_path(self) -> Path:
        return REPO_ROOT / "Casks" / "grok-build.rb"

    @property
    def version_key(self) -> tuple[int, int, int]:
        return version_key(self.version)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Mirror Grok Build stable-channel releases into this tap.")
    parser.add_argument("--dry-run", action="store_true", help="Do not write files, commit, push, or create releases.")
    parser.add_argument("--verbose", action="store_true", help="Print extra progress information.")
    return parser.parse_args()


def git(
    *args: str,
    capture_output: bool = True,
    check: bool = True,
    env: dict[str, str] | None = None,
) -> subprocess.CompletedProcess[str]:
    process_env = os.environ.copy()
    if env:
        process_env.update(env)
    return subprocess.run(
        ["git", *args],
        cwd=REPO_ROOT,
        check=check,
        text=True,
        capture_output=capture_output,
        env=process_env,
    )


def log(message: str) -> None:
    print(message, flush=True)


def debug(enabled: bool, message: str) -> None:
    if enabled:
        log(message)


def retry_delay(exc: urllib.error.HTTPError | None, attempt: int) -> int:
    if exc is not None and exc.code in (403, 429):
        retry_after = exc.headers.get("Retry-After") if exc.headers else None
        if retry_after:
            return max(1, int(retry_after))
    return max(1, 2**attempt)


def http_request_text(url: str) -> str:
    headers = {"User-Agent": "hksw-io-homebrew-grok-build-updater"}
    last_error: Exception | None = None
    for attempt in range(5):
        request = urllib.request.Request(url, headers=headers)
        try:
            with urllib.request.urlopen(request, timeout=30) as response:
                return response.read().decode("utf-8")
        except urllib.error.HTTPError as exc:
            if exc.code not in RETRYABLE_HTTP_CODES:
                details = exc.read().decode("utf-8", errors="replace")
                raise RuntimeError(f"HTTP request failed: {exc.code} {url}: {details}") from exc
            time.sleep(retry_delay(exc, attempt))
            last_error = exc
        except (
            http.client.IncompleteRead,
            urllib.error.URLError,
            TimeoutError,
            ConnectionError,
            UnicodeDecodeError,
        ) as exc:
            time.sleep(retry_delay(None, attempt))
            last_error = exc
    raise RuntimeError(f"HTTP request kept failing for {url}") from last_error


def http_request_sha256(url: str) -> str:
    headers = {"User-Agent": "hksw-io-homebrew-grok-build-updater"}
    last_error: Exception | None = None
    for attempt in range(5):
        digest = hashlib.sha256()
        byte_count = 0
        request = urllib.request.Request(url, headers=headers)
        try:
            with urllib.request.urlopen(request, timeout=120) as response:
                while chunk := response.read(1024 * 1024):
                    digest.update(chunk)
                    byte_count += len(chunk)
            if byte_count == 0:
                raise RuntimeError(f"Downloaded empty artifact from {url}")
            return digest.hexdigest()
        except urllib.error.HTTPError as exc:
            if exc.code not in RETRYABLE_HTTP_CODES:
                details = exc.read().decode("utf-8", errors="replace")
                raise RuntimeError(f"HTTP request failed: {exc.code} {url}: {details}") from exc
            time.sleep(retry_delay(exc, attempt))
            last_error = exc
        except (
            http.client.IncompleteRead,
            urllib.error.URLError,
            TimeoutError,
            ConnectionError,
        ) as exc:
            time.sleep(retry_delay(None, attempt))
            last_error = exc
    raise RuntimeError(f"Artifact download kept failing for {url}") from last_error


def api_request(path: str, token: str | None, method: str = "GET", data: dict[str, Any] | None = None) -> Any:
    headers = {
        "Accept": "application/vnd.github+json",
        "X-GitHub-Api-Version": "2022-11-28",
        "User-Agent": "hksw-io-homebrew-grok-build-updater",
    }
    if token:
        headers["Authorization"] = f"Bearer {token}"

    body = None
    if data is not None:
        body = json.dumps(data).encode("utf-8")
        headers["Content-Type"] = "application/json"

    last_error: Exception | None = None
    for attempt in range(5):
        request = urllib.request.Request(f"{API_BASE}{path}", headers=headers, method=method, data=body)
        try:
            with urllib.request.urlopen(request, timeout=30) as response:
                payload = response.read()
            if not payload:
                return None
            return json.loads(payload.decode("utf-8"))
        except urllib.error.HTTPError as exc:
            if exc.code == 422 and path.startswith(f"/repos/{TAP_REPO}/releases"):
                return {"already_exists": True}
            if exc.code in RETRYABLE_HTTP_CODES:
                time.sleep(retry_delay(exc, attempt))
                last_error = exc
                continue
            details = exc.read().decode("utf-8", errors="replace")
            raise RuntimeError(f"GitHub API request failed: {exc.code} {path}: {details}") from exc
        except (
            http.client.IncompleteRead,
            urllib.error.URLError,
            TimeoutError,
            ConnectionError,
            UnicodeDecodeError,
            json.JSONDecodeError,
        ) as exc:
            time.sleep(retry_delay(None, attempt))
            last_error = exc
    raise RuntimeError(f"GitHub API request kept failing for {path}") from last_error


def fetch_latest_version() -> str:
    errors: list[str] = []
    for marker_url in STABLE_MARKER_URLS:
        try:
            version = http_request_text(marker_url).strip()
            version_key(version)
            return version
        except (RuntimeError, ValueError) as exc:
            errors.append(str(exc))
    raise RuntimeError("Could not fetch a valid Grok Build stable marker: " + "; ".join(errors))


def asset_urls(version: str, platform: str) -> tuple[str, str]:
    filename = f"grok-{version}-{platform}"
    return (
        f"{PRIMARY_BASE_URL}/{filename}",
        f"{FALLBACK_BASE_URL}/{filename}",
    )


def fetch_asset_sha256(version: str, platform: str) -> str:
    errors: list[str] = []
    for url in asset_urls(version, platform):
        try:
            return http_request_sha256(url)
        except RuntimeError as exc:
            errors.append(str(exc))
    raise RuntimeError(f"Could not hash Grok Build {version} for {platform}: " + "; ".join(errors))


def fetch_latest_release() -> ReleaseInfo:
    version = fetch_latest_version()
    digests: dict[str, str] = {}
    with ThreadPoolExecutor(max_workers=len(REQUIRED_ASSETS)) as executor:
        futures = {
            executor.submit(fetch_asset_sha256, version, platform): key
            for key, platform in REQUIRED_ASSETS.items()
        }
        for future in as_completed(futures):
            digests[futures[future]] = future.result()
    return ReleaseInfo(version=version, sha256={key: digests[key] for key in REQUIRED_ASSETS})


def version_key(version: str) -> tuple[int, int, int]:
    match = VERSION_RE.fullmatch(version)
    if match is None:
        raise ValueError(f"Unsupported Grok Build release version: {version}")
    return (
        int(match.group("major")),
        int(match.group("minor")),
        int(match.group("patch")),
    )


def release_outranks_active(release: ReleaseInfo, active_version: str | None) -> bool:
    if active_version is None:
        return True
    return release.version_key > version_key(active_version)


def read_active_cask_version() -> str | None:
    path = REPO_ROOT / "Casks" / "grok-build.rb"
    if not path.exists():
        return None

    content = path.read_text(encoding="utf-8")
    match = CASK_VERSION_RE.search(content)
    if match is None:
        raise RuntimeError("Could not determine the active grok-build cask version.")

    version = match.group(1)
    version_key(version)
    return version


def select_release_for_sync(existing_tags: set[str]) -> ReleaseInfo | None:
    version = fetch_latest_version()
    if f"v{version}" in existing_tags:
        return None

    digests: dict[str, str] = {}
    with ThreadPoolExecutor(max_workers=len(REQUIRED_ASSETS)) as executor:
        futures = {
            executor.submit(fetch_asset_sha256, version, platform): key
            for key, platform in REQUIRED_ASSETS.items()
        }
        for future in as_completed(futures):
            digests[futures[future]] = future.result()
    return ReleaseInfo(version=version, sha256={key: digests[key] for key in REQUIRED_ASSETS})


def render_cask(release: ReleaseInfo) -> str:
    return f'''cask "{release.cask_token}" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "{release.version}"
  sha256 arm:          "{release.sha256["arm"]}",
         intel:        "{release.sha256["intel"]}",
         arm64_linux:  "{release.sha256["arm64_linux"]}",
         x86_64_linux: "{release.sha256["x86_64_linux"]}"

  url "{PRIMARY_BASE_URL}/grok-#{{version}}-#{{os}}-#{{arch}}"
  name "Grok Build"
  desc "Extensible coding agent for the terminal"
  homepage "https://x.ai/build", browsed: "2026-08-13"

  livecheck do
    url "{PRIMARY_BASE_URL}/stable"
    regex(/^v?(\\d+(?:\\.\\d+)+)$/i)
  end

  binary "grok-#{{version}}-#{{os}}-#{{arch}}", target: "grok"
  binary "grok-#{{version}}-#{{os}}-#{{arch}}", target: "agent"
  generate_completions_from_executable "grok-#{{version}}-#{{os}}-#{{arch}}", "completions", base_name: "grok"

  zap rmdir: "~/.grok"
end
'''


def ensure_clean_worktree() -> None:
    status = git("status", "--porcelain", "--untracked-files=no").stdout.strip()
    if status:
        raise RuntimeError("Refusing to run with a dirty working tree.")


def ensure_repo_writable() -> None:
    required_paths = [
        REPO_ROOT / "Casks",
        REPO_ROOT / "Casks" / "grok-build.rb",
        REPO_ROOT / ".git" / "config",
        REPO_ROOT / ".git" / "index",
        REPO_ROOT / ".git" / "objects",
        REPO_ROOT / ".git" / "refs" / "heads" / GIT_BRANCH,
    ]
    unwritable: list[str] = []

    for path in required_paths:
        target = path if path.exists() else path.parent
        if not os.access(target, os.W_OK):
            unwritable.append(str(path))

    if unwritable:
        joined = ", ".join(unwritable)
        raise RuntimeError(
            "Repository is not writable by the current user. "
            f"Fix ownership or permissions for: {joined}"
        )


def git_config_value(key: str) -> str | None:
    result = git("config", "--get", key, check=False)
    if result.returncode != 0:
        return None
    value = result.stdout.strip()
    return value or None


def resolve_git_identity() -> tuple[str, str]:
    name = GIT_USER_NAME or git_config_value("user.name")
    email = GIT_USER_EMAIL or git_config_value("user.email")
    if name is None or email is None:
        raise RuntimeError(
            "Git commit identity is not configured. Set GIT_USER_NAME and GIT_USER_EMAIL or configure git user.name and user.email."
        )
    return name, email


def configure_repo(verbose: bool) -> None:
    git_user_name, git_user_email = resolve_git_identity()
    debug(verbose, f"Using git identity {git_user_name} <{git_user_email}>.")
    git("config", "user.name", git_user_name)
    git("config", "user.email", git_user_email)
    try:
        git("remote", "get-url", "origin")
    except subprocess.CalledProcessError:
        return

    debug(verbose, f"Refreshing {GIT_BRANCH} from origin.")
    git("checkout", GIT_BRANCH)
    git("fetch", "origin", "--tags")
    git("pull", "--ff-only", "origin", GIT_BRANCH)


def existing_upstream_tags() -> set[str]:
    output = git("tag", "--list", "v*").stdout
    return {line.strip() for line in output.splitlines() if line.strip()}


def push_remote_url() -> str:
    return f"https://github.com/{TAP_REPO}.git"


def push_git_env(token: str) -> dict[str, str]:
    return {
        "GIT_ASKPASS": str(REPO_ROOT / "scripts" / "git_askpass.sh"),
        "GIT_TERMINAL_PROMPT": "0",
        "GIT_ASKPASS_USERNAME": "x-access-token",
        "GIT_ASKPASS_PASSWORD": token,
    }


def stage_and_commit(path: Path, release: ReleaseInfo, verbose: bool) -> bool:
    new_content = render_cask(release)
    old_content = path.read_text(encoding="utf-8") if path.exists() else ""
    if old_content == new_content:
        debug(verbose, f"{path.name} already matches {release.tag_name}.")
        return False

    path.write_text(new_content, encoding="utf-8")
    git("add", str(path.relative_to(REPO_ROOT)))
    git("commit", "-m", f"chore(cask): update {release.cask_token} to {release.version}")
    debug(verbose, f"Committed update for {release.tag_name}.")
    return True


def create_tag(tag_name: str, verbose: bool) -> None:
    git("tag", "-a", tag_name, "-m", f"Mirror Grok Build stable-channel version {tag_name}")
    debug(verbose, f"Created tag {tag_name}.")


def push_updates(tag_name: str, token: str, push_branch: bool, verbose: bool) -> None:
    url = push_remote_url()
    env = push_git_env(token)
    if push_branch:
        git("push", url, f"HEAD:{GIT_BRANCH}", capture_output=False, env=env)
        time.sleep(1)
    git("push", url, f"refs/tags/{tag_name}", capture_output=False, env=env)
    debug(verbose, f"Pushed {tag_name} to GitHub.")


def release_body(release: ReleaseInfo, *, active_version: str, cask_updated: bool) -> str:
    lines = [
        f"Tap mirror of Grok Build stable-channel version `{release.version}`.",
        "",
        f"- Stable marker: {STABLE_MARKER_URLS[0]}",
    ]
    for platform in REQUIRED_ASSETS.values():
        lines.append(f"- Artifact: {asset_urls(release.version, platform)[0]}")
    lines.extend(
        [
            f"- Active cask: `{release.cask_token}`",
            f"- Active cask updated: {'yes' if cask_updated else 'no'}",
            f"- Active cask version after sync: `{active_version}`",
        ]
    )
    return "\n".join(lines)


def create_github_release(release: ReleaseInfo, token: str, active_version: str, cask_updated: bool, verbose: bool) -> None:
    payload = {
        "tag_name": release.tag_name,
        "target_commitish": GIT_BRANCH,
        "name": release.version,
        "body": release_body(release, active_version=active_version, cask_updated=cask_updated),
        "draft": False,
        "prerelease": False,
    }
    response = api_request(f"/repos/{TAP_REPO}/releases", token, method="POST", data=payload)
    if isinstance(response, dict) and response.get("already_exists"):
        debug(verbose, f"GitHub Release {release.tag_name} already exists.")
        return
    debug(verbose, f"Created GitHub Release {release.tag_name}.")


def sync_releases(dry_run: bool, verbose: bool) -> int:
    ensure_repo_writable()
    configure_repo(verbose)
    ensure_clean_worktree()

    tags = existing_upstream_tags()
    active_version = read_active_cask_version()
    release = select_release_for_sync(tags)
    if release is None:
        log("No new upstream release markers.")
        return 0

    log(f"Mirroring {release.tag_name}.")
    path = release.cask_path
    changed = False
    cask_updated = False
    should_promote = release_outranks_active(release, active_version)

    if not dry_run:
        if should_promote:
            changed = stage_and_commit(path, release, verbose)
            active_version = release.version
            cask_updated = changed
        else:
            debug(
                verbose,
                f"{release.tag_name} does not outrank active grok-build {active_version}; leaving grok-build.rb unchanged.",
            )
        create_tag(release.tag_name, verbose)

        if GH_TOKEN is None:
            raise RuntimeError("GH_TOKEN or GITHUB_TOKEN is required for push/release operations.")

        push_updates(release.tag_name, GH_TOKEN, push_branch=changed, verbose=verbose)
        if active_version is None:
            raise RuntimeError("No active grok-build version is available after sync.")
        create_github_release(release, GH_TOKEN, active_version, cask_updated, verbose)
    else:
        if should_promote:
            old_content = path.read_text(encoding="utf-8") if path.exists() else ""
            changed = old_content != render_cask(release)
            active_version = release.version
            cask_updated = changed
            log(f"dry-run: would {'update' if changed else 'reuse'} {path.name}")
        else:
            log(f"dry-run: would keep {path.name} at {active_version}")
        log(f"dry-run: would create tag {release.tag_name}")
        if active_version is None:
            raise RuntimeError("No active grok-build version is available after dry-run planning.")
        log(
            f"dry-run: would create GitHub Release {release.tag_name} "
            f"(active cask updated: {'yes' if cask_updated else 'no'})"
        )

    return 0


def main() -> int:
    args = parse_args()
    try:
        return sync_releases(dry_run=args.dry_run, verbose=args.verbose)
    except Exception as exc:  # noqa: BLE001
        print(f"error: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
