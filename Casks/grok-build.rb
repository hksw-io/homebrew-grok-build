cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.33"
  sha256 arm:          "43a51b2c913683b6fe56dcba561a1c7df412bd9afa848e592922dfda3a1bee5d",
         intel:        "e839a769234c1b7bbcfbd48b287d01dcccaed5c7c1913a5660c5a2b4485f1730",
         arm64_linux:  "e32d0254e10e0505f868cc55fd338349ac87b2dee16fd3a2d13ece7773f4ec63",
         x86_64_linux: "47d3c69f93013a12669641f69caf385cebe385c591c5cfb5d5486ce5656f88ba"

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
