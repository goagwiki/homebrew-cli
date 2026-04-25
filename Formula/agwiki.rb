# typed: false
# frozen_string_literal: true

class Agwiki < Formula
  desc "Agent-based wiki CLI: init, ingest, validate, skill export"
  homepage "https://github.com/goagwiki/agwiki"
  version "0.2.0"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.2.0/agwiki-aarch64-apple-darwin.tar.gz"
      sha256 "ece944174c2b71a60f5264d72efa8086549d16fc4fb64c7a11fb98f79b9e7433"
    elsif Hardware::CPU.intel?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.2.0/agwiki-x86_64-apple-darwin.tar.gz"
      sha256 "43a6bf0aa4605f78c5c5ca642150d50417bfd84d9dbf112a8d9b4b6bc882e765"
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
        url "https://github.com/goagwiki/agwiki/releases/download/v0.2.0/agwiki-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "1904c0995f1e260baa622f45a7da309ba9aae6fef85f4904c8a9bea1b0c3c5d4"
      else
        url "https://github.com/goagwiki/agwiki/releases/download/v0.2.0/agwiki-x86_64-unknown-linux-musl.tar.gz"
        sha256 "8d258553e07e79d0f7e3918c6d9532d307f7079c0f97520c23aa6b35a0d2ef33"
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
