cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.16"
  sha256 arm:          "8d901060ef725068443fea122cc6f9e4818fb6724fc69ddeb39d464ed750e127",
         intel:        "6d1e601bc17f038216f94f0ad736c29473ef4bd8ab7107ad08ec22720b650a9b",
         arm64_linux:  "a62ff21c52a98a91aa6a07d5eee5d234c1a12ba8147182ff29bfdd5f6bdefd14",
         x86_64_linux: "12058498506e52db50815a90fd37dd44b9d0e1e21d508d1124879dd1144f971f"

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
