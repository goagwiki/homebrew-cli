# typed: false
# frozen_string_literal: true

class Agwiki < Formula
  desc "Agent-based wiki CLI: init, ingest, validate, skill export"
  homepage "https://github.com/goagwiki/agwiki"
  version "0.3.15"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.3.15/agwiki-aarch64-apple-darwin.tar.gz"
      sha256 "cfb38b1a7ab8cfbc2ce917030cedd0d6bd3b9cd1d453e00895b41336359119c4"
    elsif Hardware::CPU.intel?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.3.15/agwiki-x86_64-apple-darwin.tar.gz"
      sha256 "86e9269f144924efe40abb6f853aeddde65b69319c3ea759bf0170251001bf1d"
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
        url "https://github.com/goagwiki/agwiki/releases/download/v0.3.15/agwiki-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "acfa1926dc240cdc1eecd18b7a44f02ab0de6e136f1f9d0f028875599e3a5e67"
      else
        url "https://github.com/goagwiki/agwiki/releases/download/v0.3.15/agwiki-x86_64-unknown-linux-musl.tar.gz"
        sha256 "820a084ef970a2abe21a71f9950fe0c6f11b32256943671b32146923afabb775"
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
