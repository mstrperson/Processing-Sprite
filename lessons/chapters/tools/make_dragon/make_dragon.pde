// Draws the Unit 1 title page's picture:  a dragon, made the way Chapter 2
// makes a character.  A class that extends Blob, drawn from pos.x and pos.y.
//
//     Processing cli --sketch=lessons/chapters/tools/make_dragon --run
//
// Writes lessons/chapters/build/book/art/unit1.png, a screenshot of the
// sketch window, then closes.  Build the book again after.
import coxprogramming.processing.sprites.*;

Dragon dragon;

void setup() {
  size(1600, 1200);
  pixelDensity(1);   // the same size picture on every screen
  dragon = new Dragon(this, 400, 330);
}

void draw() {
  scale(2);   // an 800 by 600 sketch, drawn twice as big so it prints sharp
  background(225, 238, 255);

  // A few sparkles, for luck.
  noStroke();
  fill(255, 210, 90);
  sparkle(120, 110);
  sparkle(690, 150);
  sparkle(700, 380);
  sparkle(140, 390);

  // The grass.
  fill(150, 210, 130);
  ellipse(400, 572, 1100, 230);

  dragon.drawSprite();

  saveFrame("../../build/book/art/unit1.png");
  println("wrote lessons/chapters/build/book/art/unit1.png");
  exit();
}

// A four-pointed star, centered on (x, y).
void sparkle(float x, float y) {
  triangle(x - 6, y, x + 6, y, x, y - 22);
  triangle(x - 6, y, x + 6, y, x, y + 22);
  triangle(x, y - 6, x, y + 6, x - 22, y);
  triangle(x, y - 6, x, y + 6, x + 22, y);
}
