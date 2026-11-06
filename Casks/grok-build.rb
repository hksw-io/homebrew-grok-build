cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.78"
  sha256 arm:          "b9c30952eb0be0e1fbd73fb98591305df938f44d92896cc0bcadd44dfd3e950c",
         intel:        "cd683ed8650c68cbcf86828d51f7b27581a48c924ee1013914f36b286dfe0cf0",
         arm64_linux:  "755da16ff70632c03820956decb5e98e7aeba9e345c2e03d8429cf004866f915",
         x86_64_linux: "8e59eb3e32ef1a185de8ec5ebed7b64d30986abd5e20923d1695accca6e0645b"

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
