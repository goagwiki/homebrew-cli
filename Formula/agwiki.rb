# typed: false
# frozen_string_literal: true

class Agwiki < Formula
  desc "Agent-based wiki CLI: init, ingest, validate, skill export"
  homepage "https://github.com/goagwiki/agwiki"
  version "0.2.1"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.2.1/agwiki-aarch64-apple-darwin.tar.gz"
      sha256 "bfe5d15b44b79a000c206eb1d631427f326a55c3ff72a1853e968f0202001646"
    elsif Hardware::CPU.intel?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.2.1/agwiki-x86_64-apple-darwin.tar.gz"
      sha256 "6a7bb2b6c122e3e4efac75a493410aa4f744bd20054732cdc6ee22d5f5ba38df"
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
        url "https://github.com/goagwiki/agwiki/releases/download/v0.2.1/agwiki-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "64501093da70fd662c0ca4ba009d521bc0fa1c6a73b1fe87c0d46568e5d7cddb"
      else
        url "https://github.com/goagwiki/agwiki/releases/download/v0.2.1/agwiki-x86_64-unknown-linux-musl.tar.gz"
        sha256 "a7835b9d2a23099afb075be4d078a2fa408a64da844539cb6812530edc4da081"
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
