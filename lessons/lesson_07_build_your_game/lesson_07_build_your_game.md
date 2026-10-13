# Lesson 7 - Build Your Game

> **Timing:**  Three periods:  two to build, one to play-test and present.  
> **New idea:**  Restarting -- and putting all seven lessons together  
> **Builds on:**  Everything.  Lessons 1 through 6, all at once.

## Learning Goals
- Combine everything you have learned into a complete, playable game with your character in it
- Add a restart so the game can be played again without closing it
- Make your own design decisions about difficulty, theme, rules, and how it ends
- Go through the real cycle:  build, test, adjust, test again

## New Vocabulary
- **game loop** -- `draw()` running over and over is the engine of every game you have ever played
- **win / lose condition** -- the rules that decide when the game ends, and how
- **restart** -- putting every variable back to its starting value so the game can be played again
- **play-testing** -- actually playing your own game to find out whether it is fun, then changing it

## Warm-Up  (~5 min)

Write one sentence describing your game.  Who is your character?  What are they collecting, and what are they avoiding?  Two minutes, before any code.

## How It Works

### You already know all of this

Look at the starter code below.  There is exactly **one** thing in it you have not seen before.  Everything else you have already built:

- `setup()` and `draw()` -- Lesson 1
- `MyCharacter extends Blob` -- Lesson 2
- `setVelocity()` and `move()` -- Lesson 3
- `followMouse()` and `keyboardControl()` -- Lesson 4
- `Block`, `Cloud`, and draw order -- Lesson 5
- `collidesWith()`, `if`, `score`, and `gameOver` -- Lesson 6

### The one new idea:  restartGame()

To restart a game, you might think you need to undo everything that happened.  That is much harder than it sounds, and it is easy to miss something.

Instead, you just **run the starting steps again**:  make a new player, make new coins and hazards, set the score back to 0, and set the flags back to false.

- Notice that `setup()` builds the scenery and then just calls `restartGame()`.  Starting the game and restarting it are **the same thing**, so they are the same code.
- The ground and the clouds are built once, in `setup()`, because nothing in the game ever changes them.

*Reset by rebuilding*
```java
void restartGame() {
  score = 0;
  gameOver = false;
  playerWon = false;

  player = new MyCharacter(this, width/2, height/2);
  player.setVelocity(4, 0);

  coin1 = new Blob(...);     // brand-new coins
  hazard1 = new Blob(...);   // and brand-new hazards
}
```

### Now there are three states

Lesson 6 had two states:  playing and game over.  A real game usually has three -- because winning and losing should look different.

- `&&` means **AND**.  So `!gameOver && !playerWon` reads:  "not lost, and not won" -- in other words, still playing.
- You win when `score >= goal`.  Change the `goal` variable at the top to make the game longer or shorter.

*Picking which screen to show*
```java
if (!gameOver && !playerWon) {
  playGame();
} else if (playerWon) {
  showWin();
} else {
  showGameOver();
}
```

### Clicking to play again

`mousePressed()` from Lesson 4 is an event function.  Put the restart inside it, and guard it with an `if` so a click during play leaves your game alone.

- `||` means **OR**.  "If we lost or we won, start over."

*Only restart when it is over*
```java
void mousePressed() {
  if (gameOver || playerWon) {
    restartGame();
  }
}
```

### Three coins, three ifs

The starter has three coins and two hazards.  Each one has its own variable and its own `if`.  Yes, that is repetitive.  It is also code you can read top to bottom and change one piece at a time.

Want a fourth coin?  Declare `coin4`, create it in `restartGame()`, move and draw it in `playGame()`, and give it an `if`.  Check every name in the copied lines -- `coin4` has to say `coin4` everywhere.

Want twenty coins?  That is what Bonus Lesson D is for.

### The starter code is just a skeleton

The plain colored blobs in the starter are **placeholders**.  They are there so the code runs.  Your game gets to look however you want.

Replace them with things that make sense in your world.  That is the assignment itself.

## Direct Instruction  (~10 min)

<!--
Walk the structure - every piece should be familiar:
  Put the starter on the projector and name each function and where it came from.  `setup()`, `draw()`, `playGame()`, `showWin()`, `showGameOver()`, `restartGame()`, `mousePressed()`.
  The point of this walkthrough is confidence:  they have written all of this before.  There is exactly one new function today.

