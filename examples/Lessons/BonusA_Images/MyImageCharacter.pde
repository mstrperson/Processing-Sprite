/**
 * MyImageCharacter — a character that displays a picture instead of shapes,
 * but still extends Blob so collidesWith() works for collision detection.
 *
 * Replace "hero.png" with your own file name.
 * The radius in super() is the invisible collision circle — adjust it to
 * roughly match the size of the character in your image.
 */
class MyImageCharacter extends Blob {

  PImage img;

  MyImageCharacter(PApplet p, float x, float y, String fileName) {
    super(p, x, y, 30, color(0));  // radius 30 = collision circle size
    img = p.loadImage(fileName);
  }

  void drawSprite() {
    parent.pushStyle();
    parent.imageMode(CENTER);           // draw image centered on pos.x, pos.y
    parent.image(img, pos.x, pos.y, 60, 60);  // change 60, 60 to resize
    parent.popStyle();
  }
}
