cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.43"
  sha256 arm:          "630b7ec3853d903a1d903e4ee95817a461f82f699dd6fd364d47b93859b39a71",
         intel:        "e0e5f699fbda705dc115f1590a55cb4e1b94b144a452c7b2c57e92718e1177be",
         arm64_linux:  "3393884a8b40ebd376a8bdfedcbc98c7377b9c7b4e5d6fecc7bf2fe8b9cf7285",
         x86_64_linux: "34444fab6c1d77ae28f01a903d453032d48f8c85af4e5bb195d487031b265901"

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
