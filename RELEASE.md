# Releasing a New Version of Underscore

End-to-end procedure for cutting a new release. The `release-native`
workflow on `logPhase/underscore-cli` handles the build, the tap commit,
and the tap GitHub Release in one shot — only steps 1, 2, and 3 require
you to do anything.

## Prerequisites (one-time setup)

- Push access to `logPhase/underscore-cli`.
- A repo secret on `logPhase/underscore-cli` named `HOMEBREW_TAP_TOKEN`
  — a PAT with `public_repo` scope (or `repo` for broader access). The
  workflow uses this to commit to `homebrew-tap` and create the release
  on it. The default `GITHUB_TOKEN` cannot cross repos.
- `gh` CLI authenticated (`gh auth status`) if you want to manage tags
  or releases from the CLI.

## 1. Bump version in underscore-cli

Update `src/underscore_cli/main.clj`:

```clojure
(def version "X.Y.Z")
```

Commit and push to the release branch:

```bash
cd ~/projects/underscore-cli
git add src/underscore_cli/main.clj
git commit -m "bump version to X.Y.Z"
git push origin <branch>
```

## 2. Tag the release

```bash
git tag vX.Y.Z
git push origin vX.Y.Z
```

The tag push triggers `release-native` at
`.github/workflows/release-native.yml`. The workflow:

1. Validates the tag matches `main.clj`'s `(def version …)`.
2. Sets up .NET 10 SDK, JDK 21, Clojure, Node on a `macos-14` runner.
3. Runs `scripts/build-native.sh` to produce
   `dist/underscore-X.Y.Z-macos-arm64.tar.gz` and its SHA-256.
4. Checks out `logPhase/homebrew-tap` using `HOMEBREW_TAP_TOKEN`,
   sed-edits `Formula/underscore.rb` (`url`, `sha256`, `version`),
   commits as `github-actions[bot]`, pushes to `main`.
5. `gh release create vX.Y.Z --target main` on `homebrew-tap` with the
   tarball attached — the tag is created automatically and points at
   the formula-bump commit.

Wait for the run to finish (~10 minutes). Track it at
https://github.com/logPhase/underscore-cli/actions/workflows/release-native.yml.

When green, the formula on this repo is already updated and the release
is already published — there is no manual step in between.

## 3. Smoke test the install

On a Mac (Apple Silicon):

```bash
brew update
brew uninstall underscore 2>/dev/null || true
rm -rf ~/.underscore   # optional — clean slate

brew install logphase/tap/underscore        # first install
# or:
brew upgrade logphase/tap/underscore        # if previously installed

underscore version            # should print: underscore X.Y.Z
underscore analyze ./some-csharp-repo
```

If anything is off, see Rollback below.

## Notes

- **macOS-ARM64 only.** Intel Mac and Linux are not supported at present.
- **No runtime `depends_on`.** Adding one would re-introduce the
  version-drift class of failures that motivated the bundling
  architecture.
- **Re-running step 2 with the same tag** does nothing — tags are
  immutable. To rebuild, either delete the tag remotely
  (`git push --delete origin vX.Y.Z`) and re-push, or use
  `workflow_dispatch` from the Actions UI with the version as input.
- **Idempotent re-runs.** If the workflow gets partway through and
  fails (e.g. the release-create step), you can re-run it via
  `workflow_dispatch` with the same version. The formula-bump step
  skips itself when the formula is already at `vX.Y.Z`. The release-
  create step will still fail if a release with that tag already
  exists — delete it on `homebrew-tap` first and re-run.
- **Hotfix without re-tagging:** if you need to ship a fix without
  changing the version number, delete the GitHub release on the tap,
  delete the tag, then re-run the workflow with `workflow_dispatch`.
  Avoid this unless necessary — version bumps are cheaper to reason
  about.

## Rollback

If a release is bad:

```bash
# Delete the bad tap release + tag
gh release delete vX.Y.Z --repo logPhase/homebrew-tap --yes
git -C ~/projects/homebrew-tap push --delete origin vX.Y.Z

# Revert the formula bump
git -C ~/projects/homebrew-tap revert <bump-sha>
git -C ~/projects/homebrew-tap push origin main
```

`brew update && brew upgrade` on user machines will then resolve to the
previous formula version.
