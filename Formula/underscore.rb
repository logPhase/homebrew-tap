class Underscore < Formula
  desc "Spatial visualization for C# and Java codebases"
  homepage "https://github.com/logPhase/underscore-cli"
  url "https://github.com/logPhase/homebrew-tap/releases/download/v0.5.0/underscore-0.5.0-macos-arm64.tar.gz"
  sha256 "b42d1993cab3e21e6464cf43e3082d867e173500ffa8bc065e88a83f80e36dde"
  version "0.5.0"
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

      Quick start:
        underscore analyze https://github.com/dotnet/aspnetcore
        underscore pr https://github.com/dotnet/eShop/pull/972

      Disk management:
        underscore clean                    List buckets with sizes
        underscore clean --runs [<project>] Wipe run artifacts (one project, or all)
        underscore clean --sdks             Wipe the .NET runtime + SDK cache
        underscore clean --everything       Nuke ~/.underscore/ (prompts y/N)
    EOS
  end

  test do
    assert_match "underscore #{version}", shell_output("#{bin}/underscore version")
  end
end
