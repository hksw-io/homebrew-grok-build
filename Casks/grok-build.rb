cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.51"
  sha256 arm:          "627fd125176fa9e9ffe9f40376e88fc9a699555fa822b5412f175fe16fbea42a",
         intel:        "efeb35cadf4c3c9e45a40801ebc723cc040e1c09ae3a9bfb516ca810d190a1d4",
         arm64_linux:  "717d2e9ad46f72fba5bbaaf71bec7181d31987b3a0ca4644e0063503a11c540e",
         x86_64_linux: "8b4df0bb34d50ddfb2a7f4a1796a838df9acebdd1287fa10eb3bdb8ded9358c5"

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
