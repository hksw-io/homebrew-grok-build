cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.18"
  sha256 arm:          "99b77202286face91f27f97caca0590377b36300ccca99ff18e730228f7a5ca3",
         intel:        "b6b682eb551e503dfb80368e46c2129a74ba51af598692ba8f4c59202653fd2a",
         arm64_linux:  "e5c96058b6f88b2e9ae7d61401e80ac6bcbcaf1be5681eae19e36a2b8aff121d",
         x86_64_linux: "42f6efb496feafea3e8807b75852cc1f792cba0bd0be8ecbd1c9f7ed5816a7f0"

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
