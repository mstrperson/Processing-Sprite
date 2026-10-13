# Lesson 6 - Collisions:  If This, Then That

> **Timing:**  Two periods.  Day 1:  touch the coin, score a point.  Day 2:  a hazard, and a game that can end.  
> **New idea:**  `if` -- making something happen only when it is true.  Collisions give it something to be true about.  
> **Builds on:**  Lesson 5 -- your world, with a coin drifting through it.

## Learning Goals
- Use `collidesWith()` to find out whether your player is touching something
- Use an `if` statement so something happens only when it is true
- Keep score with a variable that changes, and show it on screen with `text()`
- Use a `boolean` to switch your game between two **states**:  playing and game over

## New Vocabulary
- **`collidesWith(blob)`** -- asks "are these two sprites touching?" and gives back `true` or `false`
- **`if` statement** -- "if this is true, do this block of code"
- **condition** -- the yes-or-no question inside the parentheses of an `if`
- **hitbox** -- the invisible circle used to decide if something is touching.  For your character it is the radius in the `super(...)` line
- **variable** -- a named box for a value.  `int score = 0;` makes a box called score that starts at zero
- **`int`** -- a variable that holds a whole number -- 0, 7, -3.  No decimals
- **`boolean`** -- a variable that is only ever `true` or `false`
- **`text()`** -- a Processing function that draws words or numbers on the screen
- **state** -- which mode your program is in right now -- playing, or game over

## Warm-Up  (~5 min)

**Day 1:**  your world has a coin drifting through it, and touching it does nothing.  What *should* happen?  **Day 2:**  name a game where touching the wrong thing ends it.  How does the game tell you it is over?

## How It Works

### Day 1 - collidesWith() asks a yes-or-no question

The library checks whether two circles overlap and hands you back `true` or `false`.  That is exactly the kind of answer an `if` is built to use.

- The part in the parentheses is the **condition**.  When it is true, the code inside the braces runs.  When it is false, Processing skips straight past the braces.
- This works because you wrote `class MyCharacter extends Blob` back in Lesson 2.  Your character got `collidesWith()` for free, and you never had to write it.

*Flash the sky gold while you touch the coin*
```java
background(135, 206, 235);

if (player.collidesWith(coin)) {
  background(255, 220, 50);   // only happens while they are touching
}
```

### Your hitbox is the radius you set in Lesson 2

Remember the `30` in your `super(...)` line?  That is the invisible circle the collision check uses.  The collision check reads that number and only that number, so your drawing can be any size you like.

A **bigger** radius means collisions trigger from further away, which feels generous and forgiving.  A **smaller** radius means you have to be right on top of something, which feels precise and harsh.

If your collisions feel wrong, that number is what to change.

### A variable that remembers the score

A score has to **remember** something from one frame to the next.  So it goes at the very **top** of your sketch, outside `setup()` and outside `draw()`.

- Written up there, **every** function can see it.
- Written inside `setup()`, it vanishes the second `setup()` finishes, and `draw()` cannot see it at all.

*At the top, next to your other variables*
```java
MyCharacter player;
Blob coin;
int score = 0;     // a whole number, starts at zero
```

### Putting text on screen

`text()` draws words.  You give it what to say and where to put it.

- The `+` glues the words `"Score: "` and the number `score` together into one piece of text.
- Set `fill()` **before** `text()`, or your text takes whatever color the last shape used.

*Showing the score*
```java
fill(50);                          // the text color
textSize(24);                      // how big
text("Score: " + score, 20, 36);   // what, then x, then y
```

### Why the score races, and the fix

Put `score = score + 1;` inside the `if` and sit your player on the coin.  The score climbs about sixty points a second.

Here is why.  `draw()` runs sixty times a second, so it asks "are they touching?" sixty times a second.  For as long as you sit there, the answer is yes, and every yes is a point.

The fix is to end the touch the moment you count it.  Move the coin somewhere else.

