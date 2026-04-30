class Underscore < Formula
  desc "Spatial visualization for C# and Java codebases"
  homepage "https://github.com/logPhase/underscore-cli"
  url "https://github.com/logPhase/homebrew-tap/releases/download/v0.2.1/underscore-0.2.1-macos-arm64.tar.gz"
  sha256 "b70c5da1bba9a0daade4fc21e96930b90d779fec99e783fce345335c2635ae61"
  version "0.2.1"
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
