# typed: false
# frozen_string_literal: true

class Agwiki < Formula
  desc "Agent-based wiki CLI: init, ingest, validate, skill export"
  homepage "https://github.com/goagwiki/agwiki"
  version "0.3.7"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.3.7/agwiki-aarch64-apple-darwin.tar.gz"
      sha256 "38fcb6cc830d54229352e436ae705c9cbbc27e202bd6109b09760af3a3c4eb59"
    elsif Hardware::CPU.intel?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.3.7/agwiki-x86_64-apple-darwin.tar.gz"
      sha256 "f69850d51df7bded281f88b12c1bbc394a5d689b3fd885e14ec770fd01b7f940"
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
        url "https://github.com/goagwiki/agwiki/releases/download/v0.3.7/agwiki-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "9b472d741a0676b7cebec1acaa444c7775d743dc6ad2881bb515aff64841feac"
      else
        url "https://github.com/goagwiki/agwiki/releases/download/v0.3.7/agwiki-x86_64-unknown-linux-musl.tar.gz"
        sha256 "0fd9108baef8b49f9902103de5c3f4085cf590f13f5d7e380b0d662426ba3b58"
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
