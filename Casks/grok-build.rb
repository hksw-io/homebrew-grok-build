cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.19"
  sha256 arm:          "d07bcf2a5babebb99301fb64d8aed00edc5980c98ae204bea9a91593c3ffcf68",
         intel:        "59fb8acfc6670bf300cb8dd399c480b3556bfcb2d421e05839b47dafcbdb3569",
         arm64_linux:  "2ffd02fc1a40de2270b72d1a84a80d81d67b14c57189c6857b164dcdeba0fa73",
         x86_64_linux: "590c703b504b30fa8d22860c645ce89dd706812866f62d2c372f5295bd4d1f83"

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
