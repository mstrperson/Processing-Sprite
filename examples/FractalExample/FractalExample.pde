/**
 * FractalExample — a self-similar orbital fractal built from nested
 * FractalBranch compound sprites, with Blob objects at the leaf tips.
 *
 * Structure
 * ---------
 * The tree is built recursively.  Each FractalBranch has three children
 * spaced 120° apart on a circular orbit.  Those children are either more
 * FractalBranches or, at the deepest level, plain Blobs.  With DEPTH = 5
 * there are 121 FractalBranch nodes and 243 leaf Blobs (364 sprites total).
 *
 * Motion
 * ------
 * Consecutive levels spin in opposite directions, and deeper levels spin
 * faster, creating complex spirograph-like paths.  The whole tree drifts
 * slowly on a Lissajous ellipse.
 *
 * Trail effect
 * ------------
 * Instead of clearing the screen each frame, a semi-transparent overlay
 * slowly erases old drawings, leaving ghostly motion trails.
 *
 * Controls
 * --------
 *   Any key  — clear the trail instantly
 *   +/-      — increase / decrease fractal depth (rebuilds)
 */

import coxprogramming.processing.sprites.*;

// ── Tunable parameters ────────────────────────────────────────────────────────
int   DEPTH        = 5;    // levels of branching; 5 → 243 leaf Blobs
float START_RADIUS = 200;  // orbital radius of the outermost level (pixels)

FractalBranch root;

void setup() {
  fullScreen();
  colorMode(HSB, 360, 100, 100, 100);
  Sprite.screenBehavior = ScreenBehavior.NoWalls;
  background(240, 20, 8);
  root = buildTree(DEPTH, width / 2.0, height / 2.0, START_RADIUS, 0);
}

void draw() {
  // Semi-transparent dark overlay — fades old drawings into trails.
  noStroke();
  fill(240, 20, 8, 8);
  rect(0, 0, width, height);

  // Drift the whole tree on a slow Lissajous ellipse.
  float t = frameCount * 0.0005;
  root.moveTo(width / 2.0 + cos(t) * 70, height / 2.0 + sin(t * 1.3) * 50);

  root.move();
  root.drawSprite();

  // On-screen hint (fades into the trail quickly).
  fill(0, 0, 100, 40);
  textAlign(CENTER);
  textSize(13);
  text("DEPTH " + DEPTH + "  |  " + countSprites() + " sprites  |  any key = clear  |  +/- = depth", width / 2, height - 16);
}

void keyPressed() {
  if (key == '+' || key == '=') {
    DEPTH = min(DEPTH + 1, 7);
    root = buildTree(DEPTH, width / 2.0, height / 2.0, START_RADIUS, 0);
  } else if (key == '-') {
    DEPTH = max(DEPTH - 1, 1);
    root = buildTree(DEPTH, width / 2.0, height / 2.0, START_RADIUS, 0);
  }
  background(240, 20, 8);
}

/**
 * Recursively builds one node of the fractal tree.
 *
 * depth == 0 produces a leaf Blob.
 * depth  > 0 produces a FractalBranch whose three children are built
 *            at depth - 1.
 *
 * @param depth        remaining levels (0 = leaf)
 * @param x            x position of this node's centre
 * @param y            y position of this node's centre
 * @param orbitRadius  distance its children will orbit from its centre
 * @param hue          base hue (0–360) for this node's colour
 * @return a Blob at depth 0, a FractalBranch at depth > 0
 */
FractalBranch buildTree(int depth, float x, float y, float orbitRadius, float hue) {
  // Collect the root at the top level by wrapping depth-0 leaves inside a
  // minimal depth-1 shell.  This keeps the return type consistent.
  FractalBranch root = buildBranch(depth, x, y, orbitRadius, hue);
  return root;
}

FractalBranch buildBranch(int depth, float x, float y, float orbitRadius, float hue) {
  color lineC = color(hue % 360, 60, 80, 55);
  FractalBranch branch = new FractalBranch(this, x, y, depth, lineC);

  // Deeper levels orbit faster; alternating levels spin in opposite directions.
  float speed = 0.003 * pow(1.75, depth);
  if (depth % 2 == 0) speed = -speed;

  float childRadius = orbitRadius * 0.5;

  for (int i = 0; i < 3; i++) {
    float startAngle = TWO_PI / 3.0 * i;
    // Shift hue by 110° per branch and 25° per depth level for colour variety.
    float childHue = (hue + i * 110 + depth * 25) % 360;

    if (depth == 1) {
      // Leaf node: a plain Blob from the library.
      Blob leaf = new Blob(this, x, y, childRadius * 0.55, 0, 0,
                           color(childHue, 90, 100, 95));
      branch.addOrbiting(leaf, orbitRadius, startAngle, speed);
    } else {
      FractalBranch child = buildBranch(depth - 1, x, y, childRadius, childHue);
      branch.addOrbiting(child, orbitRadius, startAngle, speed);
    }
  }

  return branch;
}

/** Returns the total number of sprites in the tree (for the HUD). */
int countSprites() {
  // FractalBranch nodes: sum of 3^k for k = 0..DEPTH-1 = (3^DEPTH - 1) / 2
  // Leaf Blobs: 3^(DEPTH-1)
  int branches = (int)((pow(3, DEPTH) - 1) / 2);
  int leaves   = (int) pow(3, DEPTH - 1);
  return branches + leaves;
}