restartGame() - the real lesson here:
  "To restart, we just run the same starting steps again -- create a new player, new coins, new hazards, and put score and the flags back to their starting values."
  Point out that `setup()` builds the scenery and then calls `restartGame()`.  Starting and restarting are the same operation, so they are the same code.  The scenery lives in `setup()` alone because play never changes it -- a useful question to ask the room before you say it.
  **This is the most important structural idea in the capstone**:  reset state by re-running the initialization logic.  Undoing individual changes is the trap.  It is a real software engineering principle and they can absolutely feel why it is better.

Three states and the new operators:
  `playerWon` joins `gameOver`, so `draw()` now picks between three screens.
  `&&` (AND) and `||` (OR) show up here for the first time.  Introduce them in plain language right when you hit them:  "not lost AND not won means still playing."

Name the repetition, and own it:
  Three coins means three `if` blocks.  Say so before a student does:  it is repetitive, it is readable, and every piece can be changed on its own.  Three similar blocks is the right tool for a sixth grader building a first game.
  A student who wants twenty coins has found a real reason for a list.  Hand them Bonus Lesson D.  They can convert their coins and leave the hazards as named variables -- a half-converted game runs fine.

Say plainly that the starter is a skeleton:
  Emphasise this hard:  **students SHOULD change everything.**  The blob coins and hazards are placeholders.  Replacing them with something that makes sense in their world is the assignment itself.
  Some students will treat the starter as sacred and only change colors.  Head that off in the first five minutes.

Frame the build order:
  Tell them explicitly:  get **one full loop** working first (player, coins, one end condition) and only then build outward.
  The students who struggle in this capstone are almost always the ones who tried to add five features before the first one played correctly.
-->

## Guided Activity  (~20 min)

<!--
Day 1 - one full loop:
1. Two minutes of writing:  a one-sentence game description.  Do this before any code.  Students who can say what their game is build much better games.
2. Run the starter together and identify each piece out loud.
3. Play until you lose, then click to restart, as a class.  Confirm the loop works before anyone changes anything.
4. Everyone brings in their own `MyCharacter` tab and their Lesson 5 world, and replaces the placeholder coin with something themed.  One quick win, immediately.
5. Release to build.  Circulate constantly.  The main intervention you will make all period is "get one thing working before you add the next thing."

Day 2 - make it theirs:
1. Open with five minutes of play-testing with a neighbor.  Watching someone else play your game, hands off the keyboard, is the fastest way to find out what is broken.
2. Release to build.  Push every student toward one thing the lesson did not ask for.  Bonus Lessons A, B, C, and D all land well today for students who want them.

Day 3 - play-test and present:
1. Half the period for final fixes, driven by what play-testers found.
2. Demo day.  Every student plays a neighbor's game and names one thing they liked and one thing they would add.
-->

## Build It Step by Step

1. Write your one-sentence game description first.  What is it about?  Do this before touching code.
2. Start from your Lesson 6 sketch, or paste in the starter below -- whichever is closer to what you want.  Either way, bring your own `MyCharacter` tab and your world from Lesson 5.
3. Run it and find each piece:  `setup`, `draw`, `playGame`, `showWin`, `showGameOver`, `restartGame`, `mousePressed`.  Say out loud what each one does.
4. Play it until you lose, then click to restart.  Make sure that works before you change anything.
5. **Get one full loop working first.**  Player, coins, and one win or lose condition.  Get that playing properly before you add anything else.
6. Now replace the placeholders.  Your character, your collectibles, your hazards, your world.
7. Rewrite the win and lose screens in your own words.  "YOU WIN!" is the starter talking.  Make it sound like you.
8. Tune the difficulty.  Play it.  Too easy?  Faster hazards, or a higher `goal`.  Too hard?  Slower hazards, or make your hitbox bigger.
9. Add one thing the lesson did not ask for.  A second mechanic, an ability, lives, a level.  Something that is your idea.
10. Play-test with a neighbor.  Watch them play and keep your hands off the keyboard.  Whatever confuses them is a real problem -- go fix it.

## Starter Code

