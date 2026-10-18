# Chapter 6 plan - Collisions:  If This, Then That

The reasoning behind [`chapter_06_collisions.md`](../chapter_06_collisions.md),
written while drafting it on 2026-10-18, during the one-shot run.  Section 8 is
where feedback is most useful.

---

## 1.  Sources read

- `lessons/lesson_06_collisions/lesson_06_collisions.md`, all of it:  How It
  Works, the Day 1 and Day 2 Build It lists, both checkpoints, the teacher notes.
- `lessons/canvas_import/content/06.json`.  The same, plus the pitfalls the
  chapter turns into Watch outs, and the lives challenge.
- `Blob.collidesWith()`:  `distanceTo(other) <= this.radius + other.radius`.
- Chapter 5, and Lesson 7's plan and Canvas page, for the hand-off.

## 2.  The sort

| Change | Pile | Where |
|---|---|---|
| The gold flash | **Built in class** | Step 1 |
| Radius tuning | **Your turn** (*"generous or precise"*) | Step 2 |
| `int score = 0;` at the top | **Built in class** | Step 3 |
| The three `text` lines | **Built in class** | Step 4 |
| Test by cheating, `score = 7` | **Built in class** | Step 4 |
| `score = score + 1` in the `if` | **Built in class** | Step 5 |
| `moveTo()` on the coin | **Built in class** | Step 6 |
| Coin speed and size, score style | **Your turn** | Step 6 |
| The hazard | **Built in class** | Step 7 |
| `boolean gameOver`, and its `if` | **Built in class** | Step 8 |
| `playGame()` | **Built in class** | Step 9 |
| `showGameOver()`, the `if` / `else` | **Built in class** | Step 10 |
| `gameOver = true` to test | **Built in class** | Step 10 |
| Game over screen, hazard tuning | **Your turn** | Part Four |
| Second hazard, coin worth 5, what ends it, stacked backgrounds | **Your turn**, **Optional** | Part Four |
| Lives | the challenge, **Optional** | Part Four |
| Comparing numbers, `=` and `==` | the How It Works section | 6.5 |

## 3.  The step order, and why

The plan's Build It lists in order, numbered straight through both days, Steps
1 to 6 on Day 1 and 7 to 10 on Day 2.  Part Three opens with the Canvas page's
Day 1 checkpoint pointer for anyone who missed the first meeting.  6.5, on
comparing numbers, sits at the end of Day 2's build because the plan and the
Canvas page both teach it there, with `score >= 10`.

## 4.  Discoveries

| Discovery | Set up in | Source |
|---|---|---|
| The hitbox is the radius from Chapter 2 | 6.1 | the plan;  Chapter 2 planted it |
| The score races | Step 5, *"Make a guess before you read on"* | the plan:  *"the highest-value few minutes of Day 1"* |
| The hazard changes a variable, and nothing reads it | Step 8 | the plan |
| A refactor that changes nothing is a success | Step 9 | the plan |

### PRIVATE NOTES - answers, for Jason and a future Flint prompt

- **The racing score.**  `draw()` asks every frame, and the answer is yes for
  every frame the two overlap, so one touch scores a point a frame.  Verified,
  seeded:  131 points by frame 300, 193 by frame 400.  `moveTo()` ends the
  overlap the moment it's counted.
- **`collidesWith()`** compares the distance between centers with the sum of
  the radii, so it's circles only.  The coin's hitbox is its drawn size, 14.
  The character's is the `super(...)` radius, whatever the art looks like.
- **The unread variable.**  Verified with a `println`:  after touching the
  hazard, `gameOver` is `true` and the screen carries on unchanged.
- **The refactor.**  Verified:  with `randomSeed(5)` in both scratch copies,
  the all-in-`draw()` version and the `playGame()` version give byte-identical
  frames at frame 240.
- **`int` and `boolean`, the Day 2 wrap-up:**  `score` and `lives` are `int`s,
  `gameOver` is a `boolean`.

## 5.  Syntax

