# typed: false
# frozen_string_literal: true

class Agwiki < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goagwiki/agwiki"
  version "0.1.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.1.2/agwiki-aarch64-apple-darwin.tar.gz"
      sha256 "fdae2d43f4673485fddc81290e29eff4e7c22ff3f40986d54b23bc38208fb173"
    elsif Hardware::CPU.intel?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.1.2/agwiki-x86_64-apple-darwin.tar.gz"
      sha256 "b27e2fa60cd5c1469328ce11a497704370b3fe1ba9cc87e5527d5e10bec56aa4"
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
        url "https://github.com/goagwiki/agwiki/releases/download/v0.1.2/agwiki-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "68245a90f4a961cd40a14f35d394fcdc0f29b30f695f4c68303c1a9527ece286"
      else
        url "https://github.com/goagwiki/agwiki/releases/download/v0.1.2/agwiki-x86_64-unknown-linux-musl.tar.gz"
        sha256 "45993105c06701e73070cd823ee013b28fd633307b192ed1eb2dc24e631e9bcc"
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
