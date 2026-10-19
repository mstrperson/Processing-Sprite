// Draws the printed book's pictures:  the cover, a title-page picture for each
// chapter, and the spot pictures finish_book.ps1 drops into large gaps.
//
//     Processing cli --sketch=lessons/chapters/tools/make_art --run
//
// Writes lessons/chapters/build/book/cover.png and build/book/art/*.png.  Line
// art in the book's blue, on a transparent background, the way the C# book's
// Course/reference/make_art.ps1 draws its own.  That book's star is a d20;  this
// one's is the Blob, with the face Chapter 2 gives it.  Every label is a real
// name from the book's code.  Run it again after changing any picture, then
// build the book.

final int BLUE  = #1F4E79;
final int MID   = #2B6CB0;
final int PALE  = #EAF2FB;
final int LIGHT = #CFE0F3;
final int RED   = #B03A2E;
final int GRAY  = #8A9AAA;
final int WHITE = #FFFFFF;

PGraphics pg;
PFont mono, monoBold, serif, sans;
String outDir;

void setup() {
  size(200, 200);
  outDir = sketchPath("../../build/book");
  mono = pickFont(new String[] { "Consolas", "Menlo-Regular", "Monospaced" }, 64);
  monoBold = pickFont(new String[] { "Consolas-Bold", "Consolas Bold", "Menlo-Bold", "Monospaced.bold" }, 64);
  serif = pickFont(new String[] { "Georgia-Bold", "Georgia Bold", "Serif.bold" }, 64);
  sans = pickFont(new String[] { "Calibri-Bold", "Calibri Bold", "HelveticaNeue-Bold", "SansSerif.bold" }, 64);

  cover();
  ch00(); ch01(); ch02(); ch03(); ch04(); ch05(); ch06(); ch07();
  chA(); chB(); chC(); chD(); chR();
  spots();
  exit();
}

// The first font in the list this machine has.
PFont pickFont(String[] names, int size) {
  String[] have = PFont.list();
  for (String name : names) {
    for (String h : have) {
      if (h.equals(name)) return createFont(name, size, true);
    }
  }
  return createFont(names[names.length - 1], size, true);
}

// ---------------------------------------------------------------------------
// The canvas, and the pieces every picture is built from.

void begin(int w, int h) {
  pg = createGraphics(w, h);
  pg.smooth(8);
  pg.beginDraw();
  pg.clear();
  pg.strokeJoin(ROUND);
  pg.strokeCap(ROUND);
}

void saveArt(String name) {
  pg.endDraw();
  String path = outDir + "/" + name;
  pg.save(path);
  println("wrote " + path);
}

void words(String s, PFont f, float px, int c, float x, float y) {
  pg.textFont(f, px);
  pg.fill(c);
  pg.noStroke();
  pg.textAlign(CENTER, CENTER);
  pg.text(s, x, y - px * 0.08);
}

// A label in a box sized to fit it, centered on (cx, cy).
void tag(String s, PFont f, float px, float cx, float cy, int fill) {
  pg.textFont(f, px);
  float w = pg.textWidth(s) + px * 1.2, h = px * 2;
  box(cx - w / 2, cy - h / 2, w, h, fill, 7, 22);
  words(s, f, px, BLUE, cx, cy);
}

void box(float x, float y, float w, float h, int fill, float stroke, float r) {
  pg.fill(fill);
  pg.stroke(BLUE);
  pg.strokeWeight(stroke);
  pg.rect(x, y, w, h, r);
}

void arrow(float x1, float y1, float x2, float y2, float w) {
  float a = atan2(y2 - y1, x2 - x1);
  float head = 5 * w;
  pg.stroke(BLUE);
  pg.strokeWeight(w);
  pg.line(x1, y1, x2 - cos(a) * head * 0.8, y2 - sin(a) * head * 0.8);
  arrowHead(x2, y2, a, head);
}

void arrowHead(float x, float y, float a, float head) {
  pg.noStroke();
  pg.fill(BLUE);
  pg.triangle(x, y,
    x - cos(a - 0.42) * head, y - sin(a - 0.42) * head,
    x - cos(a + 0.42) * head, y - sin(a + 0.42) * head);
}

