#!/usr/bin/env bash
# Every Check in Bonus D, run for real.
#
#     lessons/chapters/planning/verify_bD.sh <scratch-folder>
#
# The sketch is the Bonus D Canvas page's main tab, with the Lesson 2
# MyCharacter tab.  Most of the Checks here are the errors the teacher notes
# predict, built or run so their messages can be quoted.  The removal bug is
# made countable:  three coins start right on the player, and the first frame
# reports how many got collected.
set -euo pipefail
cd "$(dirname "$0")/../../.."
V=lessons/chapters/tools/verify.sh
CS="powershell -NoProfile -ExecutionPolicy Bypass -File lessons/chapters/tools/canvas_sketch.ps1"
S="$1"; OUT="$(pwd)/lessons/chapters/screenshots"
mkdir -p "$S" "$OUT"
$CS -Lesson 02 -Folder "$S/L2" > /dev/null
$CS -Lesson 13-bonus-d -Folder "$S/BD" -CarryFrom "$S/L2" > /dev/null

from() {
  $V prep "$S/BD" "$S/$1" > /dev/null
  [ -n "${2:-}" ] && sed -i "$2" "$S/$1/$1.pde"
  return 0
}
run() {   # run <name> <frames> [PRE]:  run a sketch for a while and print what it printed
  PRE="${3:-mouseX = 610; mouseY = 333;}" $V shot "$S/$1" "$S/$1.png" "$2" 2>&1 \
    | grep -v '^\s*at \|^saved\|^Finished' | head -4 || true
}
SEED='s|^  size(800, 600);$|  size(800, 600);\n  randomSeed(5);|'
PARK='mouseX = 610; mouseY = 333;'

echo "== the starter builds and runs:  12 coins"
from Start "$SEED"
$V build "$S/Start"
PRE="$PARK" $V shot "$S/Start" "$OUT/bD_Start.png" 30

echo "== D.4  40 coins"
from Forty "$SEED; 0,/for (int i = 0; i < 12; i++) {/s//for (int i = 0; i < 40; i++) {/"
PRE="$PARK" $V shot "$S/Forty" "$OUT/bD_Forty.png" 30

echo "== Step 2  a list made, filled, and never visited:  nothing on screen, no error"
from Unvisited '/^  \/\/ Backwards loop/,/^  }$/d'
sed -n '/void playGame/,/hazard.move/p' "$S/Unvisited/Unvisited.pde"
run Unvisited 30 "$PARK if (frameCount == 29) { println(\"frame 29:  coins.size() = \" + coins.size()); }"

echo "== Watch out  coins.drawSprite()"
from Bag 's|^\(  hazard.move();\)$|  coins.drawSprite();\n\1|'
$V build "$S/Bag"

echo "== Watch out  the two loops mixed up"
from MixA 's|^\(  hazard.move();\)$|  for (int i = 0; i < coins; i++) {\n  }\n\1|'
$V build "$S/MixA"
from MixB 's|^\(  hazard.move();\)$|  for (Blob c : 12) {\n  }\n\1|'
$V build "$S/MixB"

# Three coins right where the player starts, standing still, and nothing else.
THREE='/^  for (int i = 0; i < 12; i++) {$/,/^  }$/c\
  for (int i = 0; i < 3; i++) {\
    coins.add(new Blob(this, width/2, height/2, 10, color(255, 220, 50)));\
  }'
REPORT="$PARK if (frameCount == 2) { println(\"after frame 1:  score = \" + score + \", coins left = \" + coins.size()); }"

echo "== D.5  removing while walking forward:  three coins on the player, frame 1"
from Forward "$SEED"
sed -i "$THREE" "$S/Forward/Forward.pde"
sed -i 's|^  for (int i = coins.size() - 1; i >= 0; i--) {$|  for (int i = 0; i < coins.size(); i++) {|' "$S/Forward/Forward.pde"
grep -n 'for (int i' "$S/Forward/Forward.pde"
run Forward 2 "$REPORT"

echo "== D.5  walking backwards:  the same three coins, frame 1"
from Backward "$SEED"
sed -i "$THREE" "$S/Backward/Backward.pde"
run Backward 2 "$REPORT"

echo "== Watch out  removing inside a for-each loop"
from ForEachRemove "$SEED"
sed -i "$THREE" "$S/ForEachRemove/ForEachRemove.pde"
sed -i '/^  \/\/ Backwards loop/,/^  }$/c\
  for (Blob c : coins) {\
    c.move();\
    c.drawSprite();\
    if (player.collidesWith(c)) {\
      coins.remove(c);\
      score = score + 1;\
    }\
  }' "$S/ForEachRemove/ForEachRemove.pde"
run ForEachRemove 5

echo "== Watch out  coins.size() where coins.size() - 1 belongs"
from OffByOne 's|for (int i = coins.size() - 1; i >= 0; i--) {|for (int i = coins.size(); i >= 0; i--) {|'
run OffByOne 5

echo "== Watch out  i++ where i-- belongs"
from WrongWay 's|for (int i = coins.size() - 1; i >= 0; i--) {|for (int i = coins.size() - 1; i >= 0; i++) {|'
run WrongWay 5

echo "== Watch out  the list never created"
from NoNew '/^  coins = new ArrayList<Blob>();/d'
run NoNew 5

echo "== Watch out  the counting loop in draw():  12 more coins every frame"
from LoopInDraw 's|^\(  background(240);\)$|\1\n  for (int i = 0; i < 12; i++) {\n    coins.add(new Blob(this, random(width), random(height), random(8, 18), random(-2, 2), random(-2, 2), color(255, 220, 50)));\n  }|'
run LoopInDraw 61 "$PARK if (frameCount == 60) { println(\"frame 60:  coins.size() = \" + coins.size()); }"

echo "== D.6  an empty list sends a new wave:  start with none"
from Wave '0,/for (int i = 0; i < 12; i++) {/s//for (int i = 0; i < 0; i++) {/'
run Wave 3 "$PARK if (frameCount == 2) { println(\"frame 2:  coins.size() = \" + coins.size()); }"

echo "== D.6  a click adds a coin"
from Click "$SEED"
run Click 4 "$PARK if (frameCount == 2) { println(\"before a click:  coins.size() = \" + coins.size()); mousePressed(); println(\"after a click:  coins.size() = \" + coins.size()); }"
