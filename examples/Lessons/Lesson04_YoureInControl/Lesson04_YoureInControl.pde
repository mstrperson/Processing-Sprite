/**
 * Lesson 4 — You're in Control
 *
 * Two ways to control your character — try both, then pick your favorite:
 *
 *   Option A: followMouse() — character glides toward the cursor each frame.
 *   Option B: arrow-key control — comment out Option A and uncomment Option B.
 *             keyboardControl() is called in keyPressed() below.
 *
 * Things to try:
 *   - Switch between the two options
 *   - Change the speed in setVelocity() — what number feels right?
 *   - Add a mousePressed() function that does something fun when you click
 */

import coxprogramming.processing.sprites.*;

MyCharacter player;

/**
 * Creates the window, places the character, and sets its movement speed.
 * Runs once when the sketch starts.
 */
void setup() {
  size(800, 600);
  player = new MyCharacter(this, width/2, height/2);
  player.setVelocity(4, 0);  // speed used by followMouse() — required!
}

/**
 * Clears the screen, moves the character using the chosen control method,
 * and draws it. Called automatically ~60 times per second.
 */
void draw() {
  background(240);

  // ── Option A: follow the mouse ──────────────────────────────────────────
  player.followMouse();
  player.drawSprite();

  // ── Option B: arrow-key control ─────────────────────────────────────────
  // (comment out Option A above, then uncomment these two lines)
  // player.move();
  // player.drawSprite();
}

/**
 * Called once each time a key is pressed.
 * Passes the key press to keyboardControl(), which sets the player's velocity
 * based on which arrow key was pressed.
 */
void keyPressed() {
  player.keyboardControl();
}
