/**
 * A self-similar node in a fractal orbital tree.
 *
 * Each FractalBranch keeps its children on circular orbits around its own
 * centre and advances each orbit angle a little every frame.  Nesting
 * FractalBranches inside each other creates a multi-level fractal: children
 * orbit their parent, grandchildren orbit their parent, and so on.
 *
 * The leaf nodes at the very tips of the tree are plain {@link Blob} objects
 * from the SpriteGame library.  Everything above them is a FractalBranch.
 *
 * NOTE: move() is completely overridden here.  CompoundSprite's linear
 * velocity propagation is bypassed — children are repositioned from polar
 * math each frame instead, which lets each level spin independently.
 */
class FractalBranch extends CompoundSprite {

  /** Current angle of each child's orbit, in radians. */
  private float[] orbitAngles;

  /** Distance from this node's centre to each orbiting child, in pixels. */
  private float[] orbitRadii;

  /** Angular speed of each orbit in radians per frame.  Negative = clockwise. */
  private float[] orbitSpeeds;

  /** Depth of this node.  The root has the largest value; leaf Blobs are depth 0. */
  int depth;

  /** Colour used for the lines drawn from this node to its children. */
  color lineColor;

  /**
   * @param p         the Processing sketch — pass {@code this}
   * @param x         x position of this node's centre
   * @param y         y position of this node's centre
   * @param depth     depth in the tree (root = highest; leaves = 0)
   * @param lineColor colour for lines connecting this node to its children
   */
  FractalBranch(PApplet p, float x, float y, int depth, color lineColor) {
    super(p, x, y);
    this.depth     = depth;
    this.lineColor = lineColor;
    orbitAngles = new float[0];
    orbitRadii  = new float[0];
    orbitSpeeds = new float[0];
  }

  /**
   * Adds a child sprite on a circular orbit around this node's centre.
   *
   * @param child       the sprite to add — a nested FractalBranch or a leaf Blob
   * @param radius      orbital radius in pixels
   * @param startAngle  initial angle in radians (0 = right, HALF_PI = down)
   * @param speed       angular speed in radians per frame; negative = clockwise
   * @return this FractalBranch for chaining
   */
  FractalBranch addOrbiting(Sprite child, float radius, float startAngle, float speed) {
    orbitAngles = append(orbitAngles, startAngle);
    orbitRadii  = append(orbitRadii,  radius);
    orbitSpeeds = append(orbitSpeeds, speed);
    child.moveTo(
      pos.x + parent.cos(startAngle) * radius,
      pos.y + parent.sin(startAngle) * radius
    );
    addSprite(child);
    return this;
  }

  /**
   * Moves this node's anchor by its own velocity, then recalculates every
   * child's orbital position and calls move() on each child recursively.
   *
   * Completely replaces CompoundSprite.move() so that children are driven
   * by orbital math rather than by propagated linear velocity.
   */
  @Override
  void move() {
    // Advance the anchor by its own velocity only (the root uses this
    // to trace a slow Lissajous path; all other branches have vel = 0).
    pos.x += vel.x;
    pos.y += vel.y;

    ArrayList<Sprite> kids = getSprites();
    for (int i = 0; i < kids.size(); i++) {
      orbitAngles[i] += orbitSpeeds[i];
      // Reposition child at the new orbital angle around our centre.
      kids.get(i).moveTo(
        pos.x + parent.cos(orbitAngles[i]) * orbitRadii[i],
        pos.y + parent.sin(orbitAngles[i]) * orbitRadii[i]
      );
      // Recurse: let the child reposition its own children in the same way.
      kids.get(i).move();
    }
  }

  /**
   * Draws a line from this node's centre to each child's current position,
   * then draws all children recursively.  Lines are thicker at higher depths
   * so the tree tapers naturally from root to tips.
   */
  @Override
  void drawSprite() {
    parent.stroke(lineColor);
    parent.strokeWeight(parent.max(0.3, depth * 0.55));

    ArrayList<Sprite> kids = getSprites();
    for (Sprite child : kids) {
      Vector2D cPos = child.getPosition();
      parent.line(pos.x, pos.y, cPos.x, cPos.y);
    }

    // Draw all children (CompoundSprite walks the list and recurses).
    super.drawSprite();
  }
}
