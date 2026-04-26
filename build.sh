#!/usr/bin/env bash
#
# Build SpriteGame.jar from the Java source files in src/.
#
# This script is meant to work on macOS, Linux, and Windows when run from a
# Bash environment such as Git Bash, MSYS2, Cygwin, or WSL. Native Windows
# PowerShell cannot run .sh files by itself.
#
# The script tries to find Processing automatically. If your Processing install
# is in an unusual place, set one of these environment variables before running:
#
#   PROCESSING_HOME  folder that contains the Processing app files
#   CORE_JAR         full path to Processing's core jar
#   JAVAC            full path to javac
#   JAR_TOOL         full path to jar
#
# Examples:
#
#   bash build.sh
#   PROCESSING_HOME="/Applications/Processing.app" bash build.sh
#   CORE_JAR="/path/to/core.jar" JAVAC="/path/to/javac" bash build.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$SCRIPT_DIR/src"
BIN_DIR="$SCRIPT_DIR/bin"
LIB_DIR="$SCRIPT_DIR/library"
JAR_NAME="SpriteGame.jar"

die() {
  echo "build.sh: $*" >&2
  exit 1
}

to_unix_path() {
  local path="$1"

  # Git Bash, MSYS2, and Cygwin provide cygpath for converting Windows-style
  # paths like C:\Program Files\Processing into shell paths.
  if command -v cygpath >/dev/null 2>&1; then
    cygpath -u "$path" 2>/dev/null || printf '%s\n' "$path"
  else
    printf '%s\n' "$path"
  fi
}

add_root() {
  local root="$1"
  [ -n "$root" ] || return 0
  SEARCH_ROOTS+=("$(to_unix_path "$root")")
}

add_existing_roots() {
  local root
  for root in "$@"; do
    [ -d "$root" ] && SEARCH_ROOTS+=("$root")
  done
}

find_first_file() {
  local root="$1"
  shift

  [ -d "$root" ] || return 1

  find "$root" -type f "$@" 2>/dev/null | sort | head -n 1
}

find_core_jar() {
  local root found

  if [ -n "${CORE_JAR:-}" ]; then
    found="$(to_unix_path "$CORE_JAR")"
    [ -f "$found" ] || die "CORE_JAR was set but does not exist: $CORE_JAR"
    printf '%s\n' "$found"
    return 0
  fi

  for root in "${SEARCH_ROOTS[@]}"; do
    found="$(find_first_file "$root" \( -name 'core-4*.jar' -o -path '*/core/library/core.jar' -o -name 'core.jar' \) || true)"
    if [ -n "$found" ]; then
      printf '%s\n' "$found"
      return 0
    fi
  done

  return 1
}

find_processing_tool() {
  local env_value="$1"
  local env_name="$2"
  local tool_name="$3"
  local tool_exe="$4"
  local root found

  if [ -n "$env_value" ]; then
    found="$(to_unix_path "$env_value")"
    [ -f "$found" ] || die "$env_name was set but does not exist: $env_value"
    printf '%s\n' "$found"
    return 0
  fi

  for root in "${SEARCH_ROOTS[@]}"; do
    found="$(find_first_file "$root" \( -name "$tool_name" -o -name "$tool_exe" \) || true)"
    if [ -n "$found" ]; then
      printf '%s\n' "$found"
      return 0
    fi
  done

  if command -v "$tool_name" >/dev/null 2>&1; then
    command -v "$tool_name"
    return 0
  fi

  return 1
}

SEARCH_ROOTS=()

if [ -n "${PROCESSING_HOME:-}" ]; then
  add_root "$PROCESSING_HOME"
fi

case "$(uname -s)" in
  Darwin*)
    add_existing_roots \
      "/Applications/Processing.app" \
      "/Applications/Processing.app/Contents/Java" \
      "/Applications/Processing.app/Contents/Resources/Java"
    ;;
  Linux*)
    add_existing_roots \
      "$HOME/processing" \
      "$HOME"/processing-* \
      "/opt/processing" \
      "/opt"/processing-* \
      "/usr/local/processing" \
      "/usr/local/share/processing"
    ;;
  MINGW*|MSYS*|CYGWIN*)
    add_existing_roots \
      "/c/Program Files/Processing" \
      "/c/Program Files/Processing/app" \
      "/c/Program Files (x86)/Processing" \
      "/c/Program Files (x86)/Processing/app"
    ;;
  *)
    add_existing_roots \
      "$HOME/processing" \
      "$HOME"/processing-* \
      "/opt/processing" \
      "/opt"/processing-*
    ;;
esac

# WSL reports itself as Linux, but Windows Processing may be installed under
# /mnt/c. Add those roots when they exist.
add_existing_roots \
  "/mnt/c/Program Files/Processing" \
  "/mnt/c/Program Files/Processing/app" \
  "/mnt/c/Program Files (x86)/Processing" \
  "/mnt/c/Program Files (x86)/Processing/app"

CORE_JAR_PATH="$(find_core_jar || true)"
[ -n "$CORE_JAR_PATH" ] || die "Could not find Processing core.jar. Set CORE_JAR or PROCESSING_HOME."

JAVAC_PATH="$(find_processing_tool "${JAVAC:-}" "JAVAC" "javac" "javac.exe" || true)"
[ -n "$JAVAC_PATH" ] || die "Could not find javac. Set JAVAC or install a JDK."

JAR_TOOL_PATH="$(find_processing_tool "${JAR_TOOL:-}" "JAR_TOOL" "jar" "jar.exe" || true)"
[ -n "$JAR_TOOL_PATH" ] || die "Could not find jar. Set JAR_TOOL or install a JDK."

sources=("$SRC_DIR"/coxprogramming/processing/sprites/*.java)
[ -f "${sources[0]}" ] || die "No Java source files found in $SRC_DIR/coxprogramming/processing/sprites"

rm -rf "$BIN_DIR"
mkdir -p "$BIN_DIR" "$LIB_DIR"

echo "Using javac: $JAVAC_PATH"
echo "Using core jar: $CORE_JAR_PATH"
echo "Building $LIB_DIR/$JAR_NAME"

"$JAVAC_PATH" -cp "$CORE_JAR_PATH" -d "$BIN_DIR" "${sources[@]}"
"$JAR_TOOL_PATH" cf "$LIB_DIR/$JAR_NAME" -C "$BIN_DIR" .

echo "Built $LIB_DIR/$JAR_NAME"
