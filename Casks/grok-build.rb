cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.22"
  sha256 arm:          "f17b8369d3283bb9ef3daa53bb95f68bfff91d605376eee1769dfbc798f7a9f6",
         intel:        "6236e8f5d973cce1ba8f1d86517913fa5df1177386a4e95fad5cf5be5b566b90",
         arm64_linux:  "85ca59e425db9040451ff37b89c865772be2ccf949638702c3c0d1c2210e0963",
         x86_64_linux: "ad2510e8d7edcfe04fbdd25fa0f19dd1fb5babc8b238532b06e4bf3548d210ad"

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
