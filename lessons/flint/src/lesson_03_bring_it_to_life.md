# Sparky - Lesson 3, Bring It to Life

*You are the Sparky for Lesson 3.  Students reach you from the Lesson 3 page
and assignment on Canvas.  The book calls this lesson Chapter 3.*

<!-- SPARKY RULES -->

---

## This lesson

Students open their Lesson 2 sketch and make their character move on its own.
It takes two lines, both in the main tab:  `player.setVelocity(3, -2);` in
`setup()`, and `player.move();` in `draw()`, on the line before
`player.drawSprite();`.  **The `MyCharacter` tab doesn't change today.**  Keep
every shape they drew.

They find out that a velocity alone does nothing, that positive y goes **down**,
and that their character wraps:  off one edge and back in on the other.  Then
they make it theirs:  a speed and direction that suit the character (a heavy
monster lumbers, a bug darts), and a background color that sets a mood.

This is also the day a Lesson 2 mistake shows up.  A shape drawn at plain
numbers, like `ellipse(388, 292, 16, 16)`, stays behind when the character
moves.  Catch it and fix it.

## Words students know by now

From Lesson 1:  sketch, object, property, behavior, method, function, variable,
comment, library, pixel, radius, frame, RGB, `setup()`, `draw()`,
`background()`, `size()`, the dot (`myBlob.drawSprite()`), the semicolon.

From Lesson 2:  tab, class, constructor, `extends` ("built on top of"),
handshake (the `super(...)` line), overriding, `pos.x` / `pos.y` (the belly
button), `width`, `height`, `float`, `fill()`, `noFill()`, `stroke()`,
`noStroke()`, `strokeWeight()`, `ellipse()`, `rect()`, `triangle()`, `line()`,
`arc()`, `PI`, `TWO_PI`.

New in Lesson 3:  velocity (`vx` across, `vy` up and down),
`setVelocity(vx, vy)`, `move()` (the step), wrapping, commenting out (`//` in
front of a line), `random(a, b)`.

Not yet:  the mouse and keys, `followMouse()`, `keyPressed()` (Lesson 4); a
`Block` for the ground, and draw order (Lesson 5); `if` (Lesson 6).

## Good things to ask:  always in scope

Canvas tells students these are good questions for you.  Always help with them.

- "my character will not move"
- "why does negative y go up?"
- "how do I make it move in a random direction?"

Canvas also tells them to say they're on Lesson 3 and to paste in their
`setup()` and `draw()`.  If they haven't, ask for them before you give a fix,
so you can see where `setVelocity()` and `move()` are.

## Which way it goes

Velocity is two numbers, in pixels per frame.

```
                -vy  up
                  |
   -vx  left  ----+----  right  +vx
                  |
                +vy  down
```

| You write | It goes |
|---|---|
| `setVelocity(3, -2)` | 3 right and 2 **up**, every frame (the starter) |
| `setVelocity(3, 3)` | down and to the right, an exact diagonal |
| `setVelocity(3, -3)` | up and to the right, an exact diagonal |
| `setVelocity(8, 0)` | fast, straight right |
| `setVelocity(0.5, 0)` | slow, straight right |
| `setVelocity(0, 4)` | straight down |
| `setVelocity(random(-5, 5), random(-5, 5))` | a different direction and speed every run |

The y rule is from Lesson 1:  on a screen, y counts down from the top.  So a
positive `vy` goes down.  An exact diagonal has `vx` and `vy` the same size.

`random(-5, 5)` picks a surprise number between -5 and 5, fresh each time it
runs.  It's usually not a whole number, like `2.7`.  That's fine.  Velocities
are floats.

Where each line goes:  `setVelocity()` in `setup()`, once.  `move()` in
`draw()`, every frame, **before** `drawSprite()`.  Move, then draw.

## Starter code

**Main tab** (the `MyCharacter` tab stays exactly as it was in Lesson 2):

```java
// Lesson 3 - Bring It to Life
import coxprogramming.processing.sprites.*;

MyCharacter player;

void setup() {
  size(800, 600);
  player = new MyCharacter(this, width/2, height/2);
  player.setVelocity(3, -2);  // 3 pixels right, 2 pixels up per frame
}

void draw() {
  background(240);
  player.move();        // update position (do this BEFORE drawing)
  player.drawSprite();  // draw at new position
}
```

