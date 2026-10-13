/**
 * Lesson 6 - Collisions:  If This, Then That  (Day 2, the full lesson)
 *
 * Two collisions, two different results:
 *   - touch the coin    -> score goes up and the coin jumps somewhere new
 *   - touch the hazard  -> gameOver becomes true
 *
 * gameOver is a boolean:  it is only ever true or false.  The if/else in
 * draw() reads it every frame and picks which screen to show.
 *
 * Things to try:
 *   - Make the hazard faster, slower, or bigger
 *   - Add a second hazard (hazard2) with its own if
 *   - Rewrite the game over screen so it sounds like your game
 *   - Add a win:  if (score >= 10) { ... }
 */

import coxprogramming.processing.sprites.*;

MyCharacter player;
Cloud cloud1;
Cloud cloud2;
Block ground;
Blob coin;
Blob hazard;
int score = 0;              // a whole number, starts at zero
boolean gameOver = false;   // true or false, starts false

/**
 * Creates the window and builds the world, the coin, and the hazard.
 * Runs once when the sketch starts.
 */
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

/**
 * Draws the scenery, then picks a screen:  still playing, or game over.
 * Called automatically ~60 times per second.
 */
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

/**
 * Moves and draws the coin, the hazard, and the player, checks both
 * collisions, and shows the score.  Called from draw() while playing.
 */
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

/**
 * Shows the game over screen with the final score.
 * Called from draw() once gameOver is true.
 */
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
