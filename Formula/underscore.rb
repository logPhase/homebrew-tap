class Underscore < Formula
  desc "Spatial visualization for C# and Java codebases"
  homepage "https://github.com/logPhase/underscore-cli"
  url "https://github.com/logPhase/homebrew-tap/releases/download/v0.7.1/underscore-0.7.1-macos-arm64.tar.gz"
  sha256 "f08517df59e127da042f503a7544791bf84fc2a7a950cd50eada46db9cc68b5f"
  version "0.7.1"
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
