/**
 * Lesson 3 — Bring It to Life
 *
 * setVelocity() gives your character a speed and direction.
 * move() advances the position by that velocity every frame.
 * The library wraps the character automatically when it reaches a screen edge.
 *
 * Things to try:
 *   - Change the two numbers in setVelocity() — try big, tiny, and negative values
 *   - Use random(-5, 5) for both numbers to get a different direction every run
 *   - Make it move perfectly diagonally (set vx == vy)
 *   - Change the background color to set a mood
 *
 * Reminder: positive vx moves RIGHT, negative vx moves LEFT.
 *           positive vy moves DOWN,  negative vy moves UP.
 */

import coxprogramming.processing.sprites.*;

MyCharacter player;

/**
 * Creates the window, places the character, and gives it a starting velocity.
 * Runs once when the sketch starts.
 */
void setup() {
  size(800, 600);
  player = new MyCharacter(this, width/2, height/2);
  player.setVelocity(3, -2);  // 3 pixels right, 2 pixels up per frame
}

/**
 * Clears the screen, moves the character, then draws it.
 * Called automatically ~60 times per second.
 * move() must come before drawSprite() so the position is updated first.
 */
void draw() {
  background(240);
  player.move();        // update position — always before drawSprite()
  player.drawSprite();  // draw at new position
}
