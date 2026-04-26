#!/usr/bin/env bash
# package.sh — build SpriteGame.jar and bundle it into SpriteGame.zip
# for submission to the Processing Contributed Library Manager.
#
# The ZIP must contain a single top-level folder named SpriteGame/ with:
#   SpriteGame/library/SpriteGame.jar
#   SpriteGame/library.properties
#   SpriteGame/examples/
#   SpriteGame/src/
#
# Usage: bash package.sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

# ── 1. Build the JAR ────────────────────────────────────────────────────────
#bash build.sh

# ── 2. Assemble the staging tree ────────────────────────────────────────────
STAGE="$(mktemp -d)"
LIB_STAGE="$STAGE/SpriteGame"

mkdir -p "$LIB_STAGE/library"

cp  library/SpriteGame.jar   "$LIB_STAGE/library/SpriteGame.jar"
cp  library.properties        "$LIB_STAGE/library.properties"
cp -r examples                "$LIB_STAGE/examples"
cp -r src                     "$LIB_STAGE/src"

# ── 3. Zip ───────────────────────────────────────────────────────────────────
OUT="$SCRIPT_DIR/SpriteGame.zip"
rm -f "$OUT"

# Use pushd so relative paths inside the ZIP are SpriteGame/...
pushd "$STAGE" > /dev/null
zip -r "$OUT" SpriteGame
popd > /dev/null

# ── 4. Copy the metadata file (upload alongside the ZIP as a release asset) ──
cp SpriteGame.txt "$SCRIPT_DIR/SpriteGame.txt"

# ── 5. Clean up ──────────────────────────────────────────────────────────────
rm -rf "$STAGE"

echo "Packaged: $OUT"
echo "Metadata: $SCRIPT_DIR/SpriteGame.txt"
echo ""
echo "Upload both files as GitHub release assets:"
echo "  SpriteGame.zip"
echo "  SpriteGame.txt"
