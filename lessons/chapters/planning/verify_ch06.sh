#!/usr/bin/env bash
# Every Check in Chapter 6, run for real.
#
#     lessons/chapters/planning/verify_ch06.sh <scratch-folder>
#
# Day 1 builds on the Lesson 5 sketch, and the Canvas page gives a Day 1
# checkpoint and the full Day 2 sketch.  Touching things needs aim, so PRE
# points the mouse at the coin (or the hazard) every frame, and followMouse()
# chases it.  Where two frames have to match, randomSeed(5) goes into both
# scratch copies' setup(), so the coin starts in the same random spot.
set -euo pipefail
cd "$(dirname "$0")/../../.."
V=lessons/chapters/tools/verify.sh
CS="powershell -NoProfile -ExecutionPolicy Bypass -File lessons/chapters/tools/canvas_sketch.ps1"
S="$1"; OUT="$(pwd)/lessons/chapters/screenshots"
mkdir -p "$S" "$OUT"
$CS -Lesson 02 -Folder "$S/L2" > /dev/null
$CS -Lesson 05 -Folder "$S/L5" -CarryFrom "$S/L2" > /dev/null
$CS -Lesson 06 -Folder "$S/Day1" -MainBlock 0 -CarryFrom "$S/L5" > /dev/null
$CS -Lesson 06 -Folder "$S/Day2" -MainBlock 1 -CarryFrom "$S/L5" > /dev/null

from() {   # from <source> <name> <sed for the main tab>
  $V prep "$S/$1" "$S/$2" > /dev/null
  [ -n "${3:-}" ] && sed -i "$3" "$S/$2/$2.pde"
  return 0
}
CHASE_COIN='mouseX = int(coin.getPosition().x); mouseY = int(coin.getPosition().y);'
CHASE_HAZARD='mouseX = int(hazard.getPosition().x); mouseY = int(hazard.getPosition().y);'
SEED='s|^  size(800, 600);$|  size(800, 600);\n  randomSeed(5);|'
TOPLEFT="0 0 260 60"

echo "== the Day 1 checkpoint and the Day 2 sketch build"
from Day1 Day1Build; $V build "$S/Day1Build"
from Day2 Day2Build; $V build "$S/Day2Build"

echo "== Step 1  the flash:  chase the coin, frame 150"
from L5 Flash 's|^\(  background(135, 206, 235);.*\)$|\1\n\n  if (player.collidesWith(coin)) {\n    background(255, 220, 50);   // only happens while they are touching\n  }|'
sed -n '/void draw/,/^}/p' "$S/Flash/Flash.pde" | head -8
PRE="$CHASE_COIN" $V shot "$S/Flash" "$OUT/ch06_Flash.png" 150

SCORE_TOP='s|^Blob coin;$|Blob coin;\nint score = 0;     // a whole number, starts at zero|'
SCORE_TEXT='s|^\(  player.drawSprite();\)$|\1\n\n  fill(50);                          // the text color\n  textSize(24);                      // how big\n  text("Score: " + score, 20, 36);   // what, then x, then y|'

echo "== Step 2  Score: 0, and the cheat, Score: 7"
from L5 Score0 "$SCORE_TOP; $SCORE_TEXT"
from L5 Score7 "$SCORE_TOP; $SCORE_TEXT; s|int score = 0;|int score = 7;|"
sed -n '/^Blob coin/,/^int/p;/fill(50)/,/text(/p' "$S/Score0/Score0.pde"
$V shot "$S/Score0" "$OUT/ch06_Score0.png" 10 $TOPLEFT
$V shot "$S/Score7" "$OUT/ch06_Score7.png" 10 $TOPLEFT

echo "== Step 3  the racing score:  a point every frame, seeded, chase the coin, frame 400"
from L5 Racing "$SEED; $SCORE_TOP; $SCORE_TEXT"
# Its own pass:  once SCORE_TEXT has added lines after drawSprite(), that line
# no longer ends where a second s|...$| in the same script would look for it.
sed -i 's|^  fill(50);                          // the text color$|  if (player.collidesWith(coin)) {\n    score = score + 1;   // add a point\n  }\n\n&|' "$S/Racing/Racing.pde"
sed -n '/player.drawSprite/,/^}/p' "$S/Racing/Racing.pde"
PRE="$CHASE_COIN"' if (frameCount == 300 || frameCount == 360) { println("frame " + frameCount + ":  score = " + score); }' \
  $V shot "$S/Racing" "$OUT/ch06_Racing.png" 400 $TOPLEFT

