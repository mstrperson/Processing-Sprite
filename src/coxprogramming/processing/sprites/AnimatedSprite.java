package coxprogramming.processing.sprites;

import java.util.ArrayList;

import processing.core.PApplet;

/**
 * A sprite that creates animation by showing one sprite frame at a time.
 *
 * <p>An animation is really a fast series of pictures. In SpriteGame, each
 * picture can be a regular {@link Sprite}. For example, a walking character
 * might have one sprite for "left foot forward" and another sprite for
 * "right foot forward." {@code AnimatedSprite} stores those sprites as frames
 * and draws only the current frame.</p>
 *
 * <p>{@code AnimatedSprite} extends {@link CompoundSprite}. That means it uses
 * the same group movement idea: when the animated sprite moves, all of its
 * frame sprites move with it and stay lined up. The difference is that a
 * {@code CompoundSprite} draws every child sprite, while an
 * {@code AnimatedSprite} draws only one child sprite at a time.</p>
 *
 * <p>{@code frameNumber} is the index of the frame being shown right now.
 * It starts at 0, so the first frame is frame 0, the second frame is frame 1,
 * and so on.</p>
 *
 * <p>{@code frameRate} is a ratio: game frames per animation frame. If
 * {@code frameRate} is 8, then each animation picture stays on the screen for
 * 8 calls to {@link #drawSprite()} before the next picture appears. Smaller
 * numbers animate faster. Larger numbers animate more slowly.</p>
 *
 * <p>Typical use:</p>
 *
 * <pre>
 * AnimatedSprite cloud = AnimatedSprite.FromSprite(frame0)
 *     .AddFrameSprite(frame1)
 *     .AddFrameSprite(frame2)
 *     .setFrameRate(10);
 *
 * cloud.setVelocity(1, 0);
 *
 * // In draw():
 * cloud.move();
 * cloud.drawSprite();
 * </pre>
 */
public class AnimatedSprite extends CompoundSprite {

    /**
     * Index of the frame currently being drawn.
     * The first frame is 0, not 1.
     */
    protected int frameNumber;

    /**
     * Game frames per animation frame.
     * A value of 8 means "hold each picture for 8 game frames."
     */
    protected int frameRate;

    /**
     * Counts how many game frames have passed since the animation last changed
     * to a new frame. Students usually do not need to change this directly.
     */
    protected int frameCounter;

    /**
     * Creates an empty AnimatedSprite at position (x, y).
     * You can add frames later with {@link #AddFrameSprite(Sprite)}.
     *
     * @param parent your Processing sketch; pass {@code this}
     * @param x      the starting x position of the animation anchor
     * @param y      the starting y position of the animation anchor
     */
    public AnimatedSprite(PApplet parent, float x, float y) {
        super(parent, x, y);
        frameNumber = 0;
        frameCounter = 0;
        frameRate = 8;
    }

    /**
     * Creates an empty AnimatedSprite at position (x, y) with a starting
     * group velocity. Every frame sprite added later will receive this group
     * velocity, so all frames move together.
     *
     * @param parent your Processing sketch; pass {@code this}
     * @param x      the starting x position of the animation anchor
     * @param y      the starting y position of the animation anchor
     * @param dx     horizontal group velocity in pixels per frame
     * @param dy     vertical group velocity in pixels per frame
     */
    public AnimatedSprite(PApplet parent, float x, float y, float dx, float dy) {
        super(parent, x, y, dx, dy);
        frameNumber = 0;
        frameCounter = 0;
        frameRate = 8;
    }

    // -------------------------------------------------------------------------
    // Builder methods
    // -------------------------------------------------------------------------

    /**
     * Starts an AnimatedSprite from a first frame sprite.
     *
     * <p>This is the easiest way to build an animation. The new
     * {@code AnimatedSprite} uses the first frame's position as its own anchor
     * point. Add more frames by chaining {@link #AddFrameSprite(Sprite)}.</p>
     *
     * @param s the first sprite frame
     * @return a new AnimatedSprite containing {@code s} as frame 0
     */
    public static AnimatedSprite FromSprite(Sprite s) {
        if (s == null) {
            throw new IllegalArgumentException("AnimatedSprite.FromSprite requires a non-null Sprite");
        }
        return new AnimatedSprite(s.parent, s.pos.x, s.pos.y).AddFrameSprite(s);
    }

    /**
     * Standard Java-style alias for {@link #FromSprite(Sprite)}.
     * It does exactly the same thing, but starts with a lowercase letter.
     *
     * @param s the first sprite frame
     * @return a new AnimatedSprite containing {@code s} as frame 0
     */
    public static AnimatedSprite fromSprite(Sprite s) {
        return FromSprite(s);
    }

