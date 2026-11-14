cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.87"
  sha256 arm:          "0e6e6ba3bdfa8576f547b258f3e8942d3be21c2b87c59439f3a125dece29daf7",
         intel:        "b5940a22a0a892b525ed88e1bd7d4d002989788a12d483cb968aabb53f90b2a3",
         arm64_linux:  "2d04288e82499da19337bb54405713c84f1a4917bc24d4565a5b0d227e1046fa",
         x86_64_linux: "b8e62641cbf13bf2351c2dfd7b8b609a802253e0f5ec204cc861565cf05247ca"

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
