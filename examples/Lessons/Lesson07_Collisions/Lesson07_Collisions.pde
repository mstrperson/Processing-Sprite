/**
 * Lesson 7 — Collisions!
 *
 * collidesWith() returns true when two blob circles overlap.
 * The backwards loop (size()-1 down to 0) is the safe way to remove
 * items from a list while you are still looping through it.
 *
 * Things to try:
 *   - Add a second ArrayList of red hazard blobs that end the game on contact
 *   - Make new coins appear when the last one is collected
 *   - Change the win condition (all collected? score reaches 20? time limit?)
 *   - Make the player flash or grow when a coin is collected
 */

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
    showWin();
  }
}

void playGame() {
  // Backwards loop — safe to remove while iterating
  for (int i = coins.size() - 1; i >= 0; i--) {
    Blob c = coins.get(i);
    c.move();
    c.drawSprite();

    if (player.collidesWith(c)) {
      coins.remove(i);
      score = score + 1;
    }
  }

  player.followMouse();
  player.drawSprite();

  if (coins.size() == 0) {
    gameOver = true;
  }

  fill(50);
  textSize(24);
  text("Score: " + score, 20, 36);
}

void showWin() {
  textAlign(CENTER, CENTER);
  fill(80, 180, 80);
  textSize(52);
  text("You Win!", width/2, height/2 - 20);
  textSize(22);
  fill(50);
  text("Final score: " + score, width/2, height/2 + 26);
  textAlign(LEFT, TOP);
}
