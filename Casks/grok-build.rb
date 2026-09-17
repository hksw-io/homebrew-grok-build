cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.36"
  sha256 arm:          "14a3dda68b368f933a7eaa2e970a30b4ff2149ba42be7dd90eb81c99b6ae3c9a",
         intel:        "5517920c4811ef52dbab98ae7a61de5ae7882bc11bf1ef160d715603fcaa3532",
         arm64_linux:  "3abe9b0eabdab906bb3c491b760621009a56664a2f40d24f51efa4eb8b29768e",
         x86_64_linux: "90e373f48b0fd5b6fb2af4e92a6e59ff4fb03e97628715db74bb57dcf89c2f01"

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
