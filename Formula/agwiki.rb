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
      sha256 "d9880e1f2f6cffa8dbe0dcf30db1624b5d9c76be585a8beea029d030b9c75d1c"
    elsif Hardware::CPU.intel?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.2.0/agwiki-x86_64-apple-darwin.tar.gz"
      sha256 "8e122b3e0bf9a20e47e90d7ac561cf51017bd2146ef997a902dfebd9fe179085"
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
        sha256 "18186d66a0aadcbe5eca47b2ac94efabfd138a5619ac9d408933f7dcf00172cc"
      else
        url "https://github.com/goagwiki/agwiki/releases/download/v0.2.0/agwiki-x86_64-unknown-linux-musl.tar.gz"
        sha256 "c3a11487fe49a0f963ef5526c5cb6c0368a154e168d1f8b3e414f4af41b903d7"
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
