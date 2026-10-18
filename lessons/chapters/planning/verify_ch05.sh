#!/usr/bin/env bash
# Every Check in Chapter 5, run for real.
#
#     lessons/chapters/planning/verify_ch05.sh <scratch-folder>
#
# The finished sketch is the Lesson 5 Canvas page's main tab and Cloud tab, with
# the Lesson 2 MyCharacter tab.  The chapter builds it up from the Lesson 4
# sketch in Steps, so each Step's state is made here by taking lines back out of
# the finished one.  The coin starts at a random spot, so any Check that
# compares two frames runs on a version without the coin.
set -euo pipefail
cd "$(dirname "$0")/../../.."
V=lessons/chapters/tools/verify.sh
CS="powershell -NoProfile -ExecutionPolicy Bypass -File lessons/chapters/tools/canvas_sketch.ps1"
S="$1"; OUT="$(pwd)/lessons/chapters/screenshots"
mkdir -p "$S" "$OUT"
$CS -Lesson 02 -Folder "$S/L2" > /dev/null
$CS -Lesson 05 -Folder "$S/L5" -CarryFrom "$S/L2" > /dev/null
SRC="$S/L5"

variant() {   # variant <name> <sed for the main tab> <sed for the Cloud tab>
  $V prep "$SRC" "$S/$1" > /dev/null
  [ -n "${2:-}" ] && sed -i "$2" "$S/$1/$1.pde"
  [ -n "${3:-}" ] && sed -i "$3" "$S/$1/Cloud.pde"
  return 0
}
NOCOIN='/coin/d; /random(1, 2.5)/d; /color(255, 220, 50));/d'
NOCLOUDS='/cloud[12]/d; /Cloud cloud/d; /clouds drift/d'
GREY='s|background(135, 206, 235);   // 1. sky - furthest back|background(240);|'
# Off the player's row and column:  parked at (600, 300), 50 steps of 4 straight
# right of the start, the player lands exactly on the mouse and vanishes (the
# NaN in followMouse(), see the teacher reference).
MOUSE='mouseX = 610; mouseY = 333;'

echo "== the finished world builds and runs"
variant World
$V build "$S/World"
PRE="$MOUSE" $V shot "$S/World" "$OUT/ch05_World.png" 90

echo "== Step 1  the ground, on Chapter 4's grey"
variant Ground "$NOCOIN; $NOCLOUDS; $GREY"
sed -n '/^MyCharacter/,$p' "$S/Ground/Ground.pde"
PRE="$MOUSE" $V shot "$S/Ground" "$OUT/ch05_Ground.png" 30

echo "== Watch out  the Block's x, y used as its center"
variant Center "$NOCOIN; $NOCLOUDS; $GREY; s|new Block(this, 0, height - 70, width, 70,|new Block(this, width/2, height - 35, width, 70,|"
grep -n 'new Block' "$S/Center/Center.pde"
PRE="$MOUSE" $V shot "$S/Center" "$OUT/ch05_Center.png" 30

echo "== Step 3  draw order:  the player walked down to (400, 570), ground first and ground last"
variant OrderRight "$NOCOIN; $NOCLOUDS"
variant OrderWrong "$NOCOIN; $NOCLOUDS; /^  ground.drawSprite();/d; s|^\(  player.drawSprite();\)$|\1\n  ground.drawSprite();|"
sed -n '/void draw/,/^}/p' "$S/OrderWrong/OrderWrong.pde"
PRE='mouseX = 400; mouseY = 570;' $V shot "$S/OrderRight" "$OUT/ch05_OrderRight.png" 90 200 420 400 180
PRE='mouseX = 400; mouseY = 570;' $V shot "$S/OrderWrong" "$OUT/ch05_OrderWrong.png" 90 200 420 400 180

echo "== Step 4  two clouds:  frame 90, and the clouds have moved since frame 10"
variant Clouds "$NOCOIN"
PRE="$MOUSE" $V shot "$S/Clouds" "$OUT/ch05_Clouds.png" 90
variant Clouds10 "$NOCOIN"
PRE="$MOUSE" $V shot "$S/Clouds10" "$S/Clouds10.png" 10 0 0 800 200 > /dev/null
variant Clouds60 "$NOCOIN"
PRE="$MOUSE" $V shot "$S/Clouds60" "$S/Clouds60.png" 60 0 0 800 200 > /dev/null
cmp -s "$S/Clouds10.png" "$S/Clouds60.png" && echo "SAME (unexpected)" || echo "clouds:  the sky changed between frames 10 and 60"

echo "== Watch out  cloud1 created in draw():  the sky is the same at frames 10 and 60"
FROZEN="$NOCOIN; /cloud1 = new Cloud/d; s|^\(  background(135, 206, 235);.*\)$|\1\n  cloud1 = new Cloud(this, 150, 90, 0.5);|; /cloud2/d; /Cloud cloud2/d"
variant Frozen10 "$FROZEN"
sed -n '/void draw/,/^}/p' "$S/Frozen10/Frozen10.pde"
PRE="$MOUSE" $V shot "$S/Frozen10" "$S/Frozen10.png" 10 0 0 800 200 > /dev/null
variant Frozen60 "$FROZEN"
PRE="$MOUSE" $V shot "$S/Frozen60" "$S/Frozen60.png" 60 0 0 800 200 > /dev/null
cmp "$S/Frozen10.png" "$S/Frozen60.png" && echo "a cloud made in draw():  frozen"

echo "== Watch out  background() after the clouds:  the same as no clouds at all"
variant LateBg "$NOCOIN; /^  background(135, 206, 235);/d; s|^\(  ground.drawSprite();.*\)$|  background(135, 206, 235);\n\1|"
sed -n '/void draw/,/^}/p' "$S/LateBg/LateBg.pde"
variant NoClouds "$NOCOIN; $NOCLOUDS"
PRE="$MOUSE" $V shot "$S/LateBg" "$S/LateBg.png" 30 > /dev/null
PRE="$MOUSE" $V shot "$S/NoClouds" "$S/NoClouds.png" 30 > /dev/null
cmp "$S/LateBg.png" "$S/NoClouds.png" && echo "background() after the clouds:  identical to no clouds"

echo "== 5.5  alpha:  a faint cloud in front of a block, against a solid one"
PLATFORM='s|^\(  ground = new Block.*\)$|\1\n  platform = new Block(this, 60, 70, 200, 30, color(120, 90, 60));|; s|^Block ground;$|Block ground;\nBlock platform;|; s|^\(  background(135, 206, 235);.*\)$|\1\n  platform.drawSprite();|'
variant Solid "$NOCOIN; $PLATFORM"
variant Faint "$NOCOIN; $PLATFORM" 's|fill(250, 250, 255);|fill(250, 250, 255, 180);|; s|fill(235, 238, 248);|fill(235, 238, 248, 180);|'
grep -n 'fill' "$S/Faint/Cloud.pde"
PRE="$MOUSE" $V shot "$S/Solid" "$OUT/ch05_Solid.png" 2 50 20 220 140
PRE="$MOUSE" $V shot "$S/Faint" "$OUT/ch05_Faint.png" 2 50 20 220 140

echo "== 5.5  a platform, in the finished world"
variant Platform "$(echo "$PLATFORM" | sed 's|60, 70, 200, 30|480, 380, 180, 24|')"
sed -n '/^Block/,/^}/p' "$S/Platform/Platform.pde" | head -20
PRE="$MOUSE" $V shot "$S/Platform" "$OUT/ch05_Platform.png" 90
