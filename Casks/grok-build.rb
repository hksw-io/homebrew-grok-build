cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.64"
  sha256 arm:          "6a0787dcc60006bf5831e206b7a4973e6ec715f99b9ee3fed0071c964e51c85e",
         intel:        "46fac975a59eb2924c44423665ef3b909f96b8323d61795b720aba98ada507de",
         arm64_linux:  "89deea15f21c846ba9c18d3e8bdb73038b1b631ce6f5357a17fc69bef01822d7",
         x86_64_linux: "dbb0af28a6991e77be43f72ff90884ba604b6c06b8c8c7622904a4ef3434be93"

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
