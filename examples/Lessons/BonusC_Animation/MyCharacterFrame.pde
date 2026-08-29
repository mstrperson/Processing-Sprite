/**
 * MyCharacterFrame — ONE POSE of your character.
 *
 * It is just like MyCharacter from Lesson 2, but with a "pose" number so the
 * same class can draw a few slightly different versions. AnimatedSprite flips
 * between them to create the animation.
 *
 * Keep most of the drawing the SAME in every pose and change only what should
 * move (here, the mouth). Changing too much makes it flicker instead of animate.
 */
class MyCharacterFrame extends Blob {

  /** Which pose to draw: 0, 1, 2, ... */
  int pose;

  /**
   * Creates one pose of the character at position (x, y).
   *
   * @param p     the Processing sketch — always pass {@code this}
   * @param x     starting x position (center of the character)
   * @param y     starting y position (center of the character)
   * @param pose  which version to draw (0, 1, 2, ...)
   */
  MyCharacterFrame(PApplet p, float x, float y, int pose) {
    super(p, x, y, 30, color(100, 180, 255));  // same handshake line as MyCharacter
    this.pose = pose;
  }

  /**
   * Draws this one pose. The body and eyes are the same every time; the mouth
   * changes with {@code pose}, which is what creates the animation.
   * AnimatedSprite calls this only for the pose it is currently showing.
   */
  void drawSprite() {
    // --- Body (same in every pose) ---
    fill(100, 180, 255);
    noStroke();
    ellipse(pos.x, pos.y, 60, 60);

    // --- Eyes (same in every pose) ---
    fill(255);
    ellipse(pos.x - 12, pos.y - 8, 16, 16);
    ellipse(pos.x + 12, pos.y - 8, 16, 16);
    fill(30);
    ellipse(pos.x - 12, pos.y - 8, 8, 8);
    ellipse(pos.x + 12, pos.y - 8, 8, 8);

    // --- Mouth: CHANGES with the pose — this is what makes it animate! ---
    stroke(30);
    strokeWeight(2);
    noFill();
    if (pose == 0) {
      arc(pos.x, pos.y + 6, 24, 18, 0, PI);   // open smile
    } else if (pose == 1) {
      arc(pos.x, pos.y + 6, 24, 8, 0, PI);    // smaller smile
    } else {
      fill(30);
      ellipse(pos.x, pos.y + 10, 12, 12);     // round "talking" mouth
    }
  }
}
