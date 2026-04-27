/**
 * Cloud — a drifting background decoration.
 *
 * This is an example of how to build your own sprite class.
 * {@code extends Blob} means Cloud already knows how to move and wrap —
 * all we add here is what a cloud looks like inside {@code drawSprite()}.
 *
 * Try redesigning this completely to fit your game world
 * (a star, a fish, a rock, a tree top, a bubble …).
 */
class Cloud extends Blob {

  /**
   * Creates a cloud at (x, y) that drifts to the right at the given speed.
   * A speed of 1.0 moves the cloud 1 pixel to the right each frame.
   *
   * @param p      the Processing sketch — always pass {@code this}
   * @param x      starting x position (center of the cloud)
   * @param y      starting y position (center of the cloud)
   * @param speed  horizontal speed in pixels per frame
   */
  Cloud(PApplet p, float x, float y, float speed) {
    super(p, x, y, 40, color(255));  // radius 40 used for collision if ever needed
    setVelocity(speed, 0);           // drift slowly to the right; no vertical movement
  }

  /**
   * Draws the cloud as a cluster of overlapping ellipses.
   * Called automatically every frame.
   */
  void drawSprite() {
    noStroke();

    // Bottom puffs — the wide base of the cloud
    fill(250, 250, 255);
    ellipse(pos.x,      pos.y,      72, 46);
    ellipse(pos.x - 31, pos.y + 13, 50, 33);
    ellipse(pos.x + 33, pos.y + 13, 55, 33);

    // Top puffs — slightly greyer for a sense of depth
    fill(235, 238, 248);
    ellipse(pos.x - 13, pos.y - 17, 54, 38);
    ellipse(pos.x + 17, pos.y - 11, 46, 33);
  }
}
