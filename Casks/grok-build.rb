cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.80"
  sha256 arm:          "6eb0dc63dfda6009b7579b44ad8268f7a8ac9872e09af025bb40dac02af0b1b1",
         intel:        "a7750850121c16a5e80fd3261f8f929c176864ea0e7d9c1210219d860cc92214",
         arm64_linux:  "e6ee74cacabb35b45c6f194b3c2a09ca77ea37884b88bfef46dd6652b4912e34",
         x86_64_linux: "824feb651c4cbb130a387a4a354475832e8bbeaa500b7a60f8fdeb23069218ba"

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
