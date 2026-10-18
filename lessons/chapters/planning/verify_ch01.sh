#!/usr/bin/env bash
# Every Check in Chapter 1, run for real.
#
#     lessons/chapters/planning/verify_ch01.sh <scratch-folder> <starter-folder>
#
# <starter-folder> is a sketch holding the Lesson 1 starter exactly as the
# Canvas page gives it (lessons/canvas_import/content/01.json, "code"), in a
# folder named HelloBlob.  The screenshots land in lessons/chapters/screenshots,
# and the errors print here, to be copied into the chapter word for word.
set -euo pipefail
cd "$(dirname "$0")/../../.."
V=lessons/chapters/tools/verify.sh
S="$1"; SRC="$2"
OUT="$(pwd)/lessons/chapters/screenshots"
mkdir -p "$S" "$OUT"

variant() {   # variant <name> <sed expression>:  a copy of the starter with one edit
  $V prep "$SRC" "$S/$1" > /dev/null
  [ -n "${2:-}" ] && sed -i "$2" "$S/$1/$1.pde"
  return 0
}

echo "== 1.1  the starter, as typed"
variant Starter
$V build "$S/Starter"
$V shot "$S/Starter" "$OUT/ch01_Starter.png"

echo "== Step 1  drawSprite() moved into setup()"
variant InSetup '/^  myBlob.drawSprite();/d; s/^\(  myBlob = new Blob.*\)$/\1\n  myBlob.drawSprite();/'
grep -n drawSprite "$S/InSetup/InSetup.pde"
$V shot "$S/InSetup" "$OUT/ch01_InSetup.png"

echo "== Step 2a  no import line (code/ removed, as on a student's machine)"
variant NoImport '/^import/d'
rm -rf "$S/NoImport/code"
$V build "$S/NoImport"

echo "== Step 2b  no semicolon after size(800, 600)"
variant NoSemi 's/size(800, 600);/size(800, 600)/'
$V build "$S/NoSemi"

echo "== Step 2c  drawsprite, lowercase s"
variant Caps 's/myBlob.drawSprite();/myBlob.drawsprite();/'
$V build "$S/Caps"

echo "== 1.4  color(255, 255, 0), and a white blob on white"
variant Yellow 's/color(255, 80, 80)/color(255, 255, 0)/'
$V shot "$S/Yellow" "$OUT/ch01_Yellow.png"
variant White 's/color(255, 80, 80)/color(255, 255, 255)/'
$V shot "$S/White" "$OUT/ch01_White.png"

echo "== Step 4  the top of the window, and the corner"
variant Up 's/400, 300, 40/400, 100, 40/'
$V shot "$S/Up" "$OUT/ch01_Up.png"
variant Corner 's/400, 300, 40/0, 0, 40/'
$V shot "$S/Corner" "$OUT/ch01_Corner.png"

echo "== Step 5  background(0)"
variant Black 's/background(255); /background(0);   /'
$V shot "$S/Black" "$OUT/ch01_Black.png"

echo "== 1.5  a friend, and a friend who was never made"
variant Two 's/^Blob myBlob;$/Blob myBlob;\nBlob friend;/; s/^\(  myBlob = new Blob.*\)$/\1\n  friend = new Blob(this, 550, 200, 25, color(80, 120, 255));/; s/^\(  myBlob.drawSprite();.*\)$/\1\n  friend.drawSprite();/'
cat "$S/Two/Two.pde"
$V shot "$S/Two" "$OUT/ch01_Two.png"
variant NoNew 's/^Blob myBlob;$/Blob myBlob;\nBlob friend;/; s/^\(  myBlob.drawSprite();.*\)$/\1\n  friend.drawSprite();/'
$V build "$S/NoNew"
timeout 60 "${PROCESSING:-/c/Program Files/Processing/Processing.exe}" cli --sketch="$S/NoNew" \
  --output="$S/NoNew.out" --force --run 2>&1 | grep -v '^$' | grep -v pixelDensity || true
