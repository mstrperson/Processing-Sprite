#!/usr/bin/env bash
# Every Check in Chapter 3, run for real.
#
#     lessons/chapters/planning/verify_ch03.sh <scratch-folder>
#
# The starter is the student's Lesson 2 sketch with the Lesson 3 Canvas page's
# main tab:  tools/canvas_sketch.ps1 builds it from content/02.json and 03.json.
# The starting point students have (Lesson 2's main tab plus setVelocity, before
# move) is made from it by deleting the move() line.
set -euo pipefail
cd "$(dirname "$0")/../../.."
V=lessons/chapters/tools/verify.sh
CS="powershell -NoProfile -ExecutionPolicy Bypass -File lessons/chapters/tools/canvas_sketch.ps1"
S="$1"; OUT="$(pwd)/lessons/chapters/screenshots"
mkdir -p "$S" "$OUT"
$CS -Lesson 02 -Folder "$S/L2" > /dev/null
$CS -Lesson 03 -Folder "$S/L3" -CarryFrom "$S/L2" > /dev/null
SRC="$S/L3"

variant() {   # variant <name> <sed for the main tab> <sed for the MyCharacter tab>
  $V prep "$SRC" "$S/$1" > /dev/null
  [ -n "${2:-}" ] && sed -i "$2" "$S/$1/$1.pde"
  [ -n "${3:-}" ] && sed -i "$3" "$S/$1/MyCharacter.pde"
  return 0
}
NOMOVE='/player.move();/d'
WIDE=""   # whole windows:  where the character is in the window is the point

echo "== Step 1  setVelocity, no move():  same frame as Chapter 2's starter?"
variant NoMove "$NOMOVE"
$V prep "$S/L2" "$S/Ch2" > /dev/null
$V shot "$S/NoMove" "$S/NoMove.png" 60
$V shot "$S/Ch2" "$S/Ch2.png" 60
cmp "$S/NoMove.png" "$S/Ch2.png" && echo "no move():  identical to Lesson 2, frame 60"

echo "== Step 2  move():  frame 60, one second in.  Expect the center at (580, 180)"
variant Moving
$V shot "$S/Moving" "$OUT/ch03_Moving.png" 60

echo "== Step 2  the trail (background commented out), frame 60"
variant Trail 's|^  background(240);|  //background(240);|'
grep -n 'background' "$S/Trail/Trail.pde"
$V shot "$S/Trail" "$OUT/ch03_Trail.png" 60

echo "== Step 3  wrapping:  frame 145.  x = 400 + 435 = 835 -> 35;  y = 300 - 290 = 10"
variant Wrap 's|^  background(240);|  //background(240);|'
$V shot "$S/Wrap" "$OUT/ch03_Wrap.png" 145

echo "== Step 4  (3, 3) and (3, -3), with trails, frame 60"
variant Down 's|setVelocity(3, -2)|setVelocity(3, 3)|; s|^  background(240);|  //background(240);|'
variant Up 's|setVelocity(3, -2)|setVelocity(3, -3)|; s|^  background(240);|  //background(240);|'
$V shot "$S/Down" "$OUT/ch03_Down.png" 60
$V shot "$S/Up" "$OUT/ch03_Up.png" 60

echo "== Step 4  fast (8, 0) and slow (0.5, 0) build and run"
variant Fast 's|setVelocity(3, -2)|setVelocity(8, 0)|'
variant Slow 's|setVelocity(3, -2)|setVelocity(0.5, 0)|'
$V shot "$S/Fast" "$S/Fast.png" 60
$V shot "$S/Slow" "$S/Slow.png" 60

echo "== Step 5  random(-5, 5):  two runs, different frames?"
variant Random1 's|setVelocity(3, -2)|setVelocity(random(-5, 5), random(-5, 5))|'
variant Random2 's|setVelocity(3, -2)|setVelocity(random(-5, 5), random(-5, 5))|'
$V shot "$S/Random1" "$S/Random1.png" 60
$V shot "$S/Random2" "$S/Random2.png" 60
cmp -s "$S/Random1.png" "$S/Random2.png" && echo "SAME (unexpected)" || echo "two runs of random:  different frames"

echo "== 3.3  drawSprite() before move():  frame 61 of this equals frame 60 of the right order?"
variant Lag 's|^  player.move();.*$|  player.drawSprite();|; 0,/^  player.drawSprite();  \/\/ draw at new position$/s//  player.move();/'
sed -n '/void draw/,/^}/p' "$S/Lag/Lag.pde"
$V shot "$S/Lag" "$S/Lag61.png" 61
$V prep "$SRC" "$S/Right" > /dev/null
$V shot "$S/Right" "$S/Right60.png" 60
cmp "$S/Lag61.png" "$S/Right60.png" && echo "drawn first:  one frame behind, exactly"

echo "== Watch out  Chapter 2's fixed-number eye, now moving, frame 60"
variant FixedEye '' '0,/ellipse(pos.x - 12, pos.y - 8, 16, 16);/s//ellipse(388, 292, 16, 16);/'
$V shot "$S/FixedEye" "$OUT/ch03_FixedEye.png" 60

echo "== 3.5  a second blob with its own velocity"
variant Friend 's/^MyCharacter player;$/MyCharacter player;\nBlob friend;/; s/^\(  player.setVelocity(3, -2);.*\)$/\1\n  friend = new Blob(this, 200, 450, 20, color(255, 120, 60));\n  friend.setVelocity(-1, 0.5);/; s/^\(  player.drawSprite();.*\)$/\1\n  friend.move();\n  friend.drawSprite();/'
sed -n '/^MyCharacter player/,$p' "$S/Friend/Friend.pde"
$V shot "$S/Friend" "$OUT/ch03_Friend.png" 60
