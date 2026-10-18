# Chapter 7 plan - Build Your Game

The reasoning behind
[`chapter_07_build_your_game.md`](../chapter_07_build_your_game.md), written
while drafting it on 2026-10-18, during the one-shot run.  Section 8 is where
feedback is most useful.

---

## 1.  Sources read

- `lessons/lesson_07_build_your_game/lesson_07_build_your_game.md`, all of it:
  *"You already know all of this"*, `restartGame()`, three states, the clicking,
  three coins and three `if`s, the starter as a skeleton, the three-day guided
  sequence, the teacher notes.
- `lessons/canvas_import/content/07.json`.  The same, and the starter students
  paste, which is identical to the plan's.
- `Sprite.java`'s `ScreenBehavior` switch, for the bounce Chapter 3 promised.
- Chapter 6, and the bonus lessons, for the hand-off.

## 2.  The sort

| Change | Pile | Where |
|---|---|---|
| The one-sentence game description | **Your turn** | 7.1 |
| Paste the starter, or start from Chapter 6 | **Built in class** | 7.2 |
| Find every piece | **Built in class** | 7.2, a table |
| Play until you lose, click to restart | **Built in class** | Step 1 |
| The win, tested by `goal = 1` | **added**, *test by cheating* from Chapter 6.  See 8.1. | Step 2 |
| One full loop in your world | **Built in class** | Step 3 |
| Play-testing with a neighbor | **Built in class**, Day 2 and Day 3 | Parts Three and Four |
| Placeholders, screens, difficulty, one new thing | **Your turn** | Steps 4 to 7 |
| `BouncyWalls` | **added**, promised in Chapter 3.  See 8.2. | Step 7 |
| A second level | the challenge, **Optional** | Step 7 |
| Demo day | **Built in class** | 7.7 |

## 3.  The step order, and why

Three meetings, as the plan says.  Day 1 is Parts One and Two:  read, then one
full loop.  Day 2 is Part Three, opening with the plan's five minutes of
play-testing.  Day 3 is Part Four.

The plan's Build It list is followed in order.  Its step 3, *"find each piece,"*
became 7.2's table, which says where each piece was met.  The lesson's How It
Works sections (three states, restarting, clicking, three coins) became 7.3,
7.4 and 7.5.

## 4.  Discoveries

| Discovery | Set up in | Source |
|---|---|---|
| Starting and restarting are the same code | 7.4 | the DI:  *"the most important structural idea in the capstone"* |
| A click while playing changes nothing | 7.4 | verified |
| A restart that misses a variable | Step 2, Watch out | the pitfalls |
| A copied `if` with a stale name | 7.5, Watch out | the pitfalls, sharpened.  See PRIVATE NOTES. |
| `BouncyWalls` changes every sprite | Step 7 | **found** |

### PRIVATE NOTES - answers, for Jason and a future Flint prompt

- **Restarting.**  Reset by re-running the initialization, never by undoing
  changes.  The scenery is built once because play never changes it.
- **The stale name.**  The pitfall says a stale `coin3` in `coin4`'s block
  means *"coin4 is drawn and never scores, or coin3 gets moved twice"*,
  depending on which name was missed.  Verified the sharper case:  with `coin3`
  left in the `moveTo()`, `coin4` never moves away, so it scores every frame, and
  the game is won, 15 points, before frame 60.
- **The forgotten reset.**  Verified:  with `gameOver = false;` taken out of
  `restartGame()`, a click rebuilds everything else, and the screen stays on
  game over.
- **`BouncyWalls`** is a `static` field on `Sprite`, so it applies to every
  sprite at once:  hazards, coins, clouds.  The player is untouched, because
  `followMouse()` never calls `move()`.  The window's bottom edge is under the
  ground, so things bounce behind it.  The teacher reference covers the four
  behaviors.
- **`AnimatedSprite`** (Bonus C) isn't a `Blob`, so it uses `distanceTo()` in
  place of `collidesWith()`.  The teacher notes say so, and Bonus C's chapter
  carries it.

## 5.  Syntax

| Syntax | Where | How |
|---|---|---|
| `&&`, `else if` | 7.3 | Aside |
| `||` | 7.4 | Aside |
| `restartGame()`, the pattern | 7.4 | prose |
| `Sprite.screenBehavior = ScreenBehavior.BouncyWalls;` | Step 7 | one line, given |

Pointed back to:  everything, in 7.2's table.  *Trade-off* appears once, for
the three coins in three `if`s.

## 6.  Verification log

Everything ran on 2026-10-18 with [`verify_ch07.sh`](verify_ch07.sh), on the
Lesson 2, 5 and 7 Canvas pages' tabs.  **The starter in the chapter was spliced
in from the verified file by script and diffed against it:  149 lines,
identical.**

| Check | Result |
|---|---|
| the starter builds, and plays | `Finished.` |
| lose, chasing `hazard1` | `gameOver = true` by frame 199.  `ch07_Lose.png` |
| click at frame 220 | `gameOver` true before, false after, score 0.  `ch07_Again.png` |
| a click while playing, seeded | byte-identical to no click |
| `goal = 1`, chasing `coin1` | `playerWon = true` at frame 15.  `ch07_Win.png` |
| `restartGame()` without `gameOver = false;` | after the click, `gameOver = true` |
| a fourth coin with `coin3` in its `moveTo()` | score 15 and won by frame 60 |
| `BouncyWalls`, trails, frame 300 | `ch07_Bounce.png`.  The first try parked the player in a hazard's path and lost at frame 130.  Parked at `(150, 450)`, out of both paths, it ran to frame 300. |

## 7.  Meeting split

Three meetings.  Meeting 1 is the opening, Part One and Part Two.  Meeting 2
starts at `# Part Three`.  Meeting 3 starts at `# Part Four`.

## 8.  Guesses and open questions for Jason

1. **Step 2 tests the win by cheating, `goal = 1`.**  The plan's Day 1 says *"Play
   until you lose, then click to restart."*  The win screen never gets checked
   until a student wins for real, 15 coins later.  Keep the cheat?
2. **`BouncyWalls` is offered in Step 7**, because Lesson 3's Canvas notes park
   the bounce question for Lesson 7, and it's one line.  It's library you've
   never put in front of students.  Fine, or cut?
3. **Part Four is short**, because Day 3 is play-testing and presenting, and a
   book has little to say about that.  The plan's wrap-up, *"name your game in a
   sentence and point at one decision you made on purpose,"* closes it.
4. **What's next mentions Arduino** and the Circuit Playground, from your answer
   about the course.  Right for the end of the core chapters?
