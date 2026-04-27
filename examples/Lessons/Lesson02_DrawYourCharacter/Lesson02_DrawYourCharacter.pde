/**
 * Lesson 2 — Draw Your Character
 *
 * The character is defined in the MyCharacter tab (MyCharacter.pde).
 * Open that tab and redesign the drawSprite() method to make it yours.
 *
 * Things to try:
 *   - Change the body shape (rect? triangle? several overlapping ellipses?)
 *   - Add hair, a hat, wings, ears, a tail, antennae — anything
 *   - Change every color using Tools → Color Selector
 *   - Update the radius in super() to match your character's new size
 */

import coxprogramming.processing.sprites.*;

MyCharacter player;

/**
 * Creates the window and places the character in the center.
 * Runs once when the sketch starts.
 */
void setup() {
  size(800, 600);
  player = new MyCharacter(this, width/2, height/2);
}

/**
 * Clears the screen and draws the character. Called automatically ~60 times per second.
 */
void draw() {
  background(240);
  player.drawSprite();
}
