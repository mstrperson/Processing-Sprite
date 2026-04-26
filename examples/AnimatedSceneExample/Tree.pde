/**
 * A simple tree sprite used to complete the animated scene.
 */
class Tree extends Sprite {

  /** Overall height and width scale for the tree. */
  float treeSize;

  /**
   * Creates a tree at the given ground position.
   *
   * @param p        the Processing sketch; pass {@code this}
   * @param x        x position of the base of the trunk
   * @param y        y position of the ground at the trunk
   * @param treeSize overall size of the tree
   */
  Tree(PApplet p, float x, float y, float treeSize) {
    super(p, x, y);
    this.treeSize = treeSize;
  }

  /**
   * Draws the tree from simple shapes.
   *
   * The trunk is a rectangle. The leaves are overlapping ellipses in different
   * green colors, which makes the canopy look fuller.
   */
  public void drawSprite() {
    parent.noStroke();

    parent.fill(96, 62, 31);
    parent.rect(pos.x - treeSize * 0.10f, pos.y - treeSize * 0.46f, treeSize * 0.20f, treeSize * 0.46f);

    parent.fill(36, 122, 56);
    parent.ellipse(pos.x, pos.y - treeSize * 0.72f, treeSize * 0.72f, treeSize * 0.62f);

    parent.fill(45, 148, 69);
    parent.ellipse(pos.x - treeSize * 0.20f, pos.y - treeSize * 0.62f, treeSize * 0.48f, treeSize * 0.42f);
    parent.ellipse(pos.x + treeSize * 0.22f, pos.y - treeSize * 0.63f, treeSize * 0.50f, treeSize * 0.44f);

    parent.fill(63, 165, 80);
    parent.ellipse(pos.x, pos.y - treeSize * 0.84f, treeSize * 0.45f, treeSize * 0.40f);
  }
}
