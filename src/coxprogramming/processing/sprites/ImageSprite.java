package coxprogramming.processing.sprites;

import processing.core.PApplet;
import processing.core.PImage;

/**
 * A sprite that displays an image file instead of a drawn shape.
 *
 * <p>{@code ImageSprite} extends {@link Sprite} and works just like any other
 * sprite: it can move, wrap around the screen, follow the mouse, and so on,
 * but instead of drawing a circle or rectangle it draws a picture loaded from
 * a file.</p>
 *
 * <p>By default the image is drawn 100 by 100 pixels, centered on the sprite's
 * position, with no rotation. Use the size constructor or {@link #setSize(float, float)}
 * to change its displayed size. Use {@link #setRotation(float)} or
 * {@link #rotate(float)} to rotate the image in radians.</p>
 *
 * <p>Place your image file in your sketch's {@code data/} folder, then:
 * <pre>
 *   ImageSprite character = new ImageSprite(this, 200, 300, "hero.png");
 *   ImageSprite largeHero = new ImageSprite(this, 200, 300, "hero.png", 160, 120);
 * </pre></p>
 */
public class ImageSprite extends Sprite {

    /** The image displayed by this sprite. */
    protected PImage img;

    /** Width used when drawing the image. */
    protected float w;

    /** Height used when drawing the image. */
    protected float h;

    /** Rotation angle in radians. */
    protected float rotation;

    /**
     * Creates an ImageSprite at position (x, y) and loads its image from
     * a file. The file must be in the sketch's {@code data/} folder.
     * The image is drawn 100 by 100 pixels by default.
     *
     * @param parent   your Processing sketch; pass {@code this}
     * @param x        the starting x position (center of the image)
     * @param y        the starting y position (center of the image)
     * @param fileName the name of the image file, e.g. {@code "hero.png"}
     */
    public ImageSprite(PApplet parent, float x, float y, String fileName) {
        this(parent, x, y, fileName, 100, 100);
    }

    /**
     * Creates a square ImageSprite with a custom display size.
     *
     * @param parent   your Processing sketch; pass {@code this}
     * @param x        the starting x position (center of the image)
     * @param y        the starting y position (center of the image)
     * @param fileName the name of the image file, e.g. {@code "hero.png"}
     * @param size     the width and height to draw the image, in pixels
     */
    public ImageSprite(PApplet parent, float x, float y, String fileName, float size) {
        this(parent, x, y, fileName, size, size);
    }

    /**
     * Creates an ImageSprite with a custom display width and height.
     *
     * @param parent   your Processing sketch; pass {@code this}
     * @param x        the starting x position (center of the image)
     * @param y        the starting y position (center of the image)
     * @param fileName the name of the image file, e.g. {@code "hero.png"}
     * @param w        the width to draw the image, in pixels
     * @param h        the height to draw the image, in pixels
     */
    public ImageSprite(PApplet parent, float x, float y, String fileName, float w, float h) {
        super(parent, x, y);
        img = parent.loadImage(fileName);
        setSize(w, h);
        rotation = 0;
    }

    /**
     * Changes this sprite to a square display size.
     *
     * @param size the new width and height, in pixels
     */
    public void setSize(float size) {
        setSize(size, size);
    }

    /**
     * Changes this sprite's displayed size without changing the source image.
     *
     * @param w the new width, in pixels
     * @param h the new height, in pixels
     */
    public void setSize(float w, float h) {
        this.w = Math.abs(w);
        this.h = Math.abs(h);
    }

    /**
     * Sets this sprite's rotation angle.
     *
     * @param rotation the new angle in radians
     */
    public void setRotation(float rotation) {
        this.rotation = rotation;
    }

    /**
     * Adds to this sprite's current rotation angle.
     *
     * @param amount the amount to rotate in radians
     */
    public void rotate(float amount) {
        rotation += amount;
    }

    /**
     * Returns this sprite's current rotation angle in radians.
     *
     * @return the current rotation angle
     */
    public float getRotation() {
        return rotation;
    }

    /**
     * Draws the image centered on this sprite's current position.
     * The image is displayed at this sprite's configured size and rotation.
     * Call this once per frame inside your {@code draw()} loop.
     */
    @Override
    public void drawSprite() {
        parent.pushMatrix();
        parent.pushStyle();
        parent.translate(pos.x, pos.y);
        parent.rotate(rotation);
        parent.imageMode(PApplet.CENTER);
        parent.image(img, 0, 0, w, h);
        parent.popStyle();
        parent.popMatrix();
    }
}
