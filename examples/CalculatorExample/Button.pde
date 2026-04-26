/**
 * A rectangular {@link Sprite} that fires an {@link Action} when clicked.
 *
 * {@code Button} demonstrates the <em>Strategy pattern</em>: the button
 * itself does not know or care what happens when it is clicked.  You supply
 * that behaviour by calling {@link #onClicked(Action)} with a lambda — one
 * line of code that says exactly what to do.  This keeps {@code Button}
 * completely reusable; the same class powers every key on the calculator
 * without any special cases inside it.
 *
 * Because {@code Button} extends {@link Sprite} it could also move, follow
 * the mouse, or respond to keyboard input — though in this calculator it
 * stays still.
 */
class Button extends Sprite {

  /** Width of the button in pixels. */
  float w;

  /** Height of the button in pixels. */
  float h;

  /** The label text drawn on the button face. */
  String label;

  /** Background fill color of the button. */
  color bgColor;

  /** Color of the label text. */
  color textColor;

  /** The strategy — the code that runs when this button is clicked. */
  Action clickAction;

  /**
   * Creates a button at position (x, y) with the given dimensions, label,
   * and colors.  Call {@link #onClicked(Action)} afterwards to attach the
   * click behaviour.
   *
   * @param p         the Processing sketch — pass {@code this}
   * @param x         x position of the top-left corner
   * @param y         y position of the top-left corner
   * @param w         button width in pixels
   * @param h         button height in pixels
   * @param label     text shown on the button face
   * @param bg        background fill color
   * @param textColor label text color
   */
  Button(PApplet p, float x, float y, float w, float h,
         String label, color bg, color textColor) {
    super(p, x, y);
    this.w         = w;
    this.h         = h;
    this.label     = label;
    this.bgColor   = bg;
    this.textColor = textColor;
  }

  /**
   * Attaches an {@link Action} (the strategy) to this button and returns
   * {@code this} so the call can be chained directly onto the constructor.
   *
   * <pre>
   *   new Button(this, x, y, w, h, "7", grey, white)
   *       .onClicked(() -> digitPressed("7"));
   * </pre>
   *
   * @param action the action to execute when this button is clicked
   * @return this Button, for chaining
   */
  Button onClicked(Action action) {
    this.clickAction = action;
    return this;
  }

  /**
   * Tests whether the point (mx, my) is inside this button's bounds, and if
   * so executes the attached {@link Action}.  Call from {@code mousePressed()}
   * in the main sketch, passing in {@code mouseX} and {@code mouseY}.
   *
   * @param mx mouse x coordinate to test
   * @param my mouse y coordinate to test
   */
  void handleClick(float mx, float my) {
    if (mx >= pos.x && mx <= pos.x + w &&
        my >= pos.y && my <= pos.y + h) {
      if (clickAction != null) {
        clickAction.execute();
      }
    }
  }

  /**
   * Returns {@code true} if the mouse cursor is currently over this button.
   * Used by {@link #drawSprite()} to apply a hover highlight.
   *
   * @return {@code true} if the mouse is inside the button bounds
   */
  boolean isHovered() {
    return parent.mouseX >= pos.x && parent.mouseX <= pos.x + w &&
           parent.mouseY >= pos.y && parent.mouseY <= pos.y + h;
  }

  /**
   * Draws the button as a rounded rectangle with a centred label.
   * The button face brightens slightly when the mouse hovers over it
   * to give the user visual feedback.
   * Call once per frame inside {@code draw()}.
   */
  void drawSprite() {
    color face = isHovered()
        ? parent.lerpColor(bgColor, parent.color(255, 255, 255), 0.18)
        : bgColor;

    parent.fill(face);
    parent.noStroke();
    parent.rect(pos.x, pos.y, w, h, 14);

    parent.fill(textColor);
    parent.textSize(28);
    parent.textAlign(PApplet.CENTER, PApplet.CENTER);
    parent.text(label, pos.x + w / 2, pos.y + h / 2 + 1);
  }
}
