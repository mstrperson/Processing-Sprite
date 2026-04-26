#!/usr/bin/env bash
set -e

JAVAC="C:/Program Files/Processing/app/resources/jdk/bin/javac.exe"
CORE_JAR="C:/Program Files/Processing/app/core-4.4.7-b3ecf8494d828528c05573c1edbb881.jar"
SRC_DIR="src"
BIN_DIR="bin"
LIB_DIR="library"
JAR_NAME="SpriteGame.jar"

rm -rf "$BIN_DIR"
mkdir -p "$BIN_DIR" "$LIB_DIR"

"$JAVAC" -cp "$CORE_JAR" -d "$BIN_DIR" "$SRC_DIR"/coxprogramming/processing/sprites/*.java

jar cf "$LIB_DIR/$JAR_NAME" -C "$BIN_DIR" .

echo "Built $LIB_DIR/$JAR_NAME"
