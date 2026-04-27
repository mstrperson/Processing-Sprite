/**
 * Lesson 5 — A World of Objects
 *
 * An ArrayList holds many objects. Two kinds of for loops work together:
 *   - A counting loop in setup() creates the coins.
 *   - A for-each loop in draw() visits every coin to move and draw it.
 *
 * The Cloud class lives in Cloud.pde — open that tab to see how to build
 * your own simple environment sprite.
 *
 * Things to try:
 *   - Change the number 12 in setup() to add more or fewer coins
 *   - Change the coin color, size range, or speed
 *   - Add a second ArrayList of a different kind of blob
 *   - Click anywhere to spawn a new coin at the mouse position
 */

import coxprogramming.processing.sprites.*;

MyCharacter player;
ArrayList<Blob> coins;
ArrayList<Cloud> clouds;

/**
 * Creates the window, spawns 12 coins at random positions, and adds clouds.
 * Runs once when the sketch starts.
 */
void setup() {
  size(800, 600);

  player = new MyCharacter(this, width/2, height/2);
  player.setVelocity(4, 0);

  // Counting loop — runs 12 times to create 12 coins
  coins = new ArrayList<Blob>();
  for (int i = 0; i < 12; i++) {
    coins.add(new Blob(
      this,
      random(width),          // random x position
      random(height),         // random y position
      random(8, 20),          // random radius
      random(-2, 2),          // random horizontal speed
      random(-2, 2),          // random vertical speed
      color(255, 220, 50)     // gold
    ));
  }

  clouds = new ArrayList<Cloud>();
  clouds.add(new Cloud(this, 100,  80, 0.6));
  clouds.add(new Cloud(this, 370,  55, 0.4));
  clouds.add(new Cloud(this, 620, 110, 0.7));
}

/**
 * Clears the screen then moves and draws clouds, coins, and the player.
 * Called automatically ~60 times per second.
 * Draw order matters: things drawn first appear behind things drawn later.
 */
void draw() {
  background(135, 206, 235);  // sky blue

  // For-each loop — visits every cloud, moves it, draws it
  for (Cloud c : clouds) {
    c.move();
    c.drawSprite();
  }

  // For-each loop — visits every coin, moves it, draws it
  for (Blob coin : coins) {
    coin.move();
    coin.drawSprite();
  }

  // Player drawn last so it appears in front of everything
  player.followMouse();
  player.drawSprite();
}

/**
 * Called once each time the mouse button is clicked.
 * Adds a new coin at the mouse position.
 */
void mousePressed() {
  coins.add(new Blob(
    this, mouseX, mouseY,
    random(8, 20), random(-2, 2), random(-2, 2),
    color(255, 220, 50)
  ));
}
