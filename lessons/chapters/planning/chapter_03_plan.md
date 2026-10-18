# Chapter 3 plan - Bring It to Life

The reasoning behind
[`chapter_03_bring_it_to_life.md`](../chapter_03_bring_it_to_life.md), written
while drafting it on 2026-10-18, during the one-shot run.  Section 8 is where
feedback is most useful.

---

## 1.  Sources read

- `lessons/lesson_03_bring_it_to_life/lesson_03_bring_it_to_life.md`.
- `lessons/canvas_import/content/03.json`, teacher section and all.  The two
  new lines, the steps, *"Velocity alone does nothing"*, the axes drawn on the
  board, the wrap kept as a surprise, and the trail challenge.
- `examples/Lessons/Lesson03_BringItToLife`.  Its placeholder `MyCharacter` is
  never what students use:  the Canvas page says to keep the Lesson 2 tab.
- `Sprite.java`:  `move()`, the four `ScreenBehavior` cases, and the zero
  velocity every sprite starts with.
- Chapter 2, and Lesson 4's plan and Canvas page, for the hand-off.

## 2.  The sort

| Change | Pile | Where |
|---|---|---|
| `setVelocity(3, -2)` in `setup()` | **Built in class** | Step 1 |
| Run with no `move()` | **Built in class** (*"Show the failure first"*) | Step 1 |
| `move()` before `drawSprite()` | **Built in class** | Step 2 |
| Let it wrap | **Built in class**, unannounced on Canvas | Step 4 |
| `(8, 0)`, `(0.5, 0)`, `(3, 3)`, `(3, -3)` | **Built in class** | Step 5 |
| `random(-5, 5)` | **Built in class** | Step 6 |
| Tune a speed, set a mood | **Your turn** | 3.4 |
| A second blob with a velocity | **Your turn**, **Optional** | 3.5 |
| `background()` commented out | the Canvas **challenge**, moved up to a Step.  See 8.1. | Step 3 |
| `drawSprite()` before `move()` | the Canvas wrap-up question | 3.3 |
| Chapter 2's fixed-number eye | the Canvas pitfall, as a Watch out | 3.3 |

## 3.  The step order, and why

The Canvas page's order, with one addition.  Step 3 turns off `background()`
right after the character first moves, and keeps it off through Step 5.  Each
velocity then draws its own path, so *"which way does `(3, 3)` go?"* has an
answer you can see in a still picture, and the wrap in Step 4 shows as a stripe
that breaks off at one edge and starts again at the other.  It also pays off
the Lesson 1 Canvas page's promise about taking out `background()`, which
Chapter 1 left alone because a still blob shows nothing.

**Where the story bent.**  The Canvas teacher notes say to let the wrap surprise
the room.  The chapter can't keep a secret from a reader who reads ahead, so
Step 4 says *"keep watching when your character reaches the edge"* and holds
the word *wrapping* until after the Check.

## 4.  Discoveries

| Discovery | Set up in | Source |
|---|---|---|
| A velocity alone does nothing | Step 1 | the Canvas DI |
| The trail | Step 3 | the Canvas challenge |
| Wrapping | Step 4 | the Canvas DI:  *"Let them discover wrapping"* |
| Positive y goes down | Step 5, predict first | the Canvas page |
| Drawing first is one frame behind, and invisible | 3.3 | the wrap-up question |

### PRIVATE NOTES - answers, for Jason and a future Flint prompt

- **Nothing moves (Step 1).**  `setVelocity()` only stores two numbers.
  `move()` adds them to `pos`.
- **The trail.**  Each frame draws the character a step further on, and with no
  `background()` the earlier frames are still on the screen.  The grey is
  Processing's default window color, 204.
- **Wrapping.**  `Sprite.move()` checks the static `screenBehavior`, which is
  `ScreenBehavior.Wrapping` by default, and adds or subtracts the window's
  width or height when the **center** crosses an edge.  So half the character
  hangs off the edge before it jumps, and it pops across in one frame.  The
  library has three other behaviors (`HardWalls`, `BouncyWalls`, `NoWalls`), set
  for every sprite at once with `Sprite.screenBehavior = ...`.  The teacher
  reference at the back covers them.  Students asking for a bounce:  that's one
  line, and Chapter 7 offers it as an optional extra.
- **One frame behind.**  Verified exactly:  frame 61 of the drawn-first version
  is byte-identical to frame 60 of the right order.

## 5.  Syntax

| Syntax | Where | How |
|---|---|---|
| `setVelocity(vx, vy)`, velocity | 3.1 | prose, and the axes |
| `move()` | 3.2 | prose |
| commenting out | Step 3 | Aside.  Moved here from Chapter 4 in BOOK_PLAN's ledger. |
| `random(a, b)` | Step 6 | Aside |
| wrapping | Step 4 | prose |

Pointed back to:  y counts down (Chapter 1), frames and the flipbook (Chapter
1), `float` (Chapter 2), the friend's three places (Chapter 1), the
fixed-number eye (Chapter 2).

*Property* and *behavior* appear once each, concretely:  velocity is a property
Blob gave the character, set to zero.  `move()` is called *the step*.

## 6.  Verification log

Everything ran on 2026-10-18 with [`verify_ch03.sh`](verify_ch03.sh).  The sketch
is the Lesson 2 Canvas page's `MyCharacter` tab with the Lesson 3 Canvas page's
main tab, built by `tools/canvas_sketch.ps1`.

| Check | Result |
|---|---|
| a velocity, no `move()`, frame 60 | byte-identical to Lesson 2's sketch at frame 60 |
| `move()`, frame 60 | center at `(580, 180)`.  `ch03_Moving.png` |
| `background()` commented out, frame 60 | the stripe.  `ch03_Trail.png` |
| the same, frame 145 | wrapped off the right edge;  center at `(35, 10)`.  `ch03_Wrap.png` |
| `(3, 3)` and `(3, -3)`, trails, frame 60 | down-right and up-right.  `ch03_Down.png`, `ch03_Up.png` |
| `(8, 0)` and `(0.5, 0)` | build and run |
| `random(-5, 5)`, two runs, frame 60 | different frames |
| `drawSprite()` before `move()` | its frame 61 is byte-identical to the right order's frame 60 |
| Chapter 2's eye at `(388, 292)`, moving, frame 60 | the white stays in the middle.  `ch03_FixedEye.png` |
| a friend at `(200, 450)`, `setVelocity(-1, 0.5)` | `ch03_Friend.png` |

All pictures are whole windows:  where the character is in the window is what
they show.

## 7.  Meeting split

One meeting, one piece.

## 8.  Guesses and open questions for Jason

1. **The trail is a Step**, where the Canvas page has it as the challenge.  It
   makes Steps 4 and 5 visible in a still picture, which a book needs and a
   projector doesn't.  Keep it, or move it back to the end?
2. **The wrap surprise.**  A book can't hide it from a reader who looks ahead.
   The chapter withholds the word until after the Check.  Good enough?
3. **The axes diagram** is ASCII in a code block, because the board version is
   a drawing.  A real figure would be better in print, if you want one drawn.
4. **3.3 says the lag is too short to see.**  True, and verified.  The Canvas
   page calls it *"mostly harmless"* and keeps it as the wrap-up question.  The
   chapter keeps it short.
