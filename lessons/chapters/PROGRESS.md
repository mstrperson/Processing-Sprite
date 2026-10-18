# Progress log - the one-shot run

Jason, 2026-10-18:  *"Let's run this through to the end.  Take notes on your
progress as you go (I'd like to see if you can do this in one shot).  We should
also add a full API documentation for the teacher to reference at the end of
the book as well.  Expose the guts of the Sprite base, and why this course
builds off Blob specifically (for the teacher, name the tradeoffs that that
implies)"*

So the run is Chapters 3 to 7, Bonus A to D at the back, and a teacher's API
reference closing the book, with no check-ins between.  This file is written as
the run goes, not after.  Each entry says what got done, what the code showed,
and what got decided without asking.  Decisions that were Jason's to make, and
got made by default, are marked **default** so they're easy to find and
overturn.

| Piece | State |
|---|---|
| Ch 3 - Bring It to Life | drafted, verified, 1,900 words |
| Ch 4 - You're in Control | drafted, verified, 1,850 words |
| Ch 5 - Build Your World | drafted, verified, 1,950 words |
| Ch 6 - Collisions | drafted, verified, 2,570 words, two meetings |
| Ch 7 - Build Your Game | drafted, verified, 2,150 words of prose plus the 149-line starter, three meetings |
| Bonus A - Images | drafted, verified, 1,590 words |
| Bonus B - Sounds | drafted, verified as far as a machine can, 1,240 words |
| Bonus C - Animate Your Character | drafted, verified, 1,440 words |
| Bonus D - Lists and Loops | drafted, verified, 1,800 words |
| Teacher reference - the SpriteGame API | drafted, verified, 4,150 words |
| Build, book, final checks | done:  183 pages, every verification rerun from scratch |

---

## Log

### Start

Read back over the state:  Chapters 1 and 2, BOOK_PLAN with Jason's answers,
PROCESS.md.  The rules for this run, from those answers:  no asterisks, no
notes boxes, no homework, *property* and *behavior* as plain words, and the bar
for core chapters is what every sixth grader can do.

One tooling gap to close first.  Chapters 3 and 4 need sketches that move and
take input, and the command line has no mouse or keyboard.  So `verify.sh shot`
gets a way to run a line of code at the top of every `draw()`, which can set
`mouseX` and `mouseY`, or press a key on a given frame by setting `keyCode` and
calling `keyPressed()`.  The frame is still the real sketch's frame.  The plan
for each chapter says which pictures were driven that way.

### Chapter 3 - Bring It to Life

**Tooling first.**  Three additions, each because Chapter 3 needed it:

- `verify.sh shot` takes `PRE='code'`, run at the top of every `draw()`.  The
  first try failed:  the heredoc used `$PRE` bare, and `set -u` stopped on it.
- `tools/canvas_sketch.ps1` writes a lesson's Canvas code into a sketch, with
  the last lesson's tabs carried forward.  Passing `-1` bare made PowerShell read
  it as a switch and drop the next argument, so it takes named parameters.
- `tools/check_prose.sh` runs PROCESS.md's mechanical checks on any chapter.

**What the code showed.**  Every prediction held.  With no `move()`, frame 60 is
byte-identical to Lesson 2's sketch.  Drawing before moving is exactly one frame
behind:  frame 61 of that version is byte-identical to frame 60 of the right
order.  Two runs of `random()` give different frames.

**Decided without asking:**

- **default:**  the Canvas *challenge* (comment out `background()` for a trail)
  became Step 3, and stays on through Step 5, so the direction and wrap Checks
  show as a stripe in a still picture.  So *commenting out* moved from Chapter
  4 to Chapter 3 in the ledger.
- **default:**  wrapping can't be a surprise in a book.  The chapter holds back
  the word until after the Check.
- **default:**  Chapter 7 will offer `ScreenBehavior.BouncyWalls` as an optional
  extra, because the Lesson 3 Canvas notes park the bounce question for Lesson 7.

**Settled from BOOK_PLAN section 8:**  the Lesson 3 placeholder `MyCharacter` in
`examples/Lessons` never reaches students.  The Canvas page tells them to keep
their Lesson 2 tab.

### Chapter 4 - You're in Control

**What the code showed.**  Three findings, two against the Canvas page:

- `followMouse()` uses only the size of the velocity.  `(5, 0)`, `(0, 5)`,
  `(3, 4)` and `(-3, -4)` give byte-identical frames.
- `followMouse()` and `move()` together don't jitter, as the Canvas page says.
  The character parks just right of the mouse, where the pull of 4 and the push
  of `(4, 0)` cancel, and frames 200 and 240 are byte-identical.  The chapter
  says what the code does, and the plan records the difference.
- With the keys, every non-arrow key is a brake, the speed is always 5 whatever
  `setVelocity()` said, and the `(4, 0)` meant for the mouse makes the character
  drift right until the first key.  All three are in the chapter.

**Mistakes, mine, caught by the checks.**

- My first sed for "switch to Option B" left Option A's `drawSprite()` running,
  so the verified sketch drew the character twice.  The frames came out the
  same, which is why it hid.  Caught by printing `draw()` from the scratch copy.
- A scripted rewrite wrote `it.s` for `it's`:  in a perl replacement I'd
  written `.` where the apostrophe needed escaping.  `check_prose.sh` now looks
  for that shape.
- Adding that check, perl turned `\b` into a literal backspace in the script,
  WRITING_COMMON_ERRORS entry 18 exactly.  `cat -A` showed it as `^H`.  Fixed by
  writing the line from a file, and a control-character sweep over everything
  this run touched came back clean.

**Decided without asking:**

- **default:**  four Parts, because the two control styles are two ideas.
- **default:**  the space-bar brake is taught.  See the plan, 8.1.
- **default:**  *trade-off* used once, in the **Argue it** about mouse or keys.

### Chapter 5 - Build Your World

**What the code showed.**  Every Check held:  the ground drawn last buries the
player, a cloud made in `draw()` gives a byte-identical sky at frames 10 and 60,
and `background()` moved below the clouds gives a frame byte-identical to one
with no clouds at all.

**The finding of the run so far.**  The first Chapter 5 run parked the mouse at
`(600, 300)`, and the player was missing from the finished-world picture.  It
had landed exactly on the mouse, 50 steps of 4 straight right of its start, and
`followMouse()` divided by zero.  The NaN position draws nothing, forever.  I'd
called that rare in Chapter 4's plan.  It isn't, for a mouse held level with the
character.  Caught by looking at the frame instead of trusting the run's
"saved".

**Decided without asking:**

- **default:**  the NaN goes in the teacher reference, with a suggested
  one-line fix to `followMouse()`, and the library is left alone.  No student
  chapter mentions it.  See the Chapter 5 plan, 8.1.
- **default:**  `cloud2` is built with `cloud1`, where the guided notes have
  students add it alone.

### Chapter 6 - Collisions

**What the code showed.**  Every Check held.  The refactor into `playGame()` was
verified to change nothing at all:  with `randomSeed(5)` in both scratch copies,
the frames are byte-identical.  The unread `gameOver` was shown with a
`println`.  The lives challenge works with nothing beyond the chapter's own
tools, which matters, since it's a Your turn with no code given.

**Mistakes, mine, caught.**

- The racing score first read 0.  Two edits aimed at one line in a single sed
  script, and the second couldn't match after the first changed the line.  I
  looked at the frame, saw 0, and suspected the script before the sketch.
- sed's `c\` took the rest of its script as text, in the lives check.
- A rewrite with backticks in double-quoted perl let bash run the backticks as
  commands.  Three of four edits went through, and the file was intact.  From
  here, prose edits with backticks go through the Edit tool.

**Decided without asking:**

- **default:**  Steps numbered 1 to 10 straight through both meetings, with the
  meeting split at `# Part Three`.
- **default:**  the Day 1 checkpoint stays on the Canvas page, and Part Three
  points there.

### Chapter 7 - Build Your Game

**What the code showed.**  The loop works:  lose, click, play again, and a
click while playing is byte-identical to no click.  A sharper version of the
stale-name pitfall:  a copied `coin4` with `coin3` left in its `moveTo()` never
moves away, so it scores every frame and wins the game before frame 60.

**Mistakes, mine, caught.**

- The first bounce picture parked the player in a hazard's path.  The game ended
  at frame 130, and the frame was a pile of trails behind GAME OVER.  The fix
  came from working out both hazards' paths from their velocities.
- Splicing the 149-line starter into the chapter, the first perl ran without the
  file's path in its environment.  Perl opens an undefined filename as an empty
  temp file and succeeds, so the chapter got an empty code block and no error.
  Caught by diffing the chapter's block against the verified file, which is now
  how every long quoted listing gets checked.

**Decided without asking:**

- **default:**  the win is tested by cheating, `goal = 1`, on Day 1.
- **default:**  `BouncyWalls` is offered as a one-line extra, as the Chapter 3
  plan promised.
- **default:**  What's next points at the bonus chapters and next quarter's
  Arduino.

### Bonus A - Images

**Tooling.**  `tools/make_test_art.ps1` draws stand-in art, since the sketch
needs real image files:  a character with a transparent background, the same on
white, a tree, and a sky.

**What the code showed.**  Three things against the Canvas page.  A missing
file stops the sketch with a message and a `NullPointerException`, and no box.
Wrong capitals in a file name get Processing's own clear message, even on a
case-insensitive file system.  A folder named `Data` works on Windows.

**Mistake, mine, caught.**  The first crops showed a tree where the player
should be.  I'd copied Chapter 2's crop variable, which starts with the frame
number, and passed the frame separately, so every number shifted one place.
Caught by looking at the frame.

**Decided without asking:**

- **default:**  Step 4, drawing the hitbox as a red ring, is added.  It makes the
  `imageMode(CENTER)` pitfall visible, and it's a habit that would serve Chapter
  6 too.  See the plan, 6.1.

### Bonus B - Sounds

**How it was checked.**  The Sound library is installed in the real sketchbook,
so the command line found it.  Windows' own WAV files stood in for a student's
sounds, and since nothing here can listen, each Check printed `isPlaying()`
right after its event.  The music, an MP3 on the Canvas page, ran as a WAV.

**What the code showed.**  Everything held.  The one surprise:  a missing sound
doesn't crash at once.  The sketch prints the error, runs normally, and throws
`NullPointerException` at the first `play()`.  The chapter says so.

**Unverified, and said so in the plan:**  installing the library, MP3, and
anything about how it sounds.

### Bonus C - Animate Your Character

**What the code showed.**  The poses change on schedule, and `setFrameRate`
runs backwards from intuition, as the chapter says:  at frame 6, rate 4 is
byte-identical to pose 1, and rate 20 to pose 0.  A frame made elsewhere shows
up elsewhere.  A forgotten `this.pose` makes every frame identical.

**Against the Canvas page.**  A constructor left with its old name is a compile
error, not *"a method that never runs"*.  And the page's `distanceTo()` example
uses Bonus D's list, so the chapter's version uses Chapter 7's coins, verified
by dropping an animated player into the Chapter 7 game.

**Method.**  Both long listings went in by splice and diff, the way Chapter 7's
did.  That method's now the rule for any quoted listing longer than a screen.

### Bonus D - Lists and Loops

**What the code showed.**  Every error the teacher notes predict, with its real
message.  And the removal skip, made countable:  three coins on the player,
walked forward, collect two, and walked backwards, collect three.

**Mistakes, mine, caught.**  Two measuring mistakes, both caught because the
numbers made no sense:  reporting at the top of a frame, before its collisions,
and an unanchored edit that changed both loops.

**Decided without asking:**

- **default:**  the tagline, *"One coin is a variable.  Twenty coins is a
  list."*, since the plan's sources have none that fits.

All four bonus chapters are drafted.  Next:  the teacher reference.

### The teacher reference

**Built around the ask.**  Every class and public member, the inside of
`Sprite`, and why `Blob`, with six trade-offs, each written cost first:  the silent
misspelling, collisions only between Blobs, circles only, the handshake's two
unused values, `Block` as a `Blob`, and `pos` open to students.  Then a Part Five
with every rough edge found, and a suggested fix for each.

**What the code showed that no chapter needed.**

- Aliasing:  `getPosition()` hands out the sprite's own vector, and
  `setVelocity(Vector2D)` and `moveTo(Vector2D)` share the caller's.  It's the C#
  course's Chapter 1, living in this library.
- `Event` is ambiguous by name in any sketch, and can't call into a sketch's own
  classes.
- `angleTo()` is wrong for left-pointing vectors, and the documentation's
  *clockwise* means the opposite on the screen.
- Style settings leak across frames, not only between sprites.  The first
  picture of the leak was misleading, both Blobs bare at frame 3, and showed the
  bigger fact once frame 1 was shot too.

**The `Blob` trade-off, tested both ways.**  The same misspelling in a class that
extends `Sprite` is a compile error, and `@Override` brings the error back while
keeping `Blob`.  Both messages are in the reference.

**Decided without asking:**

- **default:**  the library is unchanged.  The `followMouse()` fix was proven as an
  override in a sketch, and the reference suggests it.
- **default:**  no Canvas page for the reference;  a Word file for Flint, like
  everything else.
- I took out one sentence of mine that gave a reason for the course's choices as
  if it were Jason's.

### The finish

**Every verification, rerun from scratch.**  `tools/verify_all.sh` ran all twelve
`planning/verify_*.sh` scripts in a clean folder, and all twelve exited 0.  Of
the 61 pictures they make, 54 came out byte-identical to the book's.  The other
seven differ only where a coin or a hazard starts at random.  Six of those went
back to the book's copies, because their captions name what's in them:
*"Eight coins in fifteen seconds"*, for one, and the coins bouncing off the
right.  The seventh, `ch06_Flash.png`, kept the new frame, since the old one had
the player cut off at the top edge.

**The build.**  All thirteen pieces, then the book, then Word's pass:  183
pages.  One fix after rendering:  a single sentence of Chapter 5 spilled onto a
page of its own, ahead of Part Four's page break.  The world screenshot above it
went from 3.4 to 3 inches, and the sentence went back under its listing.

**Totals.**  28,023 words of prose in the prologue, seven chapters, four bonus
chapters, and the teacher reference, by `check_prose.sh`'s count.

**Left for Jason.**

- The title, still deferred.
- The postscript, which is his to write.
- The helper's wording.  Canvas's `course.json` and front page say the helper
  *"will not just hand you the answer"*.  The prologue says what Jason's answer
  said:  Sparky helps with syntax and ideas, and can do the math for you.  If
  they're the same helper, one of the two needs to change.
- Every **default** in this log, and the questions in section 6 of each plan.
- Nothing is committed.

**One shot?**  The run went start to finish with no check-in.  It wasn't
mistake-free:  every mistake logged above was mine, and each one was caught by a
check before the final build.
