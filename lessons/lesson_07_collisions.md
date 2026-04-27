# Lesson 7 — Collisions!

## Learning Goals
- Use `.collidesWith()` to detect when the player touches another blob
- Combine `if` with collision to trigger game events (collecting, scoring, losing)
- Remove items from an `ArrayList` safely using the backwards index loop
- Connect the collision system to the score and game state from Lesson 6

## New Vocabulary
- **collision** — when two sprites overlap on screen
- **`.collidesWith(blob)`** — a method on Blob that returns `true` when this sprite's circle overlaps another blob's circle
- **index** — the position of an item in a list, starting from 0

## Warm-Up  (~5 min)

<!-- Review: "What does an if statement do? What is a boolean?" -->

## Direct Instruction  (~10 min)

<!--
Key things to demonstrate:

collidesWith:
  "The library checks whether the two circles overlap — it returns true or false"
  if (player.collidesWith(someCoin)) { ... }
  "Because MyCharacter extends Blob, it can use collidesWith against any other Blob"

Removing while looping — the backwards loop:
  for (int i = coins.size() - 1; i >= 0; i--) {
    Blob c = coins.get(i);
    if (player.collidesWith(c)) {
      coins.remove(i);
      score = score + 1;
    }
  }
  Explain WHY backwards: "If you walk forward through a list and remove something,
  you skip the item right after it. Walking backwards avoids that problem."
  Students do NOT need to memorize this — just recognize it as "the safe way to
  remove things while looping."

Show the bug version (forward loop + remove) so students can see the skipping artifact.
-->

## Guided Activity  (~20 min)

<!-- Step-by-step instructions go here -->
<!-- Replace the for-each coin loop from Lesson 6 with the backwards index loop -->
<!-- Add the collidesWith check inside it -->

## Starter Code

**Main sketch tab (builds directly on Lesson 6):**
```java
// Lesson 7 — Collisions!
import coxprogramming.processing.sprites.*;

MyCharacter player;
ArrayList<Blob> coins;
int score = 0;
boolean gameOver = false;

void setup() {
  size(800, 600);
  player = new MyCharacter(this, width/2, height/2);
  player.setVelocity(4, 0);

  coins = new ArrayList<Blob>();
  for (int i = 0; i < 12; i++) {
    coins.add(new Blob(
      this, random(width), random(height),
      random(8, 18), random(-2, 2), random(-2, 2),
      color(255, 220, 50)
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
  // Backwards loop — safe to remove coins while iterating
  for (int i = coins.size() - 1; i >= 0; i--) {
    Blob c = coins.get(i);
    c.move();
    c.drawSprite();

    if (player.collidesWith(c)) {
      coins.remove(i);   // collect the coin
      score = score + 1; // increase the score
    }
  }

  player.followMouse();
  player.drawSprite();

  // Win when all coins are collected
  if (coins.size() == 0) {
    gameOver = true;
  }

  fill(50);
  textSize(24);
  text("Score: " + score, 20, 36);
}

void showGameOver() {
  fill(80, 180, 80);
  textAlign(CENTER, CENTER);
  textSize(52);
  text("You Win!", width/2, height/2 - 20);
  textSize(22);
  text("Final score: " + score, width/2, height/2 + 26);
  textAlign(LEFT, TOP);
}
```

## Make It Yours  (~10 min)

- Add a second ArrayList of *obstacles* (red blobs) that the player must dodge
  — touching one decreases lives or triggers game over
- Add more coins when the player collects a certain number (`coins.add(...)` after removing)
- Change what the "win" condition is
- Make collected coins explode into smaller blobs

## Wrap-Up  (~5 min)

<!-- Exit question: "Why do we loop backwards when removing items from a list?" -->

## Teacher Notes

<!-- collidesWith works because MyCharacter extends Blob — the radius set in super() in -->
<!-- MyCharacter's constructor is the hitbox size. Remind students that a big radius = more -->
<!-- forgiving collisions; small radius = more precise -->
<!-- The backwards loop pattern: students don't need to understand it deeply. Teach it as -->
<!-- "the magic safe loop for removing things" that they can copy and use -->
<!-- Fast finishers: can they add a "dodge" mechanic — a second ArrayList of red enemies that -->
<!-- the player must not touch? This naturally sets up Lesson 9 -->
