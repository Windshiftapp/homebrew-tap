#!/usr/bin/env bash
#
# Regenerate Formula/ws.rb for a Windshift release.
#
# Usage:
#   scripts/bump.sh v0.9.4
#   scripts/bump.sh v0.9.4 /path/to/SHA256SUMS.txt
#   scripts/bump.sh v0.9.4 --dry-run
#
# Without a SHA256SUMS.txt path the file is downloaded from the GitHub release
# published by the Windshift release process.
#
# The checksums are taken verbatim from the release's SHA256SUMS.txt, so the
# formula always matches the signed release manifest.

set -euo pipefail

REPO="Windshiftapp/core"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FORMULA="$ROOT/Formula/ws.rb"

DRY_RUN=false
ARGS=()
for arg in "$@"; do
    case "$arg" in
        --dry-run) DRY_RUN=true ;;
        *) ARGS+=("$arg") ;;
    esac
done

VERSION_TAG="${ARGS[0]:?usage: bump.sh <vX.Y.Z> [SHA256SUMS.txt] [--dry-run]}"
SUMS="${ARGS[1]:-}"

if [[ ! "$VERSION_TAG" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "error: version must look like vX.Y.Z (got: $VERSION_TAG)" >&2
    exit 1
fi
VERSION="${VERSION_TAG#v}"

cleanup=""
if [ -z "$SUMS" ]; then
    SUMS="$(mktemp)"
    cleanup="$SUMS"
    echo "Fetching SHA256SUMS.txt for $VERSION_TAG..." >&2
    curl -fsSL "https://github.com/${REPO}/releases/download/${VERSION_TAG}/SHA256SUMS.txt" -o "$SUMS"
fi
[ -f "$SUMS" ] || { echo "error: no such file: $SUMS" >&2; exit 1; }
trap '[ -n "$cleanup" ] && rm -f "$cleanup"' EXIT

sha_for() {
    local artifact="ws-${VERSION_TAG}-$1.tar.gz"
    local value
    value="$(awk -v f="$artifact" '$2 == f { print $1 }' "$SUMS")"
    if [ -z "$value" ]; then
        echo "error: $artifact not found in $SUMS" >&2
        exit 1
    fi
    printf '%s' "$value"
}

DARWIN_AMD64="$(sha_for darwin-amd64)"
DARWIN_ARM64="$(sha_for darwin-arm64)"
LINUX_AMD64="$(sha_for linux-amd64)"
LINUX_ARM64="$(sha_for linux-arm64)"

read -r -d '' NEW_FORMULA <<EOF || true
class Ws < Formula
  desc "Command-line client for Windshift work management and test tracking"
  homepage "https://windshift.sh"
  version "${VERSION}"
  license "AGPL-3.0-only"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/${REPO}/releases/download/v#{version}/ws-v#{version}-darwin-amd64.tar.gz"
      sha256 "${DARWIN_AMD64}"
    end

    if Hardware::CPU.arm?
      url "https://github.com/${REPO}/releases/download/v#{version}/ws-v#{version}-darwin-arm64.tar.gz"
      sha256 "${DARWIN_ARM64}"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/${REPO}/releases/download/v#{version}/ws-v#{version}-linux-amd64.tar.gz"
      sha256 "${LINUX_AMD64}"
    end

    if Hardware::CPU.arm?
      url "https://github.com/${REPO}/releases/download/v#{version}/ws-v#{version}-linux-arm64.tar.gz"
      sha256 "${LINUX_ARM64}"
    end
  end

  def install
    bin.install "ws"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ws version")
  end
end
EOF

if [ "$DRY_RUN" = true ]; then
    printf '%s\n' "$NEW_FORMULA"
    exit 0
fi

printf '%s\n' "$NEW_FORMULA" > "$FORMULA"
echo "Updated $FORMULA to $VERSION" >&2
echo "Next: git add Formula/ws.rb && git commit -m 'ws $VERSION' && git push" >&2
