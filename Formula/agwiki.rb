# typed: false
# frozen_string_literal: true

class Agwiki < Formula
  desc "Agent-based wiki CLI: init, ingest, validate, skill export"
  homepage "https://github.com/goagwiki/agwiki"
  version "0.3.11"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.3.11/agwiki-aarch64-apple-darwin.tar.gz"
      sha256 "89b8c2a37774254064c616b6b14dd033569844df4ee62c76d7232159e72597c2"
    elsif Hardware::CPU.intel?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.3.11/agwiki-x86_64-apple-darwin.tar.gz"
      sha256 "3f070061645f7cd37bdfbb411da98725c3a232157fabc932307c8022c04b3aef"
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
        url "https://github.com/goagwiki/agwiki/releases/download/v0.3.11/agwiki-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "3ed48c4cf76583d63e72b8e06eb68c06df56907c9f31895edd8f0f3fdd90c762"
      else
        url "https://github.com/goagwiki/agwiki/releases/download/v0.3.11/agwiki-x86_64-unknown-linux-musl.tar.gz"
        sha256 "3986d2c03e701f9b30e44ea6799f52d62056756a40e7e9ff633c79c8ce4b23c7"
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
