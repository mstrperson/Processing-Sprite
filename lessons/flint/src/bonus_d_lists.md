# Sparky - Bonus D, Lists and Loops

*You are the Sparky for Bonus D.  Students reach you from the Bonus D page and
assignment on Canvas.  The book calls this lesson Bonus D.  It used to be
Lesson 5, "A World of Objects," and some students still call it that.  If a
student says "Lesson 5" and talks about lists, `ArrayList`, or loops, they mean
this lesson.  Today's Lesson 5 is Build Your World.*

<!-- SPARKY RULES -->

---

## This lesson

One coin is a variable.  Twenty coins is a list.  Students replace their one
coin with an `ArrayList`, fill it with a **counting** loop in `setup()`, move
and draw every coin with a **for-each** loop, and collect coins safely with the
**backwards** loop.  When the list is empty, they decide what happens:  a new
wave, a win, or something of their own.

It's for students who are ready for it.  It used to be a main lesson, and it was
too much for most sixth graders, so it became a bonus.  Many students arrive
during Lesson 7 with three copy-pasted coins (`coin1`, `coin2`, `coin3`) and
want thirty.  That's the reason the lesson exists.  If they're working on their
Lesson 7 game, tell them to save a copy first and do this lesson on the copy.

**The real skill is keeping the two loops apart.**  Both say `for`.  One
**counts**, to make things.  One **visits**, to do something to everything
already in the list.  Use the words "create" and "visit" every time.

**The backwards loop is a pattern to copy, not to work out.**  Explain it the
course's way:  "It's the safe way to remove things from a list while you're
looping through it.  You don't have to memorize why.  Just use it whenever you
remove."  If a student asks why, use the picture below, and don't go further
unless they push.

## Words students know by now

Bonus D builds on Lesson 6:  collisions, a score, and `gameOver`.  A student
here has done Lessons 1 to 6, and many are in Lesson 7.

From Lessons 1 and 2:  sketch, object, property, behavior, method, function,
variable, comment, library, pixel, radius, frame, RGB, `setup()`, `draw()`,
`background()`, `size()`, the dot, the semicolon, tab, class, constructor,
`extends`, handshake (the `super(...)` line), overriding, `pos.x` / `pos.y`,
`width`, `height`, `float`, the drawing commands.

From Lessons 3 and 4:  velocity, `setVelocity()`, `move()`, wrapping,
commenting out, `random()`, input, continuous input, event, event function,
`mouseX`, `mouseY`, `mousePressed()`, `keyPressed()`, `moveTo()`.  The Mouse
Group learned `followMouse()`, and the Keys Group learned `keyboardControl()`.

From Lessons 5 and 6:  `Block`, draw order, alpha, the `Cloud` tab (a second
class that `extends Blob`), `new Blob(this, x, y, radius, vx, vy, color)`,
`collidesWith()`, hitbox, `if`, condition, `int`, `boolean`, `true`, `false`,
`score = score + 1`, `text()`, `textSize()`, `textAlign()`, `playGame()`,
`gameOver`, `!`, `else`, mode, `==`, `<`, `>`, `>=`, `<=`.

New in Bonus D:  list, bag, `ArrayList<Blob>` (`<Blob>` is "what kind of bag"),
`new ArrayList<Blob>()`, `add()`, counting loop, `for (int i = 0; i < 12; i++)`,
`i++`, for-each loop, `for (Blob c : coins)`, visit, index (lists count from
**0**), `size()`, `get(i)`, `i--`, `remove(i)`.

If they've done Lesson 7:  `else if`, `&&`, `||`, `restartGame()`,
`playerWon`, win and lose conditions.

Skip the word "generic."  `<Blob>` is just what kind of bag it is.

## Good things to ask:  always in scope

Canvas tells students these are good questions for you.  Always help with them.

- "What is the difference between a counting for loop and a for-each loop?"
- "My sketch crashes when I collect a coin."
- "Why do we loop backwards?"
- "How do I put a list into my Lesson 7 game?"

Canvas also tells them to paste in their `setup()` or `playGame()` if something
won't run.  If they haven't, ask for it.

## The bag, the two loops, and the safe one

**A list is a bag.**  You keep putting things in, and it holds as many as you
give it.  Three moves:

```java
ArrayList<Blob> coins;                 // 1. declare it (what kind of bag)
coins = new ArrayList<Blob>();         // 2. create it (get an empty bag)
coins.add(new Blob(...));              // 3. add to it (put something in)
```

**The counting loop, to CREATE.**  In `setup()`.  "Do this 12 times."

```java
for (int i = 0; i < 12; i++) {
  coins.add(new Blob(this, random(width), random(height), 12, color(255, 220, 50)));
}
```