- `moveTo(x, y)` picks a sprite up and puts it down somewhere else.
- `random()` from Lesson 3 picks the spot, so the coin lands somewhere new every time.

*One touch, one point*
```java
if (player.collidesWith(coin)) {
  score = score + 1;                                      // add a point
  coin.moveTo(random(width), random(100, height - 150));  // coin jumps somewhere new
}
```

### Day 2 - a hazard, and a boolean

A hazard is one more `Blob`, red and fast, with its own `if`.  Touching it has to end the game, and the game needs a way to remember that it has ended.

That is the job for a `boolean`, the simplest variable there is.  It is `true` or it is `false`.

*At the top, and in your game code*
```java
boolean gameOver = false;   // true or false, starts false

if (player.collidesWith(hazard)) {
  gameOver = true;
}
```

### States:  your program has modes

This is the big idea of Day 2.  Your game is always in a **mode**.  Right now there are two:  playing, and game over.

The `boolean gameOver` remembers which mode you are in, and an `if/else` in `draw()` picks which one to run.  `!` means **NOT**, so `!gameOver` reads as "not game over" -- in other words, "still playing."

- `playGame()` and `showGameOver()` are functions you write yourself.  Your game code moves into `playGame()`, and the game over screen goes in `showGameOver()`.
- Leave the scenery in `draw()`, above the `if`, so your world shows behind both screens.

*Two states, one choice*
```java
void draw() {
  // ... sky, clouds, ground ...

  if (!gameOver) {
    playGame();       // still playing
  } else {
    showGameOver();   // it's over
  }
}
```

### Comparing numbers

A condition can compare numbers too.  This is how you would make something happen at a score.

- `>` greater than, `<` less than, `>=` at least, `<=` at most, `==` exactly equal.
- Careful:  `==` is a question ("are these equal?").  A single `=` is a command ("make this equal to that").  Mixing them up is a classic.

*A question about a number*
```java
if (score >= 10) {
  background(255, 0, 0);   // only happens once score is 10 or more
}
```

## Direct Instruction  (~10 min)

<!--
Day 1 - start with the question the room is already asking:
  Lesson 5 left a coin drifting through every student's world, and touching it does nothing.  Open with that.  Ask what *should* happen, take two or three answers, then show that the library can already answer "are they touching?"
  The `if` arrives as the way to act on the answer.  That order is the point of this lesson:  the collision first, then the decision about it.  Every `if` a student writes here has something real to be about.

collidesWith() - and why they already have it:
  "The library checks whether the two circles overlap and returns true or false."
  Make the connection explicit:  **because `MyCharacter extends Blob`**, their character can use `collidesWith()` against any other Blob.  This is the payoff for the one-word decision back in Lesson 2, and it is worth naming so `extends` feels like it earned its keep.
  Leave the word *inheritance* out.

The flash first:
  `if (player.collidesWith(coin)) { background(255, 220, 50); }`, right after the sky.  It is the smallest possible `if` with the loudest possible result, and every student sees their own `if` work within the first ten minutes.
  Say the shape out loud:  condition in the parentheses, action in the braces, and the action runs only when the condition is true.

The hitbox is the radius from super():
  Circle back to the `30` in their Lesson 2 constructor.  That is the collision circle, and it is separate from how big their art looks.
  A big radius is forgiving; a small one is precise.  Students whose character art drifted far from their radius will get collisions that feel wrong, and this is the fix.

Global scope - say why as well as where:
  `int score = 0;` goes above `setup()`.  "It lives outside `setup()` and `draw()` so every function can see it."
  Students will try to declare it inside `setup()`.  When they do, the variable disappears the instant `setup()` ends.  Show that failure once if you have time -- the error message is hard to read cold.

