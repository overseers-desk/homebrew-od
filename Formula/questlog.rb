# Homebrew formula for questlog.
# Install:
#   brew tap overseers-desk/od
#   brew install questlog

class Questlog < Formula
  desc "GUI for finding, reading, and reopening past Claude Code sessions"
  homepage "https://github.com/overseers-desk/questlog"
  url "https://github.com/overseers-desk/questlog/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "88474922da0d50cc63a5e99b2ff40bd341cc08a6d94ff283f487370b7ee8e527"
  license "MIT"

  depends_on "tcl-tk"

  def install
    # modules/ and vendor/ hold the Tcl modules the launcher puts on the tm
    # path; without them package require streamtree et al. fails at startup.
    pkgshare.install "lib", "ui", "cli", "data", "modules", "vendor"

    # questlog sources lib/ and ui/ relative to ROOT and runs under tclsh, loading
    # Tk only in GUI mode. Point ROOT at the installed tree, and pin the shebang to
    # Homebrew's keg-only tclsh9.0 (not on PATH, so #!/usr/bin/env tclsh9.0 would
    # not resolve); GUI mode's package require Tk resolves against the same keg.
    tclsh = Formula["tcl-tk"].opt_bin/"tclsh9.0"
    cp "questlog", "questlog.install"
    inreplace "questlog.install" do |s|
      s.sub!(/\A#![^\n]*/, "#!#{tclsh}")
      s.gsub!(/^set ROOT .*$/, "set ROOT #{pkgshare}")
    end
    libexec.install "questlog.install" => "questlog"
    chmod 0755, libexec/"questlog"
    bin.install_symlink libexec/"questlog"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/questlog --version")
  end
end
