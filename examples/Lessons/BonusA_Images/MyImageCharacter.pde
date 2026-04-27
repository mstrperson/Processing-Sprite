/**
 * MyImageCharacter — a character that displays a picture instead of shapes,
 * but still {@code extends Blob} so {@code collidesWith()} works for collision detection.
 *
 * Replace "hero.png" with your own file name.
 * The radius in {@code super()} is the invisible collision circle — adjust it to
 * roughly match the size of the character in your image.
 */
class MyImageCharacter extends Blob {

  /** The image file displayed by this character. */
  PImage img;

  /**
   * Creates a new MyImageCharacter at position (x, y) and loads its image.
   * The image file must be in the sketch's {@code data/} folder.
   *
   * @param p         the Processing sketch — always pass {@code this}
   * @param x         starting x position (center of the character)
   * @param y         starting y position (center of the character)
   * @param fileName  the name of the image file, e.g. {@code "hero.png"}
   */
  MyImageCharacter(PApplet p, float x, float y, String fileName) {
    super(p, x, y, 30, color(0));  // radius 30 = collision circle size
    img = p.loadImage(fileName);
  }

  /**
   * Draws the character's image centered on its current position.
   * Called automatically every frame.
   * Change 60, 60 to resize the displayed image.
   */
  void drawSprite() {
    parent.pushStyle();
    parent.imageMode(CENTER);           // draw image centered on pos.x, pos.y
    parent.image(img, pos.x, pos.y, 60, 60);
    parent.popStyle();
  }
}