**Main sketch tab (keep your MyCharacter and Cloud tabs):**
```java
// Lesson 7 - Build Your Game.  Replace everything marked CHANGE with your own choices!
import coxprogramming.processing.sprites.*;

MyCharacter player;
Cloud cloud1;
Cloud cloud2;
Block ground;

Blob coin1;      // things to collect
Blob coin2;
Blob coin3;
Blob hazard1;    // things to avoid
Blob hazard2;

int score = 0;
int goal = 15;               // CHANGE: the score you need to win
boolean gameOver = false;
boolean playerWon = false;

void setup() {
  size(800, 600);

  // Scenery never changes during play, so it is built once, here.
  ground = new Block(this, 0, height - 70, width, 70, color(80, 160, 60));  // CHANGE: your ground
  cloud1 = new Cloud(this, 150, 90, 0.5);
  cloud2 = new Cloud(this, 520, 60, 0.8);

  restartGame();
}

void draw() {
  background(135, 206, 235);  // CHANGE: your sky / background color

  cloud1.move();
  cloud1.drawSprite();
  cloud2.move();
  cloud2.drawSprite();

  ground.drawSprite();

  if (!gameOver && !playerWon) {
    playGame();
  } else if (playerWon) {
    showWin();
  } else {
    showGameOver();
  }
}

void playGame() {
  // --- Collectibles ---
  coin1.move();
  coin1.drawSprite();
  coin2.move();
  coin2.drawSprite();
  coin3.move();
  coin3.drawSprite();

  // --- Hazards ---
  hazard1.move();
  hazard1.drawSprite();
  hazard2.move();
  hazard2.drawSprite();

  // --- Player ---
  player.followMouse();  // or keyboardControl() in keyPressed()
  player.drawSprite();

  // --- Collecting:  score a point, and the coin jumps somewhere new ---
  if (player.collidesWith(coin1)) {
    score = score + 1;
    coin1.moveTo(random(width), random(80, height - 150));
  }
  if (player.collidesWith(coin2)) {
    score = score + 1;
    coin2.moveTo(random(width), random(80, height - 150));
  }
  if (player.collidesWith(coin3)) {
    score = score + 1;
    coin3.moveTo(random(width), random(80, height - 150));
  }

  // --- Lose condition ---
  if (player.collidesWith(hazard1)) {
    gameOver = true;
  }
  if (player.collidesWith(hazard2)) {
    gameOver = true;
  }

  // --- Win condition ---
  if (score >= goal) {
    playerWon = true;
  }

  // --- Score display ---
  fill(50);
  textSize(22);
  text("Score: " + score + " / " + goal, 20, 32);
}

void showWin() {
  textAlign(CENTER, CENTER);
  fill(80, 200, 100);
  textSize(54);
  text("YOU WIN!", width/2, height/2 - 30);
  fill(50);
  textSize(22);
  text("Score: " + score, width/2, height/2 + 18);
  text("Click to play again", width/2, height/2 + 52);
  textAlign(LEFT, BASELINE);
}

void showGameOver() {
  textAlign(CENTER, CENTER);
  fill(220, 60, 60);
  textSize(54);
  text("GAME OVER", width/2, height/2 - 30);
  fill(50);
  textSize(22);
  text("Score: " + score, width/2, height/2 + 18);
  text("Click to play again", width/2, height/2 + 52);
  textAlign(LEFT, BASELINE);
}

void mousePressed() {
  if (gameOver || playerWon) {
    restartGame();
  }
}

void restartGame() {
  score = 0;
  gameOver = false;
  playerWon = false;

  // CHANGE: your player's starting position
  player = new MyCharacter(this, width/2, height/2);
  player.setVelocity(4, 0);

  // Collectibles - CHANGE: color, size, speed
  coin1 = new Blob(this, random(width), random(80, height - 150), 14, random(1, 2.5), random(-1.5, 1.5), color(255, 220, 50));
  coin2 = new Blob(this, random(width), random(80, height - 150), 14, random(1, 2.5), random(-1.5, 1.5), color(255, 220, 50));
  coin3 = new Blob(this, random(width), random(80, height - 150), 14, random(1, 2.5), random(-1.5, 1.5), color(255, 220, 50));

  // Hazards - CHANGE: color, size, speed.  They start in the top corners, away from the player.
  hazard1 = new Blob(this, 80, 80, 22, 3, 2, color(220, 60, 60));
  hazard2 = new Blob(this, width - 80, 80, 22, -2, 3, color(220, 60, 60));
}
```

## Make It Yours

- **Theme it.**  Replace every placeholder color, name, and shape with your world -- space, ocean, forest, city, dream, whatever it is.
- **Difficulty.**  Make hazards faster as the score climbs.  Give the player 3 lives instead of instant game over.
- **A second mechanic.**  A `keyPressed()` special ability -- a speed burst, a shield, a teleport.
- **Polish.**  A title screen before the game starts.  Better draw order.  Animated decorations.  A high score that survives a restart.
- **A custom hazard.**  Write a new `extends Blob` tab for an enemy with its own look -- a shark, a storm cloud, a meteor.

