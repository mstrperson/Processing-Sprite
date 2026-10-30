/** One glowing piece of a firework burst that falls and fades away. */
class Spark extends Blob {

  /** 255 when born, 0 when it should be removed. */
  float life = 255;

  Spark(PApplet p, float x, float y, float dx, float dy, int c) {
    super(p, x, y, 2, dx, dy, c);
  }

  void move() {
    vel.y += GRAVITY;
    vel.x *= 0.98f;
    vel.y *= 0.98f;
    life -= 2.5f;
    super.move();
  }

  boolean isDead() {
    return life <= 0;
  }

  void drawSprite() {
    noStroke();
    fill(red(myColor), green(myColor), blue(myColor), life * 0.25f);
    circle(pos.x, pos.y, 14);
    fill(red(myColor), green(myColor), blue(myColor), life * 0.6f);
    circle(pos.x, pos.y, 7);
    fill(255, 255, 255, life);
    circle(pos.x, pos.y, 3);
  }
}
