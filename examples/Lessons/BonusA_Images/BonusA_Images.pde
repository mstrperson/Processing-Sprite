/**
 * Bonus Lesson A — Images
 *
 * Two patterns for using images in your sketch:
 *
 *   1. ImageSprite — for background decorations. Can move, wrap, and draw
 *      a picture, but does NOT have collidesWith().
 *
 *   2. MyImageCharacter (see its tab) — an extends Blob character whose
 *      drawSprite() draws a picture instead of shapes. Has full collision
 *      detection because it is still a Blob underneath.
 *
 * ── SETUP ────────────────────────────────────────────────────────────────
 * Add your image files to the data/ folder inside this sketch's folder.
 * Processing → Sketch → Show Sketch Folder, then drag PNG or JPG files
 * into the data/ folder that is already there.
 *
 * Replace "hero.png" and "tree.png" below with your actual file names.
 * ─────────────────────────────────────────────────────────────────────────
 *
 * Things to try:
 *   - Swap your own character image into MyImageCharacter.pde
 *   - Use a full-screen background: new ImageSprite(this, width/2, height/2, "bg.png", width, height)
 *   - Give a decoration a velocity so it drifts or scrolls
 *   - Try setRotation(PI/6) on a decoration to tilt it
 */

import coxprogramming.processing.sprites.*;

MyImageCharacter player;
ArrayList<ImageSprite> decorations;

/**
 * Creates the window, loads the character image, and places decoration ImageSprites.
 * Runs once when the sketch starts.
 */
void setup() {
  size(800, 600);

  player = new MyImageCharacter(this, width/2, height/2, "hero.png");
  player.setVelocity(4, 0);

  decorations = new ArrayList<ImageSprite>();
  decorations.add(new ImageSprite(this, 150, 430, "tree.png", 60, 100));
  decorations.add(new ImageSprite(this, 390, 440, "tree.png", 60, 100));
  decorations.add(new ImageSprite(this, 660, 425, "tree.png", 60, 100));
}

/**
 * Clears the screen, draws decorations behind the player, then draws the player.
 * Called automatically ~60 times per second.
 */
void draw() {
  background(135, 206, 235);

  // Decorations drawn first — appear behind the player
  for (ImageSprite d : decorations) {
    d.drawSprite();
  }

  // Player drawn last — appears in front
  player.followMouse();
  player.drawSprite();
}
