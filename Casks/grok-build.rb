cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.75"
  sha256 arm:          "4259f3fa278ebc2b1e1a20aa2d24be7b418af4184d43b078f4c4f138472a5e1c",
         intel:        "4245f529212b136c93576b1475df1f1b451b557524ae0eefe8ae7069887ae2cf",
         arm64_linux:  "7a8187df4179180bdb7ed4f54dcd174bf2bd4b40c924d263c042adbf456d2816",
         x86_64_linux: "9ea63fb6dbd9f1d0332674d2c6ce355c903dce9228dadc01497e94a2660c7e57"

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
