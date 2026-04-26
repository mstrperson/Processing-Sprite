/**
 * CalculatorExample — a 4-function calculator built with Sprites.
 *
 * Concepts demonstrated:
 * <ul>
 *   <li>Extending {@link Sprite} in your own sketch files (Button, Display)</li>
 *   <li>Strategy pattern: passing behaviour into an object via an {@link Action}</li>
 *   <li>Lambda expressions as a compact way to write an {@code Action} inline</li>
 *   <li>Builder-style chaining: {@code new Button(...).onClicked(() -> ...)}</li>
 * </ul>
 */

import coxprogramming.processing.sprites.*;

Display           display;
ArrayList<Button> buttons;

// Calculator state — these variables track what the calculator "remembers"
// between button presses.
float   firstOperand = 0;    // the number stored before an operator is pressed
String  pendingOp    = "";   // the operator waiting to be applied (+, -, *, /)
boolean freshEntry   = true; // when true the next digit starts a brand-new number
String  displayText  = "0";  // exactly what is shown on the display right now

// Layout constants — change these to resize the whole calculator at once.
final int BTN_W  = 75;
final int BTN_H  = 75;
final int GAP    = 7;
final int MARGIN = 10;

/**
 * Creates the window, the display, and all 16 buttons.
 * Each button is wired to a lambda that calls the appropriate logic function.
 */
void setup() {
  size(340, 450);

  int numColor = color( 50,  50,  50); // dark grey  — digit buttons
  int opColor  = color(255, 149,   0); // orange     — operator and equals
  int clrColor = color(165, 165, 165); // light grey — clear button
  int white    = color(255, 255, 255); // label text on every button

  display = new Display(this, MARGIN, MARGIN, 320, 90);

  // Column x positions and row y positions for the 4×4 button grid.
  int[] cx = { MARGIN, MARGIN + (BTN_W + GAP), MARGIN + 2*(BTN_W + GAP), MARGIN + 3*(BTN_W + GAP) };
  int[] ry = { 112, 112 + (BTN_H + GAP), 112 + 2*(BTN_H + GAP), 112 + 3*(BTN_H + GAP) };

  buttons = new ArrayList<Button>();

  // Each .onClicked() receives a lambda — () -> means "a function with no
  // arguments that runs the following code".

  // Row 0: 7  8  9  ÷
  buttons.add(new Button(this, cx[0], ry[0], BTN_W, BTN_H, "7", numColor, white).onClicked(() -> digitPressed("7")));
  buttons.add(new Button(this, cx[1], ry[0], BTN_W, BTN_H, "8", numColor, white).onClicked(() -> digitPressed("8")));
  buttons.add(new Button(this, cx[2], ry[0], BTN_W, BTN_H, "9", numColor, white).onClicked(() -> digitPressed("9")));
  buttons.add(new Button(this, cx[3], ry[0], BTN_W, BTN_H, "÷", opColor,  white).onClicked(() -> opPressed("/")));

  // Row 1: 4  5  6  ×
  buttons.add(new Button(this, cx[0], ry[1], BTN_W, BTN_H, "4", numColor, white).onClicked(() -> digitPressed("4")));
  buttons.add(new Button(this, cx[1], ry[1], BTN_W, BTN_H, "5", numColor, white).onClicked(() -> digitPressed("5")));
  buttons.add(new Button(this, cx[2], ry[1], BTN_W, BTN_H, "6", numColor, white).onClicked(() -> digitPressed("6")));
  buttons.add(new Button(this, cx[3], ry[1], BTN_W, BTN_H, "×", opColor,  white).onClicked(() -> opPressed("*")));

  // Row 2: 1  2  3  −
  buttons.add(new Button(this, cx[0], ry[2], BTN_W, BTN_H, "1", numColor, white).onClicked(() -> digitPressed("1")));
  buttons.add(new Button(this, cx[1], ry[2], BTN_W, BTN_H, "2", numColor, white).onClicked(() -> digitPressed("2")));
  buttons.add(new Button(this, cx[2], ry[2], BTN_W, BTN_H, "3", numColor, white).onClicked(() -> digitPressed("3")));
  buttons.add(new Button(this, cx[3], ry[2], BTN_W, BTN_H, "−", opColor,  white).onClicked(() -> opPressed("-")));

  // Row 3: C  0  =  +
  buttons.add(new Button(this, cx[0], ry[3], BTN_W, BTN_H, "C", clrColor, white).onClicked(() -> clearPressed()));
  buttons.add(new Button(this, cx[1], ry[3], BTN_W, BTN_H, "0", numColor, white).onClicked(() -> digitPressed("0")));
  buttons.add(new Button(this, cx[2], ry[3], BTN_W, BTN_H, "=", opColor,  white).onClicked(() -> equalsPressed()));
  buttons.add(new Button(this, cx[3], ry[3], BTN_W, BTN_H, "+", opColor,  white).onClicked(() -> opPressed("+")));
}

