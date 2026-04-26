package coxprogramming.processing.sprites;

import processing.core.PApplet;

/**
 * The base class for every sprite in the game.
 *
 * <p>A <em>sprite</em> is any object that lives on the screen, has a position,
 * and knows how to draw itself. {@code Sprite} is <em>abstract</em>, meaning
 * you cannot create a {@code Sprite} directly — instead you create a subclass
 * like {@link Blob} or {@link Block} that fills in the {@link #drawSprite()}
 * method with the actual drawing code.</p>
 *
 * <p>Every sprite stores its position and velocity as {@link Vector2D} objects.
 * What happens when a sprite reaches the edge of the screen is controlled by
 * the static {@link #screenBehavior} field — change it once in {@code setup()}
 * and every sprite obeys it automatically.</p>
 *
 * <p>Pass your sketch's {@code this} reference as the first argument to any
 * constructor so the sprite can access screen dimensions and draw itself:
 * <pre>
 *   Blob b = new Blob(this, 100, 200, 30, color(255, 0, 0));
 * </pre></p>
 */
public abstract class Sprite {

    /**
     * A reference to the Processing sketch that owns this sprite.
     * Used to call drawing functions and read screen size, mouse position, etc.
     */
    protected PApplet parent;

    /** The sprite's current position on the screen. */
    protected Vector2D pos;

    /** The sprite's current velocity — how far it moves each frame. */
    protected Vector2D vel;

    /**
     * Controls what happens to every sprite when it reaches the edge of the screen.
     * Change this once in your sketch's {@code setup()} and all sprites obey it.
     *
     * <ul>
     *   <li>{@link ScreenBehavior#Wrapping}    — sprite exits one edge and re-enters the opposite (default)</li>
     *   <li>{@link ScreenBehavior#HardWalls}   — sprite stops at the edge and velocity on that axis is zeroed</li>
     *   <li>{@link ScreenBehavior#BouncyWalls} — sprite bounces by reversing the relevant velocity component</li>
     *   <li>{@link ScreenBehavior#NoWalls}     — sprite moves freely and can travel off-screen</li>
     * </ul>
     *
     * <p>Example:</p>
     * <pre>
     *   void setup() {
     *     Sprite.screenBehavior = ScreenBehavior.BouncyWalls;
     *   }
     * </pre>
     */
    public static ScreenBehavior screenBehavior = ScreenBehavior.Wrapping;

    /**
     * Creates a sprite at position (x, y) with no initial velocity.
     *
     * @param parent your Processing sketch — pass {@code this}
     * @param x      the starting x position (pixels from the left edge)
     * @param y      the starting y position (pixels from the top edge)
     */
    public Sprite(PApplet parent, float x, float y) {
        this.parent = parent;
        pos = new Vector2D(x, y);
        vel = new Vector2D(0, 0);
    }

    /**
     * Creates a sprite at position (x, y) with a given starting velocity.
     *
     * @param parent your Processing sketch — pass {@code this}
     * @param x      the starting x position
     * @param y      the starting y position
     * @param dx     horizontal velocity in pixels per frame (positive = right)
     * @param dy     vertical velocity in pixels per frame (positive = down)
     */
    public Sprite(PApplet parent, float x, float y, float dx, float dy) {
        this.parent = parent;
        pos = new Vector2D(x, y);
        vel = new Vector2D(dx, dy);
    }

    /**
     * Creates a sprite at the position given by a {@link Vector2D},
     * with no initial velocity.
     *
     * @param parent your Processing sketch — pass {@code this}
     * @param s      the starting position as a Vector2D
     */
    public Sprite(PApplet parent, Vector2D s) {
        this.parent = parent;
        pos = s;
        vel = new Vector2D(0, 0);
    }

    /**
     * Instantly moves the sprite to the position described by {@code newPosition}.
     *
     * @param newPosition the new position as a Vector2D
     */
    public void moveTo(Vector2D newPosition) {
        pos = newPosition;
    }

    /**
     * Instantly moves the sprite to the coordinates (x, y).
     *
     * @param x the new x position
     * @param y the new y position
     */
    public void moveTo(float x, float y) {
        pos.x = x;
        pos.y = y;
    }

    /**
     * Sets the sprite's velocity to the given {@link Vector2D}.
     * The velocity controls how far the sprite moves each time
     * {@link #move()} is called.
     *
     * @param newVelocity the new velocity as a Vector2D
     */
    public void setVelocity(Vector2D newVelocity) {
        vel = newVelocity;
    }

