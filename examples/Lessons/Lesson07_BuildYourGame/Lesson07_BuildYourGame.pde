/**
 * Lesson 7 - Build Your Game
 *
 * This is YOUR game.  Everything marked CHANGE is a placeholder -- change it.
 *
 * The structure:
 *   setup()         -> builds the scenery once, then calls restartGame()
 *   draw()          -> draws the scenery, then picks playGame(), showWin(), or showGameOver()
 *   playGame()      -> moves and draws everything, checks collisions, updates the score
 *   showWin()       -> shown when the score reaches the goal
 *   showGameOver()  -> shown when the player touches a hazard
 *   restartGame()   -> puts every game piece back where it started
 *   mousePressed()  -> restarts the game after a win or a game over
 *
 * Ideas for making it yours:
 *   - Paste in your own MyCharacter.pde and your world from Lesson 5
 *   - Theme the colors, names, and shapes to match your world
 *   - Add a lives counter (start at 3, lose one on each hazard hit)
 *   - Write a new extends Blob tab for a hazard that looks like it belongs
 *   - Add a title screen before the game starts
 *   - Want twenty coins instead of three?  That is Bonus Lesson D (Lists).
 */

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

/**
 * Creates the window, builds the scenery once, then sets up the game pieces.
 * Runs once when the sketch starts.
 */
void setup() {
  size(800, 600);

  // Scenery never changes during play, so it is built once, here.
  ground = new Block(this, 0, height - 70, width, 70, color(80, 160, 60));  // CHANGE: your ground
  cloud1 = new Cloud(this, 150, 90, 0.5);
  cloud2 = new Cloud(this, 520, 60, 0.8);

  restartGame();
}

/**
 * Draws the scenery, then shows the right screen for the game's current state.
 * Called automatically ~60 times per second.
 */
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

/**
 * Moves and draws every game piece, checks every collision, and shows the score.
 * Called from draw() while the game is being played.
 */
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

/**
 * Shows the win screen.  CHANGE the words so they sound like your game.
 */
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

/**
 * Shows the game over screen.  CHANGE the words so they sound like your game.
 */
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

/**
 * Called once each time the mouse is clicked.
 * Restarts the game, but only after it has ended.
 */
void mousePressed() {
  if (gameOver || playerWon) {
    restartGame();
  }
}

/**
 * Puts every game piece back where it started.
 * Called once from setup(), and again every time the player restarts.
 */
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
