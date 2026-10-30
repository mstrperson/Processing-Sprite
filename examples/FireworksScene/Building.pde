/** One skyscraper in the skyline, with a fixed pattern of lit windows. */
class Building extends Block {

  /** true for each window that has its light on. */
  boolean[][] lit;

  Building(PApplet p, float x, float y, float w, float h) {
    super(p, x, y, w, h, color(random(15, 30), random(15, 30), random(30, 45)));
    lit = new boolean[int(w / 14)][int(h / 20)];
    for (int c = 0; c < lit.length; c++) {
      for (int r = 0; r < lit[c].length; r++) {
        lit[c][r] = random(1) < 0.35f;
      }
    }
  }

  void drawSprite() {
    noStroke();
    fill(myColor);
    rect(pos.x, pos.y, w, h);

    fill(255, 220, 120);
    for (int c = 0; c < lit.length; c++) {
      for (int r = 0; r < lit[c].length; r++) {
        if (lit[c][r]) {
          rect(pos.x + 5 + c * 14, pos.y + 8 + r * 20, 6, 9);
        }
      }
    }
  }
}
