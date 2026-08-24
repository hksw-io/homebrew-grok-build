cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.9"
  sha256 arm:          "6010f2c38bc4d9b11f44cf4968294908fdb3390e0bcd59a05e76f8c4530d3afb",
         intel:        "8f989d8a4672b652cdf7dc0a2740da14b708f8cea51e0005378bb09bd1d7bcef",
         arm64_linux:  "f4a6383e388a0c8542006c7979b7b174d6252494abd5558c365cb37af95892b2",
         x86_64_linux: "baf7984607c47e5251d409e852cd296a303d68d5da9a3007e8d7da95f2441e12"

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
