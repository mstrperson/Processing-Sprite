package coxprogramming.processing.sprites;

import processing.core.PApplet;

/**
 * A circular sprite with a color and a radius.
 *
 * <p>{@code Blob} is the simplest concrete sprite — it draws itself as a
 * filled circle and can detect when it bumps into another {@code Blob}.
 * It extends {@link Sprite}, so it inherits all of the movement and
 * keyboard/mouse-control methods.</p>
 *
 * <p>Example:
 * <pre>
 *   Blob ball = new Blob(this, 200, 300, 25, color(255, 0, 0));
 *   // Creates a red circle of radius 25 at (200, 300).
 * </pre></p>
 */
public class Blob extends Sprite {

    /** The radius of the circle in pixels. */
    protected float radius;

    /** The fill color of the circle. */
    protected int myColor;

    /**
     * Creates a stationary Blob at position (x, y).
     *
     * @param parent your Processing sketch — pass {@code this}
     * @param x      the starting x position (center of the circle)
     * @param y      the starting y position (center of the circle)
     * @param r      the radius of the circle in pixels
     * @param c      the fill color — use Processing's {@code color()} function
     */
    public Blob(PApplet parent, float x, float y, float r, int c) {
        super(parent, x, y);
        radius = r;
        myColor = c;
    }

    /**
     * Creates a moving Blob at position (x, y) with a given velocity.
     *
     * @param parent your Processing sketch — pass {@code this}
     * @param x      the starting x position (center of the circle)
     * @param y      the starting y position (center of the circle)
     * @param r      the radius of the circle in pixels
     * @param dx     horizontal velocity in pixels per frame (positive = right)
     * @param dy     vertical velocity in pixels per frame (positive = down)
     * @param c      the fill color — use Processing's {@code color()} function
     */
    public Blob(PApplet parent, float x, float y, float r, float dx, float dy, int c) {
        super(parent, x, y, dx, dy);
        radius = r;
        myColor = c;
    }

    /**
     * Checks whether this Blob is touching another Blob.
     * Two circles are touching when the distance between their centers is
     * less than or equal to the sum of their radii.
     *
     * @param other the other Blob to check against
     * @return {@code true} if the two Blobs overlap or touch, {@code false} otherwise
     */
    public boolean collidesWith(Blob other) {
        return this.distanceTo(other) <= this.radius + other.radius;
    }

    /**
     * Draws this Blob as a filled circle centered at its current position.
     * Call this once per frame inside your {@code draw()} loop.
     */
    @Override
    public void drawSprite() {
        parent.fill(myColor);
        parent.ellipse(pos.x, pos.y, 2 * radius, 2 * radius);
    }
}
