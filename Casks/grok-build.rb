cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.55"
  sha256 arm:          "06ec55c338272f648b30e242aad44d7d4a6e851269752a775adfb1d7cc408d40",
         intel:        "8277da09ff4cc8e34962e17af935fdc666f3b362bee702803b8f381108278f86",
         arm64_linux:  "bcb304c25f8d10d6ba9cd8b0c678841a8c5b4aae1b5a6561746c7e7080bde2b0",
         x86_64_linux: "00192a576ab2f6f2682f7db49093270b69df01df04e8ffc742b4f45ff6f0e9de"

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
