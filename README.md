# Homebrew Tap for Underscore

Spatial visualization for C# and Java codebases.

## Install

```bash
brew install logphase/tap/underscore
```

No prerequisites. The tarball bundles its own JRE and .NET runtime — you do
not need Java, .NET, or any other runtime installed on your machine.

The first time you run `underscore`, it copies the bundled .NET runtime to
`~/.underscore/dotnet` (5–10 seconds, one-time). After that, startup is
instant.

## Requirements

- macOS on Apple Silicon (M1/M2/M3/M4)
- ~1 GB of free disk: ~250 MB for the install, ~700 MB for the runtime cache
  in `~/.underscore/`

## Usage

```bash
underscore analyze https://github.com/org/repo
underscore analyze ./local-repo
underscore pr ./repo --base main
```

When analyzing a repo whose target framework isn't `net9.0` (the bundled
SDK), underscore lazy-installs the matching .NET SDK on first use — same
pattern as `rustup`/`nvm`/`pyenv`. Cached SDKs live under
`~/.underscore/dotnet/sdk/`.

To enable AI-generated journey narratives:

```bash
export ANTHROPIC_API_KEY=<your-key>
```

## Update

```bash
brew upgrade logphase/tap/underscore
```

The runtime cache in `~/.underscore/` is preserved across upgrades. If the
bundled .NET runtime version changes between releases, the launcher
re-seeds the cache on next run.

## Uninstall

```bash
brew uninstall underscore
rm -rf ~/.underscore  # optional: remove cached analysis data + SDK cache
```

## Troubleshooting

```bash
# Wipe the .NET runtime + SDK cache (re-seeded on next run):
underscore clean --sdks

# List or delete cached analysis databases:
underscore clean
underscore clean --all
```

## Releasing a New Version

See [RELEASE.md](./RELEASE.md) for the step-by-step release procedure.
