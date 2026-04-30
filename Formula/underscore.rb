class Underscore < Formula
  desc "Spatial visualization for C# and Java codebases"
  homepage "https://github.com/logPhase/underscore-cli"
  url "https://github.com/logPhase/homebrew-tap/releases/download/v0.2.2/underscore-0.2.2-macos-arm64.tar.gz"
  sha256 "29877c71bc9f34748013cf1944ca40457e2f162ce503ff7a998a30bd7fa8f946"
  version "0.2.2"
  license :cannot_represent

  depends_on arch: :arm64
  # No runtime depends_on — JRE and .NET runtime are bundled.

  def install
    libexec.install Dir["libexec/*"]
    bin.install "bin/underscore"
  end

  def caveats
    <<~EOS
      First run copies the bundled .NET runtime to ~/.underscore/dotnet (5-10s, once).
      All underscore state lives under ~/.underscore/:
        datomic/  per-project analysis databases
        runs/     last 5 output JSONs per project (auto-pruned)
        dotnet/   bundled runtime + lazy-installed SDKs
        www/      webapp data per port

      Quick start:
        underscore analyze https://github.com/dotnet/aspnetcore
        underscore analyze ./my-local-repo
        underscore pr ./repo --base main

      Disk management:
        underscore clean                    List buckets with sizes
        underscore clean --all              Delete all Datomic databases
        underscore clean --runs [<project>] Wipe run artifacts (one project, or all)
        underscore clean --sdks             Wipe the .NET runtime + SDK cache
        underscore clean --everything       Nuke ~/.underscore/ (prompts y/N)

      To enable AI-powered journey narratives:
        export ANTHROPIC_API_KEY=<your-key>
    EOS
  end

  test do
    assert_match "underscore #{version}", shell_output("#{bin}/underscore version")
  end
end
