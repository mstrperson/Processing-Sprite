/**
 * Lesson 6 - Collisions:  If This, Then That  (Day 1 checkpoint)
 *
 * collidesWith() asks a yes-or-no question:  are these two sprites touching?
 * An if statement runs its block only when the answer is yes.
 *
 * When the player touches the coin, two things happen:
 *   - score goes up by one
 *   - the coin jumps to a new random spot, so the player can go get it again
 *
 * Things to try:
 *   - Delete the moveTo() line and run it.  Hold still on the coin.  Watch the score.
 *   - Change the radius in MyCharacter's super(...) line.  Bigger = easier to grab.
 *   - Change the score text color or size
 */

import coxprogramming.processing.sprites.*;

MyCharacter player;
Cloud cloud1;
Cloud cloud2;
Block ground;
Blob coin;
int score = 0;   // a whole number that remembers the score between frames

/**
 * Creates the window and builds the world from Lesson 5.
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

  player = new MyCharacter(this, width/2, height/2);
  player.setVelocity(4, 0);
}

/**
 * Draws the world, checks whether the player is touching the coin,
 * and shows the score.  Called automatically ~60 times per second.
 */
void draw() {
  background(135, 206, 235);

  cloud1.move();
  cloud1.drawSprite();
  cloud2.move();
  cloud2.drawSprite();

  ground.drawSprite();

  coin.move();
  coin.drawSprite();

  player.followMouse();
  player.drawSprite();

  // Is the player touching the coin?
  if (player.collidesWith(coin)) {
    score = score + 1;                                      // add a point
    coin.moveTo(random(width), random(100, height - 150));  // coin jumps somewhere new
  }

  // Show the score in the top-left corner
  fill(50);
  textSize(24);
  text("Score: " + score, 20, 36);
}
