cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.58"
  sha256 arm:          "95a28a58525966e4a367530362ed4b930c9bbb641cbc9396f431115a6750ea2b",
         intel:        "9e1c97de09339abab7d832920c47253491ddfb33b0049300399f1db3ffffc368",
         arm64_linux:  "cb4d348eb77ee3079696aa581bf19d46ccdb4f9b805e129aba40d7a58eb477e4",
         x86_64_linux: "16e85924e5c6b4304c64f9c3cd3429c1ba6404b0d11c7cc18dd18ed88655c1ee"

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
