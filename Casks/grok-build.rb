cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.10"
  sha256 arm:          "c66b8b44b670d55bd20022e0ade5c8b449f76699d81f9861f3ad21992f604446",
         intel:        "893531af896528472dfbbfe3f44202952cd9a887cfb28a19e362dddb37a287fe",
         arm64_linux:  "050a0e35a8aa612cdf1ed9ea15d2733e05413db2b20f2cbb39a26b66e51f2b4d",
         x86_64_linux: "d698a2dfa7ea37043f1c70cdca7da12ca51a5e124ffb4fc9a7b12bd26d0e2752"

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
