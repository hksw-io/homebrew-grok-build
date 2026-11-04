cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.76"
  sha256 arm:          "2860904c4641dbaa3d170b128d74078359e2dc01131b0cd0c6b1a25e34212e25",
         intel:        "22294ee3967c531c41ee81c12c0b5c22ad79ff5090fe7e881d3430840b867bb1",
         arm64_linux:  "39e60d7bad60acda3428505c1326ad79037fffcc7e6ee689313cd3cd2c792833",
         x86_64_linux: "f3602fd4f41c16ab97b9807174d2e0e8222e44a2cd5899f60941050993aadcc7"

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
