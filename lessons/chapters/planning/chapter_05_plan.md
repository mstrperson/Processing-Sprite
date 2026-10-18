# Chapter 5 plan - Build Your World

The reasoning behind
[`chapter_05_build_your_world.md`](../chapter_05_build_your_world.md), written
while drafting it on 2026-10-18, during the one-shot run.  Section 8 is where
feedback is most useful.

---

## 1.  Sources read

- `lessons/lesson_05_build_your_world/lesson_05_build_your_world.md`, the new
  template:  How It Works, Build It Step by Step, the HTML-commented teacher
  notes.  Its `Block` diagram, comment arrows under the line of code, became a
  table in 5.2:  at book width the arrows wrapped and came apart, and a table is
  how Chapter 1 explains a Blob's five numbers.
- `lessons/canvas_import/content/05.json`.  The same steps, plus the guided
  sequence:  *"Deliberately break it as a class"*.
- `examples/Lessons/Lesson05_BuildYourWorld`.
- `Block.java`, `Blob.java` (the seven-number constructor), `Sprite.java`.
- Chapter 4, and Lesson 6's plan and Canvas page, for the hand-off.

## 2.  The sort

| Change | Pile | Where |
|---|---|---|
| Sketch on paper | **Your turn** (the warm-up) | 5.1 |
| `Block ground` | **Built in class** | Step 1 |
| A themed background | **Built in class** | Step 2 |
| Ground drawn last, then back | **Built in class** (*"Deliberately break it"*) | Step 3 |
| The `Cloud` tab, `cloud1` | **Built in class** | Step 4 |
| `cloud2` | **Your turn** in the plan;  **Build it** here, with `cloud1`.  See 8.2. | Step 4 |
| The coin | **Built in class** | Step 5 |
| A second `Block` | **Your turn** | 5.5 |
| Theme, redesign, decoration class, alpha, speed | **Your turn** | 5.5 |
| Parallax | **Optional** (the challenge) | 5.5 |
| `Block` corner, cloud in `draw()`, `background()` mid-`draw()` | the pitfalls, as Watch outs | Steps 1, 3, 4 |

## 3.  The step order, and why

The Canvas steps in order.  The paper sketch comes first, as Part One, because
the teacher notes say it *"earns its three minutes"*.  `Block` gets a reading
section of its own (5.2) because it's the chapter's one new kind of object and
its corner rule is the lesson's most common mistake.

## 4.  Discoveries

| Discovery | Set up in | Source |
|---|---|---|
| The ground drawn last buries the player | Step 3 | the plan and Canvas page |
| `Block`'s corner | Step 1, Watch out | the pitfalls |
| A cloud made in `draw()` freezes | Step 4, Watch out | the pitfalls |
| `background()` in the middle erases what's above it | Step 3, Watch out | the pitfalls |

### PRIVATE NOTES - answers, for Jason and a future Flint prompt

- **`Block`** is a `Blob` with radius 0 and its own `drawSprite()`:
  `fill(myColor); noStroke(); rect(pos.x, pos.y, w, h)`.  `rect()` draws from
  the corner by default, so `pos` is the corner.  Its `collidesWith()` is Blob's,
  a circle of radius 0 at the corner, so a `Block` never registers a touch
  unless something's circle covers that one point.  That's why the chapter says
  *scenery*.  The teacher reference covers it.
- **The coin's outline.**  `Block.drawSprite()` calls `noStroke()`, and the
  setting carries on to everything drawn after it.  The coin is drawn after the
  ground, so it has no outline, where Chapter 1's blob had one.  Nobody asks,
  usually.
- **The frozen cloud.**  `new Cloud(...)` in `draw()` puts a brand-new cloud at
  `(150, 90)` every frame, and `move()` moves it half a pixel before it's
  replaced.  Verified:  the top of the window is byte-identical at frames 10
  and 60.

## 5.  Syntax

| Syntax | Where | How |
|---|---|---|
| `Block`, and the corner | 5.2 | prose, a table of its six numbers, a Watch out |
| draw order | Step 3 | prose, the chapter's idea |
| a constructor with its own number, `setVelocity()` inside it | Step 4 | Aside |
| the seven-number `Blob` | Step 5 | Aside |
| alpha | 5.5 | prose |

Pointed back to:  shapes stacking inside a character (Chapter 2), tabs and the
class pattern (Chapter 2), `background()` (Chapters 1 and 3), `random()`
(Chapter 3), wrapping (Chapter 3), the arrow keys (Chapter 4).

## 6.  Verification log

Everything ran on 2026-10-18 with [`verify_ch05.sh`](verify_ch05.sh), on the
Lesson 2 `MyCharacter` tab and the Lesson 5 Canvas page's main and `Cloud`
tabs.  Each Step's state is made by taking lines back out of the finished
sketch.  The mouse is parked with `PRE`, as in Chapter 4.

| Check | Result |
|---|---|
| the finished world builds and runs | `ch05_World.png` (the coin is random) |
| ground only, on grey | `ch05_Ground.png` |
| the ground at `width/2, height - 35` | half off the window.  `ch05_Center.png` |
| player walked to `(400, 570)`, ground first and last | `ch05_OrderRight.png`, `ch05_OrderWrong.png` (crops of the bottom) |
| two clouds | `ch05_Clouds.png`;  the sky changes between frames 10 and 60 |
| `cloud1 = new Cloud(...)` in `draw()` | the sky is byte-identical at frames 10 and 60 |
| `background()` moved below the clouds | byte-identical to the same sketch with no clouds |
| alpha 180 on the cloud's fills, over a block | `ch05_Solid.png`, `ch05_Faint.png` (crops) |
| a platform at `(480, 380)` | `ch05_Platform.png` |

**A finding on the way, for the teacher reference.**  The first run parked the
mouse at `(600, 300)`, on the player's row, 200 pixels right of where it
starts.  That's exactly 50 steps of 4, so on frame 50 the player landed exactly
on the mouse.  `followMouse()` divided by a distance of zero, the position
became NaN, and the player vanished from every frame after.  The Chapter 4 plan
had called that rare.  It isn't, when the mouse sits level with the character
at a multiple of the speed away.  The pictures here park the mouse at
`(610, 333)`.

## 7.  Meeting split

One meeting, one piece.  The plan says it *"can happily fill a second"*, which
is the flex day.  5.5 is where a second meeting would start.

## 8.  Guesses and open questions for Jason

1. **No new Watch out for the vanishing player.**  A student can hit it in
   Chapters 4 to 7 by holding the mouse still in line with the character.  It's
   a library bug, so it's in the teacher reference with a suggested fix, and no
   student chapter mentions it.  If you'd rather not change the library, a
   one-line Watch out in Chapter 4 (*"if your character vanishes, press Stop and
   Run again"*) would cover it.
2. **`cloud2` is a Build it**, alongside `cloud1`.  The Canvas guided notes have
   students add `cloud2` on their own.  In a book the second one is the same
   three lines again, so it's built together.  Make it a Your turn?
3. **The `background()` Watch out** points ahead to Step 4's clouds.  It's in
   Step 3 because that's where draw order is named.
