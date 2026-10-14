cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.57"
  sha256 arm:          "2e15c95626493ea6cf87191f579fa65adaced5d6a83041c075461baf44957e15",
         intel:        "918934928a77a0597581814c844f8e5c71571cd0a12cc0f02cc9b2ec9b270cae",
         arm64_linux:  "0874ea98572e9aab30c6951f919d2f7a0be8c3db591ff8743d08596d130c4b09",
         x86_64_linux: "c42094c688e54883336c29c46acef100fb3a6564d2fee7d7e29ac8b0e522eb79"

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
