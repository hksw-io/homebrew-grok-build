cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.63"
  sha256 arm:          "69c7664bf0951334d4dc5026e04d931ff49b8c2ac73d12695d2ef4bc0e18ecdb",
         intel:        "12871116e75f611712321b45138165c80c51c47af3e53171a1ee648e3d832ed7",
         arm64_linux:  "a33de7911cdb431705ef28e19e2959dd83b00f283852659a3dd54f9dbd35db22",
         x86_64_linux: "ea178556ae36f44fedc611c4743d0bcf3b295d3835b16541da89f0f040aaba6b"

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
