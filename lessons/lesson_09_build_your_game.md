# Lesson 9 — Build Your Game

## Learning Goals
- Combine all prior skills into a complete, playable mini-game featuring their own character
- Add a restart mechanic so the game can be replayed
- Make independent design decisions: difficulty, theme, rules, win/lose conditions
- Experience the full cycle of building → testing → adjusting

## New Vocabulary
- **game loop** — the `draw()` function running over and over is the engine of every game
- **win / lose condition** — the rules that decide when the game ends
- **restart** — resetting all variables and lists back to their starting state so the game can be played again

## Warm-Up  (~5 min)

<!-- Quick discussion: "What is your game about? Who is your character? What do they collect or avoid?" -->
<!-- Give students 2 minutes to write a one-sentence game description before coding starts -->

## Direct Instruction  (~10 min)

<!--
Walk through the starter code structure — every piece should be familiar:
  setup()     → create player, create objects, set initial state
  draw()      → background, decorations, game loop OR game over screen
  playGame()  → move/draw everything, collision checks, score, win/lose check
  showGameOver() / showWin() → final screens
  restartGame() → reset all variables and rebuild lists
  mousePressed() → calls restartGame() when game is over

Key new idea: restartGame()
  "To restart, we just run the same setup steps again — create a new player,
  clear the lists and fill them back up, reset score and gameOver to their
  starting values."

Emphasize: the starter code is a skeleton. Students SHOULD change everything.
The Blob obstacles are placeholders — replace them with something that makes
sense in their world.
-->

## Guided Activity  (~20 min)

<!-- Students run the starter, identify each piece, then begin replacing placeholder -->
<!-- elements with their own sprites, world, and rules -->

## Starter Code

**Main sketch tab (builds on everything from Lessons 2–8):**
```java
// Lesson 9 — Build Your Game
// Replace EVERYTHING in ALL-CAPS with your own choices!
import coxprogramming.processing.sprites.*;

MyCharacter player;
ArrayList<Blob> collectibles;  // things to collect for points
ArrayList<Blob> hazards;       // things to avoid
Block ground;
int score = 0;
boolean gameOver = false;
boolean playerWon = false;

void setup() {
  size(800, 600);
  restartGame();
}

void draw() {
  background(135, 206, 235);  // CHANGE: your sky/background color

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
  for (int i = collectibles.size() - 1; i >= 0; i--) {
    Blob c = collectibles.get(i);
    c.move();
    c.drawSprite();
    if (player.collidesWith(c)) {
      collectibles.remove(i);
      score = score + 1;
    }
  }

  // --- Hazards ---
  for (Blob h : hazards) {
    h.move();
    h.drawSprite();
    if (player.collidesWith(h)) {
      gameOver = true;
    }
  }

  // --- Player ---
  player.followMouse();  // or keyboardControl() in keyPressed()
  player.drawSprite();

  // --- Win condition ---
  if (collectibles.size() == 0) {
    playerWon = true;
  }

  // --- HUD ---
  fill(50);
  textSize(22);
  text("Score: " + score, 20, 32);
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
  textAlign(LEFT, TOP);
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
  textAlign(LEFT, TOP);
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

  // CHANGE: move player to your preferred starting position
  player = new MyCharacter(this, width/2, height - 120);
  player.setVelocity(4, 0);

  // Ground
  ground = new Block(this, 0, height - 70, width, 70, color(80, 160, 60));

  // Collectibles — CHANGE: color, size, count, speed
  collectibles = new ArrayList<Blob>();
  for (int i = 0; i < 10; i++) {
    collectibles.add(new Blob(
      this, random(width), random(100, height - 120),
      random(10, 18), random(-2, 2), random(-1, 1),
      color(255, 220, 50)
    ));
  }

  // Hazards — CHANGE: color, count, speed (make them faster each wave if you want!)
  hazards = new ArrayList<Blob>();
  for (int i = 0; i < 5; i++) {
    hazards.add(new Blob(
      this, random(width), random(100, height - 120),
      random(15, 28), random(-3, 3), random(-3, 3),
      color(220, 60, 60)
    ));
  }
}
```

## Make It Yours  (~Remaining time)

Push further in any of these directions:
- **Theme it**: replace placeholder colors, names, and shapes with your world (space, ocean, forest, city …)
- **Difficulty**: make hazards faster over time; add more when a wave clears; give the player 3 lives
- **Second mechanic**: add a `keyPressed()` special ability — a speed burst, a shield, a projectile
- **Polish**: design a title screen (shown before the game starts), draw order improvements, animated decorations
- **Custom hazard**: write a new `extends Blob` tab for an enemy that behaves differently (chase the player!)

## Wrap-Up

<!-- Final demo day: each student plays a neighbor's game, then one thing they'd add next -->

## Teacher Notes

<!-- This is a capstone — the goal is ownership and completion, not polish or correctness -->
<!-- Students who finish early should be pushed toward a second mechanic (lives, powerup, level 2) -->
<!-- not just cosmetics — the extra complexity is where the real learning happens -->
<!-- Consider splitting into two periods: period 1 = build, period 2 = play-test and present -->
<!-- The restartGame() pattern is the most important structural lesson here: resetting state -->
<!-- by re-running the initialization logic, not by trying to undo individual changes -->
<!-- keyboardControl coasting reminder: velocity stays set after key-release — player coasts. -->
<!-- Students may want to zero velocity on key release; that requires a keyReleased() function -->
<!-- with player.setVelocity(0,0) — fine to introduce if they ask -->

---

## Rubric — Build Your Game (Capstone)

*This isn't a test — it's a map of where you are and what to try next. The goal here is ownership and a game you're proud of — you can keep revising it.*

**✅ Check yourself first — I can…**
- [ ] Combine movement, control, lists, collisions, state, and world into one game.
- [ ] Write win *and* lose conditions.
- [ ] Reset the game with `restartGame()`.
- [ ] Make and defend my own design decisions.

**Where am I?**  *Standard: combine all prior skills into a complete, playable, replayable mini-game with win/lose conditions and independent design decisions.*

| Level | What it looks like |
|---|---|
| **Getting Started** | The pieces aren't coming together into something playable yet. **Next step:** get *one* full loop working first — player + collectibles + a win or lose check — then build outward. Use `restartGame()` to reset by *re-running* your setup steps, not by undoing changes. |
| **Got It Working** | A playable game with my character: collectibles, a win and/or lose condition, a score, and a working restart. |
| **Made It Mine** ⭐ | …and the game is unmistakably *mine* — themed world, my own rules and difficulty, my character at the center — with design decisions I made on purpose about how it plays. |
| **Went Beyond** | …and I pushed the game past the assignment in a direction *I* chose — a second mechanic that genuinely deepens play (lives, an ability, levels, a smart enemy…), a rule nobody handed me, something I invented. The mark of this level is a design call that's mine, not cosmetics. |

⭐ **Made It Mine** is the goal for everyone this capstone.

*"Went Beyond" has no fixed list. The examples are just starting points; going somewhere the lesson did not ask for is the whole idea.*

**✍️ Show your thinking (2–3 sentences):** What's your game about? What design decision are you proudest of, and what would you add with another week?
