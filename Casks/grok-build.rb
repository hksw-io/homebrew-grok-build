cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.49"
  sha256 arm:          "184f4cb1ba2a8eefaa2c2f267b9102bdb13c32dce53db7f7e3095b88f5fe0cce",
         intel:        "7efdfb4253a5f7a8a71a482ee34afdda106a28936842537c85dac2a8f2819826",
         arm64_linux:  "df7e60362b1934b6f09e1e64b6d75a8c94b1bd9bf68c2803da273e4c6ed9a451",
         x86_64_linux: "2cc2ef5dcaa0509b56cdfb9559e27fabe322a0d893810e5129f507110e9b9c6c"

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
