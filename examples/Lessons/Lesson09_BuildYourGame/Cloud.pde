/**
 * Cloud — a drifting background decoration.
 * Redesign or replace this to fit your world.
 */
class Cloud extends Blob {

  Cloud(PApplet p, float x, float y, float speed) {
    super(p, x, y, 40, color(255));
    setVelocity(speed, 0);
  }

  void drawSprite() {
    noStroke();
    fill(250, 250, 255);
    ellipse(pos.x,      pos.y,      72, 46);
    ellipse(pos.x - 31, pos.y + 13, 50, 33);
    ellipse(pos.x + 33, pos.y + 13, 55, 33);
    fill(235, 238, 248);
    ellipse(pos.x - 13, pos.y - 17, 54, 38);
    ellipse(pos.x + 17, pos.y - 11, 46, 33);
  }
}
