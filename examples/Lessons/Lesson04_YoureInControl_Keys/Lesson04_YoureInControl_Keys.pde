/**
 * Lesson 4 - You're in Control (Keys Group)
 *
 * keyboardControl() reads the arrow keys and sets your character's velocity.
 * A key press happens once, so it goes inside keyPressed().  Then move() in
 * draw() uses that velocity, every frame.
 *
 * The other half of the class is steering with the mouse
 * (Lesson04_YoureInControl_Mouse).  You'll try each other's at your table.
 *
 * Click inside the sketch window before you press any keys!
 *
 * Things to try:
 *   - Press an arrow and let go.  Why does it keep going?
 *   - Press the space bar, then a letter key.  What do they do?
 *   - Add a keyReleased() function with player.setVelocity(0, 0); inside it
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
  player.setVelocity(4, 0);  // the drift before your first key
}

/**
 * Clears the screen, moves the character by its velocity, and draws it.
 * Called automatically ~60 times per second.
 */
void draw() {
  background(240);
  player.move();        // still needed -- applies the velocity each frame
  player.drawSprite();
}

/**
 * Called once each time a key is pressed.
 * Passes the key press to keyboardControl(), which sets the player's velocity
 * based on which arrow key was pressed.
 */
void keyPressed() {
  player.keyboardControl();
}
