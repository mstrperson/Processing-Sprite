package coxprogramming.processing.sprites;

import processing.core.PApplet;
import processing.core.PImage;

/**
 * A sprite that displays an image file instead of a drawn shape.
 *
 * <p>{@code ImageSprite} extends {@link Sprite} and works just like any other
 * sprite — it can move, wrap around the screen, follow the mouse, and so on —
 * but instead of drawing a circle or rectangle it draws a picture loaded from
 * a file.</p>
 *
 * <p>The image is automatically resized to 100×100 pixels and drawn
 * centered on the sprite's position.</p>
 *
 * <p>Place your image file in your sketch's {@code data/} folder, then:
 * <pre>
 *   ImageSprite character = new ImageSprite(this, 200, 300, "hero.png");
 * </pre></p>
 */
public class ImageSprite extends Sprite {

    /** The image displayed by this sprite. */
    protected PImage img;

    /**
     * Creates an ImageSprite at position (x, y) and loads its image from
     * a file. The file must be in the sketch's {@code data/} folder.
     *
     * @param parent   your Processing sketch — pass {@code this}
     * @param x        the starting x position (center of the image)
     * @param y        the starting y position (center of the image)
     * @param fileName the name of the image file, e.g. {@code "hero.png"}
     */
    public ImageSprite(PApplet parent, float x, float y, String fileName) {
        super(parent, x, y);
        img = parent.loadImage(fileName);
    }

    /**
     * Draws the image centered on this sprite's current position.
     * The image is resized to 100×100 pixels each frame.
     * Call this once per frame inside your {@code draw()} loop.
     */
    @Override
    public void drawSprite() {
        img.resize(100, 100);
        parent.image(img, pos.x - 50, pos.y - 50);
    }
}
