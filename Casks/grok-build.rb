cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.23"
  sha256 arm:          "a697d8e96e93f2c687f15591208abaa4e127ed6d9bd0045712086279e8cdcca0",
         intel:        "b1ffeed42d7dfaa75b7bd0b205a395e625fa91125fa1e6d89b3d210307591578",
         arm64_linux:  "c37b489699fc4db3b3a9bdc79a3f45d746422ef8a2a27581e688e97977e79764",
         x86_64_linux: "e7de856e77ef366ddb96ec042355b89a69d2fffd1311d364798e045da5c56037"

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
