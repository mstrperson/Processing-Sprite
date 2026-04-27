#!/usr/bin/env bash
# deploy.sh — copy the compiled SpriteGame library into the local
# Processing sketchbook so Processing can load it immediately.
#
# Run this after build.sh has produced library/SpriteGame.jar, or just
# run build.sh — it calls this script automatically after compiling.
#
# Override the sketchbook location if yours is non-standard:
#   PROCESSING_SKETCHBOOK="/path/to/sketchbook" bash deploy.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$SCRIPT_DIR/library"
JAR_NAME="SpriteGame.jar"

[ -f "$LIB_DIR/$JAR_NAME" ] || {
  echo "deploy.sh: $LIB_DIR/$JAR_NAME not found — run build.sh first." >&2
  exit 1
}

to_unix_path() {
  if command -v cygpath >/dev/null 2>&1; then
    cygpath -u "$1" 2>/dev/null || printf '%s\n' "$1"
  else
    printf '%s\n' "$1"
  fi
}

find_sketchbook() {
  if [ -n "${PROCESSING_SKETCHBOOK:-}" ]; then
    printf '%s\n' "$(to_unix_path "$PROCESSING_SKETCHBOOK")"
    return 0
  fi

  case "$(uname -s)" in
    Darwin*)
      printf '%s\n' "$HOME/Documents/Processing"
      ;;
    Linux*)
      if [ -d "$HOME/sketchbook" ]; then
        printf '%s\n' "$HOME/sketchbook"
      else
        printf '%s\n' "$HOME/Documents/Processing"
      fi
      ;;
    MINGW*|MSYS*|CYGWIN*)
      local win_home
      win_home="$(to_unix_path "${USERPROFILE:-$HOME}")"
      printf '%s\n' "$win_home/Documents/Processing"
      ;;
    *)
      printf '%s\n' "$HOME/Documents/Processing"
      ;;
  esac
}

SKETCHBOOK="$(find_sketchbook)"
DEPLOY_DIR="$SKETCHBOOK/libraries/SpriteGame"

echo "Deploying to $DEPLOY_DIR"

do_deploy() {
  rm -rf "$DEPLOY_DIR"
  mkdir -p "$DEPLOY_DIR/library"
  cp "$LIB_DIR/$JAR_NAME"             "$DEPLOY_DIR/library/$JAR_NAME"
  cp "$SCRIPT_DIR/library.properties" "$DEPLOY_DIR/library.properties"
  cp "$SCRIPT_DIR/LICENSE"            "$DEPLOY_DIR/LICENSE"
  cp -r "$SCRIPT_DIR/examples"        "$DEPLOY_DIR/examples"
  cp -r "$SCRIPT_DIR/src"             "$DEPLOY_DIR/src"
  if [ -d "$SCRIPT_DIR/reference" ]; then
    cp -r "$SCRIPT_DIR/reference"     "$DEPLOY_DIR/reference"
  fi
  echo "Deployed to $DEPLOY_DIR"
}

if ! do_deploy 2>/tmp/spritegame_deploy_err; then
  echo ""
  echo "WARNING: Deploy failed — Processing may have the library open."
  echo "  Close Processing and run 'bash deploy.sh' again."
  echo "  (The JAR is ready at $LIB_DIR/$JAR_NAME)"
  cat /tmp/spritegame_deploy_err >&2
fi
