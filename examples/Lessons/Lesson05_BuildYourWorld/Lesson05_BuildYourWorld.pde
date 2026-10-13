/**
 * Lesson 5 - Build Your World
 *
 * Your character gets a place to live.  Three things are new here:
 *
 *   Block       a rectangle sprite for ground, walls, and platforms.
 *               Its x, y is the TOP-LEFT corner.  (A Blob's x, y is its center.)
 *   Cloud       a second sprite class, in its own tab.  It is the same
 *               extends Blob pattern as your MyCharacter.
 *   Draw order  whatever you draw later appears in front.
 *
 * Things to try:
 *   - Move ground.drawSprite() to the last line of draw() and run it
 *   - Change the background color to fit your world
 *   - Add a third cloud, or a second Block as a platform
 *   - Write your own decoration class in a new tab (Tree, Star, Fish, Rock)
 */

import coxprogramming.processing.sprites.*;

MyCharacter player;
Cloud cloud1;
Cloud cloud2;
Block ground;
Blob coin;

/**
 * Creates the window and builds the world:  ground, clouds, a coin, and the player.
 * Runs once when the sketch starts.
 */
void setup() {
  size(800, 600);

  // Ground strip along the bottom.  x, y is the TOP-LEFT corner.
  ground = new Block(this, 0, height - 70, width, 70, color(80, 160, 60));

  // Two clouds, each drifting at its own speed (Cloud is in its own tab)
  cloud1 = new Cloud(this, 150, 90, 0.5);
  cloud2 = new Cloud(this, 520, 60, 0.8);

  // A coin drifting through the world.  You collect it in Lesson 6.
  coin = new Blob(this, random(width), random(100, height - 150),
                  14, random(1, 2.5), random(-1.5, 1.5),
                  color(255, 220, 50));

  player = new MyCharacter(this, width/2, height/2);
  player.setVelocity(4, 0);
}

/**
 * Draws the world back to front, then the player on top.
 * Called automatically ~60 times per second.
 * Draw order matters:  things drawn first appear behind things drawn later.
 */
void draw() {
  background(135, 206, 235);   // 1. sky - furthest back

  cloud1.move();               // 2. clouds drift behind everything
  cloud1.drawSprite();
  cloud2.move();
  cloud2.drawSprite();

  ground.drawSprite();         // 3. ground in front of the sky

  coin.move();                 // 4. things in the world
  coin.drawSprite();

  player.followMouse();        // 5. player last, so it is always in front
  player.drawSprite();
}
