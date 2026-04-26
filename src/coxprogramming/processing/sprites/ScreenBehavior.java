package coxprogramming.processing.sprites;

/**
 * Controls how sprites behave when they reach the edge of the screen.
 *
 * <p>Set the behavior once, and every sprite in the sketch obeys it
 * automatically when {@link Sprite#move()} is called:</p>
 *
 * <pre>
 *   // At the top of setup():
 *   Sprite.screenBehavior = ScreenBehavior.BouncyWalls;
 * </pre>
 *
 * <p>Changing {@code Sprite.screenBehavior} affects all sprites immediately,
 * so you can switch modes mid-game if you want.</p>
 */
public enum ScreenBehavior {

    /**
     * Sprites wrap around: leaving one edge brings them back on the opposite side.
     * This is the default behavior.
     */
    Wrapping,

    /**
     * Sprites stop dead when they hit an edge and their velocity is zeroed
     * on that axis.  They can still be moved away from the wall by giving
     * them a new velocity.
     */
    HardWalls,

    /**
     * Sprites bounce off the edges by reversing the relevant component of
     * their velocity — like a ball bouncing off a wall.
     */
    BouncyWalls,

    /**
     * Sprites ignore the edges completely and can travel off-screen without
     * any constraint.
     */
    NoWalls
}
