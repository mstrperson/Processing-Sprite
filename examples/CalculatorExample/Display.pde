/**
 * The number display at the top of the calculator.
 *
 * {@code Display} extends {@link Sprite} so it has a position and could
 * animate if needed (for example, a shake effect on error).  It holds a
 * String of text and renders it right-aligned inside a dark rounded rectangle,
 * as real calculators do.  The font size shrinks automatically if the number
 * becomes long so it always fits within the display area.
 */
class Display extends Sprite {

  /** Width of the display panel in pixels. */
  float w;

  /** Height of the display panel in pixels. */
  float h;

  /** The number or message currently shown on screen. */
  String displayText;

  /**
   * Creates a Display at position (x, y) showing the initial value "0".
   *
   * @param p the Processing sketch — pass {@code this}
   * @param x x position of the top-left corner
   * @param y y position of the top-left corner
   * @param w width of the display panel in pixels
   * @param h height of the display panel in pixels
   */
  Display(PApplet p, float x, float y, float w, float h) {
    super(p, x, y);
    this.w           = w;
    this.h           = h;
    this.displayText = "0";
  }

  /**
   * Replaces the text shown on the display.
   *
   * @param text the new value to display
   */
  void setText(String text) {
    this.displayText = text;
  }

  /**
   * Returns the text currently shown on the display.
   *
   * @return the current display string
   */
  String getText() {
    return displayText;
  }

  /**
   * Draws the display panel: a dark rounded rectangle with right-aligned
   * white text.  The font size is reduced automatically for longer numbers.
   * Call once per frame inside {@code draw()}.
   */
  void drawSprite() {
    parent.fill(0);
    parent.noStroke();
    parent.rect(pos.x, pos.y, w, h, 10);

    float fontSize = (displayText.length() > 9) ? 32 : 52;

    parent.fill(255);
    parent.textSize(fontSize);
    parent.textAlign(PApplet.RIGHT, PApplet.CENTER);
    parent.text(displayText, pos.x + w - 16, pos.y + h / 2 + 2);
  }
}