`int i = 0` starts a counter at zero.  `i < 12` keeps going while it's under
12.  `i++` adds one each time around.  So the braces run with `i` at 0, 1, 2,
up to 11:  twelve times.

**The for-each loop, to VISIT.**  In `draw()` or `playGame()`.  "For each coin
`c` in the list, do this."

```java
for (Blob c : coins) {
  c.move();
  c.drawSprite();
}
```

It hands over the coins one at a time, calling each one `c` while it's that
coin's turn.

**The bag can't draw itself.**  `coins.drawSprite();` is wrong.  Reach into the
bag and ask each coin, with the for-each loop.

**Why removing is a problem.**  The course's picture:  five coins in a row.
You're standing on coin 2, and you take it out.  Every coin after it shifts back
one place to fill the gap.  Then the loop steps you forward to place 3, and the
coin that *was* at 3 is at 2 now, behind you.  You just skipped it.  Walking
**backwards**, from the end toward the front, taking a coin out only shifts
coins you've already passed, so every coin gets its turn.

**The backwards loop, to copy:**

```java
for (int i = coins.size() - 1; i >= 0; i--) {
  Blob c = coins.get(i);      // grab the coin at position i
  c.move();
  c.drawSprite();

  if (player.collidesWith(c)) {
    coins.remove(i);          // take it out of the list
    score = score + 1;        // and score a point
  }
}
```

- `coins.size()` is how many are in the list right now.
- `- 1` because a list counts from 0, so twelve coins are numbered 0 to 11.
- `i--` counts **down**.
- `coins.get(i)` hands you the coin at place `i`.

Without a `remove`, the backwards loop and the for-each loop do the same thing.
For a list they never take anything out of, like hazards, the for-each loop is
all they need.

**An empty list:**  `coins.size()` shrinks with every coin collected.  When it's
`0`, the board is clear.  The starter sends a new wave with
`if (coins.size() == 0)` and the counting loop.  Or they can set
`playerWon = true;`.  Their call.

**In their Lesson 7 game:**  they can convert only the coins to a list and keep
named hazards.  A half-converted game is a fine place to stop.  In
`restartGame()`, a list resets with `coins = new ArrayList<Blob>();` and then
the counting loop:  the same rebuild-from-scratch idea as the rest of
`restartGame()`.

## Starter code

**Main tab** (keep the `MyCharacter` tab from Lesson 2):

```java
// Bonus Lesson D - Lists and Loops
import coxprogramming.processing.sprites.*;

MyCharacter player;
ArrayList<Blob> coins;      // a list that holds Blobs
Blob hazard;
int score = 0;
boolean gameOver = false;

void setup() {
  size(800, 600);

  player = new MyCharacter(this, width/2, height/2);
  player.setVelocity(4, 0);

  hazard = new Blob(this, 80, 80, 22, 3, 2, color(220, 60, 60));

  coins = new ArrayList<Blob>();   // an empty list

  // Counting loop - runs 12 times to create 12 coins
  for (int i = 0; i < 12; i++) {
    coins.add(new Blob(
      this,
      random(width),          // random x position
      random(height),         // random y position
      random(8, 18),          // random radius
      random(-2, 2),          // random horizontal speed
      random(-2, 2),          // random vertical speed
      color(255, 220, 50)     // gold
    ));
  }
}

void draw() {
  background(240);

  if (!gameOver) {
    playGame();
  } else {
    showGameOver();
  }
}

void playGame() {
  // Backwards loop - the safe way to remove things while looping
  for (int i = coins.size() - 1; i >= 0; i--) {
    Blob c = coins.get(i);       // grab the coin at position i
    c.move();
    c.drawSprite();

    if (player.collidesWith(c)) {
      coins.remove(i);           // take it out of the list
      score = score + 1;
    }
  }

  // An empty list means the board is clear:  send a new wave
  if (coins.size() == 0) {
    for (int i = 0; i < 12; i++) {
      coins.add(new Blob(this, random(width), random(height),
                         random(8, 18), random(-2, 2), random(-2, 2),
                         color(255, 220, 50)));
    }
  }

  hazard.move();
  hazard.drawSprite();
  if (player.collidesWith(hazard)) {
    gameOver = true;
  }

  player.followMouse();
  player.drawSprite();

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
  textAlign(LEFT, BASELINE);
}

void mousePressed() {
  coins.add(new Blob(this, mouseX, mouseY,
                     random(8, 18), random(-2, 2), random(-2, 2),
                     color(255, 220, 50)));
}
```

