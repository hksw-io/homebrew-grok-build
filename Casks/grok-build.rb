cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.69"
  sha256 arm:          "dd266c886003e3b6d485e274ad47cb149709b2e0e7960bb3ab7ddc611cb0f3c6",
         intel:        "55ee3f4e8c5977e06f2cae48cd98ae6b5f78be2a590f0c03ab8b47608350e343",
         arm64_linux:  "475cbf18f8a1484b2d7c16bf47caed2113c460aa77bf407861dbeafcc6d926a1",
         x86_64_linux: "f301b4e9a8ec691cdebc4ae8131f35833165d01b734aa14135a128afc6402a25"

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
