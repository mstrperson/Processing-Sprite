/**
 * MyCharacter — redesign this to make it yours!
 *
 * extends Blob means your character is built on top of Blob.
 * It already knows how to move, wrap around the screen, and detect collisions.
 * All you have to do is decide what it looks like inside drawSprite().
 *
 * Use pos.x and pos.y as your character's center.
 * Every other shape is measured from there.
 */
class MyCharacter extends Blob {

  MyCharacter(PApplet p, float x, float y) {
    // super() is the handshake that connects your character to the library.
    // The 30 is the collision radius — change it if your character is much bigger or smaller.
    super(p, x, y, 30, color(100, 180, 255));
  }

  void drawSprite() {
    // Body
    fill(100, 180, 255);
    noStroke();
    ellipse(pos.x, pos.y, 60, 60);

    // Eyes
    fill(255);
    ellipse(pos.x - 12, pos.y - 8, 16, 16);
    ellipse(pos.x + 12, pos.y - 8, 16, 16);
    fill(30);
    ellipse(pos.x - 12, pos.y - 8, 8, 8);
    ellipse(pos.x + 12, pos.y - 8, 8, 8);

    // Smile
    stroke(30);
    strokeWeight(2);
    noFill();
    arc(pos.x, pos.y + 5, 24, 18, 0, PI);
  }
}
