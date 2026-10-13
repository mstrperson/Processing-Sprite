# Bonus Lesson D - Lists and Loops

> **When to use this lesson:**  Any time after Lesson 6.  It lands best during Lesson 7, for the student who has three copy-pasted coins and wants thirty.  One period, standalone.  The main lessons are complete without it.

> **Timing:**  One period (~50 min), for students who are ready for it  
> **New idea:**  Lists and loops -- handling many things at once  
> **Builds on:**  Lesson 6 -- collisions, a score, and `gameOver`.

## Learning Goals
- Store many objects in an `ArrayList`
- Use a **counting** `for` loop to create a lot of things at once
- Use a **for-each** loop to visit every thing in a list
- Remove things from a list safely with the **backwards** loop

## New Vocabulary
- **`ArrayList`** -- a list that holds many objects of the same type.  It grows as you add more
- **counting `for` loop** -- repeats a block a set number of times.  Used to **create** things
- **for-each loop** -- visits every item already in a list, one at a time.  Used to **visit** things
- **index** -- an item's position in a list.  Lists start counting at **0**, so the first item is at index 0
- **`size()`** -- how many items are in the list right now

## Warm-Up  (~5 min)

Look at your Lesson 6 or Lesson 7 sketch.  Adding one more coin the way you have been doing it takes how many lines?  Now multiply by twenty.

## How It Works

### Why you need a list

You already know the long way.  Each coin is a variable, a `new Blob(...)` line, a `move()`, a `drawSprite()`, and an `if`.  Twenty coins is a hundred lines, and every one of them is a chance to type `coin13` where you meant `coin14`.

A list fixes that.  Think of it as a **bag** -- you keep stuffing things in, and it holds as many as you give it.

*Three things you do with a list*
```java
ArrayList<Blob> coins;                 // 1. declare it (what kind of bag)
coins = new ArrayList<Blob>();         // 2. create it (get an empty bag)
coins.add(new Blob(...));              // 3. add to it (put something in)
```

### Two loops that both say "for"

Java uses the same word, `for`, for two loops that feel completely different.  Keeping them straight is the real skill in this lesson.

### The counting loop - for CREATING

This one counts.  `i` starts at 0, and the loop repeats until `i` reaches 12.  You use it in `setup()` to fill the bag.

- `int i = 0` -- start counting at zero
- `i < 12` -- keep going while i is under 12
- `i++` -- add one to i each time around

*"Do this 12 times"*
```java
for (int i = 0; i < 12; i++) {
  coins.add(new Blob(this, random(width), random(height), 12, color(255, 220, 50)));
}
```

### The for-each loop - for VISITING

This one walks the list and hands you one item at a time.  You use it in `draw()` to move and draw everything.

*"For each coin c in the list, do this"*
```java
for (Blob c : coins) {
  c.move();
  c.drawSprite();
}
```

### You cannot call a method on the whole bag

This is the mistake almost everyone makes at least once:

- The bag is a bag.  You have to reach in and ask each coin to draw itself.

*Wrong, then right*
```java
coins.drawSprite();     // WRONG - the list itself doesn't know how to draw

for (Blob c : coins) {  // RIGHT - draw each coin inside the list
  c.drawSprite();
}
```

### The problem with removing things while looping

With a list, collecting a coin means taking it **out** of the list.  But removing something from a list *while you are walking through that list* causes a real problem.

Picture five coins in a row.  You are standing on coin 2 and you remove it.  Every coin after it shifts back one place to fill the gap.  Then the loop moves you forward to position 3… but the coin that *was* at 3 is now at 2, behind you.  **You just skipped it.**

### The fix:  walk backwards

If you walk from the **end** toward the front, removing something only shifts items you have already passed.  Every coin gets its turn.

You do not need to memorize why.  Recognize it as "the safe way to remove things while looping" and copy it when you need it.

- `coins.size()` is how many are in the list.  `- 1` because the last index is one less than the count.
- `i--` counts **down** instead of up.
- `coins.get(i)` reaches into the list and hands you the item at that position.

*The safe removal loop*
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

### When the list runs out

`coins.size()` shrinks every time you collect one.  When it hits zero the board is clear, and you get to decide what that means.  The starter sends a new wave:

- Or set `playerWon = true;` and end the game.  Your call.

*An empty list means you got them all*
```java
if (coins.size() == 0) {
  for (int i = 0; i < 12; i++) {
    coins.add(new Blob(...));   // a fresh wave
  }
}
```

## Direct Instruction  (~10 min)

