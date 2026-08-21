cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.8"
  sha256 arm:          "b16e351ea3989fc2307b28032278c43cda1e043f0adadf8ab0f40d51128aba0d",
         intel:        "1b2641ef18bbfd6a84d35663880938c0e84ba9e24fb66b65c8f30b4bfbac1d08",
         arm64_linux:  "4a8f3e6c39cf20d82e60b1a7a3d823a25150e1a9e899a5ad024b03cb61e3f94e",
         x86_64_linux: "7745786c03886ebc8cc53eb1e7f8308aefb9632f5fbebcc33378834dcd7ac050"

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
