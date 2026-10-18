#!/usr/bin/env bash
# Every claim in the teacher reference about how the library behaves, run for
# real against library/SpriteGame.jar.
#
#     lessons/chapters/planning/verify_api.sh <scratch-folder>
#
# Each check is a small sketch written here, run for a few frames, printing
# what it found.  None of these are lesson code.
set -euo pipefail
cd "$(dirname "$0")/../../.."
V=lessons/chapters/tools/verify.sh
S="$1"; OUT="$(pwd)/lessons/chapters/screenshots"
mkdir -p "$S" "$OUT"

sketch() {   # sketch <name>, with the main tab on stdin:  a fresh sketch, ready to run
  mkdir -p "$S/src/$1"
  cat > "$S/src/$1/$1.pde"
  $V prep "$S/src/$1" "$S/$1" > /dev/null
}
run() {      # run <name> <frames>:  run it and print what it printed
  PRE="${PRE:-}" $V shot "$S/$1" "$S/$1.png" "$2" 2>&1 | grep -v '^\s*at \|^saved\|^Finished\|^no frame' | head -12 || true
}
build() { $V build "$S/$1"; }

echo "== followMouse() landing exactly on the mouse:  NaN"
sketch NaN <<'PDE'
import coxprogramming.processing.sprites.*;
Blob b;
void setup() { size(800, 600); b = new Blob(this, 400, 300, 20, color(255, 0, 0)); b.setVelocity(4, 0); }
void draw() {
  mouseX = 600; mouseY = 300;   // 200 to the right:  exactly 50 steps of 4
  background(240);
  b.followMouse();
  b.drawSprite();
  if (frameCount >= 49 && frameCount <= 51) println("frame " + frameCount + ":  pos = (" + b.getPosition().x + ", " + b.getPosition().y + ")");
}
PDE
run NaN 52

echo "== collidesWith() counts touching edges (<=)"
sketch Touch <<'PDE'
import coxprogramming.processing.sprites.*;
void setup() {
  size(200, 200);
  Blob a = new Blob(this, 50, 50, 10, color(0));
  Blob b = new Blob(this, 70, 50, 10, color(0));   // centers 20 apart, radii 10 + 10
  Blob c = new Blob(this, 71, 50, 10, color(0));
  println("centers 20 apart:  " + a.collidesWith(b) + ";  21 apart:  " + a.collidesWith(c));
}
void draw() {}
PDE
run Touch 3

echo "== a Block's collision circle:  radius 0, at its top-left corner"
sketch BlockHit <<'PDE'
import coxprogramming.processing.sprites.*;
void setup() {
  size(800, 600);
  Block wall = new Block(this, 300, 300, 200, 100, color(0));          // corner (300, 300), middle (400, 350)
  Blob middle = new Blob(this, 400, 350, 30, color(0));
  Blob corner = new Blob(this, 320, 310, 30, color(0));
  println("a Blob in the middle of the Block:  " + middle.collidesWith(wall));
  println("a Blob near its corner:  " + corner.collidesWith(wall));
}
void draw() {}
PDE
run BlockHit 3

echo "== style leaks between sprites:  a Blob drawn after a Block loses its outline"
sketch Leak <<'PDE'
import coxprogramming.processing.sprites.*;
Blob first, after;
Block block;
void setup() {
  size(400, 200);
  first = new Blob(this, 100, 100, 40, color(255, 120, 60));
  block = new Block(this, 180, 60, 40, 80, color(80, 160, 60));
  after = new Blob(this, 300, 100, 40, color(255, 120, 60));
}
void draw() {
  background(240);
  first.drawSprite();
  block.drawSprite();   // calls noStroke(), and the setting carries on
  after.drawSprite();
}
PDE
run Leak 3
$V shot "$S/Leak" "$OUT/api_Leak1.png" 1 > /dev/null   # frame 1:  the first Blob still has its outline
$V shot "$S/Leak" "$OUT/api_Leak.png" 3 > /dev/null    # frame 3:  neither does.  Style carries across frames, too.

echo "== Sprite.screenBehavior:  static, so one line changes every sprite"
sketch Walls <<'PDE'
import coxprogramming.processing.sprites.*;
Blob a, b;
void setup() {
  size(800, 600);
  a = new Blob(this, 780, 100, 10, 5, 0, color(0));
  b = new Blob(this, 100, 590, 10, 0, 5, color(0));
  Sprite.screenBehavior = ScreenBehavior.HardWalls;
}
void draw() {
  a.move(); b.move();
  if (frameCount == 10) {
    println("HardWalls, frame 10:  a at x = " + a.getPosition().x + ", vx = " + a.getVelocity().x + ";  b at y = " + b.getPosition().y + ", vy = " + b.getVelocity().y);
    Sprite.screenBehavior = ScreenBehavior.BouncyWalls;
    a.setVelocity(5, 0); b.setVelocity(0, 5);
  }
  if (frameCount == 12) {
    println("BouncyWalls, frame 12:  vx = " + a.getVelocity().x + ";  vy = " + b.getVelocity().y);
    Sprite.screenBehavior = ScreenBehavior.NoWalls;
    a.moveTo(780, 100); a.setVelocity(5, 0);
  }
  if (frameCount == 22) println("NoWalls, frame 22:  a at x = " + a.getPosition().x);
}
PDE
run Walls 24

