from __future__ import annotations

import hashlib
import io
import os
import re
import sys
import unittest
from pathlib import Path
from unittest import mock


sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
import update_grok_build_tap as updater  # noqa: E402


class GrokBuildTapTests(unittest.TestCase):
    def make_release(self, version: str = "1.0.5") -> updater.ReleaseInfo:
        return updater.ReleaseInfo(
            version=version,
            sha256={
                "arm": "a" * 64,
                "intel": "b" * 64,
                "arm64_linux": "c" * 64,
                "x86_64_linux": "d" * 64,
            },
        )

    def test_version_key_orders_newer_patch_release_higher(self) -> None:
        self.assertGreater(updater.version_key("1.0.5"), updater.version_key("1.0.4"))

    def test_version_key_supports_alpha_prereleases(self) -> None:
        self.assertGreater(updater.version_key("1.0.8"), updater.version_key("1.0.8-alpha.1"))
        self.assertGreater(updater.version_key("1.0.8-alpha.10"), updater.version_key("1.0.8-alpha.2"))

    def test_fetch_latest_version_uses_fallback_marker(self) -> None:
        with mock.patch.object(
            updater,
            "http_request_text",
            side_effect=[RuntimeError("primary unavailable"), "1.0.8\n"],
        ) as request:
            self.assertEqual(updater.fetch_latest_version(), "1.0.8")
        self.assertEqual(
            [call.args[0] for call in request.call_args_list],
            list(updater.ALPHA_MARKER_URLS),
        )

    def test_asset_urls_match_official_release_layout(self) -> None:
        self.assertEqual(
            updater.asset_urls("1.0.5", "macos-aarch64"),
            (
                "https://x.ai/cli/grok-1.0.5-macos-aarch64",
                "https://storage.googleapis.com/grok-build-public-artifacts/cli/grok-1.0.5-macos-aarch64",
            ),
        )

    def test_http_request_sha256_streams_artifact(self) -> None:
        payload = b"grok-build-binary" * 100
        with mock.patch("urllib.request.urlopen", return_value=io.BytesIO(payload)):
            digest = updater.http_request_sha256("https://example.test/grok")
        self.assertEqual(digest, hashlib.sha256(payload).hexdigest())

    def test_fetch_latest_release_hashes_every_official_platform(self) -> None:
        digests = {
            platform: str(index) * 64
            for index, platform in enumerate(updater.REQUIRED_ASSETS.values(), start=1)
        }
        with mock.patch.object(updater, "fetch_latest_version", return_value="1.0.5"):
            with mock.patch.object(
                updater,
                "fetch_asset_sha256",
                side_effect=lambda version, platform: digests[platform],
            ) as fetch_digest:
                release = updater.fetch_latest_release()

        self.assertEqual(release.version, "1.0.5")
        self.assertEqual(set(release.sha256), set(updater.REQUIRED_ASSETS))
        self.assertEqual(fetch_digest.call_count, len(updater.REQUIRED_ASSETS))

    def test_render_cask_preserves_official_cask_shape(self) -> None:
        content = updater.render_cask(self.make_release())
        self.assertIn('cask "grok-build"', content)
        self.assertIn('arch arm: "aarch64", intel: "x86_64"', content)
        self.assertIn('os macos: "macos", linux: "linux"', content)
        self.assertIn('url "https://x.ai/cli/grok-#{version}-#{os}-#{arch}"', content)
        self.assertIn('url "https://x.ai/cli/alpha"', content)
        self.assertIn('target: "grok"', content)
        self.assertIn('target: "agent"', content)
        self.assertIn('generate_completions_from_executable', content)
        self.assertIn('zap rmdir: "~/.grok"', content)

    def test_checked_in_cask_matches_renderer(self) -> None:
        checked_in = (Path(__file__).resolve().parents[1] / "Casks" / "grok-build.rb").read_text()
        version_match = updater.CASK_VERSION_RE.search(checked_in)
        self.assertIsNotNone(version_match)
        assert version_match is not None

        sha256: dict[str, str] = {}
        for key in updater.REQUIRED_ASSETS:
            digest_match = re.search(rf"(?:sha256 )?{key}:\s+\"([0-9a-f]{{64}})\"", checked_in)
            self.assertIsNotNone(digest_match)
            assert digest_match is not None
            sha256[key] = digest_match.group(1)

        release = updater.ReleaseInfo(version=version_match.group(1), sha256=sha256)
        self.assertEqual(checked_in, updater.render_cask(release))

    def test_select_release_skips_downloads_when_tag_exists(self) -> None:
        with mock.patch.object(updater, "fetch_latest_version", return_value="1.0.5"):
            with mock.patch.object(updater, "fetch_asset_sha256") as fetch_digest:
                self.assertIsNone(updater.select_release_for_sync({"v1.0.5"}))
        fetch_digest.assert_not_called()

    def test_select_release_downloads_assets_for_new_version(self) -> None:
        with mock.patch.object(updater, "fetch_latest_version", return_value="1.0.6"):
            with mock.patch.object(updater, "fetch_asset_sha256", return_value="a" * 64) as fetch_digest:
                release = updater.select_release_for_sync({"v1.0.5"})
        self.assertIsNotNone(release)
        assert release is not None
        self.assertEqual(release.tag_name, "v1.0.6")
        self.assertEqual(fetch_digest.call_count, len(updater.REQUIRED_ASSETS))

    def test_release_outranks_active_uses_version_precedence(self) -> None:
        release = self.make_release("1.0.5")
        self.assertTrue(updater.release_outranks_active(release, "1.0.4"))
        self.assertFalse(updater.release_outranks_active(release, "1.0.6"))

    def test_release_body_links_official_marker_and_artifacts(self) -> None:
        body = updater.release_body(self.make_release(), active_version="1.0.5", cask_updated=True)
        self.assertIn("https://x.ai/cli/alpha", body)
        for platform in updater.REQUIRED_ASSETS.values():
            self.assertIn(f"https://x.ai/cli/grok-1.0.5-{platform}", body)

    def test_push_remote_url_does_not_embed_credentials(self) -> None:
        self.assertEqual(
            updater.push_remote_url(),
            "https://github.com/hksw-io/homebrew-grok-build.git",
        )

    def test_resolve_git_identity_prefers_environment(self) -> None:
        with mock.patch.dict(
            os.environ,
            {
                "GIT_USER_NAME": "Test User",
                "GIT_USER_EMAIL": "test@example.com",
            },
            clear=False,
        ):
            with mock.patch.object(updater, "GIT_USER_NAME", "Test User"):
                with mock.patch.object(updater, "GIT_USER_EMAIL", "test@example.com"):
                    self.assertEqual(
                        updater.resolve_git_identity(),
                        ("Test User", "test@example.com"),
                    )

    def test_resolve_git_identity_falls_back_to_git_config(self) -> None:
        with mock.patch.object(updater, "GIT_USER_NAME", None):
            with mock.patch.object(updater, "GIT_USER_EMAIL", None):
                with mock.patch.object(updater, "git_config_value", side_effect=["Test User", "test@example.com"]):
                    self.assertEqual(
                        updater.resolve_git_identity(),
                        ("Test User", "test@example.com"),
                    )

    def test_resolve_git_identity_requires_complete_identity(self) -> None:
        with mock.patch.object(updater, "GIT_USER_NAME", None):
            with mock.patch.object(updater, "GIT_USER_EMAIL", None):
                with mock.patch.object(updater, "git_config_value", side_effect=[None, None]):
                    with self.assertRaisesRegex(RuntimeError, "Git commit identity is not configured"):
                        updater.resolve_git_identity()

    def test_ensure_repo_writable_passes_when_all_paths_are_writable(self) -> None:
        with mock.patch("os.access", return_value=True):
            updater.ensure_repo_writable()

    def test_ensure_repo_writable_reports_unwritable_paths(self) -> None:
        def fake_access(path: object, mode: int) -> bool:
            return "grok-build.rb" not in str(path) and "refs/heads/main" not in str(path)

        with mock.patch("os.access", side_effect=fake_access):
            with self.assertRaisesRegex(RuntimeError, "Repository is not writable by the current user"):
                updater.ensure_repo_writable()


if __name__ == "__main__":
    unittest.main()
