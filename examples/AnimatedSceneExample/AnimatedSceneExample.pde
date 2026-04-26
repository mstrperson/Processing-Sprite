/**
 * AnimatedSceneExample - SceneExample rebuilt with AnimatedSprite.
 *
 * The clouds are AnimatedSprite objects made from several CloudFrame sprites.
 * The sun is also an AnimatedSprite, with each SunFrame drawing different ray
 * lengths. The animation frame rate is controlled by AnimatedSprite's
 * game-frames-per-animation-frame setting.
 */

import coxprogramming.processing.sprites.*;

/** y-coordinate where the sky ends and the ground begins. */
int GROUND_Y;

/** Animated clouds that drift across the sky, wrapping at the edges. */
ArrayList<AnimatedSprite> clouds;

/** Animated sun with changing ray lengths. */
AnimatedSprite sun;

/** Trees standing on the ground line. */
ArrayList<Tree> trees;

/**
 * Creates the window and builds every sprite in the scene.
 *
 * This example uses helper functions, {@code makeCloud()} and
 * {@code makeSun()}, so the main setup stays short and readable.
 */
void setup() {
  size(900, 600);
  GROUND_Y = (height * 3) / 4;

  sun = makeSun(width * 0.82f, 110, 55);

  clouds = new ArrayList<AnimatedSprite>();
  clouds.add(makeCloud(140,  85, 0.75f, 1.00f, 0));
  clouds.add(makeCloud(430,  60, 1.20f, 0.85f, 2));
  clouds.add(makeCloud(680, 130, 0.55f, 1.15f, 1));

  trees = new ArrayList<Tree>();
  trees.add(new Tree(this,  90, GROUND_Y, 55));
  trees.add(new Tree(this, 270, GROUND_Y, 80));
  trees.add(new Tree(this, 490, GROUND_Y, 65));
  trees.add(new Tree(this, 710, GROUND_Y, 75));
  trees.add(new Tree(this, 840, GROUND_Y, 50));
}

/**
 * Draws one game frame.
 *
 * The sun only needs {@code drawSprite()} because it stays in one place.
 * Each cloud calls {@code move()} before {@code drawSprite()} so it drifts
 * across the sky while its animation frames cycle.
 */
void draw() {
  background(132, 202, 234);

  sun.drawSprite();

  for (AnimatedSprite cloud : clouds) {
    cloud.move();
    cloud.drawSprite();
  }

  noStroke();
  fill(78, 155, 66);
  rect(0, GROUND_Y, width, height - GROUND_Y);

  for (Tree tree : trees) {
    tree.drawSprite();
  }
}

/**
 * Builds one animated cloud.
 *
 * Each {@code CloudFrame} is one picture in the animation. The frames are all
 * placed at the same starting point, but each one has slightly different puff
 * shapes and grey values. {@code AnimatedSprite} draws one of these frames at
 * a time.
 *
 * @param x          starting x position of the cloud
 * @param y          starting y position of the cloud
 * @param speed      horizontal velocity in pixels per game frame
 * @param cloudScale size multiplier for the whole cloud
 * @param startFrame which frame to show first, starting at 0
 * @return a finished AnimatedSprite cloud
 */
AnimatedSprite makeCloud(float x, float y, float speed, float cloudScale, int startFrame) {
  AnimatedSprite cloud = AnimatedSprite.FromSprite(new CloudFrame(this, x, y, cloudScale, 0))
      .AddFrameSprite(new CloudFrame(this, x, y, cloudScale, 1))
      .AddFrameSprite(new CloudFrame(this, x, y, cloudScale, 2))
      .AddFrameSprite(new CloudFrame(this, x, y, cloudScale, 3))
      .setFrameRate(12);

  cloud.setFrameNumber(startFrame);
  cloud.setVelocity(speed, 0);
  return cloud;
}

/**
 * Builds one animated sun.
 *
 * The body of the sun stays the same in every frame. The ray lengths change
 * from frame to frame, which makes the sun look like it is shimmering.
 *
 * @param x      x position of the sun's center
 * @param y      y position of the sun's center
 * @param radius radius of the round sun body
 * @return a finished AnimatedSprite sun
 */
AnimatedSprite makeSun(float x, float y, float radius) {
  return AnimatedSprite.FromSprite(new SunFrame(this, x, y, radius, 0))
      .AddFrameSprite(new SunFrame(this, x, y, radius, 1))
      .AddFrameSprite(new SunFrame(this, x, y, radius, 2))
      .AddFrameSprite(new SunFrame(this, x, y, radius, 3))
      .AddFrameSprite(new SunFrame(this, x, y, radius, 4))
      .AddFrameSprite(new SunFrame(this, x, y, radius, 5))
      .setFrameRate(9);
}
