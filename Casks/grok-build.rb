cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.71"
  sha256 arm:          "0d1274d3eaf34b17cf58c616c2105916e2bd25c57dfa970237673a6a29b51cbb",
         intel:        "7dc23740c4f2f693dc4df3d0d4ae668ef63e215731524669e6fc9767b34b6f3d",
         arm64_linux:  "34396c180fb95c97f634568b353b8a8bcab622e3d72f6cf7d18135924c22fdc7",
         x86_64_linux: "dd5308d5eebf04e8685de14c4cccd89c6da9becbfd3acad2124777535e2ed56f"

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
