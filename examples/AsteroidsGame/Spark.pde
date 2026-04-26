/**
 * A tiny fading particle used for asteroid and ship explosions.
 */
class Spark extends Sprite {

  int life;
  int totalLife;
  int sparkColor;

  Spark(PApplet p, float x, float y, float speed, float angle, int sparkColor) {
    super(p, x, y);
    vel = Vector2D.FromPolar(speed, angle);
    life = 28;
    totalLife = life;
    this.sparkColor = sparkColor;
  }

  void update() {
    move();
    vel = vel.scale(0.94f);
    life--;
  }

  boolean dead() {
    return life <= 0;
  }

  public void drawSprite() {
    float alpha = parent.map(life, 0, totalLife, 0, 255);
    parent.strokeWeight(2);
    parent.stroke(parent.red(sparkColor), parent.green(sparkColor), parent.blue(sparkColor), alpha);
    parent.point(pos.x, pos.y);
  }
}