| Syntax | Where | How |
|---|---|---|
| `collidesWith()`, hitbox | 6.1 | prose |
| `if`, condition | 6.2 | prose |
| `int`, a variable at the top | Step 3 | Aside, and a Watch out for the scope error |
| `text()`, `textSize()`, `+` | Step 4 | Aside |
| `score = score + 1` | Step 5 | Aside |
| `boolean` | Step 8 | Aside |
| your own function | Step 9 | Aside |
| `!`, `else` | Step 10 | Aside |
| `textAlign()` | Step 10 | in the code, and a Watch out in Part Four |
| comparisons, `=` and `==` | 6.5 | a table, and a Watch out with the real error |

Pointed back to:  `extends Blob` and the radius (Chapter 2), `moveTo()` (Chapter
4), `random()` (Chapter 3), the seven-number Blob (Chapter 5), the three places
(Chapter 1).

*Scope* is never named.  The chapter says what it does:  at the top, every
function can see it.  The plan's teacher notes skip *concatenation* the same
way.

## 6.  Verification log

Everything ran on 2026-10-18 with [`verify_ch06.sh`](verify_ch06.sh), on the
Lesson 2, 5 and 6 Canvas pages' tabs.  To touch things, `PRE` points the mouse
at the coin's or the hazard's position every frame, and `followMouse()` chases
it.

| Check | Result |
|---|---|
| the Day 1 checkpoint and the Day 2 sketch | both build |
| the flash, chasing the coin, frame 150 | gold sky.  `ch06_Flash.png` |
| `Score: 0`, and `Score: 7` | `ch06_Score0.png`, `ch06_Score7.png` (crops) |
| the racing score, seeded, frame 400 | 193.  `ch06_Racing.png` (crop) |
| the Day 1 checkpoint, chasing the coin, frame 900 | 8 points.  `ch06_OnePoint.png` |
| the hazard sets `gameOver`, nothing reads it | `println` at frame 299:  `gameOver = true`, game carries on |
| the refactor, seeded, frame 240 | byte-identical before and after |
| the Day 2 sketch, chasing the hazard, frame 300 | the game over screen.  `ch06_GameOver.png` |
| `gameOver = true` at the start | the game over screen, score 0 |
| `if (score = 10)` | `Type mismatch: cannot convert from int to boolean` |
| `int score = 0;` inside `setup()` | `score cannot be resolved to a variable` |
| the stacked background `if`s | build |
| lives, chasing the hazard | `println`:  lives 2 at frame 46, 1 at 58, 0 and game over at 267 |

**Two mistakes of mine in the script, caught.**  The first racing-score run
read 0, because two `s|...$|` edits in one sed script both aimed at the
`drawSprite()` line, and after the first one added lines, the second's `$` no
longer matched.  And sed's `c\` swallowed the rest of its script as text in the
lives check.  Both now run as separate passes.

**Unverified:**  the text's font.  Processing's default font differs between
Windows, where these frames were made, and the students' Macs.

## 7.  Meeting split

Two meetings, as the plan says.  Meeting 1 is the opening, Part One and Part
Two:  Steps 1 to 6.  Meeting 2 starts at `# Part Three`:  Steps 7 to 10, 6.5,
and Part Four.

## 8.  Guesses and open questions for Jason

1. **The Day 1 checkpoint isn't in the book.**  Part Three points at the Canvas
   page for it.  It's fifty lines, and the book's Part Two is the same code in
   order.  Print it in the book too?
2. **"Sixty a second, if you sit right on it."**  The plan says the score
   *"climbs about sixty points a second"*.  That's the rate while overlapping;
   in a real chase it's lower, because the coin wraps off the edge and the
   player loses it.  The chapter says *"a point for every frame"*.
3. **The racing score's "why" is a "Make a guess before you read on."**  The
   teacher notes say *"Ask why before you explain."*  A book can only ask.
4. **The scenery stays in `draw()`** in the refactor, as the plan says, so the
   world shows behind the game over screen.  The chapter says why in the
   screenshot's caption.
