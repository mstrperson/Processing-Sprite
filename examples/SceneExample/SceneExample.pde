/**
 * SceneExample — a simple outdoor scene using custom Sprite subclasses.
 *
 * Demonstrates how to extend {@link Sprite} directly in a Processing sketch
 * (see Cloud.pde, Sun.pde, and Tree.pde in this folder) alongside sprites
 * from the library.
 *
 * Draw order matters: the sun is drawn before the clouds so it appears
 * behind them; the ground strip is drawn after the clouds so it covers
 * anything that drifts too low; trees are drawn last so they appear on top
 * of the ground.
 */

import coxprogramming.processing.sprites.*;

/** y-coordinate where the sky ends and the ground begins. */
int GROUND_Y;

/** Clouds that drift across the sky, wrapping at the edges. */
ArrayList<Cloud> clouds;

/** The sun — placed once in the upper-right area and stays still. */
Sun sun;

/** Trees standing on the ground line. */
ArrayList<Tree> trees;

/**
 * Creates the window and all sprites.
 * Runs once at startup.
 */
void setup() {
  size(900, 600);
  GROUND_Y = (height * 3) / 4;

  sun = new Sun(this, width * 0.82, 110, 55);

  clouds = new ArrayList<Cloud>();
  clouds.add(new Cloud(this, 140,  85, 0.8));
  clouds.add(new Cloud(this, 430,  60, 1.3));
  clouds.add(new Cloud(this, 680, 130, 0.6));

  trees = new ArrayList<Tree>();
  trees.add(new Tree(this,  90, GROUND_Y, 55));
  trees.add(new Tree(this, 270, GROUND_Y, 80));
  trees.add(new Tree(this, 490, GROUND_Y, 65));
  trees.add(new Tree(this, 710, GROUND_Y, 75));
  trees.add(new Tree(this, 840, GROUND_Y, 50));
}

/**
 * Redraws the scene every frame: sky, sun, clouds, ground, trees.
 * Clouds call {@code move()} so they drift automatically and wrap around
 * when they reach the right edge of the screen.
 */
void draw() {
  background(135, 206, 235); // sky blue

  sun.drawSprite();

  for (Cloud cloud : clouds) {
    cloud.move();
    cloud.drawSprite();
  }

  // Ground — drawn after clouds so it covers anything that drifted too low.
  noStroke();
  fill(80, 160, 60);
  rect(0, GROUND_Y, width, height - GROUND_Y);

  for (Tree tree : trees) {
    tree.drawSprite();
  }
}
