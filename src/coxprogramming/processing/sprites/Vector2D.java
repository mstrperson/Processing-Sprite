package coxprogramming.processing.sprites;

/**
 * A 2D vector — a pair of numbers (x, y) that can represent either a
 * <em>position</em> (a point on the screen) or a <em>direction with speed</em>
 * (like "move 3 pixels right and 2 pixels down each frame").
 *
 * <p>Every method returns a <em>new</em> Vector2D rather than changing the
 * original, so you can chain calculations without worrying about overwriting
 * values you still need.</p>
 *
 * <p>Example — move a point one step along a direction:
 * <pre>
 *   Vector2D position  = new Vector2D(100, 200);
 *   Vector2D velocity  = new Vector2D(3, -1);
 *   Vector2D nextFrame = position.add(velocity);
 * </pre></p>
 */
public class Vector2D {

    /** The horizontal component. Positive x points to the right. */
    public float x;

    /** The vertical component. Positive y points downward (Processing convention). */
    public float y;

    /**
     * Creates a new Vector2D with the given x and y values.
     *
     * @param x the horizontal component
     * @param y the vertical component
     */
    public Vector2D(float x, float y) {
        this.x = x;
        this.y = y;
    }

    // -------------------------------------------------------------------------
    // Static factory methods
    // -------------------------------------------------------------------------

    /**
     * Creates a Vector2D from rectangular (Cartesian) coordinates.
     * This is an alternative to calling {@code new Vector2D(x, y)} directly,
     * and makes the intent explicit when working alongside {@link #FromPolar}.
     *
     * <p>Example:
     * <pre>
     *   Vector2D vel = Vector2D.FromXY(3, -2); // 3 right, 2 up
     * </pre></p>
     *
     * @param x the horizontal component
     * @param y the vertical component
     * @return a new Vector2D with the given x and y
     */
    public static Vector2D FromXY(float x, float y) {
        return new Vector2D(x, y);
    }

    /**
     * Creates a Vector2D from <em>polar coordinates</em> — a distance and an angle.
     * Polar coordinates describe a vector by saying "go this far in this direction"
     * rather than "go this far right and this far down".
     *
     * <p>The angle is measured in radians from the positive x-axis (pointing right),
     * counter-clockwise. Because Processing's y-axis points downward, an angle of
     * {@code 0} points right, and an angle of {@code PI/2} points down.</p>
     *
     * <p>Example — a velocity of speed 5 pointing at 45 degrees:
     * <pre>
     *   Vector2D vel = Vector2D.FromPolar(5, PI / 4);
     * </pre></p>
     *
     * @param r     the magnitude (length) of the vector — how far from the origin
     * @param theta the angle in radians
     * @return a new Vector2D with the equivalent x and y components
     */
    public static Vector2D FromPolar(float r, float theta) {
        return new Vector2D(
            r * (float) Math.cos(theta),
            r * (float) Math.sin(theta)
        );
    }

    /**
     * Adds this vector to {@code other} and returns the result.
     * Think of it as combining two movements: if you walk 3 steps east
     * then 2 steps east, you end up 5 steps east.
     *
     * @param other the vector to add
     * @return a new Vector2D equal to (this.x + other.x, this.y + other.y)
     */
    public Vector2D add(Vector2D other) {
        return new Vector2D(this.x + other.x, this.y + other.y);
    }

    /**
     * Subtracts {@code other} from this vector and returns the result.
     * This is useful for finding the direction <em>from</em> one point
     * <em>to</em> another: {@code target.subtract(myPosition)} points
     * from you toward the target.
     *
     * @param other the vector to subtract
     * @return a new Vector2D equal to (this.x - other.x, this.y - other.y)
     */
    public Vector2D subtract(Vector2D other) {
        return new Vector2D(this.x - other.x, this.y - other.y);
    }

    /**
     * Returns the <em>magnitude</em> (length) of this vector.
     * Calculated using the Pythagorean theorem: sqrt(x² + y²).
     * If this vector represents a velocity, {@code mag()} is the speed.
     *
     * @return the length of this vector as a non-negative float
     */
    public float mag() {
        return (float) Math.sqrt(x * x + y * y);
    }

    /**
     * Computes the <em>dot product</em> of this vector and {@code other}.
     * The dot product tells you how much two vectors point in the same
     * direction. A result of 0 means they are perpendicular; a large
     * positive number means they point in very similar directions.
     *
     * @param other the other vector
     * @return the dot product as a float
     */
    public float dotProduct(Vector2D other) {
        return this.x * other.x + this.y * other.y;
    }

    /**
     * Returns the <em>additive inverse</em> of this vector — the same
     * length but pointing in the exact opposite direction.
     * For example, the inverse of (3, -2) is (-3, 2).
     *
     * @return a new Vector2D pointing in the opposite direction
     */
    public Vector2D inverse() {
        return new Vector2D(-x, -y);
    }

    /**
     * Multiplies both components by {@code m}, making the vector longer
     * or shorter without changing its direction.
     * Use a value between 0 and 1 to shrink it, or greater than 1 to grow it.
     * A negative value also flips the direction.
     *
     * @param m the scaling factor
     * @return a new Vector2D scaled by {@code m}
     */
    public Vector2D scale(float m) {
        return new Vector2D(m * x, m * y);
    }

    /**
     * Returns a <em>unit vector</em> — a vector pointing in the same
     * direction as this one but with a length of exactly 1.
     * This is handy when you want to move at a fixed speed toward a target:
     * get the direction vector, call {@code unitVector()}, then
     * {@code scale(speed)}.
     *
     * <p><strong>Note:</strong> calling this on a zero-length vector
     * (0, 0) will cause a division-by-zero error.</p>
     *
     * @return a new unit Vector2D in the same direction
     */
    public Vector2D unitVector() {
        float m = this.mag();
        return new Vector2D(x / m, y / m);
    }

    /**
     * Returns a vector that is perpendicular (at a 90-degree right angle)
     * to this one, rotated clockwise.
     *
     * @return a new Vector2D perpendicular to this one
     */
    public Vector2D perpendicular() {
        return new Vector2D(y, -x);
    }

    /**
     * Returns the angle this vector makes with the positive x-axis,
     * in radians. This is a helper used internally by {@link #angleTo}.
     *
     * @return the angle in radians
     */
    protected float theta() {
        return (float) Math.atan(y / x);
    }

    /**
     * Returns the angle in radians you would need to rotate this vector
     * to point in the same direction as {@code other}.
     * A positive result means rotate counter-clockwise.
     *
     * @param other the target vector
     * @return the angle between the two vectors in radians
     */
    public float angleTo(Vector2D other) {
        return other.theta() - this.theta();
    }

    /**
     * Rotates this vector by {@code rads} radians around the origin and
     * returns the result. Positive values rotate counter-clockwise.
     * Uses the standard 2D rotation formula.
     *
     * @param rads the angle to rotate by, in radians
     * @return a new rotated Vector2D
     */
    public Vector2D rotate(float rads) {
        float nx = (float) (Math.cos(rads) * x - Math.sin(rads) * y);
        float ny = (float) (Math.sin(rads) * x + Math.cos(rads) * y);
        return new Vector2D(nx, ny);
    }
}
