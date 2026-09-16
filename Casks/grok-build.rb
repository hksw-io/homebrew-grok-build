cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.35"
  sha256 arm:          "948d44c6491c389d65338f2bc7cf4faf34baea787a7ed35f9e31f925abe8e41c",
         intel:        "6ae24365ee5462981dca9899869014ccf4fb659f02ec4148bb94a9bc356d0880",
         arm64_linux:  "9f347a46bb25e1eaf303f5d9cf03494b0d40fd437e8d28dad2ce784fd1a21ceb",
         x86_64_linux: "f57df130e95a230d444933596f6530738d891ae470b7b7a45e304919d71b1cc4"

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