<!--
Why this is a bonus lesson now:
  `ArrayList` used to be the main-thread Lesson 5, with the backwards removal loop in Lesson 7.  It was too much for most sixth graders:  a generic type, two loop forms that share a keyword, and a removal pattern they could only copy.  It moved here so the students who take it have already felt the need.
  Students arrive at this lesson with three copy-pasted coins in their own game.  That is the motivation.  Use it.

Motivate the list with their own code:
  Put a student's capstone on the projector (with permission) and point at `coin1`, `coin2`, `coin3`.  Ask what twenty would take.  Let the tedium land before you offer the fix.

ArrayList in three moves:
  "A list is like a bag -- you can keep stuffing things in."
  Declare, create, add.  Show all three on the projector as three separate lines before combining them.
  Skip generics.  `<Blob>` is "what kind of bag this is."  That is enough.

The two for loops - make this distinction explicit:
  **Counting loop** (in `setup()`, to CREATE):  `for (int i = 0; i < 12; i++)`.  "`i` counts from 0 to 11 -- we use it to repeat the add 12 times."
  **For-each loop** (in `draw()`, to VISIT):  `for (Blob c : coins)`.  "For each coin `c` in the list, move it and draw it."
  Both use the word `for`, and in a broad sense both are count-controlled, but they *feel* different:  **one counts, one visits.**  Students mix them up constantly.  Say the distinction out loud more than once, and use the words "create" and "visit" consistently.

Show the classic mistake on purpose:
  Write `coins.drawSprite();` on the projector and run it.  The compiler rejects it.
  "The bag is a bag.  You have to ask each coin."  Then fix it with the loop.  Seeing the error once beats a warning.

Show the removal bug before the fix:
  Run a **forward** loop with a `remove()` inside it on the projector.  Collect coins and let students watch items get skipped.
  Once students have watched coins get skipped, the backwards loop is the answer to a problem they saw happen.  Students do **not** need to derive it.  Teach it as "the safe loop for removing things" -- a pattern they can recognize and copy.

for (int i = coins.size() - 1; i >= 0; i--) {
  Blob c = coins.get(i);
  if (player.collidesWith(c)) {
    coins.remove(i);
    score = score + 1;
  }
}
-->

## Guided Activity  (~20 min)

<!--
1. Put `coin1`, `coin2`, `coin3` on the board.  Ask what happens at twenty.  Wait for the groan.
2. Declare and create the list together.  Run -- nothing changes, because the list is empty.  Name that.
3. Add the counting loop in `setup()` together.  Run -- still nothing on screen.  Ask why.  (They exist, and nothing draws them.)
4. Add the for-each loop.  Run.  The world fills.  That two-step reveal is worth the extra minute.
5. As a class, change `12` to `40`, then to `3`.
6. Swap the for-each for the backwards loop with no collision.  Run.  Nothing changes.
7. Show the forward-loop removal bug on the projector, then add the backwards loop's collision check.  Everyone collects.
8. Add the empty-list wave.  Release for personalization, or for converting their capstone.
-->

## Build It Step by Step

1. Open your Lesson 6 sketch.  (Working on your Lesson 7 game?  Save a copy first, then do this lesson on the copy.)
2. At the top, replace `Blob coin;` with `ArrayList<Blob> coins;`
3. In `setup()`, replace the line that creates your coin with `coins = new ArrayList<Blob>();` and the counting loop from the starter.  Run it.  Nothing new shows up yet -- you made the coins and nothing draws them.
4. Where you used to move and draw your coin, add a **for-each** loop that moves and draws each coin.  Delete your old coin's collision `if` for now.  Run it.  Now the world is full.
5. Change the `12` in the counting loop to `40`.  Run.  Then try `3`.  How many feels right?
6. Now **replace** the for-each loop with the backwards loop from the starter, with no collision check yet.  Run it.  Nothing should look different -- the two loops are equivalent until you remove something.
7. Inside the backwards loop, add the `if (player.collidesWith(c))` check with `coins.remove(i);` and `score = score + 1;` inside it.  Run it and collect a few.
8. Add the `if (coins.size() == 0)` check that sends a new wave.  Clear the board and watch it refill.
9. Add a `mousePressed()` that adds a coin wherever you click.
10. Try a second list:  `ArrayList<Blob> hazards;`, filled with a counting loop and visited with a **for-each** loop.  You are not removing hazards, so the backwards loop is unnecessary here.

## Starter Code

**Main sketch tab (keep your MyCharacter tab):**
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

## Make It Yours

