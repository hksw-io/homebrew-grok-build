cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.32"
  sha256 arm:          "7bfcd0938367a3696dcde7b53f66549e7f274918a67887500dda06272c7d810f",
         intel:        "26e40b3b9917b803f5ce032f0a6768316eab3a3a8c1088f44aa290a4acd875ac",
         arm64_linux:  "2b1053a8d200b3ab02988745b157d7f87dab80cee5660e527844d0bf09dbb4c9",
         x86_64_linux: "519493ba078dc280be954ed6c94e356bdedf51e053a98d48ccd779ee0446905b"

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
