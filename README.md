# Homebrew Tap for Underscore

Spatial visualization for C# and Java codebases.

## Install

```bash
brew install logphase/tap/underscore
```

No prerequisites — the tarball bundles its own JRE and .NET runtime. The
first run copies the bundled .NET runtime to `~/.underscore/dotnet/`
(5–10 s, one-time).

## Usage

```bash
underscore analyze https://github.com/dotnet/aspnetcore
underscore pr https://github.com/dotnet/eShop/pull/972
```

`analyze` produces a spatial map of the codebase; `pr` overlays the changes
from a pull request onto that map. See `underscore --help` for the full
flag list.

## Requirements

- macOS on Apple Silicon (M1/M2/M3/M4)
- ~1 GB free disk: ~250 MB install + ~700 MB runtime cache under `~/.underscore/`

## Update / Uninstall

```bash
brew upgrade logphase/tap/underscore
brew uninstall underscore
rm -rf ~/.underscore   # optional: wipe cached run artifacts and SDK cache
```

The `~/.underscore/` cache is preserved across upgrades. If the bundled
.NET runtime changes between releases, the launcher re-seeds it on next
run.

## Disk management

Everything underscore writes lives under `~/.underscore/`. To inspect or
prune:

```bash
underscore clean                       # list buckets with sizes
underscore clean --runs [<project>]    # wipe run artifacts (one or all)
underscore clean --sdks                # wipe .NET runtime + SDK cache
underscore clean --everything          # nuke ~/.underscore/ (prompts y/N)
```

## Releasing a New Version

See [RELEASE.md](./RELEASE.md).
