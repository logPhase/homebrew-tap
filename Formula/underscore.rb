class Underscore < Formula
  desc "Spatial visualization for C# and Java codebases"
  homepage "https://github.com/logPhase/underscore-cli"
  url "https://github.com/logPhase/underscore-cli/releases/download/v0.1.5-native/underscore-0.1.5-macos-arm64.tar.gz"
  sha256 "6de50ef6d15d76cfd49b2757f7ac8373b94500048a52d6c13fd867ca6dd940bc"
  version "0.1.5"
  license :cannot_represent

  depends_on arch: :arm64
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
