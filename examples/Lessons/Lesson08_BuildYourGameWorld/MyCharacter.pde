/**
 * MyCharacter — replace this with YOUR character from Lesson 2!
 *
 * {@code extends Blob} means your character already knows how to move,
 * wrap around the screen, and detect collisions.
 */
class MyCharacter extends Blob {

  /**
   * Creates a new MyCharacter at position (x, y).
   *
   * @param p  the Processing sketch — always pass {@code this}
   * @param x  starting x position (center of the character)
   * @param y  starting y position (center of the character)
   */
  MyCharacter(PApplet p, float x, float y) {
    super(p, x, y, 30, color(100, 180, 255));
  }

  /**
   * Draws the character on screen. Called automatically every frame.
   * Replace the shapes below with your own drawing code.
   */
  void drawSprite() {
    fill(100, 180, 255);
    noStroke();
    ellipse(pos.x, pos.y, 60, 60);

    fill(255);
    ellipse(pos.x - 12, pos.y - 8, 16, 16);
    ellipse(pos.x + 12, pos.y - 8, 16, 16);
    fill(30);
    ellipse(pos.x - 12, pos.y - 8, 8, 8);
    ellipse(pos.x + 12, pos.y - 8, 8, 8);

    stroke(30);
    strokeWeight(2);
    noFill();
    arc(pos.x, pos.y + 5, 24, 18, 0, PI);
  }
}
