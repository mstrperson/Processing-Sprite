/**
 * Cloud — a drifting background decoration.
 *
 * {@code extends Blob} means Cloud already knows how to move and wrap —
 * all we add is what it looks like inside {@code drawSprite()}.
 * Redesign this to fit your world (star, fish, rock, bubble …).
 */
class Cloud extends Blob {

  /**
   * Creates a cloud at (x, y) that drifts to the right at the given speed.
   *
   * @param p      the Processing sketch — always pass {@code this}
   * @param x      starting x position (center of the cloud)
   * @param y      starting y position (center of the cloud)
   * @param speed  horizontal speed in pixels per frame
   */
  Cloud(PApplet p, float x, float y, float speed) {
    super(p, x, y, 40, color(255));
    setVelocity(speed, 0);
  }

  /**
   * Draws the cloud as overlapping ellipses. Called automatically every frame.
   */
  void drawSprite() {
    noStroke();
    fill(250, 250, 255);
    ellipse(pos.x,      pos.y,      72, 46);
    ellipse(pos.x - 31, pos.y + 13, 50, 33);
    ellipse(pos.x + 33, pos.y + 13, 55, 33);
    fill(235, 238, 248);
    ellipse(pos.x - 13, pos.y - 17, 54, 38);
    ellipse(pos.x + 17, pos.y - 11, 46, 33);
  }
}
