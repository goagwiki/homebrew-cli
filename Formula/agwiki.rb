# typed: false
# frozen_string_literal: true

class Agwiki < Formula
  desc "Agent-based wiki CLI: init, ingest, validate, skill export"
  homepage "https://github.com/goagwiki/agwiki"
  version "0.3.6"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.3.6/agwiki-aarch64-apple-darwin.tar.gz"
      sha256 "f61b41001dae5653dc633b0dd2dec302bba8c9e9cd7a1d7760a765c5d145d999"
    elsif Hardware::CPU.intel?
      url "https://github.com/goagwiki/agwiki/releases/download/v0.3.6/agwiki-x86_64-apple-darwin.tar.gz"
      sha256 "a1393b4aaf6009bdcd6e9cd6b78c0ba2fbed5e6f5994b5b86b5c1ad7eb3bafc8"
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
        url "https://github.com/goagwiki/agwiki/releases/download/v0.3.6/agwiki-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "e5f1351b16d893e6abc41119f080aadddafae77facd78cc66f6c3d7bb0783963"
      else
        url "https://github.com/goagwiki/agwiki/releases/download/v0.3.6/agwiki-x86_64-unknown-linux-musl.tar.gz"
        sha256 "a8c27615f6aacf73bd2b341bfa65aef511738ba85f570bd3a0e79f01ae68de03"
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
