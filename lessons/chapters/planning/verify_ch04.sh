#!/usr/bin/env bash
# Every Check in Chapter 4, run for real.
#
#     lessons/chapters/planning/verify_ch04.sh <scratch-folder>
#
# The command line has no mouse or keyboard, so PRE (see tools/verify.sh) parks
# the mouse by setting mouseX and mouseY, presses a key by setting keyCode and
# calling keyPressed(), and clicks by calling mousePressed().  Everything else
# is the sketch as the Canvas pages give it:  the Lesson 2 MyCharacter tab, and
# the Lesson 4 main tab.
set -euo pipefail
cd "$(dirname "$0")/../../.."
V=lessons/chapters/tools/verify.sh
CS="powershell -NoProfile -ExecutionPolicy Bypass -File lessons/chapters/tools/canvas_sketch.ps1"
S="$1"; OUT="$(pwd)/lessons/chapters/screenshots"
mkdir -p "$S" "$OUT"
$CS -Lesson 02 -Folder "$S/L2" > /dev/null
$CS -Lesson 04 -Folder "$S/L4" -CarryFrom "$S/L2" > /dev/null
SRC="$S/L4"

variant() {
  $V prep "$SRC" "$S/$1" > /dev/null
  [ -n "${2:-}" ] && sed -i "$2" "$S/$1/$1.pde"
  return 0
}
TRAIL='s|^  background(240);|  //background(240);|'
# Option B:  comment out Option A's two lines, uncomment Option B's.
OPTB='s|^  // player.move();|  player.move();|; s|^  // player.drawSprite();$|  player.drawSprite();|; /--- Option A/,/--- Option B/ { s|^  player.followMouse();|  // player.followMouse();|; s|^  player.drawSprite();|  // player.drawSprite();|; }'
MOUSE='mouseX = 650; mouseY = 450;'

echo "== the starter builds"
variant Starter
$V build "$S/Starter"

echo "== Step 1  followMouse(), mouse parked at (650, 450), with a trail, frame 45"
variant Follow "$TRAIL"
PRE="$MOUSE" $V shot "$S/Follow" "$OUT/ch04_Follow.png" 45

echo "== Step 1  and at frame 120, long after it got there"
variant Arrived "$TRAIL"
PRE="$MOUSE" $V shot "$S/Arrived" "$S/Arrived.png" 120

echo "== Step 2  the size counts, the direction doesn't:  (5, 0), (0, 5), (3, 4), (-3, -4)"
speed() {   # speed <name> <velocity>
  variant "$1" "s|setVelocity(4, 0)|setVelocity($2)|"
  PRE="$MOUSE" $V shot "$S/$1" "$S/$1.png" 30 > /dev/null
}
speed SpeedA "5, 0"; speed SpeedB "0, 5"; speed SpeedC "3, 4"; speed SpeedD "-3, -4"
cmp "$S/SpeedA.png" "$S/SpeedB.png" && cmp "$S/SpeedA.png" "$S/SpeedC.png" \
  && cmp "$S/SpeedA.png" "$S/SpeedD.png" && echo "(5, 0) (0, 5) (3, 4) (-3, -4):  identical frames"

echo "== Step 2  setVelocity(0, 0):  no motion at all"
variant Zero 's|setVelocity(4, 0)|setVelocity(0, 0)|'
variant ZeroStart 's|setVelocity(4, 0)|setVelocity(0, 0)|'
PRE="$MOUSE" $V shot "$S/Zero" "$S/Zero60.png" 60 > /dev/null
PRE="$MOUSE" $V shot "$S/ZeroStart" "$S/Zero2.png" 2 > /dev/null
cmp "$S/Zero60.png" "$S/Zero2.png" && echo "zero velocity:  frame 60 identical to frame 2"

