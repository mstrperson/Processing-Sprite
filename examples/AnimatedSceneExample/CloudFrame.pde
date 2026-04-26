/**
 * One visual frame of an animated cloud.
 *
 * Each frame uses slightly different puff positions, sizes, and grey values.
 * AnimatedSprite handles choosing which CloudFrame to draw.
 */
class CloudFrame extends Sprite {

  /** Multiplies the whole cloud's size. 1.0 means normal size. */
  float cloudScale;

  /**
   * Which version of the cloud to draw.
   * Different variants are used as different animation frames.
   */
  int variant;

  /**
   * Creates one frame of a cloud animation.
   *
   * @param p          the Processing sketch; pass {@code this}
   * @param x          x position of the cloud's center
   * @param y          y position of the cloud's center
   * @param cloudScale size multiplier for the cloud
   * @param variant    which frame version to draw
   */
  CloudFrame(PApplet p, float x, float y, float cloudScale, int variant) {
    super(p, x, y);
    this.cloudScale = cloudScale;
    this.variant = variant;
  }

  /**
   * Draws this one cloud frame.
   *
   * The math below nudges each oval a little bit based on {@code variant}.
   * Those small changes become animation when AnimatedSprite switches between
   * frames.
   */
  public void drawSprite() {
    float v = variant - 1.5f;
    float s = cloudScale;

    int shade = 238 - variant * 5;
    int highlight = 252 - variant * 3;
    int outline = 158 + variant * 7;

    parent.strokeWeight(1);
    parent.stroke(outline);

    parent.fill(highlight);
    parent.ellipse(pos.x + v * 1.5f * s,       pos.y,                    72 * s,                 (46 + v * 2) * s);
    parent.ellipse(pos.x - (31 + v) * s,       pos.y + (13 - v) * s,     (50 + variant) * s,     33 * s);
    parent.ellipse(pos.x + (33 - v) * s,       pos.y + (13 + v) * s,     (55 - variant) * s,     33 * s);

    parent.fill(shade);
    parent.ellipse(pos.x - (13 - v * 2) * s,   pos.y - (17 + v) * s,     (54 - variant) * s,     (38 + variant) * s);
    parent.ellipse(pos.x + (17 + v * 2) * s,   pos.y - (11 - v) * s,     (46 + variant) * s,     (33 - v) * s);
  }
}