void dashed(float x1, float y1, float x2, float y2, int c, float w) {
  float len = dist(x1, y1, x2, y2);
  int n = max(1, int(len / 30));
  pg.stroke(c);
  pg.strokeWeight(w);
  for (int i = 0; i < n; i += 2) {
    float a = i / (float) n, b = min(1, (i + 1) / (float) n);
    pg.line(lerp(x1, x2, a), lerp(y1, y2, a), lerp(x1, x2, b), lerp(y1, y2, b));
  }
}

// The book's character, Chapter 2's face:  a body 60 across, eyes 16 across
// at (-12, -8), pupils 8, and a smile.  d is the body's width here.  mouth is
// Bonus C's pose:  0 the open smile, 1 the smaller smile, 2 the round mouth.
void blob(float x, float y, float d, int fill, int mouth) {
  float s = d / 60.0;
  float w = max(5, d / 34);
  pg.fill(fill);
  pg.stroke(BLUE);
  pg.strokeWeight(w);
  pg.ellipse(x, y, d, d);
  pg.strokeWeight(w * 0.7);
  pg.fill(WHITE);
  pg.ellipse(x - 12 * s, y - 8 * s, 16 * s, 16 * s);
  pg.ellipse(x + 12 * s, y - 8 * s, 16 * s, 16 * s);
  pg.noStroke();
  pg.fill(BLUE);
  pg.ellipse(x - 12 * s, y - 8 * s, 8 * s, 8 * s);
  pg.ellipse(x + 12 * s, y - 8 * s, 8 * s, 8 * s);
  pg.stroke(BLUE);
  pg.strokeWeight(w * 0.8);
  if (mouth == 2) {
    pg.fill(BLUE);
    pg.ellipse(x, y + 10 * s, 12 * s, 12 * s);
  } else {
    pg.noFill();
    pg.arc(x, y + 6 * s, 24 * s, (mouth == 0 ? 18 : 8) * s, 0, PI);
  }
}

void blob(float x, float y, float d) { blob(x, y, d, LIGHT, 0); }

// A coin, seen face on, with a shine.
void coin(float x, float y, float d) {
  pg.fill(PALE);
  pg.stroke(BLUE);
  pg.strokeWeight(max(5, d / 16));
  pg.ellipse(x, y, d, d);
  pg.fill(LIGHT);
  pg.strokeWeight(max(3, d / 30));
  pg.ellipse(x, y, d * 0.68, d * 0.68);
  pg.noFill();
  pg.stroke(WHITE);
  pg.strokeWeight(max(4, d / 18));
  pg.arc(x, y, d * 0.5, d * 0.5, PI + 0.3, PI + 1.3);
}

// A cloud, Chapter 5's:  three puffs and two on top.
void cloud(float x, float y, float s) {
  float[][] puffs = { {-60, 10, 100, 64}, {60, 10, 100, 64}, {0, 0, 130, 70}, {-20, -30, 110, 76}, {30, -24, 90, 64} };
  pg.stroke(BLUE);
  pg.strokeWeight(14 * s);
  for (float[] p : puffs) pg.ellipse(x + p[0] * s, y + p[1] * s, p[2] * s, p[3] * s);
  pg.noStroke();
  pg.fill(WHITE);
  for (float[] p : puffs) pg.ellipse(x + p[0] * s, y + p[1] * s, p[2] * s, p[3] * s);
}

// A window, with its title bar.
void window(float x, float y, float w, float h, int fill) {
  box(x, y, w, h, fill, 9, 24);
  pg.fill(LIGHT);
  pg.noStroke();
  pg.rect(x + 5, y + 5, w - 10, 64, 20, 20, 0, 0);
  pg.stroke(BLUE);
  pg.strokeWeight(7);
  pg.line(x, y + 70, x + w, y + 70);
  pg.noFill();
  pg.strokeWeight(9);
  pg.rect(x, y, w, h, 24);
}

// An arrow key, pointing at angle a.
void arrowKey(float x, float y, float size, float a) {
  box(x - size / 2, y - size / 2, size, size, WHITE, 8, 20);
  pg.pushMatrix();
  pg.translate(x, y);
  pg.rotate(a);
  pg.noStroke();
  pg.fill(BLUE);
  pg.triangle(size * 0.22, 0, -size * 0.14, -size * 0.2, -size * 0.14, size * 0.2);
  pg.popMatrix();
}

