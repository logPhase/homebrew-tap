# Releasing a New Version of Underscore

Step-by-step procedure for cutting a new release. Assumes you have:
- Push access to `logPhase/underscore-cli` and `logPhase/homebrew-tap`
- `gh` CLI authenticated (`gh auth status`)

## 1. Bump version in underscore-cli

Update `src/underscore_cli/main.clj`:

```clojure
(def version "X.Y.Z")
```

Commit and push to the release branch:

```bash
cd ~/projects/underscore-cli   # or wherever your clone is
git add src/underscore_cli/main.clj
git commit -m "bump version to X.Y.Z"
git push origin <branch>
```

## 2. Tag the release

```bash
git tag vX.Y.Z
git push origin vX.Y.Z
```

The tag push triggers the `release-native` workflow at
`.github/workflows/release-native.yml`. The workflow:
1. Validates the tag matches `main.clj`'s version.
2. Sets up .NET 9 SDK, JDK 21, Clojure, Node on a `macos-14` runner.
3. Runs `scripts/build-native.sh` to produce
   `dist/underscore-X.Y.Z-macos-arm64.tar.gz`.
4. Publishes the tarball as a workflow artifact (downloadable for 30 days).
5. Posts the SHA256 to the workflow run summary.

Wait for the run to finish (~10 minutes).

## 3. Download the artifact

From the workflow run page on GitHub:
- Click into the most recent `release-native` run for tag `vX.Y.Z`.
- Scroll to **Artifacts** and download `underscore-X.Y.Z-macos-arm64`.
- Unzip locally — you should get `underscore-X.Y.Z-macos-arm64.tar.gz`.

Or via CLI:

```bash
cd ~/Downloads
gh run download --repo logPhase/underscore-cli \
    -n underscore-X.Y.Z-macos-arm64 \
    $(gh run list --repo logPhase/underscore-cli \
                  --workflow release-native --limit 1 \
                  --json databaseId -q '.[0].databaseId')
```

## 4. Note the SHA256

From the workflow run summary, or recompute:

```bash
shasum -a 256 underscore-X.Y.Z-macos-arm64.tar.gz
```

Copy the SHA. You'll paste it into the formula in step 6.

## 5. Create the release on the tap

```bash
gh release create vX.Y.Z \
    --repo logPhase/homebrew-tap \
    --title "underscore vX.Y.Z (macOS ARM64)" \
    --notes "Homebrew tarball for vX.Y.Z." \
    underscore-X.Y.Z-macos-arm64.tar.gz
```

This uploads the tarball to a new GitHub release on the tap repo, which is
where the formula's `url` field points.

## 6. Update the formula

In this tap repo, edit `Formula/underscore.rb`:

```ruby
url "https://github.com/logPhase/homebrew-tap/releases/download/vX.Y.Z/underscore-X.Y.Z-macos-arm64.tar.gz"
sha256 "<SHA256 from step 4>"
version "X.Y.Z"
```

Commit and push:

```bash
git add Formula/underscore.rb
git commit -m "bump underscore to vX.Y.Z"
git push origin main
```

## 7. Smoke test the install

On a Mac (Apple Silicon):

```bash
brew update
brew uninstall underscore 2>/dev/null || true
rm -rf ~/.underscore   # clean slate
brew install logphase/tap/underscore

underscore version            # should print: underscore X.Y.Z
underscore analyze ./some-csharp-repo
```

If anything is off, you can roll back by reverting the formula commit on
the tap and pointing users back at the previous version.

## Notes

- **The tarball is built on Apple Silicon and is macOS-ARM64 only.** Intel
  Mac and Linux are not supported at present.
- **The formula carries no runtime `depends_on`.** Adding any system
  runtime dep here would re-introduce the version-drift class of failures
  that motivated the bundling architecture.
- **Re-running step 2 with the same tag** does nothing — tags are
  immutable. To rebuild, either delete the tag remotely (`git push --delete
  origin vX.Y.Z`) and re-push, or use `workflow_dispatch` from the Actions
  UI with the version as input.
- **Hotfix without re-tagging:** if you need to ship a fix without changing
  the version number, delete and recreate the GitHub release on the tap
  with a fresh tarball, update the SHA in the formula, push. Avoid this
  unless necessary — version bumps are cheaper to reason about.