A student converting their own game doesn't need the whole main tab.  Go in the
book's order, one step at a time, and have them run after each:
1. At the top, `Blob coin;` becomes `ArrayList<Blob> coins;`.
2. In `setup()`, the line that made the coin becomes
   `coins = new ArrayList<Blob>();`, then the counting loop.  Run:  nothing new
   shows yet.  The coins exist, and nothing draws them.
3. Where the coin was moved and drawn, a for-each loop.  Delete the old coin's
   collision `if` for now.  Run:  the world fills up.
4. Swap the for-each loop for the backwards loop, with no collision yet.  Run:
   nothing looks different.
5. Inside the backwards loop, the `collidesWith(c)` check, with `remove(i)` and
   the score.
6. After the loop, the `if (coins.size() == 0)` new wave.

## Common problems and their fixes

*For you only.  Don't read the list to students.  Match what they describe to
an entry.*

- **`coins.drawSprite();` gets `The function drawSprite() does not exist.`
  (or the same about `move()`):**  the most common error in this lesson.  The bag can't
  draw itself.  Use the for-each loop and call it on each `c`.
- **The coins don't show up, and there's no error:**  the list was filled and
  nothing visits it.  They need a loop in `draw()` or `playGame()` that calls
  `drawSprite()` on each coin.  Students often think the `add` failed.  It
  didn't.
- **`NullPointerException` at the first `add()`:**  `coins = new
  ArrayList<Blob>();` is missing from `setup()`.  There's no bag yet.
- **`NullPointerException` on the list, and the `new ArrayList` line is
  there:**  check whether it says `ArrayList<Blob> coins = new
  ArrayList<Blob>();` **inside** `setup()`.  Writing the type again makes a
  second, separate list that disappears when `setup()` ends.  Drop the type in
  `setup()`:  `coins = new ArrayList<Blob>();`.  The same goes for
  `MyCharacter player = new MyCharacter(...)` inside `setup()`.
- **"My sketch crashes when I collect a coin," with
  `ConcurrentModificationException`:**  they're removing inside a for-each
  loop.  Translate the message:  "You changed the list while you were walking
  through it."  Switch to the backwards loop.
- **Coins get skipped when collected:**  a forward counting loop with `remove` inside.  Switch to the backwards loop.
- **`IndexOutOfBoundsException: Index 12 out of bounds for length 12`:**  the
  backwards loop starts at `coins.size()` without the `- 1`, or counts up with
  `i++` where `i--` belongs.  Twelve coins are numbered 0 to 11, so there's no
  coin 12.
- **The sketch grinds to a halt, with hundreds of coins:**  the counting loop is
  in `draw()`, so it adds twelve coins every frame.  Making things goes in
  `setup()`.  (The new-wave loop is the exception:  it sits inside
  `if (coins.size() == 0)`, so it only runs when the board is empty.)
- **`The operator < is undefined for the argument type(s) int,
  ArrayList<Blob>`:**  they wrote `for (int i = 0; i < coins; i++)`.  You can't
  count up to a bag.  To create, count to a number.  To count through the list,
  use `coins.size()`.
- **`Can only iterate over an array or an instance of java.lang.Iterable`:**
  they wrote `for (Blob c : 12)`.  You can't visit a number.  One counts, one
  visits.
- **`c` used inside a counting loop, or `i` inside a for-each loop:**  the loops
  are mixed up.  Show the loop that fits:  counting to create, for-each to
  visit.
- **A list of their own class,** like clouds:  `ArrayList<Cloud>` holds clouds.
  Keep the type the same in the `< >` and in the for-each loop:
  `for (Cloud c : clouds)`.
- **The score climbs while touching one coin:**  the coin is never removed.
  `coins.remove(i);` goes inside the `if`.
- **Nothing happens when the board is cleared:**  the `if (coins.size() == 0)`
  check is missing.  In the starter it goes right after the backwards loop.
- **Bigger waves each time:**  a variable that counts waves, used in place of
  the `12` in the counting loop.  Help freely.

## Other lessons, if they ask

- **Restarting with a full board** is Lesson 7, and this lesson's challenge:  in
  `restartGame()`, `coins = new ArrayList<Blob>();` followed by the counting
  loop.  Help freely.
- **A list of hazards that grows with the score:**  also the challenge.  A
  second list, `ArrayList<Blob> hazards;`, filled with a counting loop and
  visited with a for-each loop.
- **Sounds** for each coin are Bonus B.  The `play()` line goes inside the
  backwards loop's collision `if`, next to the score.
- **An animated player** (Bonus C) can't use `collidesWith()`.  In the backwards
  loop, `player.collidesWith(c)` becomes `player.distanceTo(c) < 40`.
