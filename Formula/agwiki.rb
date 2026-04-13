# typed: false
# frozen_string_literal: true

class Agwiki < Formula
  desc "Agent-based wiki CLI: init, ingest, validate, skill export"
  homepage "https://github.com/goagwiki/agwiki"
  version "0.1.3"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.1.3/agwiki-aarch64-apple-darwin.tar.gz"
      sha256 "130566c3459a5ded44b865d368ce3e1caf21f30fd35043d47a6b0b986095339b"
    elsif Hardware::CPU.intel?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.1.3/agwiki-x86_64-apple-darwin.tar.gz"
      sha256 "396e5aadbda48e27ee115878eccf9060c3b068352e05784e19e8bb8dba340a2a"
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
        url "https://github.com/goagwiki/agwiki/releases/download/v0.1.3/agwiki-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "e8979d58b51a030c48ff2c1abfe8f31f095bfc6e9947542477ac100995ed72fb"
      else
        url "https://github.com/goagwiki/agwiki/releases/download/v0.1.3/agwiki-x86_64-unknown-linux-musl.tar.gz"
        sha256 "11ded88ae86c98b7413236bc6db2b6de969e78600e21f9522eb012715fa018d0"
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
