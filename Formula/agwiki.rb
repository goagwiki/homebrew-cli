# typed: false
# frozen_string_literal: true

class Agwiki < Formula
  desc "Agent-based wiki CLI: init, ingest, validate, skill export"
  homepage "https://github.com/goagwiki/agwiki"
  version "0.1.12"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.1.12/agwiki-aarch64-apple-darwin.tar.gz"
      sha256 "d35710efc704ad9579fefdbd9e2610bb75352ebf6edc20ba0ca5794991f44043"
    elsif Hardware::CPU.intel?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.1.12/agwiki-x86_64-apple-darwin.tar.gz"
      sha256 "a29f3388e15a533fe75fd6083abdbfd84684f550b73165ad651413ef06385aba"
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
        url "https://github.com/goagwiki/agwiki/releases/download/v0.1.12/agwiki-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "cf3da5f468b90e0b773ed97c7c3ee82cb46940ebd282f79333594456d60bcf14"
      else
        url "https://github.com/goagwiki/agwiki/releases/download/v0.1.12/agwiki-x86_64-unknown-linux-musl.tar.gz"
        sha256 "e7bae6f4baa1da9580cab37f27b40bf13530e7ff3ffe595e149040d3cd0a62bb"
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
