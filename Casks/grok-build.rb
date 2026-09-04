cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.20"
  sha256 arm:          "c68e058c3ac02d5af5060ec80d53dbfbb320b60d24ab69992f805af922b63039",
         intel:        "cb87bbbc9c107675a143abd8f02b8988f1d27a959a0df9d7e3cb703452002032",
         arm64_linux:  "eaa5de9370b97e58b0193cf55256d6c8b4043976cbdca5c79061c398f271f480",
         x86_64_linux: "b561c5f7bd3caf3dc4106d8697c864f406847718e5a60fc68c1a1bd8b6dc12fb"

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