echo "== aliasing:  getPosition() hands back the sprite's own vector"
sketch Alias <<'PDE'
import coxprogramming.processing.sprites.*;
void setup() {
  size(800, 600);
  Blob a = new Blob(this, 100, 100, 10, color(0));
  Vector2D p = a.getPosition();
  p.x = 500;
  println("after p.x = 500:  a is at x = " + a.getPosition().x);

  Vector2D v = new Vector2D(2, 0);
  Blob b = new Blob(this, 100, 100, 10, color(0));
  Blob c = new Blob(this, 100, 200, 10, color(0));
  b.setVelocity(v);
  c.setVelocity(v);           // b and c now share one velocity object
  keyCode = UP;
  b.keyboardControl();        // changes b's velocity in place
  println("after b.keyboardControl() with UP:  c's velocity = (" + c.getVelocity().x + ", " + c.getVelocity().y + ")");

  Vector2D spot = new Vector2D(300, 300);
  Blob d = new Blob(this, 0, 0, 10, color(0));
  Blob e = new Blob(this, 0, 0, 10, color(0));
  d.moveTo(spot);
  e.moveTo(spot);             // d and e now share one position object
  d.moveTo(50, 60);           // the float version changes it in place
  println("after d.moveTo(50, 60):  e is at (" + e.getPosition().x + ", " + e.getPosition().y + ")");
  d.move();                   // move() makes a new vector, and the sharing ends
  d.moveTo(70, 80);
  println("after d.move() and d.moveTo(70, 80):  e is at (" + e.getPosition().x + ", " + e.getPosition().y + ")");
}
void draw() {}
PDE
run Alias 3

echo "== Vector2D.angleTo() uses atan(y/x):  right to left should be PI"
sketch Angle <<'PDE'
import coxprogramming.processing.sprites.*;
void setup() {
  size(200, 200);
  Vector2D right = new Vector2D(1, 0), left = new Vector2D(-1, 0), down = new Vector2D(0, 1), upLeft = new Vector2D(-1, -1);
  println("right.angleTo(left) = " + right.angleTo(left) + "   (PI is " + PI + ")");
  println("right.angleTo(down) = " + right.angleTo(down));
  println("right.angleTo(upLeft) = " + right.angleTo(upLeft) + "   (the true angle is " + atan2(-1, -1) + ")");
  println("new Vector2D(0, 0).unitVector() = (" + new Vector2D(0, 0).unitVector().x + ", " + new Vector2D(0, 0).unitVector().y + ")");
  println("perpendicular of right (1, 0) = (" + right.perpendicular().x + ", " + right.perpendicular().y + ")");
  println("right.rotate(HALF_PI) = (" + nf(right.rotate(HALF_PI).x, 1, 3) + ", " + nf(right.rotate(HALF_PI).y, 1, 3) + ")");
}
void draw() {}
PDE
run Angle 3

echo "== extends Sprite, with drawSprite() misspelled:  a compile error, where Blob gives a silent circle"
sketch SpriteMisspelled <<'PDE'
import coxprogramming.processing.sprites.*;
Thing t;
void setup() { size(200, 200); t = new Thing(this, 100, 100); }
void draw() { background(240); t.drawSprite(); }
class Thing extends Sprite {
  Thing(PApplet p, float x, float y) { super(p, x, y); }
  void drawsprite() { ellipse(pos.x, pos.y, 20, 20); }
}
PDE
build SpriteMisspelled

echo "== extends Sprite, spelled right:  it works, and has no collidesWith()"
sketch SpriteNoCollide <<'PDE'
import coxprogramming.processing.sprites.*;
Thing t; Blob coin;
void setup() { size(200, 200); t = new Thing(this, 100, 100); coin = new Blob(this, 100, 100, 10, color(0)); }
void draw() { background(240); t.drawSprite(); if (t.collidesWith(coin)) { background(255, 0, 0); } }
class Thing extends Sprite {
  Thing(PApplet p, float x, float y) { super(p, x, y); }
  void drawSprite() { ellipse(pos.x, pos.y, 20, 20); }
}
PDE
build SpriteNoCollide
echo "   ...and the Blob can still collide with it?"
sketch BlobVsSprite <<'PDE'
import coxprogramming.processing.sprites.*;
Thing t; Blob coin;
void setup() { size(200, 200); t = new Thing(this, 100, 100); coin = new Blob(this, 100, 100, 10, color(0)); }
void draw() { background(240); t.drawSprite(); if (coin.collidesWith(t)) { background(255, 0, 0); } }
class Thing extends Sprite {
  Thing(PApplet p, float x, float y) { super(p, x, y); }
  void drawSprite() { ellipse(pos.x, pos.y, 20, 20); }
}
PDE
build BlobVsSprite
echo "   ...distanceTo() works across every kind of sprite"
sketch Distance <<'PDE'
import coxprogramming.processing.sprites.*;
void setup() {
  size(200, 200);
  Blob coin = new Blob(this, 10, 10, 5, color(0));
  Block wall = new Block(this, 40, 50, 30, 30, color(0));
  println("Blob to Block, corner to center:  " + coin.distanceTo(wall));
}
void draw() {}
PDE
run Distance 3

