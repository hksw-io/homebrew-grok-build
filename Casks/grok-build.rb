cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.94"
  sha256 arm:          "ad65f7f4d96aa36b2997b8d68850d3b35d3a5300bca8c45d4085c948693d1763",
         intel:        "2def1f317779c0803d761c4c7d33439d845a023c3a74eb0160703ad58ee51a75",
         arm64_linux:  "e81b33e829908a9782cd6f8395eb207bebfc10132d72e25ce0837a1791ee4ea0",
         x86_64_linux: "76fe0e1402af0c1734b5c45a2147e606868febe763f9c86078e5db46addfc8cc"

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
