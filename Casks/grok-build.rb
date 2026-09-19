cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.38"
  sha256 arm:          "a3c5c279339a1294cc99b4d105fe7c67a9f64d20647f2edf131ee72d70f94ed1",
         intel:        "1aa859cf7fc6f407a3d3a11c4a1e56b0bed5bf9ca9a5605a8728a25afd938187",
         arm64_linux:  "d19211b4d22421c622ceefce62a12e8954f3495f45378e0b315f4e80dd358f96",
         x86_64_linux: "d09092c50f1bf1cd686a0ecd3489aedd83ec2d16b27a821ca9f0994a4b605ef9"

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