// The mouse pointer, its tip at (x, y).
void pointer(float x, float y, float s) {
  float[][] pts = { {0, 0}, {0, 150}, {38, 116}, {64, 176}, {92, 164}, {66, 106}, {114, 106} };
  pg.fill(WHITE);
  pg.stroke(BLUE);
  pg.strokeWeight(9);
  pg.beginShape();
  for (float[] p : pts) pg.vertex(x + p[0] * s, y + p[1] * s);
  pg.endShape(CLOSE);
}

// A musical note, its head at (x, y).
void note(float x, float y, float s) {
  pg.pushMatrix();
  pg.translate(x, y);
  pg.noStroke();
  pg.fill(BLUE);
  pg.pushMatrix();
  pg.rotate(-0.4);
  pg.ellipse(0, 0, 70 * s, 50 * s);
  pg.popMatrix();
  pg.stroke(BLUE);
  pg.strokeWeight(10 * s);
  pg.line(30 * s, -8 * s, 30 * s, -170 * s);
  pg.noFill();
  pg.bezier(30 * s, -170 * s, 50 * s, -120 * s, 100 * s, -120 * s, 80 * s, -60 * s);
  pg.popMatrix();
}

// A speaker, facing right.
void speaker(float x, float y, float s) {
  pg.fill(LIGHT);
  pg.stroke(BLUE);
  pg.strokeWeight(10);
  pg.rect(x - 110 * s, y - 60 * s, 80 * s, 120 * s, 10 * s);
  pg.fill(PALE);
  pg.beginShape();
  pg.vertex(x - 30 * s, y - 60 * s);
  pg.vertex(x + 60 * s, y - 140 * s);
  pg.vertex(x + 60 * s, y + 140 * s);
  pg.vertex(x - 30 * s, y + 60 * s);
  pg.endShape(CLOSE);
  pg.noFill();
  for (int k = 0; k < 3; k++) {
    float r = (220 + 110 * k) * s;
    pg.strokeWeight(10);
    pg.stroke(k == 2 ? GRAY : BLUE);
    pg.arc(x + 40 * s, y, r, r, -0.75, 0.75);
  }
}

// A tree, Bonus A's tree.png:  a trunk and a leafy crown.
void tree(float x, float y, float s) {
  pg.fill(LIGHT);
  pg.stroke(BLUE);
  pg.strokeWeight(9);
  pg.rect(x - 24 * s, y - 60 * s, 48 * s, 160 * s, 6);
  float[][] puffs = { {0, -150, 170, 150}, {-70, -90, 150, 130}, {70, -90, 150, 130}, {0, -80, 170, 120} };
  pg.strokeWeight(9);
  for (float[] p : puffs) pg.ellipse(x + p[0] * s, y + p[1] * s, p[2] * s, p[3] * s);
  pg.noStroke();
  pg.fill(PALE);
  for (float[] p : puffs) pg.ellipse(x + p[0] * s, y + p[1] * s, p[2] * s, p[3] * s);
}

// ---------------------------------------------------------------------------
// The cover:  the Blob, above the line that draws it.

void cover() {
  begin(1200, 1200);
  blob(600, 510, 760);
  words("myBlob.drawSprite();", mono, 76, BLUE, 600, 1060);
  saveArt("cover.png");
}

// Prologue:  the editor, and the window its sketch opens.
void ch00() {
  begin(1600, 900);
  window(120, 110, 820, 660, WHITE);
  // The run button.
  pg.fill(PALE);
  pg.stroke(BLUE);
  pg.strokeWeight(7);
  pg.ellipse(190, 140, 44, 44);
  pg.noStroke();
  pg.fill(BLUE);
  pg.triangle(182, 128, 182, 152, 202, 140);
  pg.noFill();
  pg.stroke(BLUE);
  pg.strokeWeight(7);
  pg.ellipse(250, 140, 44, 44);
  pg.fill(BLUE);
  pg.noStroke();
  pg.rect(241, 131, 18, 18);
  String[] code = { "void setup() {", "  size(800, 600);", "}", "", "void draw() {", "  myBlob.drawSprite();", "}" };
  pg.textFont(mono, 46);
  pg.textAlign(LEFT, TOP);
  for (int i = 0; i < code.length; i++) {
    pg.fill(i == 5 ? BLUE : GRAY);
    pg.text(code[i], 170, 210 + 72 * i);
  }
  window(820, 290, 660, 520, PALE);
  blob(1150, 570, 260);
  saveArt("art/ch00.png");
}

