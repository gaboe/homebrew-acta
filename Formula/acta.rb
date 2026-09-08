class Acta < Formula
  desc "Local meeting recorder and transcriber"
  homepage "https://acta-diurna.gaboe.xyz"
  url "https://github.com/gaboe/homebrew-acta/releases/download/v0.1.0/acta-0.1.0-arm64.tar.gz"
  version "0.1.0"
  # Regenerate this whenever the binary changes: `packaging/release.sh` prints it, and the build is
  # reproducible so the same commit always gives the same value. The previous entry was a stale hash
  # from a local build and would have failed every install with a checksum mismatch.
  sha256 "3f4e31dc245c983db6a4155fa4d663a3644e415e1fa7c0d2cdb1401f55f3ea48"
  depends_on "ffmpeg"
  depends_on "whisper-cpp"

  def install
    odie "acta currently supports Apple Silicon only" unless Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    bin.install "acta"
  end

  def caveats
    <<~EOS
      Finish setup with:

        acta setup
        acta serve --install
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/acta --version")
  end
end
