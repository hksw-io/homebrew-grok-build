cask "grok-build" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "1.0.61"
  sha256 arm:          "827be4684ba31bdbbfd700c7f88677d8cdb03d9df89bca3e6be459fac9ee93fe",
         intel:        "5ee0a2d2e2a8d9302a3ba0bf05d0c7bfa9ad3d4f1d585b5576901ffab5312f4b",
         arm64_linux:  "020d5cdaa8d212eb37db8b635e5e811d343038b6a9f61f52af298ed286e213c4",
         x86_64_linux: "821cfaf82f648404502bb224233a4796a009cdf84498a66ca52be8c68f4c89ac"

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
