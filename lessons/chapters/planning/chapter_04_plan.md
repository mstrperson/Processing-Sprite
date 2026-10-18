# Chapter 4 plan - You're in Control

The reasoning behind
[`chapter_04_youre_in_control.md`](../chapter_04_youre_in_control.md), written
while drafting it on 2026-10-18, during the one-shot run.  Section 8 is where
feedback is most useful.

---

## 1.  Sources read

- `lessons/lesson_04_youre_in_control/lesson_04_youre_in_control.md`.
- `lessons/canvas_import/content/04.json`, teacher section and all.  *"This is
  the real idea of the lesson"*:  continuous input against events.  The two
  options, the coasting conversation, the focus warning, and the pitfalls.
- `examples/Lessons/Lesson04_YoureInControl`.
- `Sprite.java`:  `followMouse()`, `keyboardControl()`, `moveTo()`.
- Chapter 3, and Lesson 5's plan and Canvas page, for the hand-off.

## 2.  The sort

| Change | Pile | Where |
|---|---|---|
| `followMouse()` for `move()`, and `setVelocity(4, 0)` | **Built in class** | Step 1 |
| Speed `1`, then `12` | **Built in class** | Step 2 |
| Comment out `followMouse()`, `move()` back | **Built in class** | Step 3 |
| `keyPressed()` with `keyboardControl()` | **Built in class** | Step 4 |
| Click inside the window | **Built in class** (*"This will strand people otherwise"*) | Step 4, Watch out |
| Press and let go:  coasting | **Built in class** | Step 5 |
| Pick a style | **Your turn**, with an **Argue it** | 4.5 |
| `mousePressed()` teleport | **Your turn**, **Optional** | 4.6 |
| `keyReleased()` stop | the Canvas **challenge**, **Optional** | 4.6 |
| A second blob | **Your turn**, **Optional** | 4.6 |
| The space-bar brake | **found**.  See 8.1. | Step 5 |
| The drift before the first key | **found** | Step 4 |

## 3.  The step order, and why

The Canvas page's order exactly.  Part One is its *"Two very different kinds
of input"* section, which the page calls *"the real idea of the lesson"*, and
4.4 comes back to it once Option B shows both halves.

Four Parts, where most chapters have three, because the two options are two
different ideas and each one needs a Part to itself.

## 4.  Discoveries

| Discovery | Set up in | Source |
|---|---|---|
| No velocity, no chase | Step 2, Watch out | the Canvas pitfalls |
| `followMouse()` and `move()` together park beside the mouse | Step 2, Watch out | the Canvas pitfalls, corrected.  See 8.2. |
| The drift before the first key | Step 4 | **found** |
| Coasting | Step 5 | the Canvas page |
| Every non-arrow key stops it | Step 5 | **found**, in `Sprite.keyboardControl()` |
| The keys always move at 5 | Step 5 | **found** |

### PRIVATE NOTES - answers, for Jason and a future Flint prompt

- **`followMouse()`** is
  `pos = pos.add(mouseMinusPos.unitVector().scale(vel.mag()))`.  It steps the
  size of the velocity straight at the mouse, every frame, and never touches
  `vel`.  So the direction of the velocity is irrelevant (verified:  `(5, 0)`,
  `(0, 5)`, `(3, 4)` and `(-3, -4)` give byte-identical frames), and a zero
  velocity is a zero step.  Within one step of the mouse it overshoots and
  jitters, by up to the speed.  Landing exactly on the mouse would divide by
  zero and set the position to NaN, and the character would vanish for good.
  That needs the float position to equal the integer mouse exactly, which is
  rare.  The teacher reference covers it.
- **Both together.**  `followMouse()` moves 4 toward the mouse, then `move()`
  adds `vel`, which is still `(4, 0)`.  They cancel exactly where "toward the
  mouse" points straight left, so the character parks on the mouse's row,
  just to its right, and stops.  Frame 200 and frame 240 are byte-identical.
  The Canvas page calls this *"jittery"*.  With this velocity it's still.
