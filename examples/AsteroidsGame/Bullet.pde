/**
 * A short-lived projectile fired by the ship.
 */
class Bullet extends Sprite {

  float radius;
  int life;

  Bullet(PApplet p, float x, float y, float dx, float dy) {
    super(p, x, y, dx, dy);
    radius = 3;
    life = 55;
  }

  void update() {
    move();
    life--;
  }

  boolean dead() {
    return life <= 0;
  }

  public void drawSprite() {
    parent.noStroke();
    parent.fill(255, 235, 130);
    parent.ellipse(pos.x, pos.y, radius * 2, radius * 2);
  }
}
