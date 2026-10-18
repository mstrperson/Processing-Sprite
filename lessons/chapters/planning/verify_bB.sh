#!/usr/bin/env bash
# Every Check in Bonus B, run for real, as far as a machine can check sound.
#
#     lessons/chapters/planning/verify_bB.sh <scratch-folder>
#
# The sketch is the Bonus B Canvas page's main tab, with the Lesson 2
# MyCharacter tab.  The Sound library has to be installed in the sketchbook, as
# a student's would be;  on this machine it is.  Windows' own WAV files stand in
# for a student's sounds, and the music is a WAV too (no MP3 here), so the
# sketch's "music.mp3" becomes "music.wav".  Nothing here can listen, so the
# Checks print isPlaying() right after each event instead.
set -euo pipefail
cd "$(dirname "$0")/../../.."
V=lessons/chapters/tools/verify.sh
CS="powershell -NoProfile -ExecutionPolicy Bypass -File lessons/chapters/tools/canvas_sketch.ps1"
S="$1"; OUT="$(pwd)/lessons/chapters/screenshots"
mkdir -p "$S" "$OUT"
$CS -Lesson 02 -Folder "$S/L2" > /dev/null
$CS -Lesson 11-bonus-b -Folder "$S/BB" -CarryFrom "$S/L2" > /dev/null
mkdir -p "$S/BB/data"
cp "/c/Windows/Media/ding.wav" "$S/BB/data/collect.wav"
cp "/c/Windows/Media/chord.wav" "$S/BB/data/gameover.wav"
cp "/c/Windows/Media/tada.wav" "$S/BB/data/music.wav"
sed -i 's|"music.mp3"|"music.wav"|' "$S/BB/BB.pde"

from() {
  $V prep "$S/BB" "$S/$1" > /dev/null
  [ -n "${2:-}" ] && sed -i "$2" "$S/$1/$1.pde"
  return 0
}
CHASE_COIN='mouseX = int(coin.getPosition().x); mouseY = int(coin.getPosition().y);'
CHASE_HAZARD='mouseX = int(hazard.getPosition().x); mouseY = int(hazard.getPosition().y);'

echo "== the sketch builds, loads its sounds, and plays music"
from Start
$V build "$S/Start"
PRE='mouseX = 610; mouseY = 333; if (frameCount == 30) { println("frame 30:  bgMusic.isPlaying() = " + bgMusic.isPlaying()); }' \
  $V shot "$S/Start" "$S/Start.png" 31

echo "== the collect sound:  chase the coin, report the first collection"
from Collect 's|^\(    collectSound.play();.*\)$|\1\n    println("collected at frame " + frameCount + ":  collectSound.isPlaying() = " + collectSound.isPlaying());|'
PRE="$CHASE_COIN" $V shot "$S/Collect" "$S/Collect.png" 300 | grep -m2 "collected\|Exception" || true

echo "== the game over sound, and the music stopping:  chase the hazard"
from Over 's|^\(    gameOverSound.play();.*\)$|\1\n    println("game over at frame " + frameCount + ":  bgMusic.isPlaying() = " + bgMusic.isPlaying() + ", gameOverSound.isPlaying() = " + gameOverSound.isPlaying());|'
PRE="$CHASE_HAZARD" $V shot "$S/Over" "$S/Over.png" 300 | grep -m1 "game over\|Exception" || true

echo "== Watch out  a sound file that isn't there:  \"colect.wav\""
from Missing 's|"collect.wav"|"colect.wav"|'
PRE='mouseX = 610; mouseY = 333;' $V shot "$S/Missing" "$S/Missing.png" 30 2>&1 | grep -v '^\s*at ' | head -6 || true

echo "== Watch out  play() in draw():  builds and runs (the stutter can't be checked here)"
from EveryFrame 's|^\(  background(240);\)$|\1\n  collectSound.play();   // every frame:  the machine gun|'
$V build "$S/EveryFrame"

echo "== the isPlaying() guard builds"
from Guard 's|^    collectSound.play();   // one-shot sound effect on collection$|    if (!collectSound.isPlaying()) collectSound.play();|'
grep -n 'isPlaying' "$S/Guard/Guard.pde"
$V build "$S/Guard"

echo "== a milestone sound builds"
from Milestone 's|^\(    score = score + 1;\)$|\1\n    if (score == 10) {\n      gameOverSound.play();   // a level-up sound, standing in\n    }|'
$V build "$S/Milestone"
