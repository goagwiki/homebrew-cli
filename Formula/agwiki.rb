# typed: false
# frozen_string_literal: true

class Agwiki < Formula
  desc "Agent-based wiki CLI: init, ingest, validate, skill export"
  homepage "https://github.com/goagwiki/agwiki"
  version "0.1.14"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.1.14/agwiki-aarch64-apple-darwin.tar.gz"
      sha256 "81c4d918b5bb2a0565bdfde9aead3ab41bf59e7c41cc665674b89da2eadb43b5"
    elsif Hardware::CPU.intel?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.1.14/agwiki-x86_64-apple-darwin.tar.gz"
      sha256 "a069e3f521edac2f1b25db4a47fe553c520d537726421a72570f73db96786f46"
    else
      odie "Unsupported macOS CPU architecture"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      # Detect glibc version to choose appropriate binary.
      # glibc >= 2.38: use GNU binary for dynamic-linking environments.
      # glibc < 2.38 or musl-based systems: use MUSL binary for compatibility.
      glibc_version = begin
        `ldd --version 2>&1`.lines.first.to_s[/(\d+\.\d+)/].to_f
      rescue
        0
      end

      if glibc_version >= 2.38
        url "https://github.com/goagwiki/agwiki/releases/download/v0.1.14/agwiki-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "10fbcf34d03d283ca660bde453ad60778c8904899b89efba6e22b2721cb52233"
      else
        url "https://github.com/goagwiki/agwiki/releases/download/v0.1.14/agwiki-x86_64-unknown-linux-musl.tar.gz"
        sha256 "b9e0e2a42a37590cb626c09ca51bdb0494cf3f482a4387270573d390952086ca"
      end
    else
      odie "Unsupported Linux CPU architecture"
    end
  end

  def install
    bin.install "agwiki"
  end

  test do
    system bin/"agwiki", "--version"
  end
end
