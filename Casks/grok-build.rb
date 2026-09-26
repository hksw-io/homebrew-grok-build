cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.42"
  sha256 arm:          "01ff85ca48e3805981dad9e548ca19412c0407d6d1c0b43b7d058c9fd6362853",
         intel:        "cda4651a1837492242e9c10b7d180c526e559155446941861e242e124f9dd0cd",
         arm64_linux:  "3e30d9e36aeb38111c76794bcef87e7b8a81f0f3d1474c7c9df28d8452f06518",
         x86_64_linux: "779d4e5c03d321638ccef9656d0ee53a19e54758400590f6df22822f18cbc022"

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
