class Acta < Formula
  desc "Local meeting recorder and transcriber"
  homepage "https://acta-diurna.gaboe.xyz"
  url "https://github.com/gaboe/homebrew-acta/releases/download/v0.1.9/acta-0.1.9-arm64.tar.gz"
  version "0.1.9"
  # Regenerate this whenever the binary changes: `packaging/release.sh` prints it, and both the
  # binary and the archive are reproducible, so the same commit always gives the same value.
  # The archive only became reproducible once the script stopped letting gzip stamp the time of
  # compression into its header — until then a rebuild of one commit gave a new SHA every time,
  # and the mismatch would have surfaced as a failed install rather than as an error at release.
  sha256 "d2fefd801b0c1943cbe00b68d11201446d1ea22a56be7bc053c8b591292831db"
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
