# typed: false
# frozen_string_literal: true

class Agwiki < Formula
  desc "Agent-based wiki CLI: init, ingest, validate, skill export"
  homepage "https://github.com/goagwiki/agwiki"
  version "0.3.5"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.3.5/agwiki-aarch64-apple-darwin.tar.gz"
      sha256 "b0211bd6c2c7b258f28e669f10b6d3926e1256d084f4eade26954d08b4133008"
    elsif Hardware::CPU.intel?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.3.5/agwiki-x86_64-apple-darwin.tar.gz"
      sha256 "94857afed8644ee9a43bb8bed8e9ddccc6e11c6bcf9ff74155afea5264fe64c3"
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
        url "https://github.com/goagwiki/agwiki/releases/download/v0.3.5/agwiki-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "169aac7440e507e060d8cdb88cb9825bfff091870c758cd04606f1ac5f92172d"
      else
        url "https://github.com/goagwiki/agwiki/releases/download/v0.3.5/agwiki-x86_64-unknown-linux-musl.tar.gz"
        sha256 "6714810adecc9015306c1101fd32ccebd5be9151f2a73ce2b6d3692e7a9c2069"
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
