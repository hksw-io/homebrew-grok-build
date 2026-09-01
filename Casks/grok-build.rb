cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.17"
  sha256 arm:          "be8b42718132e3c2239e779707aa37cb6794ac678cf667845a7711e52fa7f4d3",
         intel:        "4ed63b531191b393a66fcac96d6340f43523b01a7f6aa4f78081aa58098820be",
         arm64_linux:  "cbf79edfbfc1f4da642b81a260fccc4057ab607b6af8ef047d82324c46b4d431",
         x86_64_linux: "82595e26cab8f5bab470415e69a6b3d58f99b71cbcc831440b416212e3c14568"

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
