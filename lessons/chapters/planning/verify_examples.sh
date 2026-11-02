#!/usr/bin/env bash
# Runs every lesson example in examples/Lessons exactly as it ships, the way a
# student opens it from File -> Examples, and says whether it runs.  Each
# chapter's Example box (and Appendix 1, A1.6) says which examples
# run as they are, and which need pictures or sounds first.
#
#     lessons/chapters/planning/verify_examples.sh [scratch-folder]
#
# A frame for each example that runs goes in the scratch folder, to look at.
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$HERE/../../.." && pwd)"
VERIFY="$REPO/lessons/chapters/tools/verify.sh"
SCRATCH="${1:-${TMPDIR:-/tmp}/verify_examples}"
mkdir -p "$SCRATCH"

for src in "$REPO"/examples/Lessons/*/; do
  name="$(basename "$src")"
  dest="$SCRATCH/$name"
  "$VERIFY" prep "$src" "$dest" > /dev/null
  out="$("$VERIFY" shot "$dest" "$SCRATCH/$name.png" 20 2>&1)"
  if [ -f "$SCRATCH/$name.png" ]; then
    echo "runs     $name"
  else
    echo "STOPS    $name:  $(echo "$out" | grep -m1 -iE 'exception|error|not found|cannot|missing|No library' || echo "$out" | tail -1)"
  fi
done
