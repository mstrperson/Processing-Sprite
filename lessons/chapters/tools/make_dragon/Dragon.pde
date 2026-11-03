// A cute dragon.  Every shape is measured from pos.x, pos.y:  the belly button.
class Dragon extends Blob {

  Dragon(PApplet p, float x, float y) {
    super(p, x, y, 90, color(120, 200, 140));
  }

  void drawSprite() {
    stroke(40, 100, 60);
    strokeWeight(4);

    // --- Tail, curling up on the right ---
    noFill();
    stroke(40, 100, 60);
    strokeWeight(34);
    arc(pos.x + 110, pos.y + 40, 150, 140, 0, PI - 0.4);
    stroke(120, 200, 140);
    strokeWeight(26);
    arc(pos.x + 110, pos.y + 40, 150, 140, 0, PI - 0.4);
    strokeWeight(4);
    stroke(40, 100, 60);
    fill(255, 150, 80);
    triangle(pos.x + 163, pos.y + 42, pos.x + 207, pos.y + 42, pos.x + 185, pos.y - 8);

    // --- Wings, behind the body ---
    fill(90, 170, 160);
    triangle(pos.x - 50, pos.y - 10, pos.x - 170, pos.y - 90, pos.x - 120, pos.y + 40);
    triangle(pos.x + 50, pos.y - 10, pos.x + 170, pos.y - 90, pos.x + 120, pos.y + 40);

    // --- Body and belly ---
    fill(120, 200, 140);
    ellipse(pos.x, pos.y + 40, 170, 180);
    fill(250, 235, 180);
    ellipse(pos.x, pos.y + 55, 110, 125);

    // --- Feet and arms ---
    fill(120, 200, 140);
    ellipse(pos.x - 50, pos.y + 125, 64, 36);
    ellipse(pos.x + 50, pos.y + 125, 64, 36);
    ellipse(pos.x - 62, pos.y + 30, 30, 44);
    ellipse(pos.x + 62, pos.y + 30, 30, 44);

    // --- Horns and spikes ---
    fill(250, 235, 180);
    triangle(pos.x - 62, pos.y - 120, pos.x - 32, pos.y - 132, pos.x - 70, pos.y - 182);
    triangle(pos.x + 62, pos.y - 120, pos.x + 32, pos.y - 132, pos.x + 70, pos.y - 182);
    fill(255, 150, 80);
    triangle(pos.x - 18, pos.y - 140, pos.x + 18, pos.y - 140, pos.x, pos.y - 172);

    // --- Head ---
    fill(120, 200, 140);
    ellipse(pos.x, pos.y - 70, 200, 160);

    // --- Eyes, with a shine ---
    fill(255);
    ellipse(pos.x - 42, pos.y - 82, 50, 56);
    ellipse(pos.x + 42, pos.y - 82, 50, 56);
    noStroke();
    fill(40, 40, 60);
    ellipse(pos.x - 38, pos.y - 78, 30, 34);
    ellipse(pos.x + 38, pos.y - 78, 30, 34);
    fill(255);
    ellipse(pos.x - 32, pos.y - 86, 11, 11);
    ellipse(pos.x + 44, pos.y - 86, 11, 11);

    // --- Cheeks and nose ---
    fill(255, 160, 170);
    ellipse(pos.x - 72, pos.y - 42, 32, 18);
    ellipse(pos.x + 72, pos.y - 42, 32, 18);
    fill(40, 100, 60);
    ellipse(pos.x - 10, pos.y - 50, 7, 5);
    ellipse(pos.x + 10, pos.y - 50, 7, 5);

    // --- Smile ---
    noFill();
    stroke(40, 100, 60);
    strokeWeight(4);
    arc(pos.x, pos.y - 40, 44, 26, 0, PI);
  }
}
