#!/usr/bin/env bash
# Every Check in Chapter 7, run for real.
#
#     lessons/chapters/planning/verify_ch07.sh <scratch-folder>
#
# The sketch is the Lesson 7 Canvas page's main tab, with the Lesson 5 Cloud tab
# and the Lesson 2 MyCharacter tab.  PRE chases things and clicks, as in
# Chapter 6.  Where frames have to match, randomSeed(5) goes into setup().
set -euo pipefail
cd "$(dirname "$0")/../../.."
V=lessons/chapters/tools/verify.sh
CS="powershell -NoProfile -ExecutionPolicy Bypass -File lessons/chapters/tools/canvas_sketch.ps1"
S="$1"; OUT="$(pwd)/lessons/chapters/screenshots"
mkdir -p "$S" "$OUT"
$CS -Lesson 02 -Folder "$S/L2" > /dev/null
$CS -Lesson 05 -Folder "$S/L5" -CarryFrom "$S/L2" > /dev/null
$CS -Lesson 07 -Folder "$S/L7" -CarryFrom "$S/L5" > /dev/null

from() {   # from <name> <sed for the main tab>
  $V prep "$S/L7" "$S/$1" > /dev/null
  [ -n "${2:-}" ] && sed -i "$2" "$S/$1/$1.pde"
  return 0
}
SEED='s|^  size(800, 600);$|  size(800, 600);\n  randomSeed(5);|'
PARK='mouseX = 610; mouseY = 333;'
CHASE_H1='mouseX = int(hazard1.getPosition().x); mouseY = int(hazard1.getPosition().y);'
CHASE_C1='mouseX = int(coin1.getPosition().x); mouseY = int(coin1.getPosition().y);'

echo "== the starter builds, and plays"
from Play
$V build "$S/Play"
PRE="$PARK" $V shot "$S/Play" "$S/Play.png" 60

echo "== Step 1  lose:  chase hazard1, frame 200"
from Lose
PRE="$CHASE_H1"' if (frameCount == 199) { println("frame 199:  gameOver = " + gameOver + ", score = " + score); }' \
  $V shot "$S/Lose" "$OUT/ch07_Lose.png" 200

echo "== Step 1  click to play again:  lose, click at frame 220, frame 230"
from Again
PRE='if (frameCount < 220) { '"$CHASE_H1"' } else { '"$PARK"' } if (frameCount == 220) { println("frame 220, before the click:  gameOver = " + gameOver); mousePressed(); println("after the click:  gameOver = " + gameOver + ", score = " + score); }' \
  $V shot "$S/Again" "$OUT/ch07_Again.png" 230

echo "== 7.4  a click while playing changes nothing:  seeded, click at 40, frame 80, against no click"
from ClickPlaying "$SEED"
from NoClick "$SEED"
PRE="$PARK"' if (frameCount == 40) { mousePressed(); }' $V shot "$S/ClickPlaying" "$S/ClickPlaying.png" 80 > /dev/null
PRE="$PARK" $V shot "$S/NoClick" "$S/NoClick.png" 80 > /dev/null
cmp "$S/ClickPlaying.png" "$S/NoClick.png" && echo "a click while playing:  byte-identical to no click"

echo "== 7.3  the win, by cheating the goal down to 1:  chase coin1"
from Win 's|^int goal = 15;|int goal = 1; |'
grep -n '^int goal' "$S/Win/Win.pde"
PRE="$CHASE_C1"' if (playerWon && !__said) { println("frame " + frameCount + ":  playerWon"); __said = true; }' \
  bash -c true
echo 'boolean __said = false;' > "$S/Win/ZZSaid.pde"
PRE="$CHASE_C1"' if (playerWon && !__said) { println("frame " + frameCount + ":  playerWon = true, score = " + score); __said = true; }' \
  $V shot "$S/Win" "$OUT/ch07_Win.png" 300

echo "== Watch out  restartGame() that forgets gameOver = false:  lose, click, still over"
from Forgot '/^  gameOver = false;$/d'
sed -n '/void restartGame/,/^  player = /p' "$S/Forgot/Forgot.pde"
PRE='if (frameCount < 220) { '"$CHASE_H1"' } else { '"$PARK"' } if (frameCount == 220) { mousePressed(); println("after the click:  gameOver = " + gameOver + ", score = " + score); }' \
  $V shot "$S/Forgot" "$S/Forgot.png" 240

echo "== Watch out  a fourth coin, copied, with a stale name in its moveTo():  chase coin4"
from Coin4 's|^Blob coin3;$|Blob coin3;\nBlob coin4;|; s|^\(  coin3.drawSprite();\)$|\1\n  coin4.move();\n  coin4.drawSprite();|; s|^\(  coin3 = new Blob(.*\)$|\1\n  coin4 = new Blob(this, random(width), random(80, height - 150), 14, random(1, 2.5), random(-1.5, 1.5), color(255, 220, 50));|'
sed -i 's|^  // --- Lose condition ---$|  if (player.collidesWith(coin4)) {\n    score = score + 1;\n    coin3.moveTo(random(width), random(80, height - 150));\n  }\n\n&|' "$S/Coin4/Coin4.pde"
sed -n '/if (player.collidesWith(coin3))/,/Lose condition/p' "$S/Coin4/Coin4.pde"
PRE='mouseX = int(coin4.getPosition().x); mouseY = int(coin4.getPosition().y); if (frameCount % 60 == 0) { println("frame " + frameCount + ":  score = " + score + ", playerWon = " + playerWon); }' \
  $V shot "$S/Coin4" "$S/Coin4.png" 300

echo "== 7.6  BouncyWalls:  one line in setup(), hazards with trails, frame 300"
from Bounce 's|^\(  restartGame();\)$|  Sprite.screenBehavior = ScreenBehavior.BouncyWalls;   // everything bounces off the edges\n\n\1|; s|^  background(135, 206, 235);.*$|  //&|'
grep -n 'BouncyWalls\|//  background' "$S/Bounce/Bounce.pde"
# Parked out of both hazards' paths for 300 frames, worked out from their
# starting velocities, so the game is still going when the frame is saved.
PRE='mouseX = 150; mouseY = 450;' $V shot "$S/Bounce" "$OUT/ch07_Bounce.png" 300
