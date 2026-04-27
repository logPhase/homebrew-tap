# Homebrew Tap for Underscore

Spatial visualization for C# and Java codebases.

## Install

```bash
brew install logphase/tap/underscore
```

## Usage

```bash
underscore analyze https://github.com/org/repo
underscore analyze ./local-repo
underscore pr ./repo --base main
```

## Update

```bash
brew upgrade logphase/tap/underscore
```

## Uninstall

```bash
brew uninstall underscore
rm -rf ~/.underscore  # optional: remove cached analysis data
```
