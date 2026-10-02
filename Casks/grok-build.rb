cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.48"
  sha256 arm:          "1ed292eb62206b1a2ec3d17dc69c9c8406a07f5ff414305f953baee5b72a4a05",
         intel:        "61f805f8ea4cdc4b28502f8b02bdcc25ea4644cdcebc1477d93acd2e3b8d0fe3",
         arm64_linux:  "9ff52baaa7f489d2e2be5b112c25a248164b9bfad4b0aefd74db682a6cf6dd9a",
         x86_64_linux: "9bc544cc3b467a6a1505ab2dadf48edb5717035abf71e8c72f5d279232d96502"

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
