#!/usr/bin/env bash
# make_pkg.sh — build a signed-or-unsigned .pkg of just the SpriteGame
# library for Jamf Pro. It's the command-line version of what Composer does.
#
# Payload:  /Library/Application Support/SpriteGame/
#             build.sh, deploy.sh, library.properties, LICENSE,
#             src/, examples/, reference/, library/SpriteGame.jar
# Scripts:  jamf/scripts/postinstall (builds, then deploys for every user)
#
# Output:   jamf/dist/SpriteGame-<version>.pkg
#
# Usage:
#   bash jamf/make_pkg.sh
#   SIGN_IDENTITY="Developer ID Installer: Your School (TEAMID)" bash jamf/make_pkg.sh

set -euo pipefail

JAMF_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$JAMF_DIR")"
DIST_DIR="$JAMF_DIR/dist"
IDENTIFIER="com.coxprogramming.spritegame"

VERSION="$(grep -m 1 '^prettyVersion=' "$REPO_DIR/library.properties" | cut -d= -f2)"
[ -n "$VERSION" ] || { echo "make_pkg.sh: no prettyVersion in library.properties" >&2; exit 1; }

[ -f "$REPO_DIR/library/SpriteGame.jar" ] || {
  echo "make_pkg.sh: library/SpriteGame.jar not found — run build.sh first." >&2
  exit 1
}

# ── 1. Stage the payload ─────────────────────────────────────────────────────
STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT

DEST="$STAGE/root/Library/Application Support/SpriteGame"
mkdir -p "$DEST/library" "$STAGE/scripts"

cp "$REPO_DIR/build.sh" "$REPO_DIR/deploy.sh" "$DEST/"
cp "$REPO_DIR/library.properties" "$REPO_DIR/LICENSE" "$DEST/"
cp "$REPO_DIR/library/SpriteGame.jar" "$DEST/library/"
cp -R "$REPO_DIR/src" "$REPO_DIR/examples" "$DEST/"
[ -d "$REPO_DIR/reference" ] && cp -R "$REPO_DIR/reference" "$DEST/"

find "$STAGE/root" -name '.DS_Store' -delete
chmod 755 "$DEST/build.sh" "$DEST/deploy.sh"

cp "$JAMF_DIR/scripts/postinstall" "$STAGE/scripts/postinstall"
chmod 755 "$STAGE/scripts/postinstall"

# ── 2. Build the package ─────────────────────────────────────────────────────
mkdir -p "$DIST_DIR"
PKG="$DIST_DIR/SpriteGame-$VERSION.pkg"
rm -f "$PKG"

sign_args=()
if [ -n "${SIGN_IDENTITY:-}" ]; then
  sign_args=(--sign "$SIGN_IDENTITY")
fi

pkgbuild \
  --root "$STAGE/root" \
  --scripts "$STAGE/scripts" \
  --identifier "$IDENTIFIER" \
  --version "$VERSION" \
  --install-location / \
  --ownership recommended \
  ${sign_args[@]+"${sign_args[@]}"} \
  "$PKG"

echo ""
echo "Built $PKG"
echo "Upload it to Jamf Pro under Settings → Packages."
