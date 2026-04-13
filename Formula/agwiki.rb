# typed: false
# frozen_string_literal: true

class Agwiki < Formula
  desc "Agent-based wiki CLI: init, ingest, validate, skill export"
  homepage "https://github.com/goagwiki/agwiki"
  version "0.1.9"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.1.9/agwiki-aarch64-apple-darwin.tar.gz"
      sha256 "35ce0046d7241540100b646176b54d768e279be0e13bb186f096a27996fc573b"
    elsif Hardware::CPU.intel?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.1.9/agwiki-x86_64-apple-darwin.tar.gz"
      sha256 "9bd792981057263ce5d12e5db4f9346daaa06ad02b2e27f814b8dcff8d8da2dc"
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
        url "https://github.com/goagwiki/agwiki/releases/download/v0.1.9/agwiki-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "1f2b7bb55d84ee27256d528b60c8de60a66133f7ad0631fc1517dddfb3518d33"
      else
        url "https://github.com/goagwiki/agwiki/releases/download/v0.1.9/agwiki-x86_64-unknown-linux-musl.tar.gz"
        sha256 "84a34571f4f61c7497f9dd1a59e14a311db7928eb990b181c73ff65f631103f9"
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
