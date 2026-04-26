/**
 * The player's ship.
 *
 * Ship extends Sprite, so it inherits position, velocity, wrapping movement,
 * and the abstract drawSprite() contract from the SpriteGame library.
 */
class Ship extends Sprite {

  float angle;
  boolean thrusting;
  boolean invincible;

  final float THRUST = 0.18f;
  final float DRAG = 0.992f;
  final float MAX_SPEED = 6.0f;
  final float COLLISION_RADIUS = 16;

  Ship(PApplet p, float x, float y) {
    super(p, x, y);
    angle = -PApplet.HALF_PI;
  }

  void reset(float x, float y) {
    moveTo(x, y);
    setVelocity(0, 0);
    angle = -PApplet.HALF_PI;
    thrusting = false;
  }

  void turn(float amount) {
    angle += amount;
  }

  void setThrusting(boolean thrusting) {
    this.thrusting = thrusting;
  }

  void setInvincible(boolean invincible) {
    this.invincible = invincible;
  }

  float radius() {
    return COLLISION_RADIUS;
  }

  void update() {
    if (thrusting) {
      Vector2D push = Vector2D.FromPolar(THRUST, angle);
      vel = vel.add(push);
    }

    if (vel.mag() > MAX_SPEED) {
      vel = vel.unitVector().scale(MAX_SPEED);
    }

    vel = vel.scale(DRAG);
    move();
  }

  Bullet fire() {
    Vector2D direction = Vector2D.FromPolar(1, angle);
    Vector2D start = pos.add(direction.scale(24));
    Vector2D shotVelocity = vel.add(direction.scale(8.5f));
    return new Bullet(parent, start.x, start.y, shotVelocity.x, shotVelocity.y);
  }

  public void drawSprite() {
    float shipAlpha = invincible ? 150 + 80 * parent.sin(parent.frameCount * 0.18f) : 255;

    parent.pushMatrix();
    parent.translate(pos.x, pos.y);
    parent.rotate(angle + PApplet.HALF_PI);

    if (thrusting) {
      parent.stroke(255, 150, 70, shipAlpha);
      parent.strokeWeight(2);
      parent.line(-6, 15, 0, 29);
      parent.line(6, 15, 0, 29);
    }

    parent.stroke(210, 235, 255, shipAlpha);
    parent.strokeWeight(2);
    parent.noFill();
    parent.triangle(0, -19, -13, 15, 13, 15);
    parent.line(-8, 9, 8, 9);

    if (invincible) {
      parent.stroke(90, 190, 255, 95);
      parent.ellipse(0, 0, 48, 48);
    }

    parent.popMatrix();
  }
}
