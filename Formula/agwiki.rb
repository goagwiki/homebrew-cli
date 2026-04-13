# typed: false
# frozen_string_literal: true

class Agwiki < Formula
  desc "Agent-based wiki CLI: init, ingest, validate, skill export"
  homepage "https://github.com/goagwiki/agwiki"
  version "0.1.8"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.1.8/agwiki-aarch64-apple-darwin.tar.gz"
      sha256 "307e69531aff475a34c06f06557ed7ab2459924e3e4cbe57daf8a12d50d29c08"
    elsif Hardware::CPU.intel?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.1.8/agwiki-x86_64-apple-darwin.tar.gz"
      sha256 "1c94431ec1fed77bf402515c881d38c6ac26382e76dda3a03c9d81f21622878b"
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
        url "https://github.com/goagwiki/agwiki/releases/download/v0.1.8/agwiki-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "eb36b82e00f8178760a09d15d95de8dd74f41d96e789b0682ddcd66d6e173522"
      else
        url "https://github.com/goagwiki/agwiki/releases/download/v0.1.8/agwiki-x86_64-unknown-linux-musl.tar.gz"
        sha256 "6e21a848a5eccfddd4d88e420bf94e307ea7b2984fe078c226977fa232a4cda2"
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
