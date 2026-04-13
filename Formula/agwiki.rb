# typed: false
# frozen_string_literal: true

class Agwiki < Formula
  desc "Agent-based wiki CLI: init, ingest, validate, skill export"
  homepage "https://github.com/goagwiki/agwiki"
  version "0.1.6"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.1.6/agwiki-aarch64-apple-darwin.tar.gz"
      sha256 "076a3ef834ba695be4b40103ca92ebe9a2f0e2668be430f72169dfdd96ef5710"
    elsif Hardware::CPU.intel?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.1.6/agwiki-x86_64-apple-darwin.tar.gz"
      sha256 "8b656cab0114fa249a0f0f80e384c1b2088621a5c70458ad95c102a76b23f964"
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
        url "https://github.com/goagwiki/agwiki/releases/download/v0.1.6/agwiki-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "f8ba6922f983151f1f65469bc393781adf790a967f21be5ad12f36c362fffa25"
      else
        url "https://github.com/goagwiki/agwiki/releases/download/v0.1.6/agwiki-x86_64-unknown-linux-musl.tar.gz"
        sha256 "d1f3acdec2b42c2c8fd058917c84441ceec1977ea41893f448a4558299a68769"
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
