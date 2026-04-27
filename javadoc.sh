#!/usr/bin/env bash
# javadoc.sh — generate HTML reference documentation from the Java source.
# Output goes to reference/ in the project root.
# Run this before package.sh to include docs in the release zip.
#
# Override auto-detection with environment variables:
#   CORE_JAR         full path to Processing's core jar
#   PROCESSING_HOME  folder containing the Processing app
#   JAVADOC          full path to the javadoc executable

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$SCRIPT_DIR/src"
OUT_DIR="$SCRIPT_DIR/reference"
PKG="coxprogramming.processing.sprites"

die() { echo "javadoc.sh: $*" >&2; exit 1; }

to_unix_path() {
  if command -v cygpath >/dev/null 2>&1; then
    cygpath -u "$1" 2>/dev/null || printf '%s\n' "$1"
  else
    printf '%s\n' "$1"
  fi
}

SEARCH_ROOTS=()

[ -n "${PROCESSING_HOME:-}" ] && SEARCH_ROOTS+=("$(to_unix_path "$PROCESSING_HOME")")

case "$(uname -s)" in
  Darwin*)
    for d in "/Applications/Processing.app" \
              "/Applications/Processing.app/Contents/Java" \
              "/Applications/Processing.app/Contents/Resources/Java"; do
      [ -d "$d" ] && SEARCH_ROOTS+=("$d")
    done ;;
  Linux*)
    for d in "$HOME/processing" "/opt/processing" "/usr/local/processing"; do
      [ -d "$d" ] && SEARCH_ROOTS+=("$d")
    done ;;
  MINGW*|MSYS*|CYGWIN*)
    for d in "/c/Program Files/Processing" "/c/Program Files/Processing/app" \
              "/c/Program Files (x86)/Processing" "/c/Program Files (x86)/Processing/app"; do
      [ -d "$d" ] && SEARCH_ROOTS+=("$d")
    done ;;
esac
for d in "/mnt/c/Program Files/Processing" "/mnt/c/Program Files/Processing/app"; do
  [ -d "$d" ] && SEARCH_ROOTS+=("$d")
done

find_core_jar() {
  if [ -n "${CORE_JAR:-}" ]; then
    local p; p="$(to_unix_path "$CORE_JAR")"
    [ -f "$p" ] || die "CORE_JAR does not exist: $CORE_JAR"
    printf '%s\n' "$p"; return 0
  fi
  local root found
  for root in "${SEARCH_ROOTS[@]}"; do
    found="$(find "$root" -type f \( -name 'core-4*.jar' -o -path '*/core/library/core.jar' -o -name 'core.jar' \) 2>/dev/null | sort | head -n 1 || true)"
    [ -n "$found" ] && { printf '%s\n' "$found"; return 0; }
  done
  return 1
}

find_javadoc() {
  if [ -n "${JAVADOC:-}" ]; then
    local p; p="$(to_unix_path "$JAVADOC")"
    [ -f "$p" ] || die "JAVADOC does not exist: $JAVADOC"
    printf '%s\n' "$p"; return 0
  fi
  local root found
  for root in "${SEARCH_ROOTS[@]}"; do
    found="$(find "$root" -type f \( -name 'javadoc' -o -name 'javadoc.exe' \) 2>/dev/null | sort | head -n 1 || true)"
    [ -n "$found" ] && { printf '%s\n' "$found"; return 0; }
  done
  command -v javadoc >/dev/null 2>&1 && { command -v javadoc; return 0; }
  return 1
}

CORE_JAR_PATH="$(find_core_jar || true)"
[ -n "$CORE_JAR_PATH" ] || die "Could not find Processing core.jar. Set CORE_JAR or PROCESSING_HOME."

JAVADOC_PATH="$(find_javadoc || true)"
[ -n "$JAVADOC_PATH" ] || die "Could not find javadoc. Set JAVADOC or install a JDK."

echo "Using javadoc : $JAVADOC_PATH"
echo "Using core jar: $CORE_JAR_PATH"
echo "Writing docs  : $OUT_DIR"

rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"

"$JAVADOC_PATH" \
  -classpath "$CORE_JAR_PATH" \
  -d "$OUT_DIR" \
  -sourcepath "$SRC_DIR" \
  -subpackages "$PKG" \
  -windowtitle "SpriteGame" \
  -doctitle "SpriteGame Library" \
  -header "SpriteGame" \
  -noqualifier all \
  -quiet

echo "Docs written to $OUT_DIR"