Let the score race, then fix it:
  Put `score = score + 1;` inside the `if` and let students sit on the coin.  The score climbs about sixty a second.  Ask why before you explain.
  `draw()` asks the question every frame, and the answer is yes for every frame they overlap.  `moveTo()` fixes it by ending the overlap the moment it is counted.
  This is the highest-value few minutes of Day 1.  Students learn that `draw()` keeps asking, and they learn it from their own score.

Displaying text:
  `fill(50); textSize(24); text("Score: " + score, 20, 36);`
  "The `+` here glues text and a number together into one string."  Skip the word *concatenation*.
  Point out that `fill()` has to come **before** `text()`, or the text inherits whatever color the last shape used.  This will bite someone.

Day 2 - a hazard that changes a variable:
  Add the hazard and the `if` that sets `gameOver = true`.  Run it, and let students notice that touching the hazard *looks* like nothing.
  The variable changed, and nothing reads it yet.  That gap is the reason for the `if/else` in `draw()`, so let the room sit in it for a moment before you fill it.

The boolean state variable:
  `if (!gameOver) { playGame(); } else { showGameOver(); }`
  "`!` means NOT -- so `if not gameOver` means `if the game is still going`."
  This is the structural idea of Day 2.  The game has **modes**, a variable remembers which one, and `draw()` picks.  Lesson 7 adds a third mode for winning and builds everything on this shape.

= versus ==:
  Worth thirty explicit seconds, best attached to a score condition like `if (score >= 10)`.  A single `=` **assigns**; a double `==` **asks**.  Write both on the board.
  In Java the compiler will usually catch `if (score = 10)`, which is a mercy, but students need the vocabulary to read the error.

Build it up in stages:
  Day 1:  flash → score variable → score on screen → score changes on contact → coin jumps away.  Day 2:  hazard → boolean → `playGame()` → `if/else` with `showGameOver()`.
  Run after every arrow.  Pasting the whole finished structure at once hides where each piece came from.
-->

## Guided Activity  (~20 min)

<!--
Day 1:
1. Warm-up:  what should happen when you touch the coin?  Take a few answers.
2. Everyone adds the flash `if` right after `background()`.  Run.  Everyone touches their coin.  Let the room react.
3. Anyone whose collisions feel wrong:  open `MyCharacter` and tune the radius in `super(...)`.
4. Replace the flash with the score:  the global variable, then the `text()` lines.  Run.  `Score: 0` appears.
5. **Test by cheating:**  `int score = 7;`, run, set it back.  Testing a display by hand-setting the value is a real technique and worth naming.
6. Add `score = score + 1;` inside the collision `if`.  Let them sit on the coin.  Ask why the score races before you explain it.
7. Add `moveTo()`.  One touch, one point.
8. Release for personalization:  coin speed and size, score styling, a second coin worth five.

Day 2:
1. Warm-up:  a game where touching the wrong thing ends it.  If anyone missed Day 1, they paste in the Day 1 checkpoint now.
2. Add the hazard and the `gameOver` boolean together.  Add the hazard `if`.  Run.  Touching it seems to do nothing.  Ask why.
3. Refactor together:  move the game code from `draw()` into `playGame()`.  Run -- nothing should change.  Say it plainly:  a refactor that changes nothing visible is a *success*.
4. Add the `if/else` in `draw()` and write `showGameOver()`.  Run and touch the hazard.
5. **Test the other branch by cheating:**  set `gameOver = true` in the declaration and run.  Straight to the game over screen.  Set it back.
6. Release for personalization:  a second hazard, a restyled game over screen, lives for the fast finishers.
-->

## Build It Step by Step

