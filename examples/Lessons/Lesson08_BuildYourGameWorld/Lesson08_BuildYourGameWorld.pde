/**
 * Lesson 8 — Build Your Game World
 *
 * Draw order determines layering: things drawn later appear in front.
 * The order here is: sky → decorations → ground → coins → player.
 *
 * Block is a rectangle sprite. Its x,y is its TOP-LEFT corner
 * (unlike Blob, where x,y is the center).
 *
 * Things to try:
 *   - Change the background color to match your theme (deep blue? black? green?)
 *   - Write a new sprite class in a new tab (Star, Tree, Fish, Rock …)
 *   - Add more Block objects to create platforms, walls, or borders
 *   - Change coin colors to match the theme (gems? hearts? fish? acorns?)
 */

import coxprogramming.processing.sprites.*;

MyCharacter player;
ArrayList<Blob> coins;
Block ground;
ArrayList<Cloud> clouds;
int score = 0;
boolean gameOver = false;

/**
 * Creates the window, builds the ground and clouds, places the character,
 * and spawns 10 coins. Runs once when the sketch starts.
 */
void setup() {
  size(800, 600);

  ground = new Block(this, 0, height - 70, width, 70, color(80, 160, 60));

  clouds = new ArrayList<Cloud>();
  clouds.add(new Cloud(this, 100,  75, 0.5));
  clouds.add(new Cloud(this, 380,  50, 0.35));
  clouds.add(new Cloud(this, 630, 100, 0.6));

  player = new MyCharacter(this, width/2, height - 120);
  player.setVelocity(4, 0);

  coins = new ArrayList<Blob>();
  for (int i = 0; i < 10; i++) {
    coins.add(new Blob(
      this, random(width), random(80, height - 100),
      random(8, 16), random(-2, 2), random(-1, 1),
      color(255, 220, 50)
    ));
  }
}

/**
 * Clears the screen and draws everything in the correct order.
 * Draw order: sky (background) → clouds → ground → game objects → player.
 * Called automatically ~60 times per second.
 */
void draw() {
  background(135, 206, 235);  // sky — change this first!

  // 1. Background (drawn first = behind everything)
  for (Cloud c : clouds) {
    c.move();
    c.drawSprite();
  }

  // 2. Ground (drawn after clouds, before coins and player)
  ground.drawSprite();

  if (!gameOver) {
    playGame();
  } else {
    showWin();
  }
}

/**
 * Moves and draws all coins, checks for collision with the player,
 * and removes collected coins. Draws the player in front of everything.
 * Called from draw() while the game is active.
 */
void playGame() {
  // 3. Coins
  for (int i = coins.size() - 1; i >= 0; i--) {
    Blob c = coins.get(i);
    c.move();
    c.drawSprite();
    if (player.collidesWith(c)) {
      coins.remove(i);
      score = score + 1;
    }
  }

  // 4. Player (drawn last = in front of everything)
  player.followMouse();
  player.drawSprite();

  if (coins.size() == 0) {
    gameOver = true;
  }

  fill(50);
  textSize(24);
  text("Score: " + score, 20, 36);
}

/**
 * Displays the win screen with the final score.
 * Called from draw() after all coins have been collected.
 */
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
