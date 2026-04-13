# typed: false
# frozen_string_literal: true

class Agwiki < Formula
  desc "Agent-based wiki CLI: init, ingest, validate, skill export"
  homepage "https://github.com/goagwiki/agwiki"
  version "0.1.4"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.1.4/agwiki-aarch64-apple-darwin.tar.gz"
      sha256 "a27726df7014e26563e21366a7cbf54f703a31830fcfedb2a0a736ed950ef06f"
    elsif Hardware::CPU.intel?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.1.4/agwiki-x86_64-apple-darwin.tar.gz"
      sha256 "82eef90fc12d03c346cfe31b4001877ab98bc1d896af0e412d0bf1d8f3677b59"
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
        url "https://github.com/goagwiki/agwiki/releases/download/v0.1.4/agwiki-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "71978c3b05aeba308403cc647bb3286fd1f627150b4a65470eedbf41244ad68a"
      else
        url "https://github.com/goagwiki/agwiki/releases/download/v0.1.4/agwiki-x86_64-unknown-linux-musl.tar.gz"
        sha256 "56f14d2c80285b1609363f172195fe4cbfbfe18abaa809888ab55340623fa240"
      end
    else
      odie "Unsupported Linux CPU architecture"
    end
  end

  def install
    bin.install "agwiki"
  end

  test do
    system "#{bin}/agwiki", "--version"
  end
end
