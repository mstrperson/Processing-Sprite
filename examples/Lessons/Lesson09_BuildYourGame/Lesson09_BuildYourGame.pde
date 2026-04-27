/**
 * Lesson 9 — Build Your Game
 *
 * This is YOUR game. Everything in ALL_CAPS is a placeholder — change it.
 *
 * The structure:
 *   setup()         → calls restartGame() to initialize everything
 *   draw()          → routes to playGame(), showWin(), or showGameOver()
 *   playGame()      → move/draw everything; check collisions; update score
 *   showWin()       → displayed when all collectibles are gone
 *   showGameOver()  → displayed when the player hits a hazard
 *   restartGame()   → resets all variables and rebuilds all lists
 *   mousePressed()  → restarts the game after win or game over
 *
 * Ideas for making it yours:
 *   - Replace MyCharacter with your own character (paste your MyCharacter.pde)
 *   - Theme the colors, names, and shapes to match your world
 *   - Add a lives counter (start at 3, decrease on hazard hit)
 *   - Write a new extends Blob tab for a custom hazard that chases the player
 *   - Add a title screen before the game starts
 *   - Make hazards faster with each new wave
 */

import coxprogramming.processing.sprites.*;

MyCharacter player;
ArrayList<Blob> collectibles;
ArrayList<Blob> hazards;
Block ground;
ArrayList<Cloud> clouds;
int score = 0;
boolean gameOver = false;
boolean playerWon = false;

/**
 * Creates the window and calls restartGame() to build all sprites.
 * Runs once when the sketch starts.
 */
void setup() {
  size(800, 600);
  restartGame();
}

/**
 * Clears the screen, draws background elements, then routes to the
 * correct screen based on game state. Called automatically ~60 times per second.
 */
void draw() {
  background(135, 206, 235);  // CHANGE: your sky / background color

  for (Cloud c : clouds) {
    c.move();
    c.drawSprite();
  }

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
 * Moves and draws collectibles and hazards, checks for collisions with the player,
 * updates score, and draws the player. Called from draw() during active play.
 */
void playGame() {
  // Collectibles — touch these to score
  for (int i = collectibles.size() - 1; i >= 0; i--) {
    Blob c = collectibles.get(i);
    c.move();
    c.drawSprite();
    if (player.collidesWith(c)) {
      collectibles.remove(i);
      score = score + 1;
    }
  }

  // Hazards — touching one ends the game
  for (Blob h : hazards) {
    h.move();
    h.drawSprite();
    if (player.collidesWith(h)) {
      gameOver = true;
    }
  }

  // Player — drawn last so it appears in front of everything
  player.followMouse();
  player.drawSprite();

  if (collectibles.size() == 0) {
    playerWon = true;
  }

  fill(50);
  textSize(22);
  text("Score: " + score, 20, 32);
}

/**
 * Displays the win screen. Called from draw() when all collectibles are collected.
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
  textAlign(LEFT, TOP);
}

/**
 * Displays the game over screen. Called from draw() when the player hits a hazard.
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
  textAlign(LEFT, TOP);
}

/**
 * Called once each time the mouse button is clicked.
 * Restarts the game if it has ended.
 */
void mousePressed() {
  if (gameOver || playerWon) {
    restartGame();
  }
}

/**
 * Resets all variables to their starting values and rebuilds every sprite list.
 * Called from setup() at the start and from mousePressed() to replay.
 */
void restartGame() {
  score = 0;
  gameOver = false;
  playerWon = false;

  ground = new Block(this, 0, height - 70, width, 70, 0, 0, color(80, 160, 60));

  clouds = new ArrayList<Cloud>();
  clouds.add(new Cloud(this, 100,  75, 0.5));
  clouds.add(new Cloud(this, 380,  50, 0.35));
  clouds.add(new Cloud(this, 630, 100, 0.6));

  player = new MyCharacter(this, width/2, height - 120);
  player.setVelocity(4, 0);

  // CHANGE: count, size, speed, and color of collectibles
  collectibles = new ArrayList<Blob>();
  for (int i = 0; i < 10; i++) {
    collectibles.add(new Blob(
      this, random(width), random(80, height - 100),
      random(10, 18), random(-2, 2), random(-1, 1),
      color(255, 220, 50)
    ));
  }

  // CHANGE: count, size, and speed of hazards — faster = harder
  hazards = new ArrayList<Blob>();
  for (int i = 0; i < 5; i++) {
    hazards.add(new Blob(
      this, random(width), random(80, height - 100),
      random(15, 28), random(-3, 3), random(-3, 3),
      color(220, 60, 60)
    ));
  }
}