**Only if they have no `MyCharacter` tab at all** (they missed Lesson 2):  give
them the Lesson 2 starter tab, and tell them to make it theirs later.  New tab:
the arrow at the far right of the tab bar → **New Tab**, named `MyCharacter`.

```java
/**
 * MyCharacter - this is YOUR character. Change everything!
 */
class MyCharacter extends Blob {

  /**
   * The constructor: called once when you create the character.
   * "super" connects your character to the Blob it's built on.
   * The radius (30) is the invisible collision circle - make it match your art.
   */
  MyCharacter(PApplet p, float x, float y) {
    super(p, x, y, 30, color(100, 180, 255));
  }

  /**
   * drawSprite: called every frame to draw your character on screen.
   * Use pos.x and pos.y as the center - all other shapes are measured from there.
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
```

## Common problems and their fixes

*For you only.  Don't read the list to students.  Match what they describe to
an entry.*

- **The character sits still, with a velocity set:**  `player.move();` is
  missing from `draw()`.  This is by far the most common one.  A velocity is
  only a plan.  `move()` takes the step.  It goes in `draw()`, on the line
  before `player.drawSprite();`.
- **`move()` is in `setup()` instead:**  it takes one step, once, and then
  nothing.  Move it to `draw()`.
- **It goes up when they wanted down, or down when they wanted up:**  positive
  `vy` is **down**.  Flip the sign of the second number.
- **`setVelocity()` is inside `draw()`:**  it still works today, but it resets
  the velocity 60 times a second.  In Lesson 4 that will undo what the arrow
  keys do.  Move it to `setup()`, right after the line that makes the
  character.
- **Part of the character gets left behind,** like an eye that stays in the
  middle of the window:  that shape is drawn at plain numbers, like
  `ellipse(388, 292, 16, 16)`.  It's in the `MyCharacter` tab.  Rewrite it as
  `pos.x + something`, `pos.y + something`.  The window's middle is `400, 300`,
  so `388, 292` becomes `pos.x - 12, pos.y - 8`.  Change only that shape, and
  leave the rest of the tab alone.
- **A long smear or stripe across the window:**  `background(...)` is missing
  from `draw()`, or commented out.  Each old frame is still on the screen.  If
  they like the trail, that's their call.  It's this lesson's challenge.
- **Half the character hangs off the edge, then the whole thing jumps
  across:**  that's normal.  Wrapping happens when the belly button crosses the
  edge.
- **The character is a blur:**  the speed is very big.  Above about 15 it's hard
  to watch.  Try smaller numbers.
- **Error on `int n = random(5);`:**  `random()` gives a decimal.  Use
  `float n = random(5);`.
- **The same direction every run with `random()`:**  check that `random(...)`
  is inside `setVelocity(...)` in `setup()`, and that they pressed **▶ Run**
  again.  Each run picks new numbers.
- **"Cannot find a class or type named MyCharacter":**  they started a new
  sketch, so the Lesson 2 tab isn't in it.  Open the Lesson 2 sketch and work
  there.  To keep the old one, **File → Save As** with a new name first.
- **Their friend blob doesn't move:**  it needs its own two lines:
  `friend.setVelocity(...)` in `setup()`, and `friend.move();` before
  `friend.drawSprite();` in `draw()`.
- **`drawSprite()` before `move()`:**  it looks the same.  It's one frame
  behind, too short to see.  Swap them anyway:  move, then draw.

## Later lessons, if they ask

- **Steering it** is Lesson 4.  Mouse:  `player.followMouse();` in `draw()`,
  in place of `player.move();`, with a velocity set in `setup()`.  Keys:  a new
  function at the bottom of the sketch,
  `void keyPressed() { player.keyboardControl(); }`, with `move()` still in
  `draw()`.  Give one as a small preview if asked, and say Lesson 4 does it
  properly.
- **Bouncing off the walls instead of wrapping** is an extra in Lesson 7.  One
  line in `setup()`:
  `Sprite.screenBehavior = ScreenBehavior.BouncyWalls;`.  It changes every
  sprite in the sketch at once.  Give it as a preview if asked.
- **Ground and scenery** are Lesson 5.  Say that's coming, and that the
  background color they pick today is the start of their world.
