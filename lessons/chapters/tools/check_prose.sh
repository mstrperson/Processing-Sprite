#!/usr/bin/env bash
# The mechanical prose checks from PROCESS.md, step 8, on one or more chapters.
#
#     lessons/chapters/tools/check_prose.sh lessons/chapters/chapter_03_*.md
#
# Code fences are skipped, and so is everything inside them in a box.  Every hit
# prints with its line number.  A hit is a line to go read, not a verdict:
# compiler messages, quoted code comments, and literal uses of "stays" (a thing
# you could point at) are fine.
for f in "$@"; do
  prose="$(awk '/^(> *)?```/{f=!f; next} !f {print FNR": "$0}' "$f" | sed -E 's/^([0-9]+): >? ?/\1: /')"
  words="$(awk '/^(> *)?```/{f=!f; next} !f' "$f" | wc -w)"
  echo "== $f   prose words: $words"
  echo "-- one space after a sentence or colon"
  echo "$prose" | grep -E '[a-z)`][.?!:] ["A-Z(`*]|[a-z)`][.?!:](\*\*|\*) [^ ]' | grep -vE '^[0-9]+: \|'
  echo "-- typographic dashes, paired dashes, headings with --"
  grep -nE '—|–' "$f"
  echo "$prose" | grep -E ' -- [^.]{5,120} -- '
  grep -nE '^#{1,6} .* -- ' "$f"
  echo "-- negation family (read for setup-and-knockdown)"
  echo "$prose" | grep -iE "\b(never|nothing|nobody|none|neither|without|rather than|instead of)\b"
  echo "-- stays, landed, holds"
  echo "$prose" | grep -iE '\bstay(s|ed|ing)?\b|\bland(s|ed|ing)?\b|\bhold(s|ing)?\b'
  echo "-- a dot where an apostrophe belongs (a slip from scripted edits)"
  echo "$prose" | grep -E '\b(it|that|there|they|you|we|what|here|let|don|won|can|isn|doesn)\.(s|re|ll|ve|t)\b'
  echo "-- marks this book leaves out"
  grep -nE '\{\.iceberg\}|Answer in your notes|\*\*Tonight' "$f"
done
true
