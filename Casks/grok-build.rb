cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.81"
  sha256 arm:          "0e4169a5a83d450caeb02edc669e91eeb6d1d182cb4bcf96e737573a1ae9a086",
         intel:        "bff82ddf26e096f6b1fc879a4f96cadd638abc3165da939b61cc338b32575448",
         arm64_linux:  "26d4ec5a9d9fa38e5aad7722ff23224d0078cea3bb8dcec6bb326cdcd84584ae",
         x86_64_linux: "de245c4cc88c18e2e56048f16b072f653fd7c4fd7033cd45cff0823d184d9182"

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
