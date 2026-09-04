cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.21"
  sha256 arm:          "daac3e1cc56771b94605c39cc091b7d3c3d4ef0aea3a45658250200aa22e936b",
         intel:        "bc275df8242ad530f88c0f110f14ff70535e2ad0ed64610b72d4d60c18183f3d",
         arm64_linux:  "8a629e703cb08856fe7d837446bc225bcbb51c85f86fff0b0e0628cd89138582",
         x86_64_linux: "3a0bd1111628768b91c4ac550034565448309fe9ec2cb13b71dea90910dc9d98"

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
