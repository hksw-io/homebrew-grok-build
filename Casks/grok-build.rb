cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.47"
  sha256 arm:          "36630d0fe232903aaa254d3de2b7324516ebbe2bbecd0a8e50d4c24be2f66560",
         intel:        "8544f99f691171ca66603ad928014a93d36a48ee01bc8a8036dd34a83df08a43",
         arm64_linux:  "191125a321884959733bb8c6d56d87c77ed3a2527eaec8fe994b54cb701f8595",
         x86_64_linux: "88c28b4e34e08961c1d6a39a6ba422d0ccad19f38277473d9f8e77692b1bebea"

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
