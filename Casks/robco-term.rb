# Homebrew cask for RobCo Terminal, which is an application rather than a
# command-line tool: it installs into /Applications.
# Install:
#   brew tap overseers-desk/od
#   brew install --cask robco-term

cask "robco-term" do
  version "0.1.8"
  sha256 "407296318c50f1d40d5dee84e69d219b4230e8a6825485d44785989754d3b0c2"

  url "https://github.com/overseers-desk/robco-term/releases/download/v#{version}/robco-term-#{version}-macos-arm64.dmg"
  name "RobCo Terminal"
  desc "Terminal emulator that behaves like a piece of hardware"
  homepage "https://github.com/overseers-desk/robco-term"

  livecheck do
    url :url
    strategy :github_latest
  end

  # Apple Silicon only: no Intel or universal build is published, so an Intel
  # Mac is refused here rather than handed an app it cannot run. The macOS
  # floor is the bundle's own LSMinimumSystemVersion.
  depends_on arch: :arm64
  depends_on macos: ">= :big_sur"

  app "RobCo Terminal.app"

  # The terminal's own per-user files. The config file is the one a hand
  # edits, so it goes with the rest on an explicit zap and not before.
  zap trash: [
    "~/Library/Application Support/robco-term",
    "~/Library/Caches/robco-term",
  ]

  caveats <<~CAVEATS
    The app is unsigned, so macOS refuses its first launch. Open it once from
    the Finder's context menu, or clear the quarantine attribute:
      xattr -d com.apple.quarantine "/Applications/RobCo Terminal.app"
  CAVEATS
end
