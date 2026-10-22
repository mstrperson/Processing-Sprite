# Lesson 4 — You're in Control

## Learning Goals
- Use `.followMouse()` to make a character track the mouse cursor
- Use `.keyboardControl()` to drive a character with the arrow keys
- Understand the difference between *continuous* input (held key → `draw()`) and *event* input (single press → `keyPressed()`)
- Use `mousePressed()` to trigger something once per click

## New Vocabulary
- **input** — information coming into the program from the player (mouse, keyboard)
- **event function** — a function Processing calls automatically when something happens once (a click, a key press)
- **`mousePressed()`** — runs once each time the mouse button is clicked
- **`keyPressed()`** — runs once each time a key is pressed

## Warm-Up  (~5 min)

<!-- Review: "What does move() do? Where does it go in draw()?" -->

## Direct Instruction  (~10 min)

<!--
Key things to demonstrate:

followMouse():
  - Goes INSIDE draw() — runs every frame, continuously pulling the character toward the cursor
  - Requires a speed: call player.setVelocity(4, 0) in setup() to give it something to move at
    (followMouse uses vel.mag() as the speed — if velocity is 0, the character won't move)
  - When using followMouse, DO NOT also call player.move() — followMouse moves the position directly

keyboardControl():
  - Call INSIDE keyPressed() — not in draw()
  - After keyPressed sets the velocity, move() in draw() applies it each frame
  - So the draw() loop still calls move() + drawSprite() as usual
  - Arrow keys change the velocity; releasing a key leaves velocity unchanged (character coasts)
    (students often expect it to stop — good discussion point)

Show on projector: put followMouse in draw() vs. forgetting it — instant difference
Then switch: comment out followMouse, uncomment keyboardControl in keyPressed()
-->

## Guided Activity  (~20 min)

<!--
Split the class.  Running both control styles in turn, with everyone, was too much
for one period.  So half the class does keyboard control and half does mouse
following, then they share at their tables.

Canvas has two parallel student Pages for this (one Assignment, one teacher copy):
  - Mouse Group:  followMouse(), setVelocity() as the chase speed, and followMouse()
    plus move() tried on purpose (the character parks next to the mouse)
  - Keys Group:   keyboardControl() in keyPressed(), move() still in draw(), the
    coasting, and the brake (every non-arrow key stops it)

  1. Split each table down the middle, so every table has both groups.
  2. Each group works its own Page, up to "Table share".  (~12 min)
  3. Table share (~8 min):  each student shows their sketch running and hands over
     the controls, then drives the other group's sketch.
  4. Each table answers together:  which input is asked about every frame, and
     which happens once?  Take two or three tables' answers to the whole class.
  5. Students pick their control style for the rest of the unit.  Anyone who
     switches follows the other group's Page.

Students still feel BOTH control styles before picking:  one by building it, the
other in a classmate's sketch.
-->

## Starter Code

Two starters, one per group.  Both keep the `MyCharacter` tab from Lesson 3.
The full sketches are `examples/Lessons/Lesson04_YoureInControl_Mouse` and
`examples/Lessons/Lesson04_YoureInControl_Keys`.

**Mouse Group, main sketch tab:**
```java
// Lesson 4 — You're in Control (Mouse Group)
import coxprogramming.processing.sprites.*;

MyCharacter player;

void setup() {
  size(800, 600);
  player = new MyCharacter(this, width/2, height/2);
  player.setVelocity(4, 0);  // the speed followMouse() chases at
}

void draw() {
  background(240);
  player.followMouse();
  player.drawSprite();
}
```

**Keys Group, main sketch tab:**
```java
// Lesson 4 — You're in Control (Keys Group)
import coxprogramming.processing.sprites.*;

MyCharacter player;

void setup() {
  size(800, 600);
  player = new MyCharacter(this, width/2, height/2);
  player.setVelocity(4, 0);  // the drift before your first key
}

void draw() {
  background(240);
  player.move();        // still needed - applies the velocity each frame
  player.drawSprite();
}

// Arrow keys change the velocity
void keyPressed() {
  player.keyboardControl();
}
```

## Make It Yours  (~10 min)

- Try both control modes and pick the one you want to use for the rest of the unit
- If using followMouse, change the speed in `setVelocity()` — what feels right?
- Add a second, non-player blob that moves on its own (copy from Lesson 3)
- If using keyboardControl, add a `mousePressed()` function that does something fun
  (e.g., snap the player to the mouse position: `player.moveTo(mouseX, mouseY);`)

## Wrap-Up  (~5 min)

<!-- Pair discussion: "What does keyboardControl() change when a key is pressed, and what does move() do each frame?" -->
<!-- Answer: keyboardControl() sets velocity; move() applies it each frame.  Holding a key may generate repeated keyPressed() calls. -->

## Teacher Notes

<!-- followMouse speed: if students forget setVelocity, the character will not move at all -->
<!-- (vel.mag() == 0 → moves 0 pixels toward mouse). Remind them to set a speed in setup() -->
<!-- keyboardControl coasting: the character keeps moving after the key is released because -->
<!-- velocity stays set. Students expect it to stop — this is a useful discussion about state -->
<!-- Make sure students are clicked inside the sketch window for keyboard input to register -->
<!-- Calling keyboardControl() in draw() reapplies velocity each frame and can overwrite a stop set in keyReleased().  Use keyPressed() for this lesson's event-driven pattern. -->

---

## Rubric — You're in Control

*Use this rubric to see where you are and choose what to try next.  You can always revise and run it again.*

**✅ Check yourself first — I can…**
- [ ] Drive my character with `followMouse()` (in `draw`) *or* `keyboardControl()` (in `keyPressed`).
- [ ] Set a speed so `followMouse()` actually moves.
- [ ] Explain why `keyboardControl()` goes in `keyPressed()`, not `draw()`.
- [ ] Tell the difference between *continuous* input and an *event*.

**Where am I?**  *Standard: control the character with `followMouse()` or `keyboardControl()`, and distinguish continuous input from event input.*

| Level | What it looks like |
|---|---|
| **Getting Started** | My character doesn't respond to input yet. **Next step:** for `followMouse`, set a speed with `setVelocity()` in `setup()` — it needs a speed > 0 to move. For keys, make sure `keyboardControl()` is inside `keyPressed()`, not `draw()`. |
| **Got It Working** | I can drive my character with the mouse or the arrow keys. |
| **Made It Mine** ⭐ | …and I picked the control style that fits my game and tuned it — a speed that feels right, or a `mousePressed()` that does something fun. |
| **Went Beyond** | …and I combined inputs (e.g., keyboard control *plus* a `mousePressed()` ability), or added a second blob that moves on its own while I steer the player. |

⭐ **Made It Mine** is the goal for everyone this lesson.

*"Went Beyond" means taking the project further in a direction you choose.  The examples are starting points.*

**✍️ Show your thinking (1–2 sentences):** Which control style did you choose for your game, and what made it the right fit?
