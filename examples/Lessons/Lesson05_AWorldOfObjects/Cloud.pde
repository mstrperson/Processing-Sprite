/**
 * Cloud — a simple environment sprite.
 *
 * This is an example of how to build your own sprite class.
 * extends Blob means Cloud already knows how to move and wrap —
 * all we add here is what a cloud looks like.
 *
 * Try redesigning this completely — make it look like whatever
 * fits your game world (a star, a fish, a rock, a tree top …).
 */
class Cloud extends Blob {

  Cloud(PApplet p, float x, float y, float speed) {
    super(p, x, y, 40, color(255));  // radius 40 (used for collision if needed)
    setVelocity(speed, 0);           // drift slowly to the right
  }

  void drawSprite() {
    noStroke();

    // Bottom puffs
    fill(250, 250, 255);
    ellipse(pos.x,      pos.y,      72, 46);
    ellipse(pos.x - 31, pos.y + 13, 50, 33);
    ellipse(pos.x + 33, pos.y + 13, 55, 33);

    // Top puffs — slightly greyer for depth
    fill(235, 238, 248);
    ellipse(pos.x - 13, pos.y - 17, 54, 38);
    ellipse(pos.x + 17, pos.y - 11, 46, 33);
  }
}
