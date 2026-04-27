# Lesson 3 — Bring It to Life

## Learning Goals
- Use `.setVelocity(vx, vy)` to give a character a speed and direction
- Call `.move()` each frame to animate the character
- Understand that the library automatically wraps sprites around screen edges
- Use `random()` to add unpredictability

## New Vocabulary
- **velocity** — how fast something moves and in which direction; it has two parts: left/right (vx) and up/down (vy)
- **frame** — one single image in the animation; `draw()` produces one frame per tick (~60 per second)
- **`random(a, b)`** — picks a surprise number between `a` and `b` every time it is called
- **wrap** — when a sprite exits one side of the screen and reappears on the opposite side

## Warm-Up  (~5 min)

<!-- Review: "Where does your character get drawn? What function draws it?" -->

## Direct Instruction  (~10 min)

<!--
Key things to demonstrate:
- Velocity is TWO numbers: vx = left/right, vy = up/down
  Sketch on the board: → is positive vx, ← is negative vx, ↓ is positive vy, ↑ is negative vy
  (positive y is DOWN in Processing — often surprises students)
- Show the call order inside draw(): move() FIRST, then drawSprite()
  If you draw first and then move, the position is one frame behind — subtle bug
- Set velocity in setup() and watch the character slide off... then show wrapping
- Change the numbers to show faster/slower, diagonal vs. horizontal
- random() demo: put random(-5, 5) directly in setup() for vx and vy — different every run
-->

## Guided Activity  (~20 min)

<!-- Step-by-step instructions go here -->

## Starter Code

**Main sketch tab (MyCharacter.pde tab stays the same from Lesson 2):**
```java
// Lesson 3 — Bring It to Life
import coxprogramming.processing.sprites.*;

MyCharacter player;

void setup() {
  size(800, 600);
  player = new MyCharacter(this, width/2, height/2);
  player.setVelocity(3, -2);  // 3 pixels right, 2 pixels up per frame
}

void draw() {
  background(240);
  player.move();        // update position (do this BEFORE drawing)
  player.drawSprite();  // draw at new position
}
```

## Make It Yours  (~10 min)

- Try `random(-5, 5)` for both velocity values in `setup()` — run it several times
- Make the character move really fast, then really slow
- Try making it move exactly diagonally (vx == vy)
- Change the background color to set a mood for the world

## Wrap-Up  (~5 min)

<!-- Exit ticket: "What happens if you call drawSprite() before move()? What does that change?" -->
<!-- (Answer: one-frame lag — character is drawn one step behind where it should be) -->

## Teacher Notes

<!-- Most common mistake: forgetting to call move() — character appears frozen -->
<!-- Second most common: calling drawSprite() before move() — one-frame lag, usually harmless but good to discuss -->
<!-- The wrapping behavior is a great "wow" moment — let students discover it on their own -->
<!-- Positive vy = DOWN (y increases downward in Processing) — this surprises many students -->
