#!/usr/bin/env bash
# Verify a chapter's code against the real library, in a scratch copy.
#
#     lessons/chapters/tools/verify.sh prep  <sketch-folder> <scratch-folder>
#     lessons/chapters/tools/verify.sh build <scratch-folder>
#     lessons/chapters/tools/verify.sh shot  <scratch-folder> <out.png> [frame] [x y w h]
#
# prep   copies a sketch into a scratch folder, renames its main tab to match
#        the new folder (Processing insists), and drops this repo's own
#        library/SpriteGame.jar into the sketch's code/ folder.  So the check
#        runs against the library as it is in this repo, and the copy needs no
#        installed library.  The lesson's own folder is never touched.
#        Processing imports every jar in code/ by itself, so a Check about a
#        missing import line has to delete code/ before it builds.  Without
#        it, the copy sees what a student's machine sees:  the library is
#        installed, and the sketch never asked for it.
# build  compiles the sketch and prints what Processing printed:  "Finished."
#        or the error, word for word, for a Check that quotes one.
# shot   runs the sketch, saves one frame (the 20th by default), and quits.
#        It adds a tab with a __shot() function and calls it as the last line
#        of draw().  Edit the scratch copy into the state the Check describes
#        first.  A sketch whose draw() returns early never reaches the call.
#        PRE='code' runs that code at the top of every draw(), to stand in for
#        the mouse and keyboard the command line doesn't have.
#        With x y w h, the saved frame is cropped to that part of the window,
#        in the sketch's own coordinates, for a picture where the window is
#        mostly empty and the thing the Check is about is small.
#
# Needs Processing 4.5 or later at the path below, for its command line.

set -euo pipefail
PROCESSING="${PROCESSING:-/c/Program Files/Processing/Processing.exe}"
HERE="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$HERE/../../.." && pwd)"

cmd="${1:-}"; shift || true

case "$cmd" in
  prep)
    src="$1"; dest="$2"
    rm -rf "$dest"
    mkdir -p "$(dirname "$dest")"
    cp -r "$src" "$dest"
    old="$(basename "$src")"; new="$(basename "$dest")"
    if [ "$old" != "$new" ] && [ -f "$dest/$old.pde" ]; then
      mv "$dest/$old.pde" "$dest/$new.pde"
    fi
    mkdir -p "$dest/code"
    cp "$REPO/library/SpriteGame.jar" "$dest/code/"
    echo "prepared $dest"
    ;;
  build)
    dir="$1"
    timeout 180 "$PROCESSING" cli --sketch="$dir" --output="$dir.out" --force --build 2>&1 \
      | grep -v '^$' || true
    ;;
  shot)
    dir="$1"; out="$2"; frame="${3:-20}"; crop="${4:+$4 $5 $6 $7}"
    main="$dir/$(basename "$dir").pde"
    # Forward slashes, so the path survives as a Java string on Windows.
    out_java="$(cygpath -m "$out" 2>/dev/null || echo "$out")"
    cat > "$dir/ZZShot.pde" <<EOF
void __shot() {
  if (frameCount == $frame) { saveFrame("$out_java"); exit(); }
}
void __pre() {
  ${PRE:-}
}
EOF
    # PRE, if set, is code that runs at the top of every draw():  the command
    # line has no mouse or keyboard, so this is how a Check that needs them
    # gets them.  PRE='mouseX = 600; mouseY = 450;' parks the mouse, and
    # PRE='if (frameCount == 5) { keyCode = RIGHT; keyPressed(); }' presses a key.
    if [ -n "${PRE:-}" ] && ! grep -q '__pre();' "$main"; then
      awk '
        !done && /void[ \t]+draw[ \t]*\(/ { inside = 1 }
        { print }
        inside && /\{/ { print "  __pre();"; inside = 0; done = 1 }' "$main" > "$main.tmp" && mv "$main.tmp" "$main"
    fi
    # Call __shot() just before the closing brace of draw(), found by counting
    # braces from the line that opens it.
    if ! grep -q '__shot();' "$main"; then
      awk '
        !done && /void[ \t]+draw[ \t]*\(/ { inside = 1 }
        inside {
          line = $0
          opens = gsub(/\{/, "{", line); closes = gsub(/\}/, "}", line)
          depth += opens - closes
          if (opens > 0) started = 1
          if (started && depth == 0) {
            # draw() written on one line, like "void draw() {}", gets the
            # call inside its own braces.
            if (opens > 0 && /void[ \t]+draw[ \t]*\(/) { sub(/\}[^}]*$/, " __shot(); }") }
            else { print "  __shot();" }
            inside = 0; done = 1
          }
        }
        { print }' "$main" > "$main.tmp" && mv "$main.tmp" "$main"
    fi
    rm -f "$out"
    timeout 120 "$PROCESSING" cli --sketch="$dir" --output="$dir.out" --force --run 2>&1 \
      | grep -v '^$' | grep -v 'pixelDensity' || true
    [ -f "$out" ] || { echo "no frame saved"; exit 1; }
    if [ -n "$crop" ]; then
      # The frame is saved at the screen's pixel density, so scale the crop by
      # the frame's width over the sketch's width, read from its size() call.
      read -r cx cy cw ch <<< "$crop"
      sw="$(grep -oE 'size\( *[0-9]+' "$main" | grep -oE '[0-9]+$' | head -1)"
      powershell -NoProfile -Command "
        Add-Type -AssemblyName System.Drawing
        \$src = [System.Drawing.Image]::FromFile('$out_java')
        \$k = \$src.Width / $sw
        \$rect = New-Object System.Drawing.Rectangle ([int]($cx * \$k)), ([int]($cy * \$k)), ([int]($cw * \$k)), ([int]($ch * \$k))
        \$bmp = New-Object System.Drawing.Bitmap \$rect.Width, \$rect.Height
        \$g = [System.Drawing.Graphics]::FromImage(\$bmp)
        \$g.DrawImage(\$src, (New-Object System.Drawing.Rectangle 0, 0, \$rect.Width, \$rect.Height), \$rect, 'Pixel')
        \$src.Dispose(); \$g.Dispose()
        \$bmp.Save('$out_java'); \$bmp.Dispose()"
      echo "saved $out, cropped to $crop"
    else
      echo "saved $out"
    fi
    ;;
  *)
    sed -n '2,20p' "$0"; exit 2 ;;
esac