// Chapter 1:  a name, and the object it points at.
void ch01() {
  begin(1600, 900);
  box(140, 375, 460, 150, PALE, 8, 20);
  pg.stroke(BLUE);
  pg.strokeWeight(6);
  pg.line(440, 395, 440, 505);
  words("myBlob", mono, 62, BLUE, 290, 450);
  pg.noStroke();
  pg.fill(BLUE);
  pg.ellipse(520, 450, 30, 30);
  arrow(535, 450, 900, 450, 8);
  blob(1170, 450, 480, LIGHT, 0);
  saveArt("art/ch01.png");
}

// Chapter 2:  measure from the belly button.
void ch02() {
  begin(1600, 900);
  float x = 1000, y = 450, d = 600, s = d / 60.0;
  blob(x, y, d, LIGHT, 0);
  // The belly button, at pos.x, pos.y.
  pg.stroke(RED);
  pg.strokeWeight(7);
  pg.line(x - 26, y, x + 26, y);
  pg.line(x, y - 26, x, y + 26);
  dashed(x, y, x - 12 * s, y - 8 * s, RED, 6);
  // Labels, with leaders.
  tag("pos.x, pos.y", mono, 46, 300, y + 40, WHITE);
  dashed(500, y + 40, x - 30, y + 8, BLUE, 6);
  tag("pos.x - 12, pos.y - 8", mono, 46, 400, 180, WHITE);
  dashed(600, 232, x - 12 * s - 50, y - 8 * s - 50, BLUE, 6);
  saveArt("art/ch02.png");
}

// Chapter 3:  a velocity, and everywhere it has been.
void ch03() {
  begin(1600, 900);
  float x0 = 260, y0 = 720, x1 = 1040, y1 = 360;
  for (int k = 0; k < 5; k++) {
    float t = k / 5.0;
    float x = lerp(x0, x1, t), y = lerp(y0, y1, t);
    pg.fill(PALE, 120 + 25 * k);
    pg.stroke(LIGHT);
    pg.strokeWeight(7);
    pg.ellipse(x, y, 230, 230);
  }
  blob(x1, y1, 260, LIGHT, 0);
  arrow(x1 + 150, y1 - 70, x1 + 380, y1 - 176, 9);
  tag("setVelocity(3, -2)", mono, 50, 1160, 735, WHITE);
  saveArt("art/ch03.png");
}

// Chapter 4:  the arrow keys, the mouse, and who the character listens to.
void ch04() {
  begin(1600, 900);
  float kx = 290, ky = 430, ks = 130, gap = 146;
  arrowKey(kx, ky - gap / 2, ks, -HALF_PI);
  arrowKey(kx - gap, ky + gap / 2, ks, PI);
  arrowKey(kx, ky + gap / 2, ks, HALF_PI);
  arrowKey(kx + gap, ky + gap / 2, ks, 0);
  words("keyboardControl()", mono, 44, BLUE, kx, ky + 250);
  blob(800, 380, 260, LIGHT, 0);
  dashed(470, 420, 650, 400, BLUE, 7);
  dashed(1180, 390, 950, 390, BLUE, 7);
  pointer(1240, 290, 1.4);
  words("followMouse()", mono, 44, BLUE, 1320, 680);
  saveArt("art/ch04.png");
}

// Chapter 5:  a world.  Sky, ground, clouds, a coin, a platform.
void ch05() {
  begin(1600, 900);
  box(60, 60, 1480, 780, PALE, 10, 30);
  pg.fill(LIGHT);
  pg.stroke(BLUE);
  pg.strokeWeight(10);
  pg.beginShape();
  pg.vertex(60, 660);
  pg.vertex(1540, 660);
  pg.vertex(1540, 810);
  pg.quadraticVertex(1540, 840, 1510, 840);
  pg.vertex(90, 840);
  pg.quadraticVertex(60, 840, 60, 810);
  pg.endShape(CLOSE);
  words("Block", monoBold, 58, BLUE, 800, 750);
  cloud(400, 220, 1.3);
  cloud(1170, 180, 1.0);
  box(900, 460, 360, 50, LIGHT, 8, 10);
  coin(1080, 380, 90);
  blob(420, 560, 190, WHITE, 0);
  saveArt("art/ch05.png");
}

