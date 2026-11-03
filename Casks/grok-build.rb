cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.74"
  sha256 arm:          "15cfa6744cfbce0760245bee3e3181b01be6fe71b9ef5d9e15bca34b0a804859",
         intel:        "79e4609577b59b9c0d042a074503b8cd8273eaf51e247e9b2dfe65ffdfc5b8ae",
         arm64_linux:  "072970dc52c5e10196c900682ec9eeb1e834c84d041d0073b3ff22028d570f3e",
         x86_64_linux: "8069fd7639827c0e253098fe0175140c863306f441249fbaa08f060f2a4ef0c4"

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
