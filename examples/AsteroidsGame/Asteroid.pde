/**
 * An irregular rock that drifts, spins, wraps, and can split into smaller
 * asteroids when hit.
 */
class Asteroid extends Sprite {

  float radius;
  int level;
  float rotationAngle;
  float rotationSpeed;
  float[] vertexScale;

  Asteroid(PApplet p, float x, float y, float radius, int level, float dx, float dy) {
    super(p, x, y, dx, dy);
    this.radius = radius;
    this.level = level;
    rotationAngle = parent.random(PApplet.TWO_PI);
    rotationSpeed = parent.random(-0.035f, 0.035f);

    vertexScale = new float[10];
    for (int i = 0; i < vertexScale.length; i++) {
      vertexScale[i] = parent.random(0.72f, 1.22f);
    }
  }

  void update() {
    rotationAngle += rotationSpeed;
    move();
  }

  boolean hits(Bullet bullet) {
    return distanceTo(bullet) <= radius + bullet.radius;
  }

  boolean hits(Ship ship) {
    return distanceTo(ship) <= radius + ship.radius();
  }

  int pointValue() {
    if (level == 3) {
      return 20;
    }
    if (level == 2) {
      return 50;
    }
    return 100;
  }

  ArrayList<Asteroid> split() {
    ArrayList<Asteroid> pieces = new ArrayList<Asteroid>();

    if (level <= 1) {
      return pieces;
    }

    float nextRadius = radius * 0.58f;
    int nextLevel = level - 1;

    for (int i = 0; i < 2; i++) {
      float angle = parent.random(PApplet.TWO_PI);
      float speed = parent.random(1.4f, 3.0f);
      Vector2D splitVelocity = vel.scale(0.35f).add(Vector2D.FromPolar(speed, angle));
      pieces.add(new Asteroid(parent, pos.x, pos.y, nextRadius, nextLevel, splitVelocity.x, splitVelocity.y));
    }

    return pieces;
  }

  public void drawSprite() {
    parent.pushMatrix();
    parent.translate(pos.x, pos.y);
    parent.rotate(rotationAngle);

    parent.noFill();
    parent.stroke(195);
    parent.strokeWeight(2);
    parent.beginShape();

    for (int i = 0; i < vertexScale.length; i++) {
      float angle = PApplet.TWO_PI * i / vertexScale.length;
      float r = radius * vertexScale[i];
      parent.vertex(parent.cos(angle) * r, parent.sin(angle) * r);
    }

    parent.endShape(PApplet.CLOSE);
    parent.popMatrix();
  }
}
