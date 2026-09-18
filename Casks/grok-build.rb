cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.37"
  sha256 arm:          "0fdb8a2e05cbe5ba623558b076f08475d5b4de257549dfc632eee7967d6d6f68",
         intel:        "8e937eb012cf2a210b24d5ba6eab4662d93f6aa4eff0895722f5c6e7b5708088",
         arm64_linux:  "4321bdc20e452937f9b335d7b3e1fdc88f0a7f9ca6ae111a3d656b2dfe7dd3e5",
         x86_64_linux: "5b18c917d4e3ab41d23dde88d46bc3cb22488de042697d26ee4975811bd92b5c"

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
