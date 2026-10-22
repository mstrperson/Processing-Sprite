/**
 * Lesson 4 - You're in Control (Mouse Group)
 *
 * followMouse() pulls your character toward the cursor a little bit, every
 * frame.  Because it happens every frame, it goes inside draw().
 *
 * The other half of the class is driving with the arrow keys
 * (Lesson04_YoureInControl_Keys).  You'll try each other's at your table.
 *
 * Things to try:
 *   - Change the speed in setVelocity() -- what number feels right?
 *   - Try setVelocity(0, 5) and setVelocity(5, 0).  Is one faster?
 *   - Add a mousePressed() function that does something fun when you click
 */

import coxprogramming.processing.sprites.*;

MyCharacter player;

/**
 * Creates the window, places the character, and sets its chase speed.
 * Runs once when the sketch starts.
 */
void setup() {
  size(800, 600);
  player = new MyCharacter(this, width/2, height/2);
  player.setVelocity(4, 0);  // the speed followMouse() chases at -- required!
}

/**
 * Clears the screen, pulls the character toward the mouse, and draws it.
 * Called automatically ~60 times per second.
 */
void draw() {
  background(240);
  player.followMouse();   // use followMouse() OR move(), not both
  player.drawSprite();
}
