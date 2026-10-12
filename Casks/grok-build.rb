cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.54"
  sha256 arm:          "67c73eaa3fc32ffd4c80811924aaafe18f193b1e0fa550a363f50302fb1146c9",
         intel:        "b1a19538ca54a152d891d659a3008ae4c86eaf1d28daaddc311ac6e169722bac",
         arm64_linux:  "d6102269aa4c8f2077f78aa5ef47064232f1d06c754e46edebbf0eed61cd3aef",
         x86_64_linux: "ae2450b32f2c45587b8a9e270cf854db126d740b2e74850385bb3a73f00fdf4c"

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
