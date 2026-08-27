cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.12"
  sha256 arm:          "a7d2495b9721d6f4d01a2a1e74beb62cc5007276a76bbab0529a238b9373f165",
         intel:        "37e4a996bad0e3ac9c122d53e5bf72a235185b75e368d90f6f4dd567c906e0e0",
         arm64_linux:  "e440bd8ae98643b70abc521688b9ca8a7b1d1f660faf1a3e9a713da302c99c02",
         x86_64_linux: "f9973b1116f98d5c4c2f2feb0c33a718cb2bca61216d36325205eb1bdc2e77da"

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
