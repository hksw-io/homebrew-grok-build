cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.83"
  sha256 arm:          "c52433979678d542d79fb52db87e4798e3ebbc379322897297ff55934737ef39",
         intel:        "80f8cbf3b745ef5a27e2629a6d337f5c56e25962532f67f8f636520e837460a1",
         arm64_linux:  "595c59658d51abaec38f341cd7e640c47cb9c088e412de565248cf54ca9e7f1c",
         x86_64_linux: "2112e0d5bbb627eb454024af9e78d5d988b22f3d74b326b70935be3ce8eb73a6"

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