echo "== Step 4  one touch, one point:  the Day 1 checkpoint, chase the coin, frame 900"
from Day1 OnePoint
PRE="$CHASE_COIN" $V shot "$S/OnePoint" "$OUT/ch06_OnePoint.png" 900

echo "== Step 6  the hazard sets gameOver, and nothing reads it:  chase the hazard"
# The pre-refactor sketch:  Day 1, plus the hazard and gameOver, all still in draw().
PRE_REFACTOR='s|^Blob coin;$|Blob coin;\nBlob hazard;|; s|^int score = 0;.*$|&\nboolean gameOver = false;|; s|^\(  player = new MyCharacter.*\)$|  // The hazard starts in the top-left corner, away from the player\n  hazard = new Blob(this, 80, 80, 22, 3, 2, color(220, 60, 60));\n\n\1|; s|^\(  coin.drawSprite();\)$|\1\n\n  hazard.move();\n  hazard.drawSprite();|; s|^  // Show the score in the top-left corner$|  if (player.collidesWith(hazard)) {\n    gameOver = true;\n  }\n\n&|'
from Day1 Unread "$PRE_REFACTOR"
sed -n '/void draw/,/^}/p' "$S/Unread/Unread.pde"
PRE="$CHASE_HAZARD"' if (frameCount == 299) { println("frame 299:  gameOver = " + gameOver); }' \
  $V shot "$S/Unread" "$OUT/ch06_Unread.png" 300

echo "== Step 7  the refactor changes nothing:  seeded, before and after, frame 240"
from Day1 Before "$PRE_REFACTOR; $SEED"
from Day2 After "$SEED; /^  if (!gameOver) {$/,/^  }$/c\\
  playGame();"
sed -n '/void draw/,/^}/p' "$S/After/After.pde"
PRE='mouseX = 610; mouseY = 333;' $V shot "$S/Before" "$S/Before.png" 240 > /dev/null
PRE='mouseX = 610; mouseY = 333;' $V shot "$S/After" "$S/After.png" 240 > /dev/null
cmp "$S/Before.png" "$S/After.png" && echo "refactor:  frame 240 byte-identical before and after"

echo "== Step 9  the game over screen:  the Day 2 sketch, chase the hazard, frame 300"
from Day2 Over
PRE="$CHASE_HAZARD" $V shot "$S/Over" "$OUT/ch06_GameOver.png" 300

echo "== Step 10  test by cheating:  gameOver starts true, frame 5"
from Day2 Cheat 's|^boolean gameOver = false;|boolean gameOver = true;|'
$V shot "$S/Cheat" "$OUT/ch06_Cheat.png" 5

echo "== Watch out  = in a condition, where == belongs"
from Day2 Assign 's|^\(  // Touching the hazard:.*\)$|  if (score = 10) {\n    background(255, 0, 0);\n  }\n\n\1|'
$V build "$S/Assign"

echo "== Watch out  score made inside setup()"
from Day2 Scope '/^int score = 0;/d; s|^\(  size(800, 600);\)$|\1\n  int score = 0;|'
$V build "$S/Scope"

echo "== 6.6  a background that changes with the score (stacked ifs) builds"
from Day2 Stacked 's|^\(  ground.drawSprite();\)$|  if (score >= 5) {\n    background(255, 170, 80);    // sunset\n  }\n  if (score >= 10) {\n    background(30, 30, 70);      // night\n  }\n\n\1|'
$V build "$S/Stacked"

echo "== 6.6  lives:  chase the hazard;  game over only on the third hit"
from Day2 Lives 's|^boolean gameOver = false;.*$|&\nint lives = 3;|; s|^  text("Score: " + score, 20, 36);|&\n  text("Lives: " + lives, 20, 66);|'
# The hazard's if, rewritten:  one life per hit, the hazard jumps away like the
# coin, and the game ends at zero.  (sed's c\ takes the rest of its script as
# text, so it gets a pass of its own.)
sed -i '/^  if (player.collidesWith(hazard)) {$/,/^  }$/c\
  if (player.collidesWith(hazard)) {\
    lives = lives - 1;\
    hazard.moveTo(random(width), random(100, height - 150));\
    if (lives == 0) {\
      gameOver = true;\
    }\
  }' "$S/Lives/Lives.pde"
sed -n '/void playGame/,/^}/p' "$S/Lives/Lives.pde"
echo 'int __lastLives = 3;' > "$S/Lives/ZZLives.pde"
PRE="$CHASE_HAZARD"' if (lives != __lastLives) { println("frame " + frameCount + ":  lives = " + lives + ", gameOver = " + gameOver); __lastLives = lives; }' \
  $V shot "$S/Lives" "$S/Lives.png" 900
