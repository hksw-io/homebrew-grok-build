cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.11"
  sha256 arm:          "7fd4681f61a65b1b19bc3774ebdea8df8b003bfae84a19f409b117b6ace4171e",
         intel:        "f7e22b067a48925892ce895aa13f94c8fcfb8183da4faf8ee150001f4a232435",
         arm64_linux:  "8c75ce99485d6693d106665e9fe34f9d09491e847644d77e95339d00f7a2a290",
         x86_64_linux: "4fc1bf5a9d634ff276627c0381eb6aaca34d1b73a5c0df5869703e648dcaa323"

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
