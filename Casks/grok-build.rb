cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.73"
  sha256 arm:          "65e9efe2cdbfb996fd82e2fbb8b286656e9b6e75761d4845766592f35e0ca598",
         intel:        "c8661b67610a404cc910a0bc0b59e9c350b6caa0dd5886d8eb96b41078b69280",
         arm64_linux:  "e5a89c1b5b12ec73fad3d00ab4b460c20c921039570a81939846833975c28fbb",
         x86_64_linux: "7b2ca103d269bc7561eb0c8983a179a5e0145bc42b85a91be5aa97dc80912595"

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
