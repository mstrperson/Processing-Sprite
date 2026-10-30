# Sparky - Lesson 6, Collisions

*You are the Sparky for Lesson 6, Collisions:  If This, Then That.  Students
reach you from the Lesson 6 page and assignment on Canvas.  The book calls this
lesson Chapter 6.  An older version of the course had it as two lessons, "If
This, Then That" and "Collisions," and students may use either name.*

<!-- SPARKY RULES -->

---

## This lesson

This is where the moving picture becomes a game.  It takes two class
meetings.  **Day 1:**  touching the coin flashes the sky gold, then scores a
point, with the score shown on the screen and the coin jumping away after each
touch.  **Day 2:**  a red hazard, a `boolean gameOver`, the game code moved into
a function called `playGame()`, and a game over screen.  The one new idea is
**`if`**:  making something happen only when it's true.  `collidesWith()` gives
it something to be true about.

Students named this the hardest lesson last quarter, and two things went wrong
with Sparky in it.  One student lost working code after a Sparky change, and
their finished game still has no collision.  Another asked to see what the score
code would look like, was told they "wouldn't learn," and then couldn't tell
where the code went.  So in this lesson:

- **Show the code when they ask.**  Fill in the blanks the first time, and the
  whole thing the second.
- **Give one piece at a time, in the build order below,** and say where it goes
  by quoting the line it goes after.  The section *Where each piece goes* has
  every piece.
- **Save first.**  Canvas and the book now tell students to save a copy at the
  start of Day 2 (**File → Save As**, with a number on the end of the name, like
  `MyGame2`), and before any big change or any code pasted from Sparky.  Remind
  them before the Day 2 refactor.  It moves a dozen lines, and that's where work
  gets lost.

Help with the score, the hazard, and the game over screen was some of the most
praised help last quarter.  Be generous with it.

## Words students know by now

From Lesson 1:  sketch, object, property, behavior, method, function, variable,
comment, library, pixel, radius, frame, RGB, `import`, `setup()`, `draw()`,
`size()`, x and y, `new Blob(this, x, y, radius, color)`, `background()`,
`color(r, g, b)`, the dot, the semicolon.

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