- Change how many coins are in a wave, how big they are, and how fast.
- Make each wave bigger than the last -- a variable that counts waves, used in the counting loop.
- Turn your hazards into a list, and add one more hazard every time a wave clears.
- Put lists into your Lesson 7 game.  Convert your coins and keep the rest as it is.
- Make collected coins **split** into two smaller coins added to the list.

**Finished early?**  Use lists in your capstone's `restartGame()`:  `coins = new ArrayList<Blob>();` followed by the counting loop gives you a fresh, full board every restart.  Then make the hazards a list too, and let the number of hazards grow with the score.

## Wrap-Up  (~5 min)

<!--
Exit question:  What is the difference between the counting `for` loop and the for-each loop?  And why do we loop backwards when we remove things?
Looking for:  Counting loop:  repeat something a set number of times -- used to create.  For-each loop:  visit every item already in a list -- used to move and draw.  Backwards:  removing an item shifts everything after it back one, so a forward loop skips the next item, and walking backwards only shifts items you already passed.
-->

## Teacher Notes

<!--
Common mistakes:
  - **`coins.drawSprite()`** -- calling a method on the whole list.  The single most common error in this lesson.
  - **Creating the list but never looping over it in `draw()`.**  The objects exist and are invisible.  Students think the `add` failed.
  - **Forgetting `coins = new ArrayList<Blob>();`** -- a null pointer exception the moment they call `.add()`.
  - **`ConcurrentModificationException`** -- removing inside a for-each loop.  The crash message is intimidating and means nothing to a sixth grader.  Translate it:  "you changed the list while walking through it."  The backwards loop is the fix.
  - **Off-by-one:**  writing `coins.size()` instead of `coins.size() - 1`, which throws an index-out-of-bounds on the first pass.
  - **`i++` instead of `i--`** in the backwards loop -- the index runs off the end of the list and the sketch crashes.
  - **Putting the counting loop in `draw()`** -- it adds 12 new coins every frame and the sketch grinds to a halt.  Dramatic, and a good demo if it happens.
  - Mixing the two loop forms:  `for (int i = 0; i < coins; i++)` or `for (Blob c : 12)`.  Both come from missing the create/visit distinction.

Notes:
  - Use the word "visit" for the for-each loop all period.  It gives students language for a distinction they can otherwise only feel.
  - The backwards loop is a copy-and-use pattern.  Leave it off any check for understanding, and keep it from becoming the hard part of the lesson.
  - In a capstone, a student can convert only their coins to a list and keep named hazards.  A half-converted game is a fine place to stop.
  - In `restartGame()`, a list resets with `coins = new ArrayList<Blob>();` followed by the counting loop.  It is the same rebuild-from-scratch idea as the rest of `restartGame()`.
  - Fast finishers:  growing waves, a list of hazards that grows with the score, coins that split into smaller coins.
-->

---

## Rubric - Lists and Loops

*Use this rubric to see where you are and choose what to try next.  You can always revise and run it again.*

**✅ Check yourself first -- I can…**
- [ ] Declare and create an `ArrayList`.
- [ ] Use a **counting** `for` loop to make many objects.
- [ ] Use a **for-each** loop to visit each one.
- [ ] Remove items from a list with the backwards loop, and explain why it walks backwards.

**Where am I?**  *Standard:  Store many objects in an `ArrayList`, create them with a counting loop, visit them with a for-each loop, and remove them safely with the backwards loop.*

| Level | What it looks like |
|---|---|
| **Getting Started** | My list of coins is not appearing, or collecting one crashes the sketch.  **Next step:**  **create** things with a counting loop in `setup()` and **draw** them with a loop in `draw()`, calling `drawSprite()` on each item `c` and leaving the list itself alone.  If collecting crashes, switch to the backwards loop (`for (int i = coins.size()-1; i >= 0; i--)`). |
| **Got It Working** | Many coins appear and move.  Collecting one removes it from the list without errors, and something happens when the list is empty. |
| **Made It Mine** ⭐ | …and I tuned it -- bigger waves, a second list of hazards, coins spawned on click, or a list working inside my Lesson 7 game. |
| **Went Beyond** | …and I used lists to make the game change as it goes:  waves that grow, hazards that multiply, coins that split, or another idea of my own. |

⭐ **Made It Mine** is the goal for everyone this lesson.

*"Went Beyond" means taking the project further in a direction you choose.  The examples are starting points.*

**✍️ Show your thinking:**  In one or two sentences:  when do you use a **counting** loop and when do you use a **for-each** loop -- and why does the removal loop walk backwards?
