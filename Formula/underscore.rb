class Underscore < Formula
  desc "Spatial visualization for C# and Java codebases"
  homepage "https://github.com/logPhase/underscore-cli"
  url "https://github.com/logPhase/homebrew-tap/releases/download/v0.1.5/underscore-0.1.5-macos-arm64.tar.gz"
  sha256 "d1e2ea2874e9dccad8f3874664198b0a30901b185426d5ef5cc12f1a9d1395d1"
  version "0.1.5"
  license :cannot_represent

  depends_on arch: :arm64
  depends_on "dotnet"
  depends_on "openjdk@21"
  depends_on "git"

  def install
    libexec.install Dir["libexec/*"]
    bin.install "bin/underscore"
  end

  def caveats
    <<~EOS
      Analysis data is stored in ~/.underscore/

      Quick start:
        underscore analyze https://github.com/dotnet/aspnetcore
        underscore analyze ./my-local-repo
        underscore pr ./repo --base main

      To clean up cached data:
        underscore clean --all

      To enable AI-powered journey narratives:
        export ANTHROPIC_API_KEY=<your-key>
    EOS
  end

  test do
    assert_match "underscore #{version}", shell_output("#{bin}/underscore version")
  end
end
