cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.86"
  sha256 arm:          "66c2f427d8380005c85dcbc6c3eafa1586c9f77a688d1b5e50c2af43ed3be60f",
         intel:        "bf162c9bc51f0ae4e06e13e805f0ff84a21de5e7c19187d726da7700f3936f65",
         arm64_linux:  "cca8fd00ec69a3e3f749e7c778035649e6c464e981c2d786fb228ad07dfc9344",
         x86_64_linux: "d268d291226f09b63052a807098ad49e4ceee8665f42e37666f2e28827458cc1"

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
