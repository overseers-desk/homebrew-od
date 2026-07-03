# Homebrew formula for scribe.
# Install:
#   brew tap overseers-desk/od
#   brew install scribe
#
# NOTE: scribe runs without configuration as a dictation tool. On macOS it
# records through sox (coreaudio) and delivers through the system's own
# osascript (Cmd+V paste, keystroke typing) and pbcopy; the macOS delivery
# paths are a best-attempt port, untested on real hardware so far. On Linux
# it records with pw-record (sox is the fallback when pw-record is absent),
# with dotool for keystrokes and wl-copy/xclip for the clipboard (from the
# distro, not this formula). The optional style pass needs the json/yaml
# (tcllib) and tls Tcl packages.

class Scribe < Formula
  desc "Take dictation or clipboard text, restyle it, and type/paste it back"
  homepage "https://github.com/overseers-desk/scribe"
  url "https://github.com/overseers-desk/scribe/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "aea61a9c26fc5bb9cd27c034dd342ea8a2cead76bb4693c7a5eb3f0bff2de309"
  license "GPL-3.0-only"

  depends_on "tcl-tk"
  on_macos do
    depends_on "sox"
  end

  def install
    # scribe.tcl finds its sibling config/data via APP_DIR = dirname of the
    # normalised [info script]. Install the script alongside its data in pkgshare
    # and symlink it onto PATH; file normalize resolves the symlink, so APP_DIR
    # lands in pkgshare where the data lives. deepseek.json is user-supplied (not
    # shipped) and current-mode.conf is runtime state, so neither is installed.
    pkgshare.install "scribe.tcl", "styles", "system-prompts.yaml",
                     "dialect-us-to-british.tsv", "config.example.toml"

    # Pin the shebang to Homebrew's keg-only wish9.0 (tcl-tk is not on PATH, so
    # #!/usr/bin/env wish9.0 would not resolve).
    wish = Formula["tcl-tk"].opt_bin/"wish9.0"
    inreplace pkgshare/"scribe.tcl" do |s|
      s.sub!(/\A#![^\n]*/, "#!#{wish}")
    end
    chmod 0755, pkgshare/"scribe.tcl"
    bin.install_symlink pkgshare/"scribe.tcl" => "scribe"
  end

  def caveats
    <<~EOS
      Dictation (--input mic) needs whisper-cli and a whisper model:
        brew install whisper-cpp
      then pass --model /path/to/ggml-*.bin.
      #{"On macOS, grant the app that launches scribe (e.g. your terminal) Accessibility permission (typing/pasting) and Microphone permission, under System Settings > Privacy & Security." if OS.mac?}
    EOS
  end

  test do
    assert_path_exists pkgshare/"scribe.tcl"
    assert_match "wish9.0", File.read(pkgshare/"scribe.tcl").lines.first
  end
end
