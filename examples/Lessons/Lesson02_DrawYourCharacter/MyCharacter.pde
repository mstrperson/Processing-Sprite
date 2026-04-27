/**
 * MyCharacter — this is YOUR character. Change everything!
 *
 * {@code extends Blob} means your character is built on top of Blob.
 * It already knows how to move, wrap around the screen, and detect collisions.
 * All you add is what it looks like, inside {@code drawSprite()}.
 */
class MyCharacter extends Blob {

  /**
   * Creates a new MyCharacter at position (x, y).
   * The radius (30) is the invisible collision circle — adjust it if your
   * character grows much larger or smaller.
   *
   * @param p  the Processing sketch — always pass {@code this}
   * @param x  starting x position (center of the character)
   * @param y  starting y position (center of the character)
   */
  MyCharacter(PApplet p, float x, float y) {
    super(p, x, y, 30, color(100, 180, 255));
  }

  /**
   * Draws your character on screen. Called automatically every frame.
   *
   * Use {@code pos.x} and {@code pos.y} as your character's center.
   * Every other shape is placed relative to that point — think of it
   * as your character's belly button.
   */
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
