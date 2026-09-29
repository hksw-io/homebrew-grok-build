cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.45"
  sha256 arm:          "7c850a97f900fee60b4cbe6b4aa2d873a0ceec9d11430e3a7917728e8c6091e1",
         intel:        "95c5d8bb4f0c4a2b2e691290d324c55a94b8090dda9ed2588df4d016cceb0b2c",
         arm64_linux:  "c3b73519d6d3d5dfc6b8d22268f43f9095dd9fec9e368762c21d276dd478c15b",
         x86_64_linux: "3ef9bf5689ae9cc58f1bc918ae6067627a3667c7519245b9e8aacd9288559718"

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
