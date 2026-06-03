# typed: false
# frozen_string_literal: true

class Agwiki < Formula
  desc "Agent-based wiki CLI: init, ingest, validate, skill export"
  homepage "https://github.com/goagwiki/agwiki"
  version "0.3.8"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.3.8/agwiki-aarch64-apple-darwin.tar.gz"
      sha256 "36913e6fc26baad40be4375262d38ccf16fe2d4f4ff5e2880cc668a20ab7d7ce"
    elsif Hardware::CPU.intel?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.3.8/agwiki-x86_64-apple-darwin.tar.gz"
      sha256 "231d3f20db4a19f5e97f380a272e4c6e30a3644a0f73de52d00ebb11a406043b"
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
        url "https://github.com/goagwiki/agwiki/releases/download/v0.3.8/agwiki-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "dee2d7b92f16e7724c579f3dafdccb1f7b40add5018004c1451509b433002cf8"
      else
        url "https://github.com/goagwiki/agwiki/releases/download/v0.3.8/agwiki-x86_64-unknown-linux-musl.tar.gz"
        sha256 "8468c17d15ed01116d64203e45dd7735e56e2e564f1e81378567ff73dede67af"
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
