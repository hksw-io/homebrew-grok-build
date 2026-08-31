cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.14"
  sha256 arm:          "90ef0f656cddd4ade316d3879af7b92927a07c4e2359d4f8f89af18b5e63d50d",
         intel:        "126a60109228b07280e0bc119def2724a46e259fa8030f71fd71d24e2655cf39",
         arm64_linux:  "d8a980e3f0e816a41b16dc01bceca7e3ca363cf3ed1341450b41a67613caf7bc",
         x86_64_linux: "fbc010151c522e073f97f00fe20fe2bb531b3bd64ec60cd595c96f2fe392b880"

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
