/**
 * One visual frame of an animated sun.
 *
 * The body stays in the same place, but ray lengths change from frame to
 * frame so the sun appears to shimmer.
 */
class SunFrame extends Sprite {

  /** Radius of the sun's circular body. */
  float radius;

  /**
   * Which version of the rays to draw.
   * Different variants become different animation frames.
   */
  int variant;

  /** Number of rays drawn around the sun. */
  int numRays;

  /**
   * Creates one frame of a sun animation.
   *
   * @param p       the Processing sketch; pass {@code this}
   * @param x       x position of the sun's center
   * @param y       y position of the sun's center
   * @param radius  radius of the round sun body
   * @param variant which ray-length pattern to draw
   */
  SunFrame(PApplet p, float x, float y, float radius, int variant) {
    super(p, x, y);
    this.radius = radius;
    this.variant = variant;
    numRays = 16;
  }

  /**
   * Draws this one sun frame.
   *
   * The ray length uses {@code sin()} so neighboring rays have different
   * lengths. Changing {@code variant} shifts the pattern, which creates the
   * shimmer when AnimatedSprite changes frames.
   */
  public void drawSprite() {
    float angleStep = PApplet.TWO_PI / numRays;

    parent.stroke(255, 208, 0);
    parent.strokeWeight(2.5f);

    for (int i = 0; i < numRays; i++) {
      float angle = angleStep * i;
      float pulse = parent.sin(i * 1.4f + variant * 0.9f);
      float rayLength = radius * (0.62f + 0.28f * pulse);
      float innerX = pos.x + parent.cos(angle) * radius;
      float innerY = pos.y + parent.sin(angle) * radius;
      float outerX = pos.x + parent.cos(angle) * (radius + rayLength);
      float outerY = pos.y + parent.sin(angle) * (radius + rayLength);
      parent.line(innerX, innerY, outerX, outerY);
    }

    parent.fill(255, 221, 48);
    parent.noStroke();
    parent.ellipse(pos.x, pos.y, radius * 2, radius * 2);

    parent.fill(255, 238, 90, 145);
    parent.ellipse(pos.x - radius * 0.25f, pos.y - radius * 0.28f, radius * 0.65f, radius * 0.45f);
  }
}
