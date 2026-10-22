cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.68"
  sha256 arm:          "845acbda235b34a76417e19ac9a8a4312aa0e31975f21fded1e7c3781ca105ed",
         intel:        "9d2fb745c48633cd0faada176218d5fd94b7f7e44f1c9a4f88eefe5e2f645ecf",
         arm64_linux:  "c8925b52e0ba2f1392cdd59ff2210d6da9d51e425a025161bdff1a290a95c0fe",
         x86_64_linux: "7158ba47ce2a70004747a3f390af6f8d7db9a2f0711862351f2a83df6dad46d5"

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
