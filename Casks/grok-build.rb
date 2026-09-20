cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.39"
  sha256 arm:          "da2011c9a4e011e61d59651bb243b30304727eda8b987bdddd5836c279609453",
         intel:        "11e9057761df52ecab69cb88cbb088331f2a0ffb25166b8587c6988277b5747d",
         arm64_linux:  "718f17f851138741addda715f5ed6b91fb3856097ad6a7dba399df45aaf5718c",
         x86_64_linux: "576cd799f754643d1bf807086849eb4a90aed41a223e7cac72a1cb909f7c40e7"

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
