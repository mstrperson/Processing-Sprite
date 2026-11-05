package coxprogramming.processing.sprites;

import processing.core.PApplet;

/**
 * A rectangular sprite with a width and a height.
 *
 * <p>{@code Block} extends {@link Blob}, which means it has all of Blob's
 * movement and collision features, but draws itself as a rectangle instead
 * of a circle. It is useful for walls, platforms, floors, and other
 * box-shaped objects in a game.</p>
 *
 * <p>The position (x, y) marks the <em>top-left corner</em> of the rectangle,
 * following Processing's default {@code rect()} behavior.</p>
 *
 * <p>Example:
 * <pre>
 *   Block wall = new Block(this, 0, 200, 800, 20, color(100));
 *   // Creates a dark-grey horizontal platform at y=200, spanning the screen.
 * </pre></p>
 */
public class Block extends Blob {

    /** The width of the rectangle in pixels. Always positive. */
    protected float w;

    /** The height of the rectangle in pixels. Always positive. */
    protected float h;

    /**
     * Creates a stationary Block.
     * Negative values for width or height are automatically made positive.
     *
     * @param parent your Processing sketch — pass {@code this}
     * @param x      the x position of the top-left corner
     * @param y      the y position of the top-left corner
     * @param w      the width of the rectangle in pixels
     * @param h      the height of the rectangle in pixels
     * @param c      the fill color — use Processing's {@code color()} function
     */
    public Block(PApplet parent, float x, float y, float w, float h, int c) {
        super(parent, x, y, 0, c);
        this.w = Math.abs(w);
        this.h = Math.abs(h);
    }

    /**
     * Checks whether this Block is touching another Blob or Block.
     * Against another Block, the two rectangles are touching when they
     * overlap on both the x-axis and the y-axis. Against a circular Blob,
     * they are touching when the point on the rectangle closest to the
     * circle's center is within the circle's radius.
     *
     * @param other the Blob or Block to check against
     * @return {@code true} if the two shapes overlap or touch, {@code false} otherwise
     */
    @Override
    public boolean collidesWith(Blob other) {
        if (other instanceof Block) {
            Block b = (Block) other;
            return pos.x <= b.pos.x + b.w && b.pos.x <= pos.x + w
                && pos.y <= b.pos.y + b.h && b.pos.y <= pos.y + h;
        }
        float closestX = Math.max(pos.x, Math.min(other.pos.x, pos.x + w));
        float closestY = Math.max(pos.y, Math.min(other.pos.y, pos.y + h));
        float dx = other.pos.x - closestX;
        float dy = other.pos.y - closestY;
        return dx * dx + dy * dy <= other.radius * other.radius;
    }

    /**
     * Draws this Block as a filled rectangle with no outline.
     * Call this once per frame inside your {@code draw()} loop.
     */
    @Override
    public void drawSprite() {
        parent.fill(myColor);
        parent.noStroke();
        parent.rect(pos.x, pos.y, w, h);
    }
}
