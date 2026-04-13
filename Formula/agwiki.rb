# typed: false
# frozen_string_literal: true

class Agwiki < Formula
  desc "Agent-based wiki CLI: init, ingest, validate, skill export"
  homepage "https://github.com/goagwiki/agwiki"
  version "0.1.10"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.1.10/agwiki-aarch64-apple-darwin.tar.gz"
      sha256 "4e8d4794344767e04dbd0544032f5183c511060c42370f644b514cf3b24104db"
    elsif Hardware::CPU.intel?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.1.10/agwiki-x86_64-apple-darwin.tar.gz"
      sha256 "a04bbf9d13506338497efcf85439ad058862aead7978175e0e7e92bc2800413b"
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
        url "https://github.com/goagwiki/agwiki/releases/download/v0.1.10/agwiki-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "82b7dcb7ed89ac924a31c2131fd766ad738cfc9bc5205d99733cd8ec1797773d"
      else
        url "https://github.com/goagwiki/agwiki/releases/download/v0.1.10/agwiki-x86_64-unknown-linux-musl.tar.gz"
        sha256 "e920b5dfde19025e3a711f4e30fc0b4fbd3ef5e858c318a97b8944c6e97eb360"
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
