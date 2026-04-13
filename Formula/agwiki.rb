# typed: false
# frozen_string_literal: true

class Agwiki < Formula
  desc "Agent-based wiki CLI: init, ingest, validate, skill export"
  homepage "https://github.com/goagwiki/agwiki"
  version "0.1.7"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.1.7/agwiki-aarch64-apple-darwin.tar.gz"
      sha256 "9641874cbefad6f9a135547232445e4f22839af27b11ae366c6c76e63cc35138"
    elsif Hardware::CPU.intel?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.1.7/agwiki-x86_64-apple-darwin.tar.gz"
      sha256 "24afc432006c6c3ab8d8007ab16bf2faa9b9dcba8cce772f360de3e5bfb1bb4c"
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
        url "https://github.com/goagwiki/agwiki/releases/download/v0.1.7/agwiki-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "117cde3d89c7774d51eaa971dd660615f74881c18459a16bdee2da5a31b1fd58"
      else
        url "https://github.com/goagwiki/agwiki/releases/download/v0.1.7/agwiki-x86_64-unknown-linux-musl.tar.gz"
        sha256 "c4aa0bc3722fbe9e9ca326e3c6c7eae474440982884362d73f70fcc7a32c1a68"
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
