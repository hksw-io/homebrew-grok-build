cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.15"
  sha256 arm:          "86ffac7a9547936f02e97dcd9a0ddb3f69486c7bac66ee9e1cbefc72d59b4635",
         intel:        "87e3fe8cd2ed6687d5be8fbad5c1e8ab123561ee2f626898fce14ca1adbad8d2",
         arm64_linux:  "a9245ef79a01acba0b4b88cca7dfa333e61d94df31ca73a878f021b84ab5f8f2",
         x86_64_linux: "530d9bb951171f8358861297a8c9157ce8a97b0414f14cb7cf38eccd2c9ce567"

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