**Finished early?**  Add a second level.  When the player wins, instead of stopping, rebuild the world harder (faster hazards, a different background, a higher goal) and keep the score.  That is `restartGame()` with a level number, and it turns a demo into a game people want to keep playing.

## Wrap-Up  (~5 min)

<!--
Exit question:  Play a neighbor's game.  Tell them one thing you liked and one thing you would add.
Looking for:  For the final share-out you want each student to be able to name their game in a sentence and point at one decision they made on purpose.  That is the real evidence of the capstone.
-->

## Teacher Notes

<!--
Common mistakes:
  - **Adding features before the core loop works.**  The number one cause of a frustrated capstone.  Intervene early and often.
  - **A copied `if` with a stale name.**  A student copies the `coin3` block for `coin4` and misses one name, so `coin4` is drawn and never scores, or `coin3` gets moved twice.  Have them read the copied block out loud, name by name.
  - **`restartGame()` that misses a variable** -- score resets but the hazards stay where they were, or the player stays dead.  Have them check every variable at the top against the reset function, one at a time.
  - **Creation code drifting into `draw()`.**  `coin1 = new Blob(...)` inside `draw()` rebuilds the coin every frame, so it sits frozen at its starting spot.  Creation belongs in `setup()` or `restartGame()`.
  - **Hazards created on top of the player**, so a restart ends instantly.  The starter puts hazards in the top corners for this reason.
  - **`keyboardControl()` coasting**:  velocity stays set after key release, so the player drifts.  If they want it to stop, `keyReleased()` with `setVelocity(0, 0)`.  Fine to introduce if they ask.
  - Difficulty tuned by the person who built it, who is therefore excellent at it.  Almost every student game is too hard.  Play-testing with a neighbor fixes this.

Notes:
  - **Help students finish a playable game they have made their own.**  Get the core game working, then use the remaining time to develop it further.
  - **Three periods:**  Day 1 to get one full loop running in their own world, Day 2 to make it theirs, Day 3 to play-test and present.  The presentation is real work -- an audience changes how much students care.
  - Ask students who finish early to choose something to develop further:  a mechanic, the art, or the sound.  Have them explain the change and test what it adds to the game.
  - The `restartGame()` pattern is the structural takeaway.  If a student remembers one thing from this lesson in a year, that is the one worth remembering.
  - Bonus Lesson C (Animation) drops in beautifully here -- students often want their character to feel alive instead of sliding around as one frozen drawing.  Note that an `AnimatedSprite` is not a `Blob`, so it uses `distanceTo()` instead of `collidesWith()`.
  - Bonus Lessons A (Images) and B (Sounds) also land well during this capstone for students who want polish.  Bonus Lesson D (Lists) is for the student who wants many more coins.
  - Watch for students who will not change the starter.  Sit with them and ask what their game is *about* -- usually they have an idea and did not realize they were allowed to build it.
-->

---

## Rubric - Build Your Game

*Use this rubric to see where you are and choose what to try next.  You can always revise and run it again.*

**✅ Check yourself first -- I can…**
- [ ] Combine movement, control, my world, collisions, and state into one game.
- [ ] Write win **and** lose conditions.
- [ ] Reset the game with `restartGame()`.
- [ ] Make and defend my own design decisions.

**Where am I?**  *Standard:  Combine all prior skills into a complete, playable, replayable mini-game with win/lose conditions and independent design decisions.*

| Level | What it looks like |
|---|---|
| **Getting Started** | The pieces are not coming together into something playable yet.  **Next step:**  get **one** full loop working first (player, coins, and a win or lose check), then build outward.  Use `restartGame()` to reset by **re-running** your starting steps.  Trying to undo everything is way harder. |
| **Got It Working** | A playable game with my character:  collectibles, a win and a lose condition, a score, and a working restart. |
| **Made It Mine** ⭐ | …and the game is unmistakably **mine** (themed world, my own rules and difficulty, my character at the center) with design decisions I made on purpose about how it plays. |
| **Went Beyond** | …and I developed the game further in a direction **I** chose:  a new mechanic, original art or animation, sound that helps the player, or another idea of my own.  I can explain what my choices add to the game. |

⭐ **Made It Mine** is the goal for everyone this lesson.

*"Went Beyond" means taking the project further in a direction you choose.  The examples are starting points.*

**✍️ Show your thinking:**  In two or three sentences:  what is your game about?  What design decision are you proudest of, and what would you add with another week?
