/**
 * A {@link Sprite} that drifts horizontally across the sky.
 *
 * {@code Cloud} is an example of how to extend {@link Sprite} in your own
 * sketch file.  We only add the things that make a cloud unique — its
 * appearance.  Everything else (position, velocity, screen-wrapping, and
 * {@code move()}) comes for free from {@link Sprite}.
 */
class Cloud extends Sprite {

  /**
   * Creates a cloud at position (x, y) that moves right at the given speed.
   * A speed of 1.0 moves the cloud 1 pixel to the right each frame.
   *
   * @param p     the Processing sketch — pass {@code this}
   * @param x     starting x position
   * @param y     starting y position
   * @param speed horizontal velocity in pixels per frame (positive = right)
   */
  Cloud(PApplet p, float x, float y, float speed) {
    // Pass speed as dx and 0 as dy so the cloud only moves horizontally.
    super(p, x, y, speed, 0);
  }

  /**
   * Draws the cloud as a cluster of overlapping ellipses in white and
   * very light grey.  Call once per frame inside {@code draw()}.
   */
  void drawSprite() {
    parent.strokeWeight(1);
    parent.stroke(160);          // soft grey outline on each puff

    // Three bottom puffs — wide base of the cloud.
    parent.fill(250, 250, 255);  // nearly white with a faint cool tint
    parent.ellipse(pos.x,       pos.y,       72, 46);  // centre puff
    parent.ellipse(pos.x - 31,  pos.y + 13,  50, 33);  // left puff
    parent.ellipse(pos.x + 33,  pos.y + 13,  55, 33);  // right puff

    // Two top puffs — slightly greyer for a sense of depth.
    parent.fill(235, 238, 248);
    parent.ellipse(pos.x - 13,  pos.y - 17,  54, 38);  // upper-left puff
    parent.ellipse(pos.x + 17,  pos.y - 11,  46, 33);  // upper-right puff
  }
}
