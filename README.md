# Homebrew Tap for Grok Build

Community-maintained Homebrew tap based on Homebrew's official `grok-build` cask and updated directly from xAI's fast-moving `alpha` release channel every 5 minutes.

## Why This Exists

The official Homebrew cask is the right default if you only want xAI's stable channel, but its pull-request update cycle and stable-only policy can lag behind newer Grok Build releases. This tap keeps the official cask shape while checking xAI's `alpha` marker every 5 minutes.

Both casks install the same upstream binaries and expose the same commands. The difference is update cadence:

- `brew install --cask grok-build` installs Homebrew's official cask
- `brew install --cask hksw-io/grok-build/grok-build` installs this faster-moving alpha-channel mirror

## Install

```sh
brew install --cask hksw-io/grok-build/grok-build
```

Upgrade:

```sh
brew upgrade --cask hksw-io/grok-build/grok-build
```

If you want plain `brew upgrade` to include casks that update outside Homebrew/core, set:

```sh
export HOMEBREW_UPGRADE_GREEDY=1
```

## Version Policy

This tap polls xAI's `alpha` marker every 5 minutes. The alpha channel is xAI's newest published Grok Build version and may move ahead of `stable`.

The active cask follows a "highest seen wins" policy:

- a newly observed higher alpha-channel version replaces `Casks/grok-build.rb`
- a newly observed lower version is still tagged and released in this repo, but does not downgrade the active cask
- once a higher version has been published here, the tap will not move backward automatically

This matches the rollback protection used by the other HKSW fast-moving taps.

## How It Works

This tap polls xAI's official release endpoints:

- `https://x.ai/cli/alpha`
- `https://x.ai/cli/grok-<version>-<os>-<architecture>`

xAI publishes four binaries used by the Homebrew cask: Apple Silicon macOS, Intel macOS, ARM64 Linux, and x86_64 Linux. Because the release service does not publish a checksum manifest, the updater streams each new binary through SHA-256 before rendering the cask. It does not retain the downloaded binaries.

Each newly observed alpha-channel version:

- creates a matching git tag such as `v1.0.8`
- creates a GitHub Release in `hksw-io/homebrew-grok-build`
- updates `Casks/grok-build.rb` only if that version outranks the current active version

## Run It Yourself

Clone the repo wherever you want to run the mirror:

```sh
git clone https://github.com/hksw-io/homebrew-grok-build.git
cd homebrew-grok-build
```

Create an environment file. The default location is `${XDG_CONFIG_HOME:-$HOME/.config}/grok-build-tap.env`, but every helper script also accepts an explicit path:

```sh
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}"
cat > "${XDG_CONFIG_HOME:-$HOME/.config}/grok-build-tap.env" <<'EOF'
GH_TOKEN=...
TAP_REPO=hksw-io/homebrew-grok-build
GIT_BRANCH=main
GIT_USER_NAME="Your Name"
GIT_USER_EMAIL="you@example.com"
EOF
chmod 600 "${XDG_CONFIG_HOME:-$HOME/.config}/grok-build-tap.env"
```

Run the updater once:

```sh
./scripts/run_update.sh --dry-run --verbose
```

Run the tests:

```sh
python3 -m unittest discover -s tests -v
```

Automate it on Linux with `systemd`:

```sh
sudo ./scripts/install_systemd_units.sh "${XDG_CONFIG_HOME:-$HOME/.config}/grok-build-tap.env"
systemctl status grok-build-tap-sync.timer
systemctl list-timers grok-build-tap-sync.timer
```

Automate it on macOS with `launchd`:

```sh
./scripts/install_launchd_agent.sh "${XDG_CONFIG_HOME:-$HOME/.config}/grok-build-tap.env"
launchctl print "gui/$(id -u)/io.hksw.grok-build-tap-sync"
```

Notes:

- The helper scripts render the scheduler config with your actual clone path, so you do not need to use `/srv/homebrew-grok-build`.
- `GH_TOKEN` needs permission to create releases and push tags/commits in `hksw-io/homebrew-grok-build`.
- Set `GIT_USER_NAME` and `GIT_USER_EMAIL` if you want mirrored commits to use a specific identity. If unset, the updater falls back to the repo's local git config.
- The Linux installer defaults to running the timer as the invoking user. Override `GROK_BUILD_TAP_USER`, `GROK_BUILD_TAP_GROUP`, or `GROK_BUILD_TAP_HOME` if you want a dedicated service account.
