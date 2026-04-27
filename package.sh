#!/usr/bin/env bash
# package.sh — bundle SpriteGame into a release zip for the Processing
# Contributed Library Manager.
#
# Prerequisites (run in order before this script):
#   1. bash build.sh      — compiles library/SpriteGame.jar
#   2. bash javadoc.sh    — generates reference/ (optional but recommended)
#
# Output (all written to releases/download/latest/):
#   SpriteGame.zip    — the distributable archive
#   SpriteGame.pdex   — identical to .zip; enables IDE pde:// installation
#   SpriteGame.txt    — copy of library.properties for the Contribution Manager
#
# Usage: bash package.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

[ -f library/SpriteGame.jar ] || {
  echo "package.sh: library/SpriteGame.jar not found — run build.sh first." >&2
  exit 1
}

# ── 1. Assemble the staging tree ─────────────────────────────────────────────
STAGE="$(mktemp -d)"
LIB_STAGE="$STAGE/SpriteGame"

mkdir -p "$LIB_STAGE/library"

cp library/SpriteGame.jar "$LIB_STAGE/library/SpriteGame.jar"
cp library.properties     "$LIB_STAGE/library.properties"
cp LICENSE                "$LIB_STAGE/LICENSE"
cp -r examples            "$LIB_STAGE/examples"
cp -r src                 "$LIB_STAGE/src"

# Include generated reference docs if they exist
if [ -d reference ]; then
  cp -r reference "$LIB_STAGE/reference"
else
  echo "package.sh: reference/ not found — run javadoc.sh first for complete docs."
fi

# ── 2. Zip ────────────────────────────────────────────────────────────────────
RELEASE_DIR="$SCRIPT_DIR/releases/download/latest"
mkdir -p "$RELEASE_DIR"

ZIP="$RELEASE_DIR/SpriteGame.zip"
PDEX="$RELEASE_DIR/SpriteGame.pdex"
TXT="$RELEASE_DIR/SpriteGame.txt"

rm -f "$ZIP" "$PDEX" "$TXT"

pushd "$STAGE" > /dev/null
zip -r "$ZIP" SpriteGame
popd > /dev/null

# ── 3. Create .pdex (identical to .zip — enables IDE pde:// installation) ────
cp "$ZIP" "$PDEX"

# ── 4. Create .txt (copy of library.properties for Contribution Manager) ─────
cp library.properties "$TXT"

# ── 5. Clean up ───────────────────────────────────────────────────────────────
rm -rf "$STAGE"

echo "Packaged:"
echo "  $ZIP"
echo "  $PDEX"
echo "  $TXT"
echo ""
echo "Commit and push releases/ to publish the update."