// Chapter 6:  two things touch, and the program decides.
void ch06() {
  begin(1600, 900);
  tag("if (player.collidesWith(coin))", mono, 48, 800, 130, WHITE);
  float bx = 700, by = 560;
  blob(bx, by, 340, LIGHT, 2);
  coin(bx + 248, by - 28, 160);
  // The touch.
  float cx = bx + 168, cy = by - 28;
  pg.stroke(RED);
  pg.strokeWeight(10);
  for (float deg : new float[] { -105, -70, -35, 35, 70, 105 }) {
    float a = radians(deg);
    pg.line(cx + cos(a) * 175, cy + sin(a) * 175, cx + cos(a) * 245, cy + sin(a) * 245);
  }
  words("score = score + 1", mono, 46, BLUE, 800, 830);
  saveArt("art/ch06.png");
}

// Chapter 7:  one game, two endings, and a click to play again.
void ch07() {
  begin(1600, 900);
  window(80, 250, 560, 420, PALE);
  blob(260, 520, 130, WHITE, 0);
  coin(500, 430, 60);
  window(1000, 60, 520, 330, WHITE);
  words("YOU WIN!", sans, 70, BLUE, 1260, 230);
  window(1000, 510, 520, 330, WHITE);
  words("GAME OVER", sans, 70, RED, 1260, 680);
  arrow(660, 400, 980, 250, 9);
  arrow(660, 520, 980, 670, 9);
  // Back to the start:  a curve from the lower ending, under the game window.
  pg.noFill();
  pg.stroke(BLUE);
  pg.strokeWeight(8);
  pg.bezier(1000, 820, 820, 905, 400, 905, 360, 712);
  float a = atan2(712 - 905, 360 - 400);
  arrowHead(358, 700, a, 40);
  words("restartGame()", mono, 46, BLUE, 690, 770);
  saveArt("art/ch07.png");
}

// Bonus A:  a picture in the data folder becomes a sprite.
void chA() {
  begin(1600, 900);
  // The folder.
  pg.fill(LIGHT);
  pg.stroke(BLUE);
  pg.strokeWeight(10);
  pg.beginShape();
  pg.vertex(120, 260); pg.vertex(320, 260); pg.vertex(370, 310); pg.vertex(700, 310);
  pg.vertex(700, 720); pg.vertex(120, 720);
  pg.endShape(CLOSE);
  // The picture, half out of it.
  pg.pushMatrix();
  pg.translate(420, 360);
  pg.rotate(-0.12);
  box(-170, -180, 340, 320, WHITE, 9, 16);
  pg.popMatrix();
  tree(420, 330, 0.62);
  pg.fill(PALE);
  pg.stroke(BLUE);
  pg.strokeWeight(10);
  pg.rect(120, 420, 580, 300, 0, 0, 20, 20);
  words("data", monoBold, 64, BLUE, 410, 530);
  words("tree.png", mono, 46, GRAY, 410, 620);
  arrow(740, 480, 990, 480, 9);
  tree(1200, 560, 1.4);
  words("ImageSprite", mono, 48, BLUE, 1200, 830);
  saveArt("art/chA.png");
}

// Bonus B:  the ding.
void chB() {
  begin(1600, 900);
  speaker(560, 420, 1.5);
  note(1200, 380, 1.1);
  note(1340, 300, 0.8);
  words("collectSound.play();", mono, 52, BLUE, 800, 790);
  saveArt("art/chB.png");
}

// Bonus C:  a flipbook.  Same character, three mouths.
void chC() {
  begin(1600, 900);
  for (int k = 0; k < 3; k++) {
    float x = 160 + 450 * k;
    box(x, 180, 380, 500, k == 1 ? PALE : WHITE, 9, 20);
    for (int h = 0; h < 6; h++) {
      pg.noStroke();
      pg.fill(LIGHT);
      pg.rect(x + 28 + 58 * h, 200, 32, 28, 6);
      pg.rect(x + 28 + 58 * h, 632, 32, 28, 6);
    }
    blob(x + 190, 430, 260, LIGHT, k);
    words("pose " + k, mono, 44, GRAY, x + 190, 740);
  }
  saveArt("art/chC.png");
}

