cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.91"
  sha256 arm:          "4559050fc0ff8c959ee6021bf0f305739f9903c12a8a64f7813119708f145750",
         intel:        "a259c9d5c787c819ee8fa1705701c0b61b61d574d25b715e4b5d9472f0853c04",
         arm64_linux:  "004b4c109e79b54a2606619ff8a50f406952984002c6f6d0c66681164f9f79b6",
         x86_64_linux: "630a4f046f7fc6b7dbb6af2bd301ec277b5e43772c64f673a22ae5ef07b10a0c"

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
