package coxprogramming.processing.sprites;

import processing.core.PApplet;
import java.util.ArrayList;

/**
 * A sprite made up of multiple other sprites that move together as a group.
 *
 * <p>A {@code CompoundSprite} acts as a container. You add child sprites to it,
 * and from then on they all move in concert whenever the compound moves.
 * Each child can still have its own independent velocity on top of the group
 * velocity — for example, an orbiting moon that also drifts across the screen,
 * or eyes on a character that blink while the character walks.</p>
 *
 * <p>{@code CompoundSprite} uses a builder pattern so you can set it up in one
 * readable chain of calls:
 * <pre>
 *   CompoundSprite player = new CompoundSprite(this, 200, 300)
 *       .addSprite(body)
 *       .addSprite(head)
 *       .addSprite(leftArm)
 *       .addSprite(rightArm);
 *
 *   player.setVelocity(3, 0); // the whole character walks right
 * </pre></p>
 *
 * <h3>How velocity works</h3>
 * <p>When you call {@link #setVelocity(float, float)} on the compound,
 * the <em>change</em> in velocity is applied to every child so they all gain
 * (or lose) exactly the same velocity shift. This means a child's
 * independent velocity is always preserved:
 * <pre>
 *   // Give a child its own upward drift before adding it
 *   moon.setVelocity(0, -1);        // moon drifts up on its own
 *   system.addSprite(moon);
 *   system.setVelocity(2, 0);       // whole system moves right
 *   // moon now has vel (2, -1): group velocity + its own drift
 * </pre></p>
 *
 * <h3>Positions</h3>
 * <p>Each child's position is absolute (in screen pixels). When you create a
 * compound sprite, place the children at their desired starting positions
 * before calling {@link #addSprite}. Methods that translate the whole group
 * ({@link #move()}, {@link #moveTo(float, float)}, {@link #followMouse()})
 * will keep all children in formation.</p>
 */
public class CompoundSprite extends Sprite {

    /** The child sprites that belong to this compound. */
    private ArrayList<Sprite> children;

    /**
     * Creates a CompoundSprite at position (x, y) with no initial velocity.
     *
     * @param parent your Processing sketch — pass {@code this}
     * @param x      the starting x position of the compound's anchor point
     * @param y      the starting y position of the compound's anchor point
     */
    public CompoundSprite(PApplet parent, float x, float y) {
        super(parent, x, y);
        children = new ArrayList<Sprite>();
    }

    /**
     * Creates a CompoundSprite at position (x, y) with a given starting velocity.
     * The velocity is not automatically applied to children until you call
     * {@link #addSprite} — children added later will receive the current velocity.
     *
     * @param parent your Processing sketch — pass {@code this}
     * @param x      the starting x position
     * @param y      the starting y position
     * @param dx     horizontal velocity in pixels per frame
     * @param dy     vertical velocity in pixels per frame
     */
    public CompoundSprite(PApplet parent, float x, float y, float dx, float dy) {
        super(parent, x, y, dx, dy);
        children = new ArrayList<Sprite>();
    }

    // -------------------------------------------------------------------------
    // Builder methods
    // -------------------------------------------------------------------------

    /**
     * Adds a child sprite to this compound and returns {@code this} so calls
     * can be chained. The compound's current group velocity is immediately
     * added to the child's velocity so it moves in sync from the first frame.
     *
     * @param s the sprite to add
     * @return this CompoundSprite, for chaining
     */
    public CompoundSprite addSprite(Sprite s) {
        s.vel.x += vel.x;
        s.vel.y += vel.y;
        children.add(s);
        return this;
    }

    /**
     * Removes a child sprite from this compound and returns {@code this} so
     * calls can be chained. The compound's current group velocity is subtracted
     * from the child's velocity, restoring its original independent motion.
     *
     * @param s the sprite to remove
     * @return this CompoundSprite, for chaining
     */
    public CompoundSprite removeSprite(Sprite s) {
        if (children.remove(s)) {
            s.vel.x -= vel.x;
            s.vel.y -= vel.y;
        }
        return this;
    }