    /**
     * Adds a sprite as the next animation frame and returns {@code this}.
     *
     * <p>Frame sprites use normal screen positions, just like sprites inside a
     * {@link CompoundSprite}. Place each frame where it should appear before
     * adding it. Most animations use frames that start at the same position, so
     * switching frames does not make the picture jump.</p>
     *
     * <p>The method returns this same {@code AnimatedSprite}, so calls can be
     * chained together in one readable setup statement.</p>
     *
     * @param s the sprite frame to add
     * @return this AnimatedSprite, for chaining
     */
    public AnimatedSprite AddFrameSprite(Sprite s) {
        if (s == null) {
            throw new IllegalArgumentException("AnimatedSprite.AddFrameSprite requires a non-null Sprite");
        }
        super.addSprite(s);
        return this;
    }

    /**
     * Standard Java-style alias for {@link #AddFrameSprite(Sprite)}.
     * It does exactly the same thing, but starts with a lowercase letter.
     *
     * @param s the sprite frame to add
     * @return this AnimatedSprite, for chaining
     */
    public AnimatedSprite addFrameSprite(Sprite s) {
        return AddFrameSprite(s);
    }

    // -------------------------------------------------------------------------
    // Animation state
    // -------------------------------------------------------------------------

    /**
     * Sets how many game frames each animation frame stays visible.
     *
     * <p>Example: if your sketch draws 60 game frames per second and this value
     * is 10, the animation changes pictures 6 times per second. Values less
     * than 1 are treated as 1 because an animation frame must stay visible for
     * at least one game frame.</p>
     *
     * @param frameRate game frames per animation frame
     * @return this AnimatedSprite, for chaining
     */
    public AnimatedSprite setFrameRate(int frameRate) {
        this.frameRate = Math.max(1, frameRate);
        return this;
    }

    /**
     * Returns how many game frames each animation frame stays visible.
     * This is the same value set by {@link #setFrameRate(int)}.
     *
     * @return game frames per animation frame
     */
    public int getFrameRate() {
        return frameRate;
    }

    /**
     * Sets the current animation frame.
     *
     * <p>The value wraps into the valid range. For example, if there are
     * 4 frames, setting frame 5 will show frame 1. This keeps the animation
     * from crashing when a number is too large or too small.</p>
     *
     * @param frameNumber the new frame index, starting at 0
     * @return this AnimatedSprite, for chaining
     */
    public AnimatedSprite setFrameNumber(int frameNumber) {
        ArrayList<Sprite> frames = getSprites();
        if (frames.isEmpty()) {
            this.frameNumber = 0;
        } else {
            this.frameNumber = Math.floorMod(frameNumber, frames.size());
        }
        frameCounter = 0;
        return this;
    }

    /**
     * Returns the current animation frame index, starting at 0.
     * This is useful for debugging or for showing animation state on screen.
     *
     * @return current frame index
     */
    public int getFrameNumber() {
        return frameNumber;
    }

    /**
     * Returns the sprites used as animation frames.
     * The first sprite in the list is frame 0.
     *
     * @return the frame sprite list
     */
    public ArrayList<Sprite> getFrameSprites() {
        return getSprites();
    }

    /**
     * Returns the number of sprites in this animation.
     * This is the total number of animation frames.
     *
     * @return frame count
     */
    public int getFrameCount() {
        return getSprites().size();
    }

    /**
     * Manually advances to the next animation frame.
     *
     * <p>Most sketches do not need this because {@link #drawSprite()} advances
     * the animation automatically. Use this method when you want button presses,
     * mouse clicks, or other game events to control the frame yourself.</p>
     *
     * @return this AnimatedSprite, for chaining
     */
    public AnimatedSprite nextFrame() {
        if (!getSprites().isEmpty()) {
            frameNumber = (frameNumber + 1) % getSprites().size();
        }
        frameCounter = 0;
        return this;
    }

    /**
     * Manually moves to the previous animation frame.
     * Like {@link #nextFrame()}, this is useful when game events should control
     * the animation frame directly.
     *
     * @return this AnimatedSprite, for chaining
     */
    public AnimatedSprite previousFrame() {
        if (!getSprites().isEmpty()) {
            frameNumber = Math.floorMod(frameNumber - 1, getSprites().size());
        }
        frameCounter = 0;
        return this;
    }

    /**
     * Draws the current frame sprite, then advances the animation clock.
     *
     * <p>Call this once per game frame inside Processing's {@code draw()}
     * function. If no frame sprites have been added yet, this method simply
     * returns without drawing anything.</p>
     */
    @Override
    public void drawSprite() {
        ArrayList<Sprite> frames = getSprites();
        if (frames.isEmpty()) {
            return;
        }

        if (frameNumber >= frames.size()) {
            frameNumber = 0;
        }

        frames.get(frameNumber).drawSprite();
        advanceAnimationClock();
    }

    /**
     * Updates the current frame after enough game frames have passed.
     * This helper is protected because it is part of how the class works
     * internally, not something most students need to call.
     */
    protected void advanceAnimationClock() {
        if (getSprites().size() <= 1) {
            return;
        }

        frameCounter++;
        if (frameCounter >= frameRate) {
            frameCounter = 0;
            frameNumber = (frameNumber + 1) % getSprites().size();
        }
    }
}
