# typed: false
# frozen_string_literal: true

class Agwiki < Formula
  desc "Agent-based wiki CLI: init, ingest, validate, skill export"
  homepage "https://github.com/goagwiki/agwiki"
  version "0.3.9"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.3.9/agwiki-aarch64-apple-darwin.tar.gz"
      sha256 "2da16762803b45c766c2bbcf381cbcc1591c46bd5922003677f4599c7c14468b"
    elsif Hardware::CPU.intel?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.3.9/agwiki-x86_64-apple-darwin.tar.gz"
      sha256 "dade05a265eec6a0652236413de20efdce9ed9bf3ac70435b9bbcf51f6b76806"
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
        url "https://github.com/goagwiki/agwiki/releases/download/v0.3.9/agwiki-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "525f11495fd1ee79a0edfec38f80a85324f90f3c754bb4e8d4912c0435ec2565"
      else
        url "https://github.com/goagwiki/agwiki/releases/download/v0.3.9/agwiki-x86_64-unknown-linux-musl.tar.gz"
        sha256 "b9222ac54b753ddd2ac44d81771de3988a996d84ef76823821cf0b1e382abd8e"
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
