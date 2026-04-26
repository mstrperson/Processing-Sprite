/**
 * A tree-shaped {@link Sprite} — yours to design!
 *
 * {@code Tree} extends {@link Sprite}, which gives it a position
 * ({@code pos.x}, {@code pos.y}) and all of {@link Sprite}'s movement
 * methods for free, even though a tree doesn't move on its own.
 *
 * {@code pos.x} and {@code pos.y} mark the <em>base of the trunk</em>
 * (where it meets the ground).  Use the {@code size} field to scale the
 * tree proportionally.
 *
 * Your task: fill in {@link #drawSprite()} below!  A few drawing functions
 * to get you started:
 * <ul>
 *   <li>{@code parent.fill(r, g, b)} — set the fill colour (0–255 each)</li>
 *   <li>{@code parent.noStroke()} — turn off the outline</li>
 *   <li>{@code parent.rect(x, y, w, h)} — rectangle from its top-left corner</li>
 *   <li>{@code parent.ellipse(x, y, w, h)} — ellipse centred at (x, y)</li>
 *   <li>{@code parent.triangle(x1,y1, x2,y2, x3,y3)} — great for pine trees!</li>
 * </ul>
 */
class Tree extends Sprite {

  /** Overall size of the tree in pixels. You decide how to use it! */
  float size;

  /**
   * Creates a Tree at (x, y) with the given size.
   * The tree does not move, so velocity starts at (0, 0).
   *
   * @param p    the Processing sketch — pass {@code this}
   * @param x    x position of the base of the trunk
   * @param y    y position of the base of the trunk (ground level)
   * @param size overall scale of the tree in pixels
   */
  Tree(PApplet p, float x, float y, float size) {
    super(p, x, y);
    this.size = size;
  }

  /**
   * Draws this tree.  Fill in the body of this method to make your tree!
   * Call once per frame inside {@code draw()}.
   */
  void drawSprite() {

    // TODO: Draw the trunk.
    //
    // A trunk is usually a tall, narrow brown rectangle.
    // pos.x is the centre of the tree, pos.y is the bottom of the trunk.
    //
    // Example (uncomment and adjust to your liking):
    //   parent.fill(101, 67, 33);                    // brown
    //   parent.noStroke();
    //   parent.rect(pos.x - size * 0.1,              // left edge of trunk
    //               pos.y - size * 0.5,              // top of trunk
    //               size * 0.2,                      // trunk width
    //               size * 0.5);                     // trunk height


    // TODO: Draw the canopy (the leafy or branchy top part).
    //
    // The top of your trunk is at approximately (pos.x, pos.y - size * 0.5).
    // Centre your canopy there or a little above it.
    //
    // Ideas:
    //   • A green ellipse for a round, leafy tree.
    //   • A green triangle (or stack of triangles) for a pine/Christmas tree.
    //   • Several overlapping circles in different shades of green.
    //
    // Example round canopy (uncomment and adjust):
    //   parent.fill(34, 139, 34);                    // forest green
    //   parent.ellipse(pos.x,                        // centre x
    //                  pos.y - size * 0.75,          // centre y (above trunk)
    //                  size * 0.8,                   // canopy width
    //                  size * 0.8);                  // canopy height

  }
}
