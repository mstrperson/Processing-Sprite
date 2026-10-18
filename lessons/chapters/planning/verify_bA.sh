#!/usr/bin/env bash
# Every Check in Bonus A, run for real.
#
#     lessons/chapters/planning/verify_bA.sh <scratch-folder>
#
# The sketch is the Bonus A Canvas page's main tab and MyImageCharacter tab.  It
# needs image files in data/, so tools/make_test_art.ps1 draws stand-ins for a
# student's art:  hero.png, hero_white.png, tree.png, bg.png.
set -euo pipefail
cd "$(dirname "$0")/../../.."
V=lessons/chapters/tools/verify.sh
CS="powershell -NoProfile -ExecutionPolicy Bypass -File lessons/chapters/tools/canvas_sketch.ps1"
S="$1"; OUT="$(pwd)/lessons/chapters/screenshots"
mkdir -p "$S" "$OUT"
powershell -NoProfile -ExecutionPolicy Bypass -File lessons/chapters/tools/make_test_art.ps1 -Folder "$S/art" > /dev/null
$CS -Lesson 10-bonus-a -Folder "$S/BA" > /dev/null
mkdir -p "$S/BA/data" && cp "$S/art/"*.png "$S/BA/data/"

from() {   # from <name> <sed for the main tab> <sed for the MyImageCharacter tab>
  $V prep "$S/BA" "$S/$1" > /dev/null
  [ -n "${2:-}" ] && sed -i "$2" "$S/$1/$1.pde"
  [ -n "${3:-}" ] && sed -i "$3" "$S/$1/MyImageCharacter.pde"
  return 0
}
PARK='mouseX = 610; mouseY = 333;'
# The hitbox, drawn as a ring, to show where collidesWith() looks.
RING='s|^    parent.popStyle();$|&\n    parent.noFill();\n    parent.stroke(255, 0, 0);\n    parent.ellipse(pos.x, pos.y, 2 * radius, 2 * radius);   // the hitbox|'
FACE="300 210 220 180"   # x y w h around the player, at the middle of the window

echo "== the starter builds and runs, with the art in data/"
from Start
$V build "$S/Start"
PRE="$PARK" $V shot "$S/Start" "$OUT/bA_Start.png" 20

echo "== Watch out  a file name that doesn't match:  \"pine.png\""
from Missing 's|"tree.png", 60, 100);|"pine.png", 60, 100);|'
PRE="$PARK" $V shot "$S/Missing" "$S/Missing.png" 20 || true

echo "== a name with different capitals:  \"Tree.PNG\" (on this file system)"
from Caps 's|"tree.png", 60, 100);|"Tree.PNG", 60, 100);|'
PRE="$PARK" $V shot "$S/Caps" "$S/Caps.png" 20 || true

echo "== a folder named Data"
from DataCaps
mv "$S/DataCaps/data" "$S/DataCaps/Data_" && mv "$S/DataCaps/Data_" "$S/DataCaps/Data"
ls "$S/DataCaps"
PRE="$PARK" $V shot "$S/DataCaps" "$S/DataCaps.png" 20 || true

echo "== Watch out  a PNG without transparency:  hero_white.png"
from White 's|"hero.png");|"hero_white.png");|'
PRE="$PARK" $V shot "$S/White" "$OUT/bA_White.png" 2 $FACE

echo "== Watch out  imageMode(CENTER) left out, hitbox drawn as a ring;  and with it"
from NoCenter '' "/parent.imageMode(CENTER);/d; $RING"
from Center '' "$RING"
sed -n '/void drawSprite/,/^  }/p' "$S/NoCenter/MyImageCharacter.pde"
PRE="$PARK" $V shot "$S/NoCenter" "$OUT/bA_NoCenter.png" 2 $FACE
PRE="$PARK" $V shot "$S/Center" "$OUT/bA_Center.png" 2 $FACE

echo "== Watch out  collidesWith() and an ImageSprite, both ways round"
from CollideA 's|^\(  player.drawSprite();\)$|\1\n  if (player.collidesWith(tree1)) {\n    background(255, 0, 0);\n  }|'
$V build "$S/CollideA"
from CollideB 's|^\(  player.drawSprite();\)$|\1\n  if (tree1.collidesWith(player)) {\n    background(255, 0, 0);\n  }|'
$V build "$S/CollideB"

echo "== a background image, drawn first"
from Bg 's|^ImageSprite tree1;$|ImageSprite bg;\nImageSprite tree1;|; s|^\(  tree1 = new ImageSprite.*\)$|  bg = new ImageSprite(this, width/2, height/2, "bg.png", width, height);\n\1|; s|^  background(135, 206, 235);$|&\n  bg.drawSprite();|'
PRE="$PARK" $V shot "$S/Bg" "$OUT/bA_Background.png" 20

echo "== a drifting, tilted decoration builds and runs"
from Drift 's|^\(  tree3 = new ImageSprite.*\)$|\1\n  tree3.setVelocity(0.5, 0);\n  tree3.setRotation(PI/6);|; s|^  tree3.drawSprite();$|  tree3.move();\n&|'
PRE="$PARK" $V shot "$S/Drift" "$S/Drift.png" 60
