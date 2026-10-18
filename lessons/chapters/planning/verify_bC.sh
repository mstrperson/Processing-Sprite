#!/usr/bin/env bash
# Every Check in Bonus C, run for real.
#
#     lessons/chapters/planning/verify_bC.sh <scratch-folder>
#
# The sketch is the Bonus C Canvas page's main tab and MyCharacterFrame tab.
# With setFrameRate(8), frame k of draw() shows pose (k - 1) / 8, so frames 4,
# 12 and 20 show poses 0, 1 and 2.  For still pictures of the poses, the
# "Still" copy takes out followMouse(), so the character sits in the middle.
set -euo pipefail
cd "$(dirname "$0")/../../.."
V=lessons/chapters/tools/verify.sh
CS="powershell -NoProfile -ExecutionPolicy Bypass -File lessons/chapters/tools/canvas_sketch.ps1"
S="$1"; OUT="$(pwd)/lessons/chapters/screenshots"
mkdir -p "$S" "$OUT"
$CS -Lesson 12-bonus-c -Folder "$S/BC" > /dev/null

from() {   # from <name> <sed for the main tab> <sed for the MyCharacterFrame tab>
  $V prep "$S/BC" "$S/$1" > /dev/null
  [ -n "${2:-}" ] && sed -i "$2" "$S/$1/$1.pde"
  [ -n "${3:-}" ] && sed -i "$3" "$S/$1/MyCharacterFrame.pde"
  return 0
}
STILL='s|^  player.followMouse();$|  // player.followMouse();|'
FACE="340 250 120 100"

echo "== the starter builds and runs"
from Start
$V build "$S/Start"
PRE='mouseX = 610; mouseY = 333;' $V shot "$S/Start" "$S/Start.png" 30

echo "== the three poses:  frames 4, 12 and 20"
for f in 4 12 20; do
  from "Pose$f" "$STILL"
  $V shot "$S/Pose$f" "$S/Pose$f.png" $f $FACE > /dev/null
done
cp "$S/Pose4.png" "$OUT/bC_Pose0.png"; cp "$S/Pose12.png" "$OUT/bC_Pose1.png"; cp "$S/Pose20.png" "$OUT/bC_Pose2.png"
cmp -s "$S/Pose4.png" "$S/Pose12.png" || echo "pose 0 and pose 1 differ"
cmp -s "$S/Pose12.png" "$S/Pose20.png" || echo "pose 1 and pose 2 differ"

echo "== setFrameRate:  at frame 6, rate 4 is on pose 1 already, and rate 20 is still on pose 0"
from Rate4 "$STILL; s|setFrameRate(8)|setFrameRate(4)|"
from Rate20 "$STILL; s|setFrameRate(8)|setFrameRate(20)|"
$V shot "$S/Rate4" "$S/Rate4.png" 6 $FACE > /dev/null
$V shot "$S/Rate20" "$S/Rate20.png" 6 $FACE > /dev/null
cmp "$S/Rate4.png" "$S/Pose12.png" && echo "rate 4, frame 6:  pose 1"
cmp "$S/Rate20.png" "$S/Pose4.png" && echo "rate 20, frame 6:  pose 0"

echo "== Watch out  the second frame made 70 pixels to the right:  trail, frame 20"
from Jump "$STILL; s|^  background(240);|  //background(240);|; s|AddFrameSprite(new MyCharacterFrame(this, width/2, height/2, 1))|AddFrameSprite(new MyCharacterFrame(this, width/2 + 70, height/2, 1))|"
grep -n 'width/2 + 70' "$S/Jump/Jump.pde"
$V shot "$S/Jump" "$OUT/bC_Jump.png" 20 300 230 260 140

echo "== Watch out  no this.pose = pose;  frames 4, 12 and 20 identical"
for f in 4 12 20; do
  from "NoPose$f" "$STILL" '/this.pose = pose;/d'
  $V shot "$S/NoPose$f" "$S/NoPose$f.png" $f $FACE > /dev/null
done
cmp "$S/NoPose4.png" "$S/NoPose12.png" && cmp "$S/NoPose4.png" "$S/NoPose20.png" && echo "no this.pose:  all three frames identical"

echo "== Watch out  the constructor still called MyCharacter"
from OldName '' 's|^  MyCharacterFrame(PApplet p, float x, float y, int pose) {|  MyCharacter(PApplet p, float x, float y, int pose) {|'
grep -n 'MyCharacter(PApplet' "$S/OldName/MyCharacterFrame.pde"
$V build "$S/OldName"

echo "== Watch out  collidesWith() on an AnimatedSprite"
from Collide 's|^\(  player.drawSprite();   // draws.*\)$|\1\n  if (player.collidesWith(player)) {\n    background(255, 0, 0);\n  }|'
$V build "$S/Collide"

echo "== C.5  in the Chapter 7 game:  an animated player, distanceTo() for the touching"
$CS -Lesson 02 -Folder "$S/L2" > /dev/null
$CS -Lesson 05 -Folder "$S/L5" -CarryFrom "$S/L2" > /dev/null
$CS -Lesson 07 -Folder "$S/L7" -CarryFrom "$S/L5" > /dev/null
cp "$S/BC/MyCharacterFrame.pde" "$S/L7/"
$V prep "$S/L7" "$S/Game" > /dev/null
sed -i 's|^MyCharacter player;$|AnimatedSprite player;|; s|player.collidesWith(\([a-z0-9]*\))|player.distanceTo(\1) < 40|g' "$S/Game/Game.pde"
sed -i '/^  player = new MyCharacter(this, width\/2, height\/2);$/c\
  player = AnimatedSprite.FromSprite(new MyCharacterFrame(this, width/2, height/2, 0))\
      .AddFrameSprite(new MyCharacterFrame(this, width/2, height/2, 1))\
      .AddFrameSprite(new MyCharacterFrame(this, width/2, height/2, 2))\
      .setFrameRate(8);' "$S/Game/Game.pde"
grep -n 'distanceTo\|AnimatedSprite' "$S/Game/Game.pde"
$V build "$S/Game"
PRE='mouseX = int(coin1.getPosition().x); mouseY = int(coin1.getPosition().y); if (frameCount % 100 == 0) { println("frame " + frameCount + ":  score = " + score + ", gameOver = " + gameOver); }' \
  $V shot "$S/Game" "$S/Game.png" 300

echo "== C.6  poses by hand:  nextFrame() on a key, setFrameNumber() on a click"
from ByHand "$STILL"' ; s|^  player.keyboardControl();$|  player.keyboardControl();\n  if (key == '"'"'n'"'"') {\n    player.nextFrame();         // turn one page\n  }|'
cat >> "$S/ByHand/ByHand.pde" <<'PDE'

void mousePressed() {
  player.setFrameNumber(2);   // jump straight to pose 2
}
PDE
$V build "$S/ByHand"
