# typed: false
# frozen_string_literal: true

class Agwiki < Formula
  desc "Agent-based wiki CLI: init, ingest, validate, skill export"
  homepage "https://github.com/goagwiki/agwiki"
  version "0.1.5"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.1.5/agwiki-aarch64-apple-darwin.tar.gz"
      sha256 "7e6cd5896d9c540c0c9435be7bd447befa0ad4c2218e3f66e177495cd840af90"
    elsif Hardware::CPU.intel?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.1.5/agwiki-x86_64-apple-darwin.tar.gz"
      sha256 "e3ca4dc38eed471c6f35919eca7fa0e19db4cbb2ba734761abc2d65fab62fa6f"
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
        url "https://github.com/goagwiki/agwiki/releases/download/v0.1.5/agwiki-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "8317e702aab6d4feb1570ac3212ceb4d17d11f2e9a4fd24b2a7d52d6dcb7f07c"
      else
        url "https://github.com/goagwiki/agwiki/releases/download/v0.1.5/agwiki-x86_64-unknown-linux-musl.tar.gz"
        sha256 "0c01ac6e7b8adc43208807c83ffe70b5a8e98f8e4f9a538a156f7fadb2faf7ae"
      end
    else
      odie "Unsupported Linux CPU architecture"
    end
  end

  def install
    bin.install "agwiki"
  end

  test do
    system "#{bin}/agwiki", "--version"
  end
end
