# typed: false
# frozen_string_literal: true

class Agwiki < Formula
  desc "Agent-based wiki CLI: init, ingest, validate, skill export"
  homepage "https://github.com/goagwiki/agwiki"
  version "0.1.11"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.1.11/agwiki-aarch64-apple-darwin.tar.gz"
      sha256 "cfbd20d97364802091e774346357554189defe177455c20414abc327355e40bc"
    elsif Hardware::CPU.intel?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.1.11/agwiki-x86_64-apple-darwin.tar.gz"
      sha256 "9b2f2b762bd9359d8ec850907824370ab78256c9d2d5836ce7bd72e8ae558666"
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
        url "https://github.com/goagwiki/agwiki/releases/download/v0.1.11/agwiki-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "ef2c730ba2f1b56183e0211816de5bcf739f3d30e274bffa7b0ad5ff5cc8bda6"
      else
        url "https://github.com/goagwiki/agwiki/releases/download/v0.1.11/agwiki-x86_64-unknown-linux-musl.tar.gz"
        sha256 "0f0e00b295c78f6ed0de944be1bbd63c6408c58e0f614807d84cdf7b6baa8fe1"
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