- **`keyboardControl()`** is a `switch` on `keyCode`:  UP, DOWN, LEFT and RIGHT
  each set a velocity of 5 in that direction and zero in the other, and the
  `default` sets both to zero.  So any other key stops the character, and the
  speed is always 5 (verified:  `setVelocity(12, 0)` and `(1, 0)` give
  byte-identical frames after a RIGHT).
- **The drift.**  The Canvas page's `setVelocity(4, 0)` is there for Option A.
  With Option B, `move()` uses it until the first key.  Harmless, and a nice
  proof that `move()` is reading the velocity.
- **The wrap-up answer**, in 4.4:  `keyboardControl()` changes the velocity, and
  `move()` uses it.

## 5.  Syntax

| Syntax | Where | How |
|---|---|---|
| `followMouse()` | Step 1 | prose |
| `mouseX`, `mouseY` | Step 1 | Aside |
| `keyPressed()`, event functions, `mousePressed()` | Step 4 | Aside |
| `keyboardControl()` | Step 4 | prose |
| `moveTo()` | 4.6 | prose |
| `keyReleased()` | 4.6 | the challenge, as given |
| *trade-off* | 4.5 | once, in the **Argue it** |

Pointed back to:  commenting out (Chapter 3), `setVelocity()` and `move()`
(Chapter 3), x and y (Chapter 1), the trail (Chapter 3), the second blob
(Chapter 3).

## 6.  Verification log

Everything ran on 2026-10-18 with [`verify_ch04.sh`](verify_ch04.sh), on the
Lesson 2 `MyCharacter` tab and the Lesson 4 Canvas main tab.  **The mouse and
keys are simulated** with `verify.sh`'s `PRE` hook:  the mouse by setting
`mouseX` and `mouseY` at the top of `draw()`, a key by setting `keyCode` and
calling `keyPressed()` on a given frame, a click by calling `mousePressed()`,
and a release by calling `keyReleased()`.  Those are the calls Processing makes
when the real thing happens.

| Check | Result |
|---|---|
| the starter builds | `Finished.` |
| `followMouse()`, mouse at `(650, 450)`, frame 45, trail | `ch04_Follow.png` |
| speed `(5, 0)`, `(0, 5)`, `(3, 4)`, `(-3, -4)`, frame 30 | all four byte-identical |
| `setVelocity(0, 0)` | frame 60 byte-identical to frame 2 |
| `followMouse()` and `move()`, frame 200, trail | parks right of the mouse.  `ch04_Both.png`.  Frames 200 and 240 byte-identical. |
| Option B, no key, frame 60 | drifted right 240 pixels.  `ch04_Drift.png` |
| UP at frame 10, LEFT at 50, frame 110, trail | `ch04_Drive.png` |
| UP at 10, space at 40, frame 110, trail | stops.  `ch04_Brake.png` |
| RIGHT with `setVelocity(12, 0)` and with `(1, 0)` | byte-identical:  always 5 |
| `mousePressed()` at `(150, 120)`, frame 20 | `ch04_Click.png` |
| `keyReleased()` with `setVelocity(0, 0)` | `ch04_Release.png` |
| Option B with `move()` deleted | frozen:  frame 10 byte-identical to frame 60 |

**Unverified:**  the window-focus warning, and holding a key down.  The command
line has no window to click, and a held key's repeat rate is the operating
system's.

## 7.  Meeting split

One meeting, one piece.

## 8.  Guesses and open questions for Jason

1. **The space-bar brake is in the chapter.**  It falls out of
   `keyboardControl()`'s `default` case, and a student will find it by
   accident anyway.  Is it a feature you want taught, or a library behavior
   you'd rather change?
2. **The Canvas page says `followMouse()` plus `move()` is "jittery."**  With
   `setVelocity(4, 0)` it parks perfectly still, just right of the mouse.  The
   chapter says what the code does.  The Canvas page and the teacher notes
   could say the same.
3. **"Trade-off" appears once**, in the **Argue it**.  BOOK_PLAN keeps the C#
   book's word, lightly, and this is the first real choice the course hands
   students.  Keep it?
4. **Four Parts.**  Fine, or fold Part One into Part Two?
