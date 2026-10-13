/**
 * Bonus Lesson D - Lists and Loops
 *
 * One coin is a variable.  Twelve coins is a list.
 *
 * An ArrayList holds as many objects as you want.  Three loops work with it:
 *   - A counting loop in setup() CREATES the coins.
 *   - A for-each loop VISITS every item, when nothing is being removed.
 *   - A backwards loop visits every item when you might REMOVE one.
 *
 * Collect every coin to clear the board, and a new wave arrives.
 *
 * Things to try:
 *   - Change the 12 in the counting loop
 *   - Make a second list of hazards, and visit it with a for-each loop
 *   - Click anywhere to add a coin at the mouse
 */

import coxprogramming.processing.sprites.*;

MyCharacter player;
ArrayList<Blob> coins;      // a list that holds Blobs
Blob hazard;
int score = 0;
boolean gameOver = false;

/**
 * Creates the window, the player, the hazard, and the first wave of coins.
 * Runs once when the sketch starts.
 */
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

/**
 * Clears the screen and picks a screen:  still playing, or game over.
 * Called automatically ~60 times per second.
 */
void draw() {
  background(240);

  if (!gameOver) {
    playGame();
  } else {
    showGameOver();
  }
}

/**
 * Moves, draws, and collects the coins, moves the hazard, and refills
 * the board when it is empty.  Called from draw() while playing.
 */
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

/**
 * Shows the game over screen with the final score.
 */
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

/**
 * Called once each time the mouse is clicked.
 * Adds a new coin at the mouse position.
 */
void mousePressed() {
  coins.add(new Blob(this, mouseX, mouseY,
                     random(8, 18), random(-2, 2), random(-2, 2),
                     color(255, 220, 50)));
}
