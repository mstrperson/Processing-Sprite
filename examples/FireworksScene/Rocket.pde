/** A firework shell that flies up, slows down, and bursts at the top. */
class Rocket extends Blob {

  /**
   * Creates a rocket aimed to burst at (burstX, burstY).
   *
   * The launch speed is worked out from how high it has to climb, so it runs
   * out of upward speed right at burstY. It drifts a little sideways, so it
   * launches from wherever that drift will carry it to burstX.
   */
  Rocket(PApplet p, float burstX, float burstY) {
    super(p, burstX, p.height, 2, color(255, 230, 180));
    float climb = p.height - burstY;
    float dy = -sqrt(2 * GRAVITY * climb);
    float frames = -dy / GRAVITY;
    float dx = random(-0.5f, 0.5f);
    moveTo(burstX - dx * frames, p.height);
    setVelocity(dx, dy);
  }

  void move() {
    vel.y += GRAVITY;
    super.move();
  }

  /** The rocket bursts once it stops climbing. */
  boolean readyToBurst() {
    return vel.y >= 0;
  }

  /** Adds a ring of sparks in one random color to the list. */
  void burst(ArrayList<Spark> sparks) {
    colorMode(HSB, 360, 100, 100);
    int c = color(random(360), 70, 100);
    colorMode(RGB, 255);
    int count = int(random(50, 90));
    float speed = random(2.5f, 4.5f);
    for (int i = 0; i < count; i++) {
      float angle = TWO_PI * i / count;
      float s = speed * random(0.85f, 1.0f);
      sparks.add(new Spark(parent, pos.x, pos.y, cos(angle) * s, sin(angle) * s, c));
    }
  }

  void drawSprite() {
    noStroke();
    fill(myColor);
    circle(pos.x, pos.y, 4);
    fill(255, 160, 60, 150);
    circle(pos.x - vel.x, pos.y - vel.y * 1.5f, 3);
  }
}
