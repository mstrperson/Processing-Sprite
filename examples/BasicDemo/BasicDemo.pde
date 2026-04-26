/**
 * BasicDemo — ten bouncing, wrapping blobs.
 *
 * The simplest possible demonstration of the SpriteGame library.
 * Ten {@link Blob} objects are created with random positions, sizes,
 * velocities, and colors.  Each frame every blob moves by its velocity;
 * {@link Sprite#move()} wraps it around the screen edges automatically.
 */

import coxprogramming.processing.sprites.*;

// Declare a list that will hold all of our Blob objects.
// ArrayList is like an array, but it can grow and shrink as we add or remove items.
// The <Blob> part tells Java that this list will only ever hold Blob objects.
ArrayList<Blob> blobs;

/**
 * Creates the window and populates it with 10 randomly configured blobs.
 * Runs once at startup.
 */
void setup() {
  fullScreen();
  blobs = new ArrayList<Blob>();

  // Add 10 blobs, each with a random position, size, velocity, and color.
  for (int i = 0; i < 10; i++) {
    blobs.add(
      new Blob(
        this,            // give the Blob a reference to this sketch so it can draw itself
        random(width),   // random x position across the screen
        random(height),  // random y position down the screen
        random(10, 30),  // random radius between 10 and 30 pixels
        random(-5, 5),   // random horizontal speed between -5 and 5 px/frame
        random(-5, 5),   // random vertical speed between -5 and 5 px/frame
        color(random(255), random(255), random(255)) // random RGB color
      )
    );
  }
}

/**
 * Clears the screen, then moves and draws every blob.
 * Runs continuously after {@code setup()} completes to create the animation.
 */
void draw() {
  // White background erases the previous frame — without this, blobs leave trails.
  background(255);

  // The "for each" loop visits every blob in the list one at a time.
  for (Blob blob : blobs) {
    blob.move();        // advance by velocity, wrap at screen edges
    blob.drawSprite();  // draw the circle at the new position
  }
}
