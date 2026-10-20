cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.66"
  sha256 arm:          "54df077afe7e191f3d7dfad3d11bbdb0c2ee5de6b632c9f54dd9d39eb27925a6",
         intel:        "2b1f91dd949fe1a6a00b455e9381235861e19ad61565cd5962cf2c7511b17424",
         arm64_linux:  "b4e7e5c87ecc1e679f76bb2e8c108f1872ce48dc4b5627aa978a5694016fe1a1",
         x86_64_linux: "d2455f6f9ac940dd8898f6de560cd37e38082afeed9536c0979b58c97ffe4eff"

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
