cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.93"
  sha256 arm:          "289724555499ef6941f258943d4c2971f7cdc79ae19e90c396b858d0aa1d63a4",
         intel:        "31c39a7f826a3042746e1db5410d496af9f54d136830e562b5f724545fc18176",
         arm64_linux:  "153c5c70acba58139cd408f4b47cbeb5dbb3bcbec54071086af14608c6c67540",
         x86_64_linux: "e797ec6f3029ca9231fa0e424ebd2f6336b9e5230c521a7263d7320e7048b5db"

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
