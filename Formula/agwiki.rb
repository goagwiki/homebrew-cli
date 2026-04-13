# typed: false
# frozen_string_literal: true

class Agwiki < Formula
  desc "Agent-based wiki CLI: init, ingest, validate, skill export"
  homepage "https://github.com/goagwiki/agwiki"
  version "0.1.13"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.1.13/agwiki-aarch64-apple-darwin.tar.gz"
      sha256 "238a485c2392dd3f93c76a7a6408c9222d399691f8aa199b8cf575767c0a2984"
    elsif Hardware::CPU.intel?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.1.13/agwiki-x86_64-apple-darwin.tar.gz"
      sha256 "0deb0fbbd4ae46aa0f0c5eb8e2a31e7194509979d648ac3164050bf79fcf49fc"
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
        url "https://github.com/goagwiki/agwiki/releases/download/v0.1.13/agwiki-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "a29be3c91e8e873b7b63a873dc10a180382a0e73f9da189dbdb86441f5f53426"
      else
        url "https://github.com/goagwiki/agwiki/releases/download/v0.1.13/agwiki-x86_64-unknown-linux-musl.tar.gz"
        sha256 "b49d59ec9c1afbf19e2c1c214153222bbb54a59d4fced2f4ab8c6c6d143fa5b5"
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