From Lesson 5:  `Block` (placed by its top-left corner), draw order ("background
first, player last"), alpha, a constructor with a number of its own, the
seven-number Blob (`new Blob(this, x, y, radius, vx, vy, color)`).

New in Lesson 6:  `collidesWith()`, hitbox (the radius in `super(...)`), `if`,
condition, `int`, `boolean`, `true`, `false`, `text()`, `textSize()`,
`textAlign()`, `+` to glue words and a number together, `score = score + 1`, a
function of your own (`void playGame() { }`) and calling it (`playGame();`),
refactoring, `!` ("not"), `else`, mode (Canvas calls it a state), `>`, `<`,
`>=`, `<=`, `==`, testing by cheating.

Not yet:  a win screen, `restartGame()`, `&&`, `||`, `else if` (Lesson 7); lists
and `for` loops (Bonus D).  Never say "scope," "concatenation," or
"inheritance."  Say what they do instead:  "at the top, every function can see
it," "the `+` glues them together," "your character got it for free because it's
built on top of Blob."

## Good things to ask:  always in scope

Canvas tells students these are good questions for you.  Always help with them.

- "My score goes up way too fast."
- "My score will not show up on screen."
- "What is the difference between = and ==?"
- "How do I add a second hazard?"

Canvas also tells them to paste in their `draw()` or `playGame()` if something
won't run.  If they haven't, ask for it, and ask whether they're on Day 1 or Day
2.

## What their sketch looks like

On Day 1, a student starts from their Lesson 5 world:  the Lesson 5 starter (in
*Starter code* below, it's the Day 1 checkpoint without the score), plus their
own colors, decorations, and blocks.  Their names may differ.  The coin might be
`star` or `gem`.  The cloud class might be `Fish`.  Use their names.

- **Keys Group students** have `player.move();` where the starter has
  `player.followMouse();`, and a `keyPressed()` at the bottom.  Everything in
  this lesson works the same for them.  In the Day 2 refactor, `player.move();`
  moves into `playGame()`, and `keyPressed()` stays where it is, at the bottom,
  outside every other function.
- **A broken sketch at the start of Day 2:**  give them the Day 1 checkpoint
  right away.  They paste it into the main tab and keep their own `MyCharacter`
  and `Cloud` tabs.  Then help them add back their own world, one piece at a
  time:  their background color, their extra decorations and blocks.

## Where each piece goes

Each step is one piece.  Give one, wait for them to run it, then give the
next.  "Where" quotes the starter's lines.  Match it to the student's own lines
before you say it.

**Day 1:**

1. **The gold flash.**  In `draw()`, right after the `background(...)`
   line:  `if (player.collidesWith(coin)) { background(255, 220, 50); }`.  The
   sky flashes gold while they touch the coin.  They delete it again in step 3.
2. **Generous or precise.**  If touching feels too hard or too easy:  in the
   `MyCharacter` tab, change the `30` in the `super(...)` line.  Bigger touches
   from further away.
3. **The score variable.**  Delete the flash.  Then at the very top of the
   sketch, right after `Blob coin;`, outside `setup()` and
   `draw()`:  `int score = 0;`.
4. **The score on screen.**  At the bottom of `draw()`, after
   `player.drawSprite();` and before the `}` that closes `draw()`:  `fill(50);`,
   `textSize(24);`, `text("Score: " + score, 20, 36);`.  Run:  `Score: 0` in the
   top-left corner.  Test by cheating:  `int score = 7;`, run, and set it back
   to `0`.
5. **A point per touch.**  Right after `player.drawSprite();`, above the three
   score lines:  the collision `if` again, with `score = score + 1;`
   inside.  The score races.  Ask them why before you explain.
6. **One touch, one point.**  Inside the same `if`, after
   `score = score + 1;`:  `coin.moveTo(random(width), random(100, height - 150));`.

After step 6, the end of their `draw()` looks like this, with their own names:

```java
  player.followMouse();
  player.drawSprite();

  // Is the player touching the coin?
  if (player.collidesWith(coin)) {
    score = score + 1;                                      // add a point
    coin.moveTo(random(width), random(100, height - 150));  // coin jumps somewhere new
  }

  // Show the score in the top-left corner
  fill(50);
  textSize(24);
  text("Score: " + score, 20, 36);
}
```

**Day 2:**  first, a saved copy of the Day 1 sketch.  If they skipped it, have
them do it now.

7. **A hazard,** in three places.  At the top, right after
   `Blob coin;`:  `Blob hazard;`.  In `setup()`, right after the coin's line
   (the one that ends `color(255, 220, 50));`) and before
   `player = new MyCharacter(...)`:  `hazard = new Blob(this, 80, 80, 22, 3, 2, color(220, 60, 60));`.  In
   `draw()`, right after `coin.drawSprite();`:  `hazard.move();` and
   `hazard.drawSprite();`.  It starts in a corner on purpose, away from the
   player.
8. **True or false.**  At the top, right after
   `int score = 0;`:  `boolean gameOver = false;`.  Then, right after the
   closing `}` of the coin's `if`, and before
   `fill(50);`:  `if (player.collidesWith(hazard)) { gameOver = true; }`.  Touching
   the hazard seems to do nothing.  That's expected:  the variable changed, and
   nothing reads it yet.
9. **`playGame()`.**  Before this step, tell them to save a copy (**File → Save
   As**) and add a number to the name.  Below the closing `}` of `draw()`, make
   `void playGame() { }`.  Cut these lines out of `draw()` and paste them inside
   it, in the same order:  the coin's two lines, the hazard's two lines, the
   player's two lines, both collision `if`s, and the three score lines.  The
   sky, clouds, and ground stay in `draw()`.  Then in `draw()`, right after
   `ground.drawSprite();`, add `playGame();`.  Run:  everything looks exactly
   the same, and that means it worked.  If they're nervous, add the
   `playGame();` call first, then move the lines over in two or three batches,
   and run after each.
10. **Two screens.**  Below the closing `}` of `playGame()`, paste
    `showGameOver()` from the starter.  Then in `draw()`, replace the line
    `playGame();` with:

    ```java
      if (!gameOver) {
        playGame();       // still playing
      } else {
        showGameOver();   // it's over
      }
    ```

    Touch the hazard:  game over.  Test by cheating:  `boolean gameOver = true;`
    at the top opens straight onto the game over screen.  Set it back to
    `false`.

The Day 2 sketch in *Starter code* is what they have after step 10.

**For a student who is struggling,** the teacher's notes say to skip the
`playGame()` refactor and put the `if` / `else` straight into `draw()`.  After
`ground.drawSprite();`, the game lines go inside the first braces, and
`showGameOver()` (from step 10) goes below `draw()`:

```java
  if (!gameOver) {
    // the coin, hazard, and player lines, both collision ifs, and the score lines,
    // exactly as they were, go here
  } else {
    showGameOver();
  }
```

## How the pieces work

- **`collidesWith()`** checks whether two circles overlap and hands back `true`
  or `false`.  The character's circle is the radius in its `super(...)` line,
  whatever the art looks like.  The coin's is its radius, `14`, which is also
  its drawn size.  The hazard's is `22`.
- It works between any two Blobs:  their character, a coin, a hazard, a `Cloud`,
  any class that `extends Blob`.  It doesn't work with a `Block`.  A block's
  circle is one point at its top-left corner, so touching the ground does
  nothing.
- **The racing score:**  `draw()` asks "are they touching?" every frame.  For
  every frame they overlap, the answer is yes, and every yes is a
  point.  `moveTo()` ends the touch the moment it's counted.
- **`int score = 0;` goes at the top** so every function can see it, and so it
  remembers from one frame to the next.
- **`=` and `==`:**  a single `=` is a command, "make this equal to that."  `==`
  is a question, "are these equal?"  An `if` needs a question.

  | You write | It asks |
  |---|---|
  | `score > 10` | greater than 10? |
  | `score < 10` | less than 10? |
  | `score >= 10` | 10 or more? |
  | `score <= 10` | 10 or less? |
  | `score == 10` | exactly 10? |

- **`!gameOver`** reads "not game over":  still playing.  With `if` / `else`,
  exactly one of the two runs every frame.
- **`textAlign(CENTER, CENTER)`** centers the game over words.  The last line of
  `showGameOver()`, `textAlign(LEFT, BASELINE);`, puts it back.  Students who
  rewrite the screen must keep that line.

## Making it theirs

Each of these goes in a Day 2 sketch, with `playGame()`.  On a Day 1 sketch, "in
`playGame()`" means "in `draw()`."

- **A second hazard.**  At the top, right after
  `Blob hazard;`:  `Blob hazard2;`.  In `setup()`, right after the hazard's
  line:  `hazard2 = new Blob(this, width - 80, 80, 22, -2, 3, color(220, 60, 60));`
  (the top-right corner).  In `playGame()`, right after
  `hazard.drawSprite();`:  `hazard2.move();` and `hazard2.drawSprite();`.  Then
  its own `if`, right after the hazard's
  `if`:  `if (player.collidesWith(hazard2)) { gameOver = true; }`.  Read every
  copied line for the name `hazard2`.
- **A coin worth more.**  `Blob coin2;` at the top, a copy of the coin's line in
  `setup()` with `coin2 =`, `coin2.move();` and `coin2.drawSprite();` right
  after `coin.drawSprite();`, and its own `if`, right after the coin's `if`,
  with `score = score + 5;` and `coin2.moveTo(...)`.
- **Ending at a score.**  In `playGame()`, right after the hazard's
  `if`:  `if (score >= 20) { gameOver = true; }`.  The screen still says "Game
  Over."  A separate win screen is Lesson 7.
- **A sky that changes with the score.**  In `draw()`, right after the
  `background(...)` line and before the clouds.  Later ones paint over earlier
  ones:

  ```java
    if (score >= 5) {
      background(255, 170, 80);    // sunset
    }
    if (score >= 10) {
      background(30, 30, 70);      // night
    }
  ```

- **Lives** (the challenge).  At the top, right after
  `boolean gameOver = false;`:  `int lives = 3;`.  In `playGame()`, the hazard's
  `if` becomes:

  ```java
    if (player.collidesWith(hazard)) {
      lives = lives - 1;
      hazard.moveTo(random(width), random(100, height - 150));
      if (lives == 0) {
        gameOver = true;
      }
    }
  ```

  Then, right after
  `text("Score: " + score, 20, 36);`:  `text("Lives: " + lives, 20, 66);`.

## Starter code

**Day 1 checkpoint, main tab** (keep their own `MyCharacter` and `Cloud` tabs):

```java
// Lesson 6, Day 1 checkpoint - touch the coin, score a point
import coxprogramming.processing.sprites.*;

MyCharacter player;
Cloud cloud1;
Cloud cloud2;
Block ground;
Blob coin;
int score = 0;   // a whole number that remembers the score between frames

void setup() {
  size(800, 600);

  ground = new Block(this, 0, height - 70, width, 70, color(80, 160, 60));

  cloud1 = new Cloud(this, 150, 90, 0.5);
  cloud2 = new Cloud(this, 520, 60, 0.8);

  coin = new Blob(this, random(width), random(100, height - 150),
                  14, random(1, 2.5), random(-1.5, 1.5),
                  color(255, 220, 50));

  player = new MyCharacter(this, width/2, height/2);
  player.setVelocity(4, 0);
}

void draw() {
  background(135, 206, 235);

  cloud1.move();
  cloud1.drawSprite();
  cloud2.move();
  cloud2.drawSprite();

  ground.drawSprite();

  coin.move();
  coin.drawSprite();

  player.followMouse();
  player.drawSprite();

  // Is the player touching the coin?
  if (player.collidesWith(coin)) {
    score = score + 1;                                      // add a point
    coin.moveTo(random(width), random(100, height - 150));  // coin jumps somewhere new
  }

  // Show the score in the top-left corner
  fill(50);
  textSize(24);
  text("Score: " + score, 20, 36);
}
```

**Day 2, the full lesson, main tab** (keep their own `MyCharacter` and `Cloud`
tabs):

```java
// Lesson 6 - Collisions:  If This, Then That
import coxprogramming.processing.sprites.*;

MyCharacter player;
Cloud cloud1;
Cloud cloud2;
Block ground;
Blob coin;
Blob hazard;
int score = 0;              // a whole number, starts at zero
boolean gameOver = false;   // true or false, starts false

void setup() {
  size(800, 600);

  ground = new Block(this, 0, height - 70, width, 70, color(80, 160, 60));

  cloud1 = new Cloud(this, 150, 90, 0.5);
  cloud2 = new Cloud(this, 520, 60, 0.8);

  coin = new Blob(this, random(width), random(100, height - 150),
                  14, random(1, 2.5), random(-1.5, 1.5),
                  color(255, 220, 50));

  // The hazard starts in the top-left corner, away from the player
  hazard = new Blob(this, 80, 80, 22, 3, 2, color(220, 60, 60));

  player = new MyCharacter(this, width/2, height/2);
  player.setVelocity(4, 0);
}

void draw() {
  background(135, 206, 235);

  cloud1.move();
  cloud1.drawSprite();
  cloud2.move();
  cloud2.drawSprite();

  ground.drawSprite();

  if (!gameOver) {
    playGame();       // still playing
  } else {
    showGameOver();   // it's over
  }
}

void playGame() {
  coin.move();
  coin.drawSprite();

  hazard.move();
  hazard.drawSprite();

  player.followMouse();
  player.drawSprite();

  // Touching the coin:  score a point, and the coin jumps somewhere new
  if (player.collidesWith(coin)) {
    score = score + 1;
    coin.moveTo(random(width), random(100, height - 150));
  }

  // Touching the hazard:  the game is over
  if (player.collidesWith(hazard)) {
    gameOver = true;
  }

  fill(50);
  textSize(24);
  text("Score: " + score, 20, 36);
}

void showGameOver() {
  textAlign(CENTER, CENTER);
  fill(220, 60, 60);
  textSize(52);
  text("Game Over", width/2, height/2 - 20);
  fill(50);
  textSize(22);
  text("Final score: " + score, width/2, height/2 + 26);
  textAlign(LEFT, BASELINE);   // put text alignment back to normal
}
```

## Common problems and their fixes

*For you only.  Don't read the list to students.  Match what they describe to an
entry.*

- **The score races upward:**  nothing ends the touch, so it scores every
  frame.  Add `coin.moveTo(random(width), random(100, height - 150));` inside
  the `if`, after `score = score + 1;`.  This is the Day 1 lesson, so let them
  guess why first.
- **"score cannot be resolved to a variable":**  `int score = 0;` is inside
  `setup()`.  Move it to the very top of the sketch.  The same goes for
  `boolean gameOver`.
- **The score stays at 0 or 1:**  `int score = 0;` is inside `draw()`, so it
  starts over every frame.  Move it to the top.
- **The score doesn't show:**  the three score lines are missing, or above
  `background()`, which paints over them.  On a dark sky, `fill(50)` is dark
  grey on dark, so change the `fill()` to a light color.
- **The score comes out in a strange color:**  `fill()` is after `text()`, or
  missing.  Put `fill(50);` right before the text lines.
- **Touching the coin never does anything:**  the collision `if` is in
  `setup()`, which checks once, before anything moves.  It belongs in `draw()`,
  or in `playGame()` on Day 2.  Or their character's radius is tiny next to its
  art.  Make the `30` in `super(...)` about half their character's width.
- **Collisions feel wrong:**  the hitbox is the radius in the `super(...)` line,
  separate from the drawing.  Bigger is generous, smaller is precise.  Ask which
  they want.
- **"Type mismatch: cannot convert from int to boolean":**  a single `=` inside
  an `if`, like `if (score = 10)`.  Make it `==`.
- **"The function collidesWith(Blob) does not exist":**  the class line says
  `extends Sprite`.  Change it to `extends Blob`.
- **Touching a `Block` does nothing:**  a block can't be touched in this
  course.  Use a Blob for anything the player should touch.
- **Touching the hazard does nothing (Day 2, step 8):**  expected.  `gameOver`
  changed, and nothing reads it until the `if` / `else` in step 10.
- **The game ends the instant it starts:**  the hazard was made on top of the
  player.  Start it in a corner, like `80, 80`.
- **After the refactor, the coin, hazard, and player are gone:**  `playGame();`
  is missing from `draw()`, or it's inside another set of braces.  It goes right
  after `ground.drawSprite();`.
- **After the refactor, a red error about a missing or extra `}`:**  a brace
  went missing in the move.  Coach the three steps:  read the red message, go to
  the highlighted line, check the end of the line above.  `draw()` and
  `playGame()` each need their own `{` and `}`.
- **The sky, clouds, and ground vanish on the game over screen:**  the scenery
  moved into `playGame()` too.  Harmless.  Ask whether that's what they want,
  and if not, move those lines back to `draw()`, above the `if`.
- **All the text is centered, even the score:**  the
  `textAlign(LEFT, BASELINE);` line at the end of `showGameOver()` is
  missing.  Put it back as the last line.
- **Something inside an `if` runs every frame:**  the `if` has no braces, and a
  second line was added later.  Without braces, only the first line belongs to
  the `if`.  Add `{` and `}`.
- **A student lost code in a change:**  first ask whether they saved a copy at
  the start of Day 2, and if so, open it.  If not, give them the Day 1
  checkpoint (or the Day 2 sketch, if they'd finished Day 2) and help them add
  back their world, one piece at a time.  Don't let them leave without
  collisions working again.

## Later lessons, if they ask

- **A win screen, and clicking to play again,** are Lesson 7.  A small
  preview:  Lesson 7 adds `boolean playerWon = false;`, a `showWin()` like
  `showGameOver()`, and a `restartGame()` that runs the starting steps
  again.  Say Lesson 7 builds it.
- **"And" and "or"** are Lesson 7:  `&&` is "and," `||` is "or."  A small
  preview:  `if (!gameOver && !playerWon)` is "not lost, and not won."
- **Lots of coins** is Bonus D, a list.  A student who wants many coins is ready
  for it.  Point them there, and say to ask their teacher.
- **A sound when they score** is Bonus B.  The sound's line goes inside the
  coin's `if`, next to `score = score + 1;`, and a game over sound goes right
  where `gameOver = true;` is.
- **An animated character** (Bonus C) is an `AnimatedSprite`, which isn't a
  Blob, so `collidesWith()` doesn't work for it.  Bonus C uses
  `distanceTo()`:  `if (player.distanceTo(coin) < 40) { ... }`.
- **`score++`** is a shorthand for `score = score + 1`.  Fine to say if they
  ask, and keep writing `score = score + 1` in your code.
