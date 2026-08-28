# homebrew-od

A Homebrew tap for the Overseer's Desk tools. Tap it once, then install any of them:

```sh
brew trust overseers-desk/od
brew tap overseers-desk/od
brew install crude courier questlog
brew install --cask robco-term
```

`brew tap overseers-desk/od` resolves to this repository (`overseers-desk/homebrew-od`) by Homebrew's naming convention, so no URL is needed.

## Formulae

- **crude:** CRUD-style command-line clients for sites without a public API.
- **courier:** email toolkit for AI assistants and command-line scripting.
- **majordomo:** Google Chat task reporting.
- **questlog:** GUI for finding, reading, and reopening past Claude Code sessions.
- **scribe:** hotkey dictation and clipboard restyling.

## Casks

- **robco-term:** RobCo Terminal, a terminal emulator that behaves like a piece of hardware. It is an application rather than a command-line tool, so it installs into `/Applications` and is asked for with `--cask`. Apple Silicon only, and unsigned: macOS refuses the first launch until you open it once from the Finder's context menu.

Each formula and cask pulls its release asset from the tool's own repository (or PyPI), so this tap holds no source code and cuts no releases of its own. A tool release is a single-file edit here: bump the `url` and `sha256` in `Formula/<tool>.rb` or `Casks/<tool>.rb` after the tool's release is published.