Day 1 - touch the coin, score a point:
1. Open your Lesson 5 sketch.
2. In `draw()`, right after your `background()` line, add `if (player.collidesWith(coin)) { background(255, 220, 50); }`.  Run it and touch the coin.  The sky flashes gold while you touch it.
3. If touching feels too hard or too easy, open your `MyCharacter` tab and change the radius in the `super(...)` line.
4. Delete the flash.  At the very top of your sketch, add `int score = 0;`
5. At the bottom of `draw()`, add the three lines that show the score:  `fill(50);`, `textSize(24);`, and `text("Score: " + score, 20, 36);`.  Run it.  You should see `Score: 0` in the corner.
6. Test it by cheating:  change `int score = 0;` to `int score = 7;` and run.  The display should change.  Set it back to 0.
7. Above the score lines, add the collision `if` again, this time with `score = score + 1;` inside it.  Run it and sit on the coin.  Watch the score.  Why is it doing that?
8. Add `coin.moveTo(random(width), random(100, height - 150));` inside the same `if`.  Run it.  One touch, one point.
9. Make it yours:  change the coin's speed and size, and style the score so it fits your world.

Day 2 - a game that can end:
1. Open your Day 1 sketch.  (If it is broken, paste in the Day 1 checkpoint below and keep your own `MyCharacter` and `Cloud` tabs.)
2. Declare `Blob hazard;` at the top.  In `setup()`, create it in a corner, away from your player:  `hazard = new Blob(this, 80, 80, 22, 3, 2, color(220, 60, 60));`.  Move and draw it in `draw()`.
3. At the top, add `boolean gameOver = false;`
4. Add `if (player.collidesWith(hazard)) { gameOver = true; }`.  Run it and touch the hazard.  Nothing seems to happen.  The variable changed -- and nothing in your sketch reads it yet.
5. Make a new function called `playGame()` below `draw()`.  Move your coin, hazard, player, both collision `if`s, and the score display into it.  In `draw()`, after the scenery, call `playGame();`.  Run it.  Nothing should look different, and that means it worked.
6. Write a `showGameOver()` function.  Copy it from the starter code below.
7. In `draw()`, replace `playGame();` with the `if (!gameOver) { playGame(); } else { showGameOver(); }` block.  Run it and touch the hazard.  Game over.
8. Test the other branch by cheating:  change `boolean gameOver = false;` to `true` and run.  You should land straight on the game over screen.  Set it back.
9. Make it yours:  rewrite the game over screen so it sounds like your game, tune the hazard, and add a second one if you want a harder game.

## Starter Code

**Day 1 checkpoint - main sketch tab (keep your MyCharacter and Cloud tabs):**
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

**Day 2 - main sketch tab, the full lesson (keep your MyCharacter and Cloud tabs):**
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

## Make It Yours

- Add a second hazard, `hazard2`, with its own `if`.  Give it a different speed or size.
- Add a second coin, `coin2`, that is worth more:  `score = score + 5;`
- Change what ends the game.  A hazard?  Reaching a score of 20?  Both?
- Restyle the game over screen -- different words, different colors, a message that fits your game.
- Make the background change as the score goes up -- a few `if` statements stacked up, one for each score.

**Finished early?**  Give the player lives.  Start with `int lives = 3;`.  When the hazard hits, take one away and move the hazard somewhere else (exactly like the coin).  Only set `gameOver` to `true` when `lives` reaches 0.  Show the lives on screen next to the score.

## Wrap-Up  (~5 min)

<!--
Exit question:  **Day 1:**  why did the score race upward before you added `moveTo()`?  **Day 2:**  what is the difference between an `int` and a `boolean`?  Give an example of each from your own game.
Looking for:  **Day 1:**  `draw()` asks the question every frame, and the answer is yes for every frame the two overlap, so one touch scored many points.  `moveTo()` ends the overlap the moment it is counted.  **Day 2:**  an `int` holds a whole number (score, lives); a `boolean` holds only true or false (gameOver).  Look for examples from their own sketch.
-->

## Teacher Notes

