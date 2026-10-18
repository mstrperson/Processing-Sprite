#!/usr/bin/env bash
# Rerun every chapter's verification, start to finish, and compare the
# screenshots it makes with the ones in the book.
#
#     lessons/chapters/tools/verify_all.sh <scratch-folder>
#
# Each planning/verify_*.sh writes its pictures into screenshots/.  This copies
# the book's pictures aside first, reruns everything, and reports, picture by
# picture, whether the new frame is byte-identical to the old one.  A sketch with
# random() in it (coins, mostly) makes a different frame every run, so a
# "changed" there is expected;  a "changed" anywhere else is worth a look.
# Takes the better part of an hour.
set -uo pipefail
cd "$(dirname "$0")/../../.."
S="$1"
SHOTS=lessons/chapters/screenshots
CS="powershell -NoProfile -ExecutionPolicy Bypass -File lessons/chapters/tools/canvas_sketch.ps1"
mkdir -p "$S/before" "$S/logs"
cp "$SHOTS"/*.png "$S/before/"

# Chapters 1 and 2 take their starter as an argument;  the rest build their own.
$CS -Lesson 01 -Folder "$S/starters/HelloBlob" > /dev/null
$CS -Lesson 02 -Folder "$S/starters/MyCharacterSketch" > /dev/null

for v in lessons/chapters/planning/verify_*.sh; do
  name="$(basename "$v" .sh)"
  echo "== $name"
  case "$name" in
    verify_ch01) bash "$v" "$S/$name" "$S/starters/HelloBlob" > "$S/logs/$name.txt" 2>&1 ;;
    verify_ch02) bash "$v" "$S/$name" "$S/starters/MyCharacterSketch" > "$S/logs/$name.txt" 2>&1 ;;
    *)           bash "$v" "$S/$name" > "$S/logs/$name.txt" 2>&1 ;;
  esac
  echo "   exit $?, $(grep -c '' "$S/logs/$name.txt") lines of log"
done

echo
echo "== the pictures, against the book's"
same=0; changed=0
for f in "$S/before/"*.png; do
  n="$(basename "$f")"
  if [ ! -f "$SHOTS/$n" ]; then echo "MISSING  $n"; continue; fi
  if cmp -s "$f" "$SHOTS/$n"; then same=$((same + 1)); else changed=$((changed + 1)); echo "changed  $n"; fi
done
echo "byte-identical:  $same     changed:  $changed"
