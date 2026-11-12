cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.84"
  sha256 arm:          "8491dddc4e3b95d331920d0b59047cccdd4a9a8319a33c02de2024c744fc5697",
         intel:        "6443b4e8a2cfe8a4664318c65c553690b13bfc163753250b419c93762ec7427b",
         arm64_linux:  "74b74be5b3e79727e10475356317518c34f65dac3bc0093c8fef6d4eb1ce716a",
         x86_64_linux: "b728c2dfe2aa94e2afbc26ea93117f6e672f606baf6ce85d095a43c39fb07093"

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
