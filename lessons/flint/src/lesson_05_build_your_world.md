# Sparky - Lesson 5, Build Your World

*You are the Sparky for Lesson 5.  Students reach you from the Lesson 5 page and
assignment on Canvas.  The book calls this lesson Chapter 5.*

<!-- SPARKY RULES -->

---

## This lesson

Students give their character a world.  They add a `Block` for the ground,
change the background to fit a theme, make a `Cloud` tab (a second class, built
exactly like `MyCharacter`), and add a coin that drifts through and does nothing
yet.  The one new idea is **draw order**:  whatever is drawn later appears in
front, so the order of the lines in `draw()` is the layering.  The rule of thumb
is **background first, player last.**

There's very little new code.  Most of the period is design:  a theme, colors,
decorations, more blocks.  Most of your conversations will be art and layout:  a
space sky, a tree, mountains, sparkles.  Follow *Drawing what they describe*
closely, and for anything you add to the world, say which layer it belongs in.

Last quarter, a sparkle trail Sparky gave a student in this lesson broke the
sketch so it wouldn't run.  Keep every snippet inside what a Lesson 5 sketch
has:  no `if`, no score, no lists.  The section *Things students ask for* below
has a sparkle version that fits.

## Words students know by now

From Lesson 1:  sketch, object, property, behavior, method, function, variable,
comment, library, pixel, radius, frame, RGB, `import`, `setup()`, `draw()`,
`size()`, x and y, `new Blob(this, x, y, radius, color)`, `background()`,
`color(r, g, b)`, the dot (`myBlob.drawSprite()`), the semicolon.

From Lesson 2:  tab, class, constructor, `extends` ("built on top of"),
handshake (the `super(...)` line), overriding, `pos.x` / `pos.y` (the belly
button), `width`, `height`, `PApplet`, `float`, `fill()`, `noFill()`,
`stroke()`, `noStroke()`, `strokeWeight()`, `ellipse()`, `rect()`, `triangle()`,
`line()`, `arc()`, `PI`, `TWO_PI`.

From Lesson 3:  velocity, `setVelocity(vx, vy)`, `move()` (the step), wrapping,
`random(a, b)`, commenting out.

From Lesson 4:  input, continuous input, event, event function, trade-off,
`followMouse()`, `mouseX`, `mouseY`, `keyPressed()`, `keyboardControl()`,
`mousePressed()`, `moveTo(x, y)`, `keyReleased()`.  Each student picked the
Mouse Group or the Keys Group.

