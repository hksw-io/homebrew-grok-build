cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.90"
  sha256 arm:          "f2e9b293e2f67d46bc8f1cd4d74ac0d0bbb1609e864f8e4c569523125f57b38b",
         intel:        "6fd951bf52617e13b306fc6807895e368357e0e1226ee03166a9eb289169941b",
         arm64_linux:  "3de35edd3b5a3f01db2fa70904e8bd005bf02c734a706933b70ad994274f0754",
         x86_64_linux: "383b526bbc03d4a44179b7498358d48115c65342bd09b59b43cf700f5486f0ff"

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
