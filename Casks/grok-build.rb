cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.72"
  sha256 arm:          "4f816014815c5e9ba80ddbf47ac26d24bc4a0159b7c974ba5089779ef02df872",
         intel:        "2bd38df3fccf7c465b36002fbda94dad87ebb4f8794371cf467db8140dc27946",
         arm64_linux:  "c5e550b6aff2e6e5c811d911f16561d970d5e17beee9a8170379149e0858508f",
         x86_64_linux: "78837f6a19fcda62f23c6baae4887bf56bb42c1d166a2261f31ab16990896e91"

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
