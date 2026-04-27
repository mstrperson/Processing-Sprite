/**
 * Lesson 4 — You're in Control
 *
 * Two ways to control your character — try both, then pick your favorite:
 *
 *   Option A (active): followMouse() — character glides toward the cursor.
 *   Option B (active): arrow-key control — comment out Option A and
 *                       uncomment Option B. keyboardControl() is called in
 *                       keyPressed() below.
 *
 * Things to try:
 *   - Switch between the two options
 *   - Change the speed in setVelocity() — what number feels right?
 *   - Add a mousePressed() function that does something fun when you click
 */

import coxprogramming.processing.sprites.*;

MyCharacter player;

void setup() {
  size(800, 600);
  player = new MyCharacter(this, width/2, height/2);
  player.setVelocity(4, 0);  // speed used by followMouse() — required!
}

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

// Arrow keys set the velocity (used with Option B)
void keyPressed() {
  player.keyboardControl();
}