echo "== a CompoundSprite's parts wrap one at a time"
sketch Tear <<'PDE'
import coxprogramming.processing.sprites.*;
CompoundSprite pair;
Blob left, right;
void setup() {
  size(800, 600);
  left = new Blob(this, 740, 300, 10, color(0));
  right = new Blob(this, 790, 300, 10, color(0));
  pair = new CompoundSprite(this, 765, 300).addSprite(left).addSprite(right);
  pair.setVelocity(4, 0);
}
void draw() {
  pair.move();
  if (frameCount == 3 || frameCount == 10 || frameCount == 16) println("frame " + frameCount + ":  left x = " + left.getPosition().x + ", right x = " + right.getPosition().x + ", the pair's own x = " + pair.getPosition().x);
}
PDE
run Tear 17

echo "== Event:  binding a sketch function, and a method in a class of the sketch"
sketch Events <<'PDE'
import coxprogramming.processing.sprites.*;
Event onCoin = new Event();
Counter counter = new Counter();
int sketchCount = 0;
void setup() {
  size(200, 200);
  onCoin.bind(this, "addPoint");
  onCoin.bind(counter, "add");
  onCoin.bind(counter, "addPublic");
  onCoin.trigger();
  println("after one trigger:  sketchCount = " + sketchCount + ", counter.n = " + counter.n);
}
void draw() {}
void addPoint() { sketchCount++; }
class Counter {
  int n = 0;
  void add() { n++; }
  public void addPublic() { n += 10; }
}
PDE
run Events 3

echo "== Event, by its full name:  the sketch's own function, and a class's methods"
# "Event" alone is ambiguous in a sketch:  Processing imports processing.event.Event.
sketch Events2 <<'PDE'
import coxprogramming.processing.sprites.*;
coxprogramming.processing.sprites.Event onCoin = new coxprogramming.processing.sprites.Event();
Counter counter = new Counter();
int sketchCount = 0;
void setup() {
  size(200, 200);
  onCoin.bind(this, "addPoint");
  onCoin.bind(counter, "add");
  onCoin.bind(counter, "addPublic");
  onCoin.trigger();
  println("after one trigger:  sketchCount = " + sketchCount + ", counter.n = " + counter.n);
}
void draw() {
}
void addPoint() { sketchCount++; }
class Counter {
  int n = 0;
  void add() { n++; }
  public void addPublic() { n += 10; }
}
PDE
run Events2 3

echo "== @Override catches the misspelling, and keeps Blob"
sketch OverrideCatch <<'PDE'
import coxprogramming.processing.sprites.*;
Thing t;
void setup() { size(200, 200); t = new Thing(this, 100, 100); }
void draw() {
  background(240);
  t.drawSprite();
}
class Thing extends Blob {
  Thing(PApplet p, float x, float y) { super(p, x, y, 30, color(100, 180, 255)); }
  @Override
  void drawsprite() { ellipse(pos.x, pos.y, 20, 20); }
}
PDE
build OverrideCatch

echo "== the suggested followMouse() fix, as an override:  no NaN, and no jitter"
sketch SafeFollow <<'PDE'
import coxprogramming.processing.sprites.*;
SafeBlob b;
void setup() { size(800, 600); b = new SafeBlob(this, 400, 300, 20, color(255, 0, 0)); b.setVelocity(4, 0); }
void draw() {
  mouseX = 600; mouseY = 300;   // the spot that gives the library's version a NaN at frame 51
  background(240);
  b.followMouse();
  b.drawSprite();
  if (frameCount == 51 || frameCount == 60) println("frame " + frameCount + ":  pos = (" + b.getPosition().x + ", " + b.getPosition().y + ")");
}
class SafeBlob extends Blob {
  SafeBlob(PApplet p, float x, float y, float r, int c) { super(p, x, y, r, c); }
  // Within one step of the mouse, land on it;  otherwise step toward it.
  public void followMouse() {
    float speed = vel.mag();
    Vector2D toMouse = new Vector2D(parent.mouseX, parent.mouseY).subtract(pos);
    float d = toMouse.mag();
    if (d <= speed) {
      pos = new Vector2D(parent.mouseX, parent.mouseY);
    } else {
      pos = pos.add(toMouse.scale(speed / d));
    }
  }
}
PDE
run SafeFollow 61
