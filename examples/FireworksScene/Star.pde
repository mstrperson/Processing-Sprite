/** A tiny star that twinkles by changing brightness over time. */
class Star extends Blob {

  /** Where in its twinkle cycle this star starts, so they don't blink together. */
  float phase;

  Star(PApplet p, float x, float y) {
    super(p, x, y, random(0.5f, 1.8f), color(255));
    phase = random(TWO_PI);
  }

  void drawSprite() {
    float glow = 160 + 95 * sin(frameCount * 0.05f + phase);
    noStroke();
    fill(255, 255, 230, glow);
    circle(pos.x, pos.y, radius * 2);
  }
}
