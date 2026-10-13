cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.56"
  sha256 arm:          "351345ebafd7df3ff55b3504e8f421c7222e1b2dc1fe11a4c597c7de64ba97f9",
         intel:        "4c6f3457c20c26bee7a0317b011010624ce9ec15a74046041e6b41ad593a8bd5",
         arm64_linux:  "e4d37856054b26de50fe2bdf9725c3b5f454d2c9bd7cbe77d7a2f92703aaa96c",
         x86_64_linux: "cafc86883022cabf6824d7ff6b8ed38d7c5f07c3394bca1c6d8c1c649260f696"

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