<!--
Common mistakes:
  - **The racing score** -- the collision `if` adds a point every frame because nothing ends the overlap.  It is the Day 1 lesson.  `moveTo()` fixes it.
  - **Putting the collision `if` in `setup()`.**  It is checked once, before anything moves, and never again.
  - **Declaring `score` or `gameOver` inside `setup()`.**  Scope error.  The most common structural mistake in this lesson.
  - **`=` instead of `==`** in a condition.
  - **`fill()` after `text()`** -- text comes out in an unexpected color.
  - **`textAlign(CENTER, CENTER)` never reset.**  It affects every later `text()` call.  The starter resets it with `textAlign(LEFT, BASELINE)` at the end of `showGameOver()` -- make sure students who restyle that function keep the reset.
  - **A hazard created on top of the player**, so the game ends the instant it starts.  The starter puts the hazard in a corner for exactly this reason.
  - **Scenery moved into `playGame()`** during the refactor, so the world vanishes behind the game over screen.  Harmless, and worth asking the student whether that is what they want.
  - Collisions that never fire because the character's radius is tiny compared to the art.
  - Forgetting the braces on a one-line `if` and then adding a second line later that runs every frame.

Notes:
  - This lesson replaces the old Lesson 6 (If This, Then That) and Lesson 7 (Collisions!).  The old Lesson 6 taught `if` with a score that nothing could change, so the starter did nothing visible when it ran.  Here every `if` has a collision to be about from the first ten minutes.
  - Two days, one new idea.  `if` is the concept.  `collidesWith()`, `int`, `boolean`, and `text()` are the supporting cast.  If a student is struggling, drop the `playGame()` refactor and get an `if/else` working directly in `draw()`.
  - The Day 1 checkpoint is on the page for anyone who missed Day 1 or whose sketch is broken when Day 2 starts.  Paste it in, keep their own `MyCharacter` and `Cloud` tabs, and they are caught up.
  - `score++` is shorthand for `score = score + 1`.  Fine to mention if a student asks, but keep `score = score + 1` in the starter, so students can see the operation written out.
  - The "test by cheating" move (hand-setting a variable to check a branch) is a genuine debugging skill.  Name it while you use it.
  - Radius tuning is a real design decision.  Frame it that way:  "do you want your game generous or precise?"
  - Fast finishers:  lives, a second hazard, a coin worth five.  Students who ask for *lots* of coins are ready for Bonus Lesson D.
  - This is the lesson where the moving picture becomes a **game**.  Expect energy, and leave time to play.
-->

---

## Rubric - Collisions:  If This, Then That

*Use this rubric to see where you are and choose what to try next.  You can always revise and run it again.*

**✅ Check yourself first -- I can…**
- [ ] Use `collidesWith()` inside an `if`.
- [ ] Keep a score with an `int` and show it with `text()`.
- [ ] Use a `boolean` and an `if/else` to switch between playing and game over.
- [ ] Explain why the coin has to jump away when it is collected.

**Where am I?**  *Standard:  Use `collidesWith()` inside `if` statements to trigger game events, track the score with a variable shown by `text()`, and use a `boolean` to switch between playing and game over.*

| Level | What it looks like |
|---|---|
| **Getting Started** | Collisions are not registering, my score will not show, or it races up too fast.  **Next step:**  put the `if (player.collidesWith(coin))` check inside `draw()` (or `playGame()`), declare `score` at the **top** of the sketch, and move the coin away with `moveTo()` the moment it is collected. |
| **Got It Working** | Touching the coin scores one point and the coin jumps away.  The score shows on screen.  Touching the hazard switches to a game over screen. |
| **Made It Mine** ⭐ | …and I made the rules mine -- a second hazard, a coin worth more, a different way for the game to end, or a game over screen that sounds like my game. |
| **Went Beyond** | …and I layered rules of my own on top:  lives that count down, a background that changes with the score, or another idea of mine that makes the game react. |

⭐ **Made It Mine** is the goal for everyone this lesson.

*"Went Beyond" means taking the project further in a direction you choose.  The examples are starting points.*

**✍️ Show your thinking:**  In one or two sentences:  what happens in your game when the player touches something -- and why does the coin have to jump away?
