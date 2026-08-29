/**
 * Bonus Lesson C — Animate Your Character
 *
 * Animation is a flipbook: a few still pictures (frames) shown fast, in a loop.
 * AnimatedSprite holds the frames and draws one at a time for you.
 *
 * This sketch builds an animated character from three MyCharacterFrame poses
 * (see the MyCharacterFrame tab). Each pose is the same character with a
 * slightly different mouth, so the character looks like it is talking.
 *
 *   FromSprite(firstFrame)   — starts the flipbook with the first page
 *   .AddFrameSprite(next)    — adds another page
 *   .setFrameRate(8)         — holds each page for 8 game frames (smaller = faster)
 *
 * Every frame is created at the SAME x, y so the character does not jump when
 * the page turns.
 *
 * Things to try:
 *   - Add a 4th pose in MyCharacterFrame, then AddFrameSprite() it here
 *   - Change setFrameRate(8) — try 4 (fast) and 20 (slow)
 *   - Animate legs or arms instead of the mouth to make it walk
 *   - Switch to arrow keys: use player.move() in draw() (instead of followMouse)
 *       and add:  void keyPressed() { player.keyboardControl(); }
 *   - In a Lesson 9 game, an AnimatedSprite is NOT a Blob, so use distanceTo()
 *       for collisions:  if (player.distanceTo(coin) < 40) { ...collect... }
 */

import coxprogramming.processing.sprites.*;

AnimatedSprite player;

/**
 * Creates the window and builds the animated character from three poses.
 * Runs once when the sketch starts.
 */
void setup() {
  size(800, 600);

  // Build the flipbook — all frames at the SAME spot so it doesn't jump.
  // AnimatedSprite shows one pose at a time and flips between them for you.
  player = AnimatedSprite.FromSprite(new MyCharacterFrame(this, width/2, height/2, 0))
      .AddFrameSprite(new MyCharacterFrame(this, width/2, height/2, 1))
      .AddFrameSprite(new MyCharacterFrame(this, width/2, height/2, 2))
      .setFrameRate(8);   // hold each pose for 8 game frames; smaller = faster

  player.setVelocity(4, 0);  // gives followMouse() a speed to move at
}

/**
 * Clears the screen, moves the character toward the mouse, then draws it.
 * Called automatically ~60 times per second.
 * drawSprite() draws the current pose AND advances the flipbook.
 */
void draw() {
  background(240);

  player.followMouse();
  player.drawSprite();
}
