cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.79"
  sha256 arm:          "883590123966c804edc1aa2e4c29c5a02bf27ee5bbf85c245a5c83f92b017ec6",
         intel:        "3ee179724ed53e93a912cff9dbd06ebb3170f5f2c072440eddedd6bfb9ca6461",
         arm64_linux:  "00b112e993dfd9b365019a96f636e98fb948e6a7bed94f6ba499682b5ca89c67",
         x86_64_linux: "a7a4760127da62db2e3961edf55ad1a76b904fad4c619b92f6245bcce1e4322a"

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
