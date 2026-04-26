/**
 * A stationary {@link Sprite} that draws a glowing yellow circle with rays.
 *
 * Ray lengths are chosen randomly once in the constructor and stored in an
 * array.  If {@code random()} were called inside {@link #drawSprite()} instead,
 * the lengths would change every frame and the rays would appear to flicker.
 */
class Sun extends Sprite {

  /** Radius of the circular body in pixels. */
  float radius;

  /** Number of rays drawn around the body. */
  int numRays;

  /** Pre-calculated extra length for each ray, beyond the circle edge. */
  float[] rayLengths;

  /**
   * Creates a stationary Sun at position (x, y) with the given radius.
   * Ray lengths are randomly assigned now and fixed for the life of the sketch.
   *
   * @param p      the Processing sketch — pass {@code this}
   * @param x      x position of the sun's centre
   * @param y      y position of the sun's centre
   * @param radius radius of the circular body in pixels
   */
  Sun(PApplet p, float x, float y, float radius) {
    // No velocity — the sun stays still.
    super(p, x, y);
    this.radius = radius;

    numRays    = 16;
    rayLengths = new float[numRays];

    // Decide ray lengths once here so they never change.
    for (int i = 0; i < numRays; i++) {
      rayLengths[i] = p.random(radius * 0.4, radius * 0.9);
    }
  }

  /**
   * Draws the sun: 16 golden rays extending from the circle edge, then a
   * bright yellow disc on top to cover the ray bases.
   * Call once per frame inside {@code draw()}.
   */
  void drawSprite() {
    float angleStep = (float)(Math.PI * 2) / numRays;

    parent.stroke(255, 210, 0);
    parent.strokeWeight(2.5);

    for (int i = 0; i < numRays; i++) {
      float angle = angleStep * i;
      float innerX = pos.x + parent.cos(angle) * radius;
      float innerY = pos.y + parent.sin(angle) * radius;
      float outerX = pos.x + parent.cos(angle) * (radius + rayLengths[i]);
      float outerY = pos.y + parent.sin(angle) * (radius + rayLengths[i]);
      parent.line(innerX, innerY, outerX, outerY);
    }

    // Draw the body last so it covers the inner ends of the rays.
    parent.fill(255, 220, 40);
    parent.noStroke();
    parent.ellipse(pos.x, pos.y, radius * 2, radius * 2);
  }
}
