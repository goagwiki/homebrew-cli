# typed: false
# frozen_string_literal: true

class Agwiki < Formula
  desc "Agent-based wiki CLI: init, ingest, validate, skill export"
  homepage "https://github.com/goagwiki/agwiki"
  version "0.2.2"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.2.2/agwiki-aarch64-apple-darwin.tar.gz"
      sha256 "8987a0df8d12168d48e70c40c5d85c601a8fcb0dd4006b6c1816122db06d247f"
    elsif Hardware::CPU.intel?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.2.2/agwiki-x86_64-apple-darwin.tar.gz"
      sha256 "beabdc0895fdacb4ee9b705be29fd3078cad76434ea4c8895b12ece23a3417a6"
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
        url "https://github.com/goagwiki/agwiki/releases/download/v0.2.2/agwiki-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "3db2a16dbe6866310511b06e9ec1f6d0a44e194e28a2f8dd717ff92808a120d9"
      else
        url "https://github.com/goagwiki/agwiki/releases/download/v0.2.2/agwiki-x86_64-unknown-linux-musl.tar.gz"
        sha256 "1e741370dbd7d0411e66b060965e564e78f1815ee02c62fbf1fa1520939df984"
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
