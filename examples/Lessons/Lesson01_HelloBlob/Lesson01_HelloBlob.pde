/**
 * Lesson 1 — Hello, Blob!
 *
 * Your first sketch with the SpriteGame library.
 * Run it, then try changing the color, position, and size.
 *
 * Things to try:
 *   - Open Tools → Color Selector to pick a new color
 *   - Change the 40 (radius) to something bigger or smaller
 *   - Change 400, 300 to put the blob somewhere else on screen
 *   - Add a second Blob with a different color
 */

import coxprogramming.processing.sprites.*;

Blob myBlob;

void setup() {
  size(800, 600);
  // new Blob(this, x, y, radius, color)
  myBlob = new Blob(this, 400, 300, 40, color(255, 80, 80));
}

void draw() {
  background(255);        // white background — erases the previous frame
  myBlob.drawSprite();    // draw the blob at its position
}