    /**
     * Returns the list of child sprites belonging to this compound.
     * You can use this to access individual children and adjust their
     * independent velocities.
     *
     * @return the list of child sprites
     */
    public ArrayList<Sprite> getSprites() {
        return children;
    }

    // -------------------------------------------------------------------------
    // Velocity — propagate the change to all children
    // -------------------------------------------------------------------------

    /**
     * Sets the group velocity and applies the velocity <em>change</em> to
     * every child sprite, so each child gains or loses the same amount.
     * A child's own independent velocity is preserved on top of the group velocity.
     *
     * <p>For example, if a child has velocity (1, -2) and the group velocity
     * changes from (0, 0) to (3, 0), the child will end up with (4, -2).</p>
     *
     * @param dx the new horizontal group velocity
     * @param dy the new vertical group velocity
     */
    @Override
    public void setVelocity(float dx, float dy) {
        float ddx = dx - vel.x;
        float ddy = dy - vel.y;
        super.setVelocity(dx, dy);
        for (Sprite child : children) {
            child.vel.x += ddx;
            child.vel.y += ddy;
        }
    }

    /**
     * Sets the group velocity from a {@link Vector2D} and applies the change
     * to every child sprite. See {@link #setVelocity(float, float)} for
     * a full explanation.
     *
     * @param newVelocity the new group velocity
     */
    @Override
    public void setVelocity(Vector2D newVelocity) {
        setVelocity(newVelocity.x, newVelocity.y);
    }

    // -------------------------------------------------------------------------
    // Movement — translate the whole group
    // -------------------------------------------------------------------------

    /**
     * Moves the compound sprite forward one step by its velocity, wraps it
     * around the screen edges if needed, then calls {@code move()} on every
     * child. Because each child already carries the group velocity as part of
     * its own velocity (added when {@link #setVelocity} was called), all
     * children automatically stay in formation.
     */
    @Override
    public void move() {
        super.move();
        for (Sprite child : children) {
            child.move();
        }
    }

    /**
     * Instantly moves the whole group to (x, y). The compound jumps to the
     * new position and every child is translated by the same offset, keeping
     * all relative positions intact.
     *
     * @param x the new x position for the compound's anchor
     * @param y the new y position for the compound's anchor
     */
    @Override
    public void moveTo(float x, float y) {
        float dx = x - pos.x;
        float dy = y - pos.y;
        super.moveTo(x, y);
        for (Sprite child : children) {
            child.pos.x += dx;
            child.pos.y += dy;
        }
    }

    /**
     * Instantly moves the whole group to the given position vector.
     * See {@link #moveTo(float, float)} for details.
     *
     * @param newPosition the new anchor position
     */
    @Override
    public void moveTo(Vector2D newPosition) {
        moveTo(newPosition.x, newPosition.y);
    }

    /**
     * Moves the whole group toward the mouse cursor at the current speed,
     * keeping all children in formation. If the group's speed is 0,
     * nothing moves — set a velocity first with
     * {@link #setVelocity(float, float)}.
     */
    @Override
    public void followMouse() {
        float oldX = pos.x, oldY = pos.y;
        super.followMouse();
        float dx = pos.x - oldX;
        float dy = pos.y - oldY;
        for (Sprite child : children) {
            child.pos.x += dx;
            child.pos.y += dy;
        }
    }

    /**
     * Reads arrow-key input and updates the group velocity accordingly,
     * propagating the velocity change to every child. Call this inside
     * your sketch's {@code keyPressed()} function.
     */
    @Override
    public void keyboardControl() {
        float oldDx = vel.x, oldDy = vel.y;
        super.keyboardControl();
        float ddx = vel.x - oldDx;
        float ddy = vel.y - oldDy;
        for (Sprite child : children) {
            child.vel.x += ddx;
            child.vel.y += ddy;
        }
    }

    // -------------------------------------------------------------------------
    // Drawing
    // -------------------------------------------------------------------------

    /**
     * Draws every child sprite in the order they were added.
     * The compound itself has no visual appearance — it is only a container.
     * Call this once per frame inside your {@code draw()} loop.
     */
    @Override
    public void drawSprite() {
        for (Sprite child : children) {
            child.drawSprite();
        }
    }
}
