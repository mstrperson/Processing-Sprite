# Bonus D plan - Lists and Loops

The reasoning behind [`bonus_d_lists.md`](../bonus_d_lists.md), written while
drafting it on 2026-10-18, during the one-shot run.

---

## 1.  Sources read

`lessons/bonus_lesson_D_lists/bonus_lesson_D_lists.md` (the new template:  How
It Works, the Build It list, the teacher notes, including *"Why this is a bonus
lesson now"*), `lessons/canvas_import/content/13-bonus-d.json`, whose code is
identical to the plan's starter, and `examples/Lessons/BonusD_Lists`.

## 2.  Shape

The plan's Build It list, Steps 1 to 9, in order.  The How It Works sections
became the Asides and D.5.  The plan's own reason this is a bonus, a generic
type, two loops that share a keyword, and a removal pattern students can only
copy, is why the backwards loop is taught as a pattern to recognize and copy,
in the plan's words.

**Tagline mine.**  The plan and the Canvas page have none that fits the other
chapters' pattern.  *"One coin is a variable.  Twenty coins is a list."*

## 3.  What the code showed

On the Canvas page's main tab and the Lesson 2 `MyCharacter` tab.

| Check | Result |
|---|---|
| the starter, seeded | 12 coins.  `bD_Start.png` |
| 40 coins | `bD_Forty.png` |
| a list filled and never visited | `coins.size() = 12`, nothing drawn, no error |
| `coins.drawSprite();` | `The function drawSprite() does not exist.` |
| `for (int i = 0; i < coins; i++)` | `The operator < is undefined for the argument type(s) int, ArrayList<Blob>` |
| `for (Blob c : 12)` | `Can only iterate over an array or an instance of java.lang.Iterable` |
| three coins on the player, **forward** loop, after frame 1 | score 2, one coin left:  one skipped |
| the same, **backwards** loop | score 3, the list empty, and the new wave refills it to 12 in the same frame |
| `remove()` inside a for-each loop | `ConcurrentModificationException` |
| `coins.size()` without `- 1`, and `i++` for `i--` | both `IndexOutOfBoundsException: Index 12 out of bounds for length 12` |
| no `new ArrayList` | `NullPointerException`, at the first `add()` |
| the counting loop in `draw()` | 703 coins at frame 60 |
| an empty list | refilled to 12 by frame 2 |
| a click | one more coin |

**Mistakes, mine, caught.**  The first run's forward and backward loops both
reported 0, because `PRE` runs at the top of a frame and I'd reported on frame 1,
before its collisions.  And my edit for *"start with no coins"* also emptied the
refill loop, because it had no anchor.  Both caught because the numbers made no
sense.

## 4.  PRIVATE NOTES

- **The skip**, exactly:  `[A, B, C]`, all touching.  `i = 0` removes A, and the
  list is `[B, C]`.  `i = 1` is C, removed, and the list is `[B]`.  The loop ends,
  and B waits a frame.  Backwards, `i = 2, 1, 0` removes C, B, A.
- **`ConcurrentModificationException`** is Java's iterator noticing the list
  changed under it.  The plan's translation is the chapter's:  *"you changed the
  list while walking through it."*

## 5.  Guesses and open questions for Jason

1. **D.5 cites the three-coin result** in prose, so the skip is a fact before
   it's a pattern.  The plan's DI says to show the forward bug on the projector.
   In a book, the measured result stands in for the demo.
2. **No screenshot for the skip.**  It happens within one frame, so the chapter
   says what was counted, and the opening quotes the count.
