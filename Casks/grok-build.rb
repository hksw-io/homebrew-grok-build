cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.59"
  sha256 arm:          "071d663993dcffcd8f3b88581d48e7681832470eae54acbd6298941a93a399a4",
         intel:        "dd9c5a097798a7f8d07f8c6a888a6af304e3a3ed21160ca00e22123ae71dc03e",
         arm64_linux:  "b46af69ef12b3753820236659cf0625943602326389afddd3f2bdeccdb89a9c9",
         x86_64_linux: "bc7367c738a6e1fb9e3575e10b44c3fa10bd535f9be9bedf11dc42cfee6808ae"

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
