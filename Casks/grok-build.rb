cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.53"
  sha256 arm:          "eb8daea155162e5782c1557cff70e27a234f12a74f2f4a82a0ed30b0d91ba3d4",
         intel:        "cd906cb00a5be412061b67396187defdfeb8f255b44ae1bcc6c7f5473fd9a2bd",
         arm64_linux:  "abff6896422037b0e64f02008bfadddd0a1935f64198b9b842957e1ac2220191",
         x86_64_linux: "407c0059193090b54731cda8475bbb6a52c032324a8a72bfacda8633cc0affad"

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