    /**
     * Sets the sprite's velocity using separate x and y values.
     *
     * @param dx the new horizontal speed (pixels per frame; positive = right)
     * @param dy the new vertical speed  (pixels per frame; positive = down)
     */
    public void setVelocity(float dx, float dy) {
        vel.x = dx;
        vel.y = dy;
    }

    /**
     * Moves the sprite forward one step by adding its velocity to its position,
     * then applies the current {@link #screenBehavior} to handle screen edges.
     * Call this once per frame inside your {@code draw()} loop.
     */
    public void move() {
        pos = pos.add(vel);

        switch (screenBehavior) {
            case Wrapping:
                if (pos.x > parent.width)  pos.x -= parent.width;
                if (pos.x < 0)             pos.x += parent.width;
                if (pos.y > parent.height) pos.y -= parent.height;
                if (pos.y < 0)             pos.y += parent.height;
                break;

            case HardWalls:
                if (pos.x > parent.width)  { pos.x = parent.width;  vel.x = 0; }
                if (pos.x < 0)             { pos.x = 0;             vel.x = 0; }
                if (pos.y > parent.height) { pos.y = parent.height; vel.y = 0; }
                if (pos.y < 0)             { pos.y = 0;             vel.y = 0; }
                break;

            case BouncyWalls:
                if (pos.x > parent.width)  { pos.x = parent.width;  vel.x = -vel.x; }
                if (pos.x < 0)             { pos.x = 0;             vel.x = -vel.x; }
                if (pos.y > parent.height) { pos.y = parent.height; vel.y = -vel.y; }
                if (pos.y < 0)             { pos.y = 0;             vel.y = -vel.y; }
                break;

            case NoWalls:
                // No boundary enforcement — sprites move freely off-screen.
                break;
        }
    }

    /**
     * Returns the sprite's current position as a {@link Vector2D}.
     *
     * @return the position vector
     */
    public Vector2D getPosition() {
        return pos;
    }

    /**
     * Returns the sprite's current velocity as a {@link Vector2D}.
     *
     * @return the velocity vector
     */
    public Vector2D getVelocity() {
        return vel;
    }

    /**
     * Lets the player move this sprite with the arrow keys.
     * Call this inside your sketch's {@code keyPressed()} function.
     * The sprite will move at 5 pixels per frame in the pressed direction,
     * and stop when any other key is pressed.
     *
     * <p>Example usage:
     * <pre>
     *   void keyPressed() {
     *     player.keyboardControl();
     *   }
     * </pre></p>
     */
    public void keyboardControl() {
        switch (parent.keyCode) {
            case PApplet.UP:    vel.y = -5; vel.x =  0; break;
            case PApplet.DOWN:  vel.y =  5; vel.x =  0; break;
            case PApplet.LEFT:  vel.y =  0; vel.x = -5; break;
            case PApplet.RIGHT: vel.y =  0; vel.x =  5; break;
            default:            vel.x =  0; vel.y =  0; break;
        }
    }

    /**
     * Moves the sprite toward the mouse cursor at the sprite's current speed.
     * The sprite travels in a straight line toward wherever the mouse is right now.
     * Call this inside {@code draw()} to create a "follow the mouse" effect.
     *
     * <p><strong>Note:</strong> if the sprite's speed is 0, it will not move.
     * Set a velocity first with {@link #setVelocity(float, float)}.</p>
     */
    public void followMouse() {
        float speed = vel.mag();
        Vector2D mLoc = new Vector2D(parent.mouseX, parent.mouseY);
        Vector2D mDir = mLoc.subtract(pos);
        pos = pos.add(mDir.unitVector().scale(speed));
    }

    /**
     * Returns the straight-line distance in pixels between the center of
     * this sprite and the center of {@code other}.
     *
     * @param other the sprite to measure to
     * @return the distance in pixels
     */
    public float distanceTo(Sprite other) {
        return other.pos.subtract(this.pos).mag();
    }

    /**
     * Draws this sprite on the screen.
     * Every subclass <strong>must</strong> provide its own version of this method
     * that contains the actual drawing code (shapes, images, etc.).
     * Call this once per frame inside your {@code draw()} loop.
     */
    public abstract void drawSprite();
}
