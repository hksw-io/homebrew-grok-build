cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.85"
  sha256 arm:          "085f3043b5bc66eda2a24b8243890759f181e5c154eb37dfe52ce77779f5926c",
         intel:        "fb6af4558661a6afd153679a5e9845dbfc07cb9e6d19764069574633d2e8b1e4",
         arm64_linux:  "855d55aa740d8f89ddc3d3783161da34cfabded7679e8b3906d57b0d5435a00a",
         x86_64_linux: "a8302a0651289f8b6e6cd519977c8cf7941ba2ad7dce6c674cd2a7b34cb4eb66"

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
