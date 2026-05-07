# typed: false
# frozen_string_literal: true

class Agwiki < Formula
  desc "Agent-based wiki CLI: init, ingest, validate, skill export"
  homepage "https://github.com/goagwiki/agwiki"
  version "0.3.4"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.3.4/agwiki-aarch64-apple-darwin.tar.gz"
      sha256 "bc7f39d33738a1680bfecb189749fa82ce8efda3409a3977911a515a2b4cdde9"
    elsif Hardware::CPU.intel?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.3.4/agwiki-x86_64-apple-darwin.tar.gz"
      sha256 "56c1c1a4ecaca055015ba8fc1a5de59963e9a622e4e98b09d8b83e3ca9548cb4"
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
        url "https://github.com/goagwiki/agwiki/releases/download/v0.3.4/agwiki-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "a12f4faeaf6f895674eb9d24305658b9bd3511adf7de67ea6e466669e4be90af"
      else
        url "https://github.com/goagwiki/agwiki/releases/download/v0.3.4/agwiki-x86_64-unknown-linux-musl.tar.gz"
        sha256 "e317f2e34bc55297c0b65cfa9a528a123cb999b275d64d1d8ba4a7a9793b54f7"
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