// Bonus D:  a name for a whole bag of coins.
void chD() {
  begin(1600, 900);
  box(80, 375, 360, 150, PALE, 8, 20);
  pg.stroke(BLUE);
  pg.strokeWeight(6);
  pg.line(310, 395, 310, 505);
  words("coins", mono, 60, BLUE, 195, 450);
  pg.noStroke();
  pg.fill(BLUE);
  pg.ellipse(375, 450, 30, 30);
  arrow(390, 450, 520, 450, 8);
  box(530, 330, 990, 240, WHITE, 9, 26);
  for (int k = 0; k < 5; k++) {
    float x = 530 + 198 * k;
    if (k > 0) {
      pg.stroke(BLUE);
      pg.strokeWeight(6);
      pg.line(x, 330, x, 570);
    }
    coin(x + 99, 450, 130);
    words(str(k), mono, 48, GRAY, x + 99, 630);
  }
  words("ArrayList<Blob>", mono, 50, BLUE, 1025, 250);
  saveArt("art/chD.png");
}

// Teacher Reference:  the family tree.
void chR() {
  begin(1600, 900);
  String[][] rows = {
    { "Sprite" },
    { "Blob", "ImageSprite", "CompoundSprite" },
    { "Block", "", "AnimatedSprite" },
  };
  float[] xs = { 300, 800, 1300 };
  float bw = 440, bh = 120;
  pg.stroke(BLUE);
  pg.strokeWeight(8);
  pg.line(800, 200, 800, 260);
  pg.line(300, 260, 1300, 260);
  for (float x : xs) pg.line(x, 260, x, 330);
  pg.line(300, 450, 300, 580);
  pg.line(1300, 450, 1300, 580);
  box(800 - bw / 2, 80, bw, bh, MID, 8, 22);
  words("Sprite", monoBold, 58, WHITE, 800, 140);
  for (int r = 1; r < 3; r++) {
    for (int c = 0; c < 3; c++) {
      if (rows[r][c].equals("")) continue;
      float y = r == 1 ? 330 : 580;
      box(xs[c] - bw / 2, y, bw, bh, c == 0 && r == 1 ? LIGHT : WHITE, 8, 22);
      words(rows[r][c], mono, 44, BLUE, xs[c], y + bh / 2);
    }
  }
  saveArt("art/chR.png");
}

// ---------------------------------------------------------------------------
// Spot pictures:  small things from the game's world, for filling a large gap
// at the foot of a page.  finish_book.ps1 places them, sparingly.  No words.

void spots() {
  // A coin, shining.
  begin(900, 900);
  coin(430, 480, 500);
  pg.stroke(GRAY);
  pg.strokeWeight(12);
  for (float deg : new float[] { -80, -50, -20 }) {
    float a = radians(deg);
    pg.line(430 + cos(a) * 300, 480 + sin(a) * 300, 430 + cos(a) * 380, 480 + sin(a) * 380);
  }
  saveArt("art/spot_coin.png");

  // A cloud.
  begin(900, 900);
  cloud(450, 480, 3.0);
  saveArt("art/spot_cloud.png");

  // The pointer, clicking.
  begin(900, 900);
  pointer(360, 300, 2.4);
  pg.stroke(GRAY);
  pg.strokeWeight(12);
  for (int k = 0; k < 5; k++) {
    float a = PI + k * PI / 4 - PI / 8;
    pg.line(360 + cos(a) * 70, 300 + sin(a) * 70, 360 + cos(a) * 150, 300 + sin(a) * 150);
  }
  saveArt("art/spot_mouse.png");

  // The four arrow keys.
  begin(900, 900);
  arrowKey(450, 330, 220, -HALF_PI);
  arrowKey(200, 580, 220, PI);
  arrowKey(450, 580, 220, HALF_PI);
  arrowKey(700, 580, 220, 0);
  saveArt("art/spot_keys.png");

  // Two notes.
  begin(900, 900);
  note(330, 640, 2.2);
  note(620, 540, 1.6);
  saveArt("art/spot_notes.png");

  // The Blob, talking.
  begin(900, 900);
  blob(450, 450, 600, LIGHT, 2);
  saveArt("art/spot_blob.png");

  // A tree.
  begin(900, 900);
  tree(450, 660, 2.2);
  saveArt("art/spot_tree.png");

  // Three frames of a flipbook, fanned.
  begin(900, 900);
  for (int k = 0; k < 3; k++) {
    pg.pushMatrix();
    pg.translate(450, 780);
    pg.rotate(-0.3 + 0.3 * k);
    box(-150, -560, 300, 400, k == 2 ? PALE : WHITE, 9, 22);
    blob(0, -360, 190, LIGHT, 2 - k);
    pg.popMatrix();
  }
  saveArt("art/spot_flipbook.png");
}
