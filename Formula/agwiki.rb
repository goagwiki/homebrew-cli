# typed: false
# frozen_string_literal: true

class Agwiki < Formula
  desc "Agent-based wiki CLI: init, ingest, validate, skill export"
  homepage "https://github.com/goagwiki/agwiki"
  version "0.3.10"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.3.10/agwiki-aarch64-apple-darwin.tar.gz"
      sha256 "cbebfe45995dc0243fcbbb8f769a0737a981f60f3eca7903b0f68995de91644c"
    elsif Hardware::CPU.intel?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.3.10/agwiki-x86_64-apple-darwin.tar.gz"
      sha256 "dfa480bd01fd6805e0e7c9dc1323cece36a83ddf1a2dd9f5c1178d3e979ac6cb"
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
        url "https://github.com/goagwiki/agwiki/releases/download/v0.3.10/agwiki-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "06adea8132cb57f33028992905531a8a4d598519af8cd3fd3d66e484e6d7c7ba"
      else
        url "https://github.com/goagwiki/agwiki/releases/download/v0.3.10/agwiki-x86_64-unknown-linux-musl.tar.gz"
        sha256 "8ff392b12e8f9555f3d0df7f4234b013f05013288480e666e2f1b84708d59cfe"
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