/**
 * Clears the background and redraws the display and all buttons every frame.
 */
void draw() {
  background(28, 28, 30);
  display.drawSprite();
  for (Button btn : buttons) {
    btn.drawSprite();
  }
}

/**
 * Routes each mouse click through every button's hit-test.
 * {@link Button#handleClick(float, float)} decides internally whether the
 * click landed inside it and fires its {@link Action} if so.
 */
void mousePressed() {
  for (Button btn : buttons) {
    btn.handleClick(mouseX, mouseY);
  }
}

// ─── Calculator logic ─────────────────────────────────────────────────────────

/**
 * Called when a digit button (0–9) is pressed.
 * Starts a fresh number if {@code freshEntry} is true; otherwise appends
 * the digit to the right of whatever is already on the display.
 *
 * @param digit the digit character to append, e.g. {@code "7"}
 */
void digitPressed(String digit) {
  if (freshEntry) {
    displayText = digit;
    freshEntry  = false;
  } else {
    if (displayText.length() < 10) {
      displayText = displayText.equals("0") ? digit : displayText + digit;
    }
  }
  display.setText(displayText);
}

/**
 * Called when an operator button (+, −, ×, ÷) is pressed.
 * Stores the current display value and the chosen operator.
 * If there is already a pending operation and a second number has been
 * started, the intermediate result is computed first (chaining).
 *
 * @param op the operator symbol: {@code "+"}, {@code "-"}, {@code "*"}, or {@code "/"}
 */
void opPressed(String op) {
  if (!pendingOp.equals("") && !freshEntry) {
    equalsPressed();
    pendingOp = op;
  } else {
    firstOperand = Float.parseFloat(displayText);
    pendingOp    = op;
  }
  freshEntry = true;
}

/**
 * Called when the equals button is pressed.
 * Applies the pending operator to {@code firstOperand} and the current
 * display value, then shows the result.  The result becomes the new
 * {@code firstOperand} so further operations can be chained.
 */
void equalsPressed() {
  if (pendingOp.equals("")) return;

  float second = Float.parseFloat(displayText);
  float result = calculate(firstOperand, pendingOp, second);

  if (Float.isNaN(result) || Float.isInfinite(result)) {
    displayText = "Error";
  } else if (result == (int) result) {
    displayText = str((int) result); // show "6" not "6.0"
  } else {
    displayText = str(result);
  }

  display.setText(displayText);
  firstOperand = result;
  pendingOp    = "";
  freshEntry   = true;
}

/**
 * Applies a single arithmetic operation and returns the result.
 * Division by zero returns {@code Float.NaN}, which {@link #equalsPressed()}
 * catches and displays as "Error".
 *
 * @param a  the first operand
 * @param op the operator: {@code "+"}, {@code "-"}, {@code "*"}, or {@code "/"}
 * @param b  the second operand
 * @return the result of applying {@code op} to {@code a} and {@code b}
 */
float calculate(float a, String op, float b) {
  if (op.equals("+")) return a + b;
  if (op.equals("-")) return a - b;
  if (op.equals("*")) return a * b;
  if (op.equals("/")) return (b != 0) ? a / b : Float.NaN;
  return a;
}

/**
 * Resets all calculator state to the initial condition — display shows "0"
 * and all stored values and operators are cleared.
 */
void clearPressed() {
  displayText  = "0";
  firstOperand = 0;
  pendingOp    = "";
  freshEntry   = true;
  display.setText("0");
}
