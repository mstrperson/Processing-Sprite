/**
 * MyCharacter — replace this with YOUR character from Lesson 2!
 * This is just the starter example so the sketch runs out of the box.
 */
class MyCharacter extends Blob {

  MyCharacter(PApplet p, float x, float y) {
    super(p, x, y, 30, color(100, 180, 255));
  }

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
