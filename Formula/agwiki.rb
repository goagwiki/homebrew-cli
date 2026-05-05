# typed: false
# frozen_string_literal: true

class Agwiki < Formula
  desc "Agent-based wiki CLI: init, ingest, validate, skill export"
  homepage "https://github.com/goagwiki/agwiki"
  version "0.3.3"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.3.3/agwiki-aarch64-apple-darwin.tar.gz"
      sha256 "8e8417d6b36a1d3c577fe8c4a3e254df1d184f263547bcd6ad98f43d0be2fba5"
    elsif Hardware::CPU.intel?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.3.3/agwiki-x86_64-apple-darwin.tar.gz"
      sha256 "c0e2b0bcad58bae977e506b9a81b4a71f73b8613f690479aa98ed13639bda951"
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
        url "https://github.com/goagwiki/agwiki/releases/download/v0.3.3/agwiki-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "00e0545d3e588fad6ba110d5e4cbedf9ca48e784775bea48424b82c2348e6579"
      else
        url "https://github.com/goagwiki/agwiki/releases/download/v0.3.3/agwiki-x86_64-unknown-linux-musl.tar.gz"
        sha256 "e3a3e2808a33fa7cfb65cded1d12771beb31acb0094e85b87882e7804beee825"
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
