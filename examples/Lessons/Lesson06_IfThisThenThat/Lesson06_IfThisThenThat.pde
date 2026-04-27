/**
 * Lesson 6 — If This, Then That
 *
 * Variables declared at the top keep their values across frames.
 * An if statement runs a block of code only when a condition is true.
 * text() draws words and numbers on screen.
 *
 * Things to try:
 *   - Change the win condition (score >= 10) to a different number
 *   - Add a second variable — a lives counter that starts at 3
 *   - Make the background color shift as the score increases
 *   - Design a different win screen (different text, colors, layout)
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
  for (int i = 0; i < 10; i++) {
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
  for (Blob c : coins) {
    c.move();
    c.drawSprite();
  }

  player.followMouse();
  player.drawSprite();

  if (score >= 10) {
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
