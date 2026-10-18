#!/usr/bin/env bash
# Every Check in Chapter 2, run for real.
#
#     lessons/chapters/planning/verify_ch02.sh <scratch-folder> <starter-folder>
#
# <starter-folder> is a sketch holding the Lesson 2 starter exactly as the
# Canvas page gives it (lessons/canvas_import/content/02.json, "code"):  a main
# tab and a MyCharacter tab, in a folder named MyCharacterSketch.  The
# screenshots land in lessons/chapters/screenshots.
set -euo pipefail
cd "$(dirname "$0")/../../.."
V=lessons/chapters/tools/verify.sh
S="$1"; SRC="$2"
OUT="$(pwd)/lessons/chapters/screenshots"
mkdir -p "$S" "$OUT"

# variant <name> <sed for the main tab> <sed for the MyCharacter tab>
variant() {
  $V prep "$SRC" "$S/$1" > /dev/null
  [ -n "${2:-}" ] && sed -i "$2" "$S/$1/$1.pde"
  [ -n "${3:-}" ] && sed -i "$3" "$S/$1/MyCharacter.pde"
  return 0
}

# The character is 60 pixels across in an 800-by-600 window, so the published
# pictures are cropped around it.  FACE is the middle of the window;  WIDE takes
# in the top-left too, for the Steps that move the character to (200, 150).
FACE="20 270 210 260 180"
WIDE="20 100 75 400 300"

echo "== 2.1  the starter"
variant Starter
$V build "$S/Starter"
$V shot "$S/Starter" "$S/Starter.png"          # the whole frame, for the comparisons below
cp -r "$S/Starter" "$S/StarterCrop" && mv "$S/StarterCrop/Starter.pde" "$S/StarterCrop/StarterCrop.pde"
$V shot "$S/StarterCrop" "$OUT/ch02_Starter.png" $FACE

echo "== Step 4  slide the left eye:  both of its lines, pos.x - 12 to pos.x - 20"
variant EyeSlide '' 's/ellipse(pos.x - 12, pos.y - 8,/ellipse(pos.x - 20, pos.y - 8,/'
grep -n 'pos.x - 20' "$S/EyeSlide/MyCharacter.pde"
$V shot "$S/EyeSlide" "$OUT/ch02_EyeSlide.png" $FACE

echo "== Step 5  start somewhere else"
variant Moved 's|width/2, height/2)|200, 150)|'
$V shot "$S/Moved" "$OUT/ch02_Moved.png" $WIDE

echo "== Step 6  one eye at fixed numbers, at the center and then moved"
variant FixedEye '' '0,/ellipse(pos.x - 12, pos.y - 8, 16, 16);/s//ellipse(388, 292, 16, 16);/'
variant FixedEyeMoved 's|width/2, height/2)|200, 150)|' '0,/ellipse(pos.x - 12, pos.y - 8, 16, 16);/s//ellipse(388, 292, 16, 16);/'
grep -n '388' "$S/FixedEye/MyCharacter.pde"
$V shot "$S/FixedEye" "$S/FixedEye.png"
$V shot "$S/FixedEyeMoved" "$OUT/ch02_FixedEyeMoved.png" $WIDE
cmp "$S/FixedEye.png" "$S/Starter.png" && echo "FixedEye at the center is identical to the starter"

echo "== Step 1  drawsprite, lowercase s, in the class"
variant Misspelled '' 's/void drawSprite()/void drawsprite()/'
$V build "$S/Misspelled"
$V shot "$S/Misspelled" "$OUT/ch02_Misspelled.png" $FACE

echo "== 2.3  the super line deleted"
variant NoSuper '' '/super(p, x, y, 30/d'
$V build "$S/NoSuper"

echo "== the Canvas pitfall:  a tab named MyCharacter.pde"
variant DoublePde
mv "$S/DoublePde/MyCharacter.pde" "$S/DoublePde/MyCharacter.pde.pde"
ls "$S/DoublePde"
$V build "$S/DoublePde"

echo "== 2.5  the radius in super() at 100"
variant BigRadius '' 's/super(p, x, y, 30,/super(p, x, y, 100,/'
$V shot "$S/BigRadius" "$S/BigRadius.png"
cmp "$S/BigRadius.png" "$S/Starter.png" && echo "radius 100 is identical to the starter"

echo "== Step 2  the body drawn last"
# Move the three Body lines below the smile, so the body paints over the face.
variant BodyLast '' '/    \/\/ Body/,/    ellipse(pos.x, pos.y, 60, 60);/{H;d}; /    arc(pos.x, pos.y + 5, 24, 18, 0, PI);/{p;x;s/^\n//;}'
sed -n '/void drawSprite/,/^  }/p' "$S/BodyLast/MyCharacter.pde"
$V shot "$S/BodyLast" "$OUT/ch02_BodyLast.png" $FACE

echo "== Step 2 Watch out  the smile without noFill()"
variant NoNoFill '' '/    noFill();/d'
$V shot "$S/NoNoFill" "$OUT/ch02_NoNoFill.png" $FACE