echo "== Watch out  followMouse() AND move(), trail, frame 200"
variant Both "$TRAIL; s|^  player.followMouse();|  player.followMouse();\n  player.move();|"
sed -n '/void draw/,/^}/p' "$S/Both/Both.pde"
PRE="$MOUSE" $V shot "$S/Both" "$OUT/ch04_Both.png" 200
variant Both2 "s|^  player.followMouse();|  player.followMouse();\n  player.move();|"
PRE="$MOUSE" $V shot "$S/Both2" "$S/Both200.png" 200 > /dev/null
variant Both3 "s|^  player.followMouse();|  player.followMouse();\n  player.move();|"
PRE="$MOUSE" $V shot "$S/Both3" "$S/Both240.png" 240 > /dev/null
cmp "$S/Both200.png" "$S/Both240.png" && echo "both:  parked, frame 200 = frame 240"

echo "== Step 4  Option B, no key pressed yet:  the (4, 0) drift, frame 60"
variant KeysIdle "$OPTB"
sed -n '/void draw/,/^}/p' "$S/KeysIdle/KeysIdle.pde"
$V shot "$S/KeysIdle" "$OUT/ch04_Drift.png" 60

echo "== Step 5  UP at frame 10, LEFT at frame 50, trail, frame 110"
variant Drive "$OPTB; $TRAIL"
PRE='if (frameCount == 10) { keyCode = UP; keyPressed(); } if (frameCount == 50) { keyCode = LEFT; keyPressed(); }' \
  $V shot "$S/Drive" "$OUT/ch04_Drive.png" 110

echo "== Step 6  UP at frame 10, then the space bar at frame 40, trail, frame 110"
variant Brake "$OPTB; $TRAIL"
PRE='if (frameCount == 10) { keyCode = UP; keyPressed(); } if (frameCount == 40) { key = '"' '"'; keyCode = 32; keyPressed(); }' \
  $V shot "$S/Brake" "$OUT/ch04_Brake.png" 110

echo "== Step 6  the speed is always 5:  RIGHT with setVelocity(12, 0) vs (1, 0), frame 30"
variant Fast12 "$OPTB; s|setVelocity(4, 0)|setVelocity(12, 0)|"
variant Slow1 "$OPTB; s|setVelocity(4, 0)|setVelocity(1, 0)|"
PRE='if (frameCount == 1) { keyCode = RIGHT; keyPressed(); }' $V shot "$S/Fast12" "$S/Fast12.png" 30 > /dev/null
PRE='if (frameCount == 1) { keyCode = RIGHT; keyPressed(); }' $V shot "$S/Slow1" "$S/Slow1.png" 30 > /dev/null
cmp "$S/Fast12.png" "$S/Slow1.png" && echo "keys:  speed 5 whatever setVelocity said"

echo "== 4.6  mousePressed() with moveTo(), click at (150, 120) on frame 10, frame 20"
variant Click "$OPTB; \$a\\
\\
void mousePressed() {\\
  player.moveTo(mouseX, mouseY);   // teleport to wherever you clicked\\
}"
tail -5 "$S/Click/Click.pde"
PRE='if (frameCount == 10) { mouseX = 150; mouseY = 120; mousePressed(); }' $V shot "$S/Click" "$OUT/ch04_Click.png" 20

echo "== 4.6  keyReleased() with setVelocity(0, 0):  RIGHT at 5, release at 20, trail, frame 60"
variant Release "$OPTB; $TRAIL; \$a\\
\\
void keyReleased() {\\
  player.setVelocity(0, 0);\\
}"
PRE='if (frameCount == 5) { keyCode = RIGHT; keyPressed(); } if (frameCount == 20) { keyReleased(); }' \
  $V shot "$S/Release" "$OUT/ch04_Release.png" 60

echo "== Watch out  Option B with move() deleted:  frozen"
variant NoMove "$OPTB; s|^  player.move();||"
PRE='if (frameCount == 5) { keyCode = RIGHT; keyPressed(); }' $V shot "$S/NoMove" "$S/NoMove60.png" 60 > /dev/null
PRE='if (frameCount == 5) { keyCode = RIGHT; keyPressed(); }' $V shot "$S/NoMove" "$S/NoMove10.png" 10 > /dev/null
cmp "$S/NoMove60.png" "$S/NoMove10.png" && echo "no move():  frozen, frame 10 = frame 60"