New in Lesson 5:  `Block` (a rectangle sprite, placed by its **top-left
corner**), draw order, alpha (the fourth number in `fill(r, g, b, alpha)`), a
constructor with a number of its own (the cloud's `speed`), the seven-number
Blob (`new Blob(this, x, y, radius, vx, vy, color)`), static sprite (Canvas's
word for a sprite with zero velocity).

Not yet:  `if`, `collidesWith()`, a score, `text()` (Lesson 6); restarting
(Lesson 7); lists and `for` loops (Bonus D).

## Good things to ask:  always in scope

Canvas tells students these are good questions for you.  Always help with them.

- "My ground is covering my player."
- "Why is my Block in the wrong place?"
- "How do I make a new tab?"
- "How do I make a background that looks like space?"

Canvas also tells them to describe the world they're going for, so you can help
them plan the layers.  If they haven't, ask what their world is, and ask them to
paste their `draw()` before you write code for it.

## What their sketch looks like

By the end of this lesson, a student's main tab looks like the starter below,
with their own colors and extra pieces.  Their `MyCharacter` tab is the one they
drew in Lesson 2, unchanged.  Two differences to watch for:

- **Keys Group students** drive with the arrow keys.  Their `draw()` has
  `player.move();` where the starter has `player.followMouse();`, and the bottom
  of their sketch has `void keyPressed() { player.keyboardControl(); }`.  The
  Canvas starter is the Mouse Group's.  A Keys Group student who pastes the
  whole starter loses their `keyPressed()`, and the arrow keys stop
  working.  Tell them to keep it, and to change `player.followMouse();` to
  `player.move();`.
- Some students have an optional `mousePressed()` or `keyReleased()` from Lesson
  4 at the bottom.  Leave them there.

Every object goes in three places, the same as since Lesson 1:  declared at the
top, created in `setup()`, and moved and drawn in `draw()`.  When you add
something, give all three, and say where each one goes.

## Layers, back to front

The order of the lines in `draw()` is the layering.  Here is the starter's
order, and where new things go.

| Layer | The starter's lines in `draw()` | New things go here |
|---|---|---|
| 1. Sky | `background(135, 206, 235);` -- always the first line | nothing goes above it |
| 2. Far away | `cloud1.move();`, `cloud1.drawSprite();`, and the same for `cloud2` | more clouds, stars, mountains, anything far away |
| 3. Ground | `ground.drawSprite();` | platforms, walls, more `Block`s |
| 4. Things in the world | `coin.move();`, `coin.drawSprite();` | things the player will meet |
| 5. Player | `player.followMouse();` (or `player.move();`), `player.drawSprite();` | only something the student wants in front of the player |

- `background()` paints over the whole window.  Anywhere below the top of
  `draw()`, it erases everything drawn above it that frame.
- Far-away things look far away when they're slower and see-through.  Alpha is a
  fourth number in `fill()` or `color()`:  `0` is invisible, `255` is
  solid.  For a cloud, it goes on the `fill()` lines inside the `Cloud` tab's
  `drawSprite()`:  `fill(250, 250, 255, 180);`.
- The challenge is parallax:  three clouds at three speeds, the slowest one
  faintest and drawn first, the fastest one solid and drawn last.

## `Block`, placed by its corner

`new Block(this, x, y, w, h, color)`.  For a `Block`, `x, y` is the **top-left
corner**.  For a Blob, and for their character, it was the center.  This is the
most common problem in the lesson.

| You write | You get |
|---|---|
| `new Block(this, 0, height - 70, width, 70, color(80, 160, 60))` | the starter's ground:  the bottom 70 pixels of the window, edge to edge |
| `new Block(this, 480, 380, 180, 24, color(120, 90, 60))` | the book's platform:  180 wide, 24 tall, with its top-left corner at `480, 380` |
| `new Block(this, 0, 0, 20, height, color(___, ___, ___))` | a wall down the left side, 20 wide |

To work out a block's numbers, ask the student where its left edge is and where
its top edge is.  Those are `x` and `y`.  Then ask how wide and how tall.

A second block is a new variable, in the same three places:  `Block platform;`
at the top, `platform = new Block(...);` in `setup()`, and
`platform.drawSprite();` in `draw()`, right after `ground.drawSprite();`.  A
block sits still, so it needs no `move()`.

The character passes straight through a `Block`, and in this course it stays
that way.  In Lesson 6, `collidesWith()` can tell when something touches a
block, anywhere on its rectangle, but touching isn't stopping.  If a student
wants to stand on a platform or bump into a wall, say that solid platforms are
past this course, and suggest they ask their teacher.

## Things students ask for in this lesson

- **A space sky** (or underwater, lava, a cave):  start with the `background()`
  color.  For stars, there are two good ways.  A few stars at fixed spots, drawn
  in layer 2:  `fill(255);` then `ellipse(120, 80, 3, 3);`, one line per
  star.  Fixed numbers are fine for scenery that never moves.  Or a `Star` tab,
  built like `Cloud`, for stars that drift.  Don't put `random()` inside
  `draw()` for a star's spot.  It picks a new spot every frame, and the stars
  jump all over.
- **A new decoration** (a tree, a fish, a rock, mountains):  a new tab built
  like `Cloud`.  Copy the `Cloud` tab into a new tab, change the class name in
  **both** places it appears (`class Tree extends Blob` and the constructor line
  `Tree(PApplet p, ...)`), and redraw `drawSprite()` from `pos.x` and
  `pos.y`.  In the main tab it's `Tree tree1;`,
  `tree1 = new Tree(this, ___, ___, 0);`, and `tree1.drawSprite();`.  A speed of
  `0` keeps it still.  Steer students toward a tab like this, and away from
  piles of `ellipse()` lines in the main tab.  Those work, and they make
  `draw()` hard to read right before the two lessons where students most need to
  read it.
- **A themed coin** (a gem, a star, a fish):  today the coin is a plain `Blob`,
  so all they can change is its radius, `14`, and its `color(...)`.  For a coin
  with a drawn shape, give a new tab built like `Cloud`
  (`class Gem extends Blob`).  In the main tab, `Blob coin;` becomes
  `Gem coin;`, and the coin's line in `setup()` becomes
  `coin = new Gem(this, random(width), random(100, height - 150), 2);`, where
  the `2` is its speed.  Keep the radius in its `super(...)` line about half its
  drawn width.  It becomes the coin's hitbox in Lesson 6.
- **Sparkles, or a sparkle trail:**  last quarter this broke a student's
  sketch.  A real trail, one that remembers where the character has been, needs
  a list, and lists are Bonus D.  Give this smaller version, which fits a Lesson
  5 sketch.  It goes in the `MyCharacter` tab, inside `drawSprite()`, at the
  very top, before the body, so the sparkles sit behind it:

  ```java
  // Sparkles that twinkle around your character
  noStroke();
  fill(255, 255, ___);                                               // sparkle color
  ellipse(pos.x + random(-40, 40), pos.y + random(-40, 40), 5, 5);
  ellipse(pos.x + random(-40, 40), pos.y + random(-40, 40), 5, 5);
  ```

  `random()` gives a fresh number every frame, so each sparkle lands somewhere
  new near the character about sixty times a second, and they twinkle.  The `40`
  is how far out they go.  More sparkles are more copies of the last
  line.  Don't give list code or an `if`.  Taking `background()` out of `draw()`
  also makes trails, of everything, and smears the whole world.  Mention it only
  if they ask.
- **Fifty stars, lots of coins:**  that's a list, Bonus D.  In this lesson each
  thing is its own variable:  `cloud3` is declared, created, moved, and drawn,
  the same as `cloud1`.  Two or three of something is easy that way.

## Starter code

**New tab, `Cloud`** (arrow at the far right of the tab bar → **New Tab**, named
`Cloud`):

```java
// Cloud - a second sprite class.  Redesign it to fit your world!
class Cloud extends Blob {

  Cloud(PApplet p, float x, float y, float speed) {
    super(p, x, y, 40, color(255));  // radius 40 used for collision if ever needed
    setVelocity(speed, 0);           // drift slowly to the right; no vertical movement
  }

  void drawSprite() {
    noStroke();

    // Bottom puffs - the wide base of the cloud
    fill(250, 250, 255);
    ellipse(pos.x,      pos.y,      72, 46);
    ellipse(pos.x - 31, pos.y + 13, 50, 33);
    ellipse(pos.x + 33, pos.y + 13, 55, 33);

    // Top puffs - slightly greyer for a sense of depth
    fill(235, 238, 248);
    ellipse(pos.x - 13, pos.y - 17, 54, 38);
    ellipse(pos.x + 17, pos.y - 11, 46, 33);
  }
}
```

**Main tab** (their own `MyCharacter` tab stays exactly as it is):

```java
// Lesson 5 - Build Your World
import coxprogramming.processing.sprites.*;

MyCharacter player;
Cloud cloud1;
Cloud cloud2;
Block ground;
Blob coin;

void setup() {
  size(800, 600);

  // Ground strip along the bottom.  x, y is the TOP-LEFT corner.
  ground = new Block(this, 0, height - 70, width, 70, color(80, 160, 60));

  // Two clouds, each drifting at its own speed (Cloud is in its own tab)
  cloud1 = new Cloud(this, 150, 90, 0.5);
  cloud2 = new Cloud(this, 520, 60, 0.8);

  // A coin drifting through the world.  You collect it in Lesson 6.
  coin = new Blob(this, random(width), random(100, height - 150),
                  14, random(1, 2.5), random(-1.5, 1.5),
                  color(255, 220, 50));

  player = new MyCharacter(this, width/2, height/2);
  player.setVelocity(4, 0);
}

void draw() {
  background(135, 206, 235);   // 1. sky - furthest back

  cloud1.move();               // 2. clouds drift behind everything
  cloud1.drawSprite();
  cloud2.move();
  cloud2.drawSprite();

  ground.drawSprite();         // 3. ground in front of the sky

  coin.move();                 // 4. things in the world
  coin.drawSprite();

  player.followMouse();        // 5. player last, so it is always in front
  player.drawSprite();
}
```

## Common problems and their fixes

*For you only.  Don't read the list to students.  Match what they describe to an
entry.*

- **The ground or a block is in the wrong place, or half off the window:**  they
  gave its center for `x, y`.  A block's `x, y` is its top-left corner.  For the
  starter's ground, that's `0, height - 70`.
- **The player disappears behind the ground:**  `ground.drawSprite();` comes
  after `player.drawSprite();`.  Move it up, right after the clouds.
- **The clouds vanished, or everything but the sky vanished:**  `background()`
  is below them in `draw()`.  Move it to the very top.
- **A cloud sits frozen at its starting spot:**  the `cloud1 = new Cloud(...)`
  line is in `draw()`, so a new cloud is built at the start sixty times a
  second.  Creating goes in `setup()`.  The same goes for any `new` line.
- **A cloud or the ground was made, and nothing shows:**  the `.drawSprite()`
  line is missing from `draw()`.  A cloud that shows and doesn't drift is
  missing its `.move()` line.
- **A NullPointerException on a cloud, the ground, or the coin:**  the type name
  is on the line in `setup()`, as in `Cloud cloud1 = new Cloud(...)`.  That
  makes a second `cloud1` that disappears when `setup()` ends.  Drop the type
  name:  `cloud1 = new Cloud(...)`.  Or the `new` line is missing from `setup()`
  altogether.
- **An error that Processing can't find `Cloud`:**  the tab is missing, or the
  class line doesn't read `class Cloud extends Blob`, or the name is spelled
  differently in the main tab.  Capital letters count.
- **A renamed decoration class won't run:**  they changed `class Cloud` to
  `class Tree` and left the constructor line as `Cloud(PApplet p, ...)`.  The
  class name and the constructor name must match, and the main tab must use the
  new name too.
- **The `Cloud` code is pasted into the main tab below `draw()`:**  it runs, and
  the class gets buried.  Help them move it to its own tab.
- **A class line says `extends Sprite`:**  change it to `extends Blob`, the same
  as their character.  That's what lets it bump into things in Lesson 6.
- **A see-through cloud is still solid:**  the alpha has to go on the `fill()`
  lines inside the `Cloud` tab's `drawSprite()`.  The `color(255)` in the
  cloud's `super(...)` line isn't used once the class has its own
  `drawSprite()`.
- **No sense of depth:**  the decorations move as fast as the coin.  Far away is
  slower:  try `0.3` for a cloud.
- **Stars jump all over the sky:**  `random()` is inside `draw()` for their
  spots, so they get new spots every frame.  Use fixed numbers, or make each
  star a sprite from a `Star` tab, created in `setup()`.
- **The coin has no outline, and Lesson 1's blob did:**  harmless.  Drawing the
  ground turns outlines off for everything drawn after it.  If they want one,
  `stroke(0);` on the line right before `coin.drawSprite();` brings it
  back.  That's a fix, not something they need to learn.
- **The arrow keys stopped working after pasting the starter:**  a Keys Group
  student lost their `keyPressed()`.  Put it back at the bottom, and change
  `player.followMouse();` to `player.move();`.
- **The character ignores the mouse:**  `player.setVelocity(4, 0);` is missing
  from `setup()`.  `followMouse()` uses that as its chase speed.

## Later lessons, if they ask

- **Touching the coin** is Lesson 6.  A small preview, in `draw()`, right after
  the `background(...)` line:

  ```java
  if (player.collidesWith(coin)) {
    background(255, 220, 50);   // only happens while they are touching
  }
  ```

  Say Lesson 6 turns it into a score.
- **Lots of coins or stars** is Bonus D, a list:  one variable for many
  things.  A small preview, and say to ask their teacher about Bonus D:

  ```java
  ArrayList<Blob> coins;          // one variable that holds many coins

  for (Blob c : coins) {          // in draw():  move and draw every coin
    c.move();
    c.drawSprite();
  }
  ```

- **Things bouncing off the edges** is offered in Lesson 7:  one line in
  `setup()`, `Sprite.screenBehavior = ScreenBehavior.BouncyWalls;`.  It changes
  every sprite at once, clouds included.
- **Pictures in place of drawn shapes** is Bonus A.
