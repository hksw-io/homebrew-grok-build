cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.65"
  sha256 arm:          "91cf354680d2e1cb762e64f74784428dfe3ed8f539c1d8d3e2933c2a39ff158b",
         intel:        "ecfdb041d70cf084f82c2eac3d20cbd4fd99cf1852a515b36c21046ce24c4aa2",
         arm64_linux:  "fb07200deb1122390d8a3ef8127bcb200fdd8a4eea47dc3f36a68ce9d3d75993",
         x86_64_linux: "9ea7eb7f27559830e86d41455058a3e2018bfe9b6019c055212aa006fb7a611b"

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
