#!/usr/bin/env bash
set -euo pipefail

# Auto-generated formula update script
# Usage: ./generate_formula.sh [--version VERSION]

APP_NAME="agwiki"
GITHUB_REPO="goagwiki/agwiki"
FORMULA_CLASS="Agwiki"
BINARY_NAME="agwiki"

LINUX_GNU_ASSET_NAME="agwiki-x86_64-unknown-linux-gnu.tar.gz"
LINUX_MUSL_ASSET_NAME="agwiki-x86_64-unknown-linux-musl.tar.gz"
MACOS_ARM_ASSET_NAME="agwiki-aarch64-apple-darwin.tar.gz"
MACOS_X64_ASSET_NAME="agwiki-x86_64-apple-darwin.tar.gz"

check_gh_available() {
  if ! command -v gh >/dev/null 2>&1; then
    echo "Error: GitHub CLI (gh) is not installed or not in PATH"
    exit 1
  fi

  if ! gh auth status >/dev/null 2>&1; then
    echo "Error: GitHub CLI (gh) is not authenticated"
    echo "Please run: gh auth login"
    exit 1
  fi

  if ! command -v jq >/dev/null 2>&1; then
    echo "Error: jq is not installed or not in PATH"
    exit 1
  fi
}

parse_version_arg() {
  if [ "$#" -eq 0 ]; then
    echo "latest"
    return
  fi

  if [ "$#" -eq 2 ] && [ "$1" = "--version" ]; then
    echo "$2"
    return
  fi

  echo "Error: invalid arguments. Usage: ./generate_formula.sh [--version VERSION]" >&2
  exit 1
}

resolve_release_tag() {
  local requested_version="$1"

  if [ "$requested_version" = "latest" ] || [ -z "$requested_version" ]; then
    gh release view --repo "$GITHUB_REPO" --json tagName -q .tagName
    return
  fi

  local version_no_prefix
  version_no_prefix=$(echo "$requested_version" | sed 's/^v//')
  local candidate_tag="v${version_no_prefix}"

  if gh release view "$candidate_tag" --repo "$GITHUB_REPO" >/dev/null 2>&1; then
    echo "$candidate_tag"
    return
  fi

  if gh release view "$version_no_prefix" --repo "$GITHUB_REPO" >/dev/null 2>&1; then
    echo "$version_no_prefix"
    return
  fi

  echo "Error: Release $requested_version not found" >&2
  exit 1
}

asset_field_exact() {
  local release_data="$1"
  local asset_name="$2"
  local field="$3"

  local match_count
  match_count=$(echo "$release_data" | jq -r --arg name "$asset_name" '[.assets[] | select(.name == $name)] | length')
  if [ "$match_count" -ne 1 ]; then
    echo "Error: expected exactly one asset named '$asset_name', found $match_count" >&2
    exit 1
  fi

  local value
  value=$(echo "$release_data" | jq -r --arg name "$asset_name" --arg field "$field" '.assets[] | select(.name == $name) | .[$field]')

  if [ -z "$value" ] || [ "$value" = "null" ]; then
    echo "Error: missing '$field' for asset '$asset_name'" >&2
    exit 1
  fi

  echo "$value"
}

digest_without_prefix() {
  local digest="$1"
  if [[ "$digest" != sha256:* ]]; then
    echo "Error: invalid digest format '$digest' (expected sha256:...)" >&2
    exit 1
  fi
  echo "${digest#sha256:}"
}

check_gh_available
REQUESTED_VERSION=$(parse_version_arg "$@")
RELEASE_TAG=$(resolve_release_tag "$REQUESTED_VERSION")
VERSION=$(echo "$RELEASE_TAG" | sed 's/^v//')

echo "Using release tag: $RELEASE_TAG"
echo "Resolved version: $VERSION"

RELEASE_DATA=$(gh api "repos/$GITHUB_REPO/releases/tags/$RELEASE_TAG")

LINUX_GNU_URL=$(asset_field_exact "$RELEASE_DATA" "$LINUX_GNU_ASSET_NAME" "browser_download_url")
LINUX_GNU_DIGEST=$(asset_field_exact "$RELEASE_DATA" "$LINUX_GNU_ASSET_NAME" "digest")
LINUX_GNU_SHA256=$(digest_without_prefix "$LINUX_GNU_DIGEST")

LINUX_MUSL_URL=$(asset_field_exact "$RELEASE_DATA" "$LINUX_MUSL_ASSET_NAME" "browser_download_url")
LINUX_MUSL_DIGEST=$(asset_field_exact "$RELEASE_DATA" "$LINUX_MUSL_ASSET_NAME" "digest")
LINUX_MUSL_SHA256=$(digest_without_prefix "$LINUX_MUSL_DIGEST")

MACOS_ARM_URL=$(asset_field_exact "$RELEASE_DATA" "$MACOS_ARM_ASSET_NAME" "browser_download_url")
MACOS_ARM_DIGEST=$(asset_field_exact "$RELEASE_DATA" "$MACOS_ARM_ASSET_NAME" "digest")
MACOS_ARM_SHA256=$(digest_without_prefix "$MACOS_ARM_DIGEST")

MACOS_X64_URL=$(asset_field_exact "$RELEASE_DATA" "$MACOS_X64_ASSET_NAME" "browser_download_url")
MACOS_X64_DIGEST=$(asset_field_exact "$RELEASE_DATA" "$MACOS_X64_ASSET_NAME" "digest")
MACOS_X64_SHA256=$(digest_without_prefix "$MACOS_X64_DIGEST")

FORMULA_FILE="Formula/${APP_NAME}.rb"
cat > "$FORMULA_FILE" <<FORMULA_EOF
# typed: false
# frozen_string_literal: true

class ${FORMULA_CLASS} < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goagwiki/agwiki"
  version "${VERSION}"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "${MACOS_ARM_URL}"
      sha256 "${MACOS_ARM_SHA256}"
    elsif Hardware::CPU.intel?
      url "${MACOS_X64_URL}"
      sha256 "${MACOS_X64_SHA256}"
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
        \`ldd --version 2>&1\`.lines.first.to_s[/(\d+\.\d+)/].to_f
      rescue
        0
      end

      if glibc_version >= 2.38
        url "${LINUX_GNU_URL}"
        sha256 "${LINUX_GNU_SHA256}"
      else
        url "${LINUX_MUSL_URL}"
        sha256 "${LINUX_MUSL_SHA256}"
      end
    else
      odie "Unsupported Linux CPU architecture"
    end
  end

  def install
    bin.install "${BINARY_NAME}"
  end

  test do
    system "#{bin}/${BINARY_NAME}", "--version"
  end
end
FORMULA_EOF

echo "✅ Formula generated: $FORMULA_FILE"
echo "Version: $VERSION"
