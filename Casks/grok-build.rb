cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.82"
  sha256 arm:          "9f3fc0a4dae593f4ed6035e56cb24542cf004af839c2e01a4ae3f15ca65c6009",
         intel:        "32bdf7c0fdd885282064dc927c2436257a08e58c99e9810865aec7bf049d8226",
         arm64_linux:  "26a35659347bc990192dd9de3eba20c792bcbce6216af720b694a7667739b1e1",
         x86_64_linux: "5eec0e9f755e5e598d1fe5364fdd91180eae4682015899bd7ded3ff3f6ae8225"

  url "https://x.ai/cli/grok-#{version}-#{os}-#{arch}"
  name "Grok Build"
  desc "Extensible coding agent for the terminal"
  homepage "https://x.ai/build", browsed: "2026-08-13"

  livecheck do
    url "https://x.ai/cli/alpha"
    regex(/^v?(\d+(?:\.\d+)+(?:-[a-z0-9_]+(?:\.[a-z0-9_]+)*)?)$/i)
  end

  binary "grok-#{version}-#{os}-#{arch}", target: "grok"
  binary "grok-#{version}-#{os}-#{arch}", target: "agent"
  generate_completions_from_executable "grok-#{version}-#{os}-#{arch}", "completions", base_name: "grok"

  zap rmdir: "~/.grok"
end
