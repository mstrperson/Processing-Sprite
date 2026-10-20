# Book Plan - Objects First with Processing

The decisions behind the whole book, made once, before the chapters, so that
eleven chapters don't each make them separately.  Written 2026-10-18 by Claude,
for Jason to mark up.  Section 9, the open questions, is where feedback is worth
most.

The model is the C# course's book in `OODP_Lessons/Course/chapters`, and its
process is `OODP_Lessons/Course/chapters/PROCESS.md`.  That book's REVIEW.md
found its worst trouble in decisions nobody made up front:  syntax explained
two and three times, and questions creeping back in where explanations
belonged.  This file is the up-front half of the fix.  [`PROCESS.md`](PROCESS.md)
in this folder is the per-chapter half.

---

## 1.  What exists so far

Updated 2026-10-18, at the end of the one-shot run.  [`PROGRESS.md`](PROGRESS.md)
is that run's log.

| Piece | File | State |
|---|---|---|
| This plan | `BOOK_PLAN.md` | Jason's answers in section 9 |
| The process | [`PROCESS.md`](PROCESS.md) | adapted from the C# book's |
| Prologue | [`chapter_00_prologue.md`](chapter_00_prologue.md) | drafted, with Jason's answers in it |
| Chapters 1 to 7 | `chapter_01_hello_blob.md` to `chapter_07_build_your_game.md` | drafted, every Check verified |
| Bonus A to D | `bonus_a_images.md` to `bonus_d_lists.md` | drafted, every Check verified, as far as a machine can check sound |
| Teacher reference | [`reference_api.md`](reference_api.md) | drafted, every claim about the library verified |
| Their plans | [`planning/`](planning/) | one per piece, and one verification script per piece |
| Their openings | [`book/`](book/) | one per chapter and bonus chapter |
| Screenshots | [`screenshots/`](screenshots/) | real frames, saved from the real code, some cropped |
| Build | [`tools/`](tools/) | see PROCESS.md |

The printed draft, `build/book/Book_Draft.pdf`, runs 183 pages:  the prologue,
two units, the bonus chapters, and the teacher reference, each with a page of its
own.  Every meeting's PDF is cut from it, into `build/pdf`.  Most of the length is
pictures and the page break that starts every Part and every numbered section,
which is the C# book's rule.  If that's too much paper for a sixth-grade meeting,
those breaks are the first thing to bend.

A postscript, the C# book's record of how its book got made, was left for Jason:
it's meta-analysis in his voice, and PROGRESS.md has the raw material.

---

## 2.  The register, settled before the first sentence

WRITING_COMMON_ERRORS entry 22 asks for three answers in one line each.

| Question | Answer |
|---|---|
| Who is the audience? | Sixth graders, 11 and 12, who have never programmed.  They read the chapter in class with the teacher in the room, or alone when they missed the day. |
| How serious is it? | Light.  A joke belongs when it's about something true on the screen, said deadpan. |
| What is the vibe? | Jason as the teacher in the room:  plain, warm, direct, and short.  The same voice as the C# book at a younger setting. |

What follows from those answers, as rules for drafting:

- **Short sentences, common words.**  A sentence a sixth grader would have to
  read twice gets split.  Technical words arrive only when the thing they name
  is already on the screen (Guiding Principle 9).
- **Contractions wherever you'd say one.**  Measured with entry 22's
  `register` check on 2026-10-18, the C# book's chapters run 8 to 11 per
  thousand words, counting the code in them, and its prologue runs 17.  A
  chapter is mostly instructions, and an imperative has nothing to contract, so
  a chapter's count sits near the C# chapters' and the prologue's near 17.  The
  first draft of this plan asked chapters for the prologue's rate, and Chapter 1
  showed that was the wrong target:  forcing contractions past the ear is entry
  30's manufacturing.  The test is reading it aloud.
- **Asides are short.**  Two to five sentences.  A sixth grader skims a long box.
- **Every Check says what the window shows**, and most of them show it, with a
  real screenshot.  A sketch's output is a picture, so the picture is the Check.
- **One meeting is 1,800 to 2,800 words, code included.**  The C# book's
  chapters run 5,300 to 6,600 words for two meetings, for high-schoolers who
  have programmed in two languages.  This reader is younger and newer, Lessons 1
  to 5 are one meeting each, and the Guided Activity they replace is twenty
  minutes long.  The range is a guess, to be corrected by watching students
  read it.
- **Every style rule in `meta/` still applies.**  The double space, `--` with a
  space each side, headings with a single hyphen, no definition by negation, no
  abstract `stays`, no `landed` for an idea, no commentary lines, no beat that
  only completes a shape.  These are mechanical, and a younger reader changes
  none of them.

The style rules come from OODP_Lessons' copies of
`APPALACHIAN_ACADEMIC_STYLE.md` and `WRITING_COMMON_ERRORS.md`.  This repo's
`meta/WRITING_COMMON_ERRORS.md` is an older copy (95 KB against 111 KB), and
lacks entries 36 to 39.  See question 9.12.

---

## 3.  What carries over from the C# book, and what changes

| | The C# book | This book |
|---|---|---|
| Reader | high-schoolers, two languages behind them | sixth graders, none |
| The idea | object-oriented design, with trade-offs | objects first:  use them, then extend them |
| The two strands | dice together, then cards alone | the class's example, then **your character** |
| The file that's yours | `Card.cs` | `MyCharacter.pde`, from Chapter 2 on |
| Source of the Steps | the diff from `main` to `Teacher` | the Canvas page's steps and the teacher's guided sequence (`canvas_import/content/0N.json`), and the lesson plan, against the starter code students type from the Canvas page |
| What a Check shows | console output, or a compiler error | the window, as a screenshot, or Processing's error message |
| Verification | `dotnet build` in a scratch export | `tools/verify.sh`:  Processing's own command line, in a scratch copy |
| Meetings | two or three per chapter | one each for 1 to 5, two for 6, three for 7 |
| Homework | capped, in **Tonight** boxes | none, so no **Tonight** boxes (settled, 9.5) |
| Screenshots | empty frames, never filled | real frames from the real code |

The chapter shape is the C# book's, unchanged:  an opening with its moves
table, Part One reading the starter, later Parts building in Steps, and the
chapter's end matter (summary, new syntax, vocabulary, check your
understanding, what's next).

The marks are the C# book's, minus two.

| Mark | Used | Notes |
|---|---|---|
| **Build it.** | yes | |
| **Your turn.** | yes | Make It Yours items become these |
| **Optional** | yes | |
| Aside | yes | short |
| Check | yes | usually with a screenshot |
| Watch out | yes | Lesson 5 already uses it, for the `Block` corner.  The build gives it a red box. |
| Answer in your notes | **no** | notes aren't an expectation of the course (settled, 9.6).  A question the chapter wants the student to think about comes as a plain line, *"Make a guess before you read on,"* right before the answer. |
| Argue it | yes, rarely | where a choice is real:  mouse or keys (Ch 4), three named coins or a list (Ch 7) |
| Tonight | **no** | no homework in the plans |
| Screenshot | yes | `> **Screenshot:**  caption`, then the image on the next line of the box |

---

## 4.  The threads that run through every chapter

### Your character

Guiding Principle 2, the Character Thread, is this book's second strand.  The
C# book does every idea with dice, together, then with cards, alone.  This book
does every idea with the class's example, then with your character.  From
Chapter 2 on, `MyCharacter.pde` is the one file that belongs entirely to the
student, and every chapter ends by giving it something new.

### Setup once, draw forever

Guiding Principle 8 asks for the `setup()` / `draw()` model to be reinforced
every lesson.  So every chapter says where its new code goes, and why there.
Chapter 1 states it as the chapter's one idea, and proves it by moving a line.

### Objects have properties and behaviors

**Settled 2026-10-18 (9.1):  the words, without the spiral.**  Jason:  *"We can
mention the words, but they're just words at this point.  6th graders are not
cognatively ready for those abstract nuances."*  So Chapter 1 defines
*property* and *behavior* as plain vocabulary, with concrete examples (where
it is, how big, what color; it can draw itself).  Later chapters use the words
where they describe something on the screen, and never restate the sentence as
a principle or add a nuance to it.  The table below was the proposal, kept for
the record.

| Ch | The nuance (proposed, and declined) |
|---|---|
| 1 | A `Blob` has properties (where, how big, what color) and a behavior (it draws itself).  The dot asks for a behavior. |
| 2 | Your character gets Blob's properties and behaviors for free, and you replace one behavior, `drawSprite()`, with your own. |
| 3 | Velocity is a property.  `move()` is a behavior that uses it. |
| 4 | A behavior can be asked for by an event:  a key, a click. |
| 5 | Different kinds of objects can share a behavior.  Clouds, blocks, and coins all `drawSprite()`. |
| 6 | A behavior can answer a question:  `collidesWith()` hands back `true` or `false`. |
| 7 | Restarting is setting every property back to where it began. |

### Trade-offs

Lightly.  A sixth grader can weigh two real options, and the word is the C#
book's.  It goes only where the lessons already name a choice with a cost on
each side:  mouse or keys (Ch 4), one variable per thing or a list (Ch 5 and
Bonus D), and three coins in three `if`s, which Lesson 7 already calls
*"repetitive"* and *"code you can read top to bottom"* (Ch 7).

### The giant asterisk

**Settled 2026-10-18 (9.2):  none in this book.**  Jason:  *"We don't need to
use aserix with 6th graders.  That will only confuse them."*  Entry 39's other
half still applies:  a sentence that would need one gets rewritten until it's
accurate at the level it's pitched.  The build still knows the mark, for the C#
book's sake, and `grep -n '{.iceberg}'` on these chapters should find nothing.
The two places proposed, kept for the record:

| Ch | After | The monster |
|---|---|---|
| 1 | **objects have properties and behaviors** | the whole of object-oriented design.  Jason marks it himself the first time he says it. |
| 2 | `extends`, *built on top of* | inheritance.  Guiding Principle 6 keeps the word out of the room, which is exactly the facade the asterisk is for. |

`this` and `super(...)` were candidates and got rewritten instead:  each one has
a sentence that's accurate at the level it's pitched.  `this` is how a `Blob`
finds the sketch it belongs to.  `super(...)` hands Blob the five things a Blob
needs.

### The guardrails

From `meta/GUIDING_PRINCIPLES.md`, and binding on the prose:

- The word *inheritance* stays out.  So do *abstract* and *constructor
  chaining*.  *Override* is in, once, in Chapter 2, because the Lesson 2 Canvas
  page's goals and checklist use it.  (`@Override` appears in no starter.)
- `super(...)` is the handshake.  Copy it exactly, change the radius.
- One new idea per chapter.  Everything else in the chapter is review or a
  small step from something already seen.
- Vocabulary after the thing it names is already on the screen.

---

## 5.  The chapters

| Ch | Title | Meetings | The one new idea | Source |
|---|---|---|---|---|
| 0 | Prologue - How This Book Works | -- | | |
| 1 | Hello, Blob! | 1 | `setup()` runs once, `draw()` runs forever | Lesson 1 |
| 2 | Draw Your Character | 1 | `extends Blob`:  your own kind of object | Lesson 2 |
| 3 | Bring It to Life | 1 | velocity and `move()` | Lesson 3 |
| 4 | You're in Control | 1 | input, and event functions | Lesson 4 |
| 5 | Build Your World | 1 | draw order | Lesson 5 |
| 6 | Collisions:  If This, Then That | 2 | `if` | Lesson 6, Day 1 and Day 2 |
| 7 | Build Your Game | 3 | restarting | Lesson 7 |
| A | Images | 1 | `ImageSprite` | Bonus A |
| B | Sounds | 1 | `SoundFile` | Bonus B |
| C | Animate Your Character | 1 | `AnimatedSprite` | Bonus C |
| D | Lists and Loops | 1 | `ArrayList` and `for` | Bonus D |

That's ten meetings for Chapters 1 to 7, and the course has eleven.  The
eleventh is the flex day, and Lesson 5's teacher notes suggest spending it
there.

**Units, settled (9.7 and 9.8).**  **Unit 1 - Your Character** is Chapters 1 to
4, and **Unit 2 - Your Game** is 5 to 7, each with a page of its own in the
printed book.  The bonus chapters go at the back, after Chapter 7.

**The course, as Jason described it (9.3 and 9.9).**  It's the first quarter
of Coding for Embedded Systems, Winsor's sixth-grade class, which meets 2 of
every 7 class days for two alternating quarters.  This quarter is eleven
55-minute periods, *"if I'm lucky."*  The second quarter is Arduino, on the
Circuit Playground.  This fall, 2026, is the first run of these lesson plans,
and it's already changed them once:  lists and loops moved from a core lesson to Bonus D,
*"because that was a step too far to be an expecation that /every/ 6th grader
can do."*  That's the bar for core chapters:  what every sixth grader can be
expected to do.

---

## 6.  The syntax ledger

The first chapter to use a piece of syntax explains it in an Aside.  Every later
chapter points back in one line ("You met `random()` in Chapter 3").  This is
the rule the C# book's REVIEW recommended after the fact.  Here it's settled
first, and a chapter's plan checks itself against this table.

| Syntax or idea | Explained in | Notes |
|---|---|---|
| the sketch, ▶ Run and ■ Stop | 1 | |
| `//` and `/** */` comments | 1 | |
| `import` and what a library is | 1 | |
| a variable, declared:  `Blob myBlob;` | 1 | the box picture, switched on |
| `setup()` and `draw()`, and braces | 1 | the chapter's one idea |
| statements and the semicolon | 1 | |
| `size(800, 600)`, and x and y | 1 | y counts down from the top |
| `new` and the five things a `Blob` needs | 1 | `this` is the sketch |
| `color(r, g, b)`, RGB, the Color Selector | 1 | light, not paint |
| the dot:  `myBlob.drawSprite()` | 1 | asking for a behavior.  The word *method* comes with it, as on the Lesson 1 Canvas page. |
| frames, about sixty a second | 1 | the starter's own comment says *"erases the previous frame"*, so the word arrives with the flipbook |
| `background()` | 1 | |
| reading an error, and capitals matter | 1 | |
| `NullPointerException` | 1 | in a Watch out:  declared, never created |
| tabs | 2 | |
| `class MyCharacter extends Blob` | 2 | the asterisk |
| the constructor and `super(...)` | 2 | the handshake |
| `float` | 2 | only as far as the constructor needs it |
| `void drawSprite()`, replacing Blob's | 2 | the misspelling discovery |
| `pos.x`, `pos.y` | 2 | |
| `fill`, `noFill`, `stroke`, `noStroke`, `strokeWeight` | 2 | Chapter 1 shows the outline;  Chapter 2 names it |
| `ellipse`, `arc`, `PI`, `rect`, `triangle`, `line` | 2 | `rect`, `triangle`, and `line` in the Make It Yours list |
| `width/2`, `height/2` | 2 | |
| shapes stack:  what's drawn later sits on top | 2 | inside one character.  Chapter 5 names it *draw order* and uses it for the whole scene. |
| `setVelocity(vx, vy)`, `move()` | 3 | velocity is pixels per frame;  points back to frames in Chapter 1 |
| wrapping at the edges | 3 | |
| `random(a, b)` | 3 | |
| `followMouse()`, `keyboardControl()` | 4 | |
| `keyPressed()`, `mousePressed()`, event functions | 4 | |
| `mouseX`, `mouseY`, `moveTo()`, `keyReleased()` | 4 | `keyReleased()` added during the run:  the Lesson 4 Canvas challenge |
| commenting a line out to switch it off | 3 | moved from Chapter 4 on 2026-10-18:  Chapter 3 switches off `background()` to show the trail, the Lesson 3 Canvas challenge |
| `Block`, and its top-left corner | 5 | Watch out |
| draw order | 5 | |
| a constructor with its own extra number (`Cloud`'s speed) | 5 | |
| alpha, the fourth number | 5 | |
| the seven-number `Blob` (with velocity) | 5 | |
| `collidesWith()` | 6 | |
| `if`, the condition, braces again | 6 | |
| `int`, and a variable at the top of the sketch | 6 | why the top |
| `score = score + 1` | 6 | |
| `text()`, `textSize()`, `+` gluing text to a number | 6 | |
| `boolean`, `true`, `false` | 6 | |
| `!`, `if` / `else` | 6 | |
| writing your own function | 6 | `playGame()`, `showGameOver()` |
| `>`, `<`, `>=`, `<=`, `==`, and `=` against `==` | 6 | |
| `textAlign()` | 6 | |
| `&&`, `||`, `else if` | 7 | |
| restarting by rebuilding, `Sprite.screenBehavior` | 7 | `screenBehavior` added during the run, for the bounce Chapter 3 promised |
| the `data/` folder, `PImage`, `loadImage()`, `ImageSprite`, `String`, `image()`, `imageMode()`, `pushStyle()`, `radius`, `setRotation()` | A | |
| the Sound library, `SoundFile`, `play()`, `loop()`, `stop()`, `amp()`, `isPlaying()` | B | |
| `AnimatedSprite`, animation frames, a property of your own, `this.pose`, a chain of calls, `distanceTo()`, `key` | C | `this` gets its second meaning here, *the object itself* |
| `ArrayList`, `for`, for-each, indexes from 0 | D | |

Checked at the end of the one-shot run, 2026-10-18:  every chapter's *New syntax* table against this ledger.  The rows above with notes are what the run added.  One deliberate repeat:  Bonus C can be taken right after Chapter 2, and its poses need `if`, `==`, and `else if`, so it carries a short Aside on them for early readers, marked as such.  Chapter 6 is still where `if` is taught.

Chapter 1 names *function* (`setup()` and `draw()`) and *method* (a behavior,
written in code) on the same day, as the Lesson 1 Canvas page does.  Chapter 2
is the first time a student writes a method, `drawSprite()`, and it points back.

---

## 7.  The discoveries, chapter by chapter

Each chapter sets these up and leaves the finding to the student.  The answers
go in each chapter's plan, under PRIVATE NOTES, for Jason and for Flint.  Those
marked **found** came from building the code for this book, and the lesson plans
are silent on them.

| Ch | Discovery | Source |
|---|---|---|
| 1 | Move `drawSprite()` into `setup()`, and the blob disappears. | **found**, built from Principle 8 |
| 1 | `color(255, 255, 0)` is yellow.  Light mixes differently from paint. | the lesson plan's developer note on RGB |
| 1 | A white blob on white still shows:  a thin black ring. | **found** |
| 1 | A blob at `(0, 0)` is a quarter of a blob.  `x, y` is the center. | **found** |
| 2 | Move the character's starting spot, and an eye drawn with fixed numbers stays behind. | the plan's "changing pos.x offsets... as you move the blob" |
| 2 | Misspell `drawSprite`, and the character turns back into a plain circle. | **found** |
| 2 | Change the radius in `super(...)`, and nothing on screen changes. | **found**, plants Chapter 6's hitbox |
| 2 | Draw the body last, and it paints over the face. | the Canvas page's pitfalls |
| 2 | Leave out `noFill()`, and the smile fills in. | the Canvas page's pitfalls |
| 3 | Call `drawSprite()` before `move()`. | the plan's exit ticket |
| 3 | Positive `vy` goes down. | the plan |
| 4 | Let go of an arrow key and the character keeps going. | the plan |
| 4 | Any key that isn't an arrow stops it dead.  The space bar is a brake. | **found**, in `Sprite.keyboardControl()` |
| 4 | With arrow keys, the character starts drifting right before you touch a key, from `setVelocity(4, 0)`. | **found** |
| 5 | Draw the ground last, and it buries the player. | the plan |
| 5 | Create a cloud in `draw()`, and it freezes. | the plan's teacher notes |
| 6 | The score races. | the plan |
| 6 | The hazard changes a variable, and nothing reads it. | the plan |
| 7 | Restarting by rebuilding. | the plan |

---

## 8.  What the source material says against itself

Building the code for this plan turned up places where the lesson plan, the
starter, and the library tell different stories.  Following PROCESS.md, the
chapters follow the code, and every disagreement is written down here.

| Where | What |
|---|---|
| Lesson 4 plan | *"releasing a key leaves velocity unchanged (character coasts)"*.  True.  The plan leaves out the other half:  `keyboardControl()` sets the velocity to zero for every key that isn't an arrow.  So any letter, or the space bar, stops the character.  That's a better discovery than the coast. |
| Lesson 4 plan | *"If using followMouse, change the speed in setVelocity()"*.  Right, and it's only for the mouse:  `keyboardControl()` always moves at 5, whatever `setVelocity()` said. |
| Library, `followMouse()` | It divides by the distance to the mouse.  When the character lands exactly on the mouse, the distance is zero and the position becomes NaN, and the character disappears for good.  Rare, and possible.  Within one step of the mouse it also jitters back and forth, since it always takes a full step.  For Jason;  no chapter mentions it. |
| Library, `Blob.drawSprite()` | Uses whatever stroke is set, so a plain Blob has a thin black outline.  `Block.drawSprite()` calls `noStroke()`, and that carries on to everything drawn after it, so in Lesson 5 the coin loses its outline once the ground is drawn first.  Chapter 1 uses the outline;  Chapter 5 will have to say why the coin's outline went. |
| Lesson 3 starter | The plan says the `MyCharacter` tab *"stays the same from Lesson 2"*.  The starter in `examples/Lessons/Lesson03_BringItToLife` ships a placeholder `MyCharacter`, with a comment saying to replace it.  Chapter 3 has to say how a student brings their own tab across. |
| Two starters for each lesson | The Canvas page's code is what students type, and it's what the chapters quote.  `examples/Lessons` holds the same code with longer comments, and those comments use the typographic dash, `—`, which entry 1 bans.  The Canvas copies use a plain hyphen.  **Fixed 2026-10-18** (9.11):  every `—` in `examples/Lessons` is now ` -- `, or a single hyphen on a header title line, as the Canvas copies have it, and one range `0.0–1.0` reads `0.0 to 1.0`.  All twelve starters rebuilt clean afterward. |
| Lesson 1 Canvas page | *"Try taking it out later and see what happens.  It is a good surprise."*, about `background()`.  In Lesson 1 the blob sits still, so taking `background()` out gives Processing's default grey and the same blob.  The surprise, the smear, needs motion, and it's Chapter 3's.  Chapter 1 leaves the promise out. |
| Lesson 2 Canvas pitfall | *"Naming the tab `MyCharacter.pde`... they end up with `MyCharacter.pde.pde`."*  Verified harmless:  a sketch with a `MyCharacter.pde.pde` tab builds and runs.  Chapter 2 leaves it out. |
| Lesson plans 1 to 4 | Still in the old template, with typographic dashes and the teaching held in HTML comments.  Lessons 5 to 7 are in the new one.  The chapters read both. |
| `canvas_import/course.json` and `flint/code_helper_lessons_01_05.md` | The front page says the helper *"will not just hand you the answer"*.  The newer Flint helper, from 2026-10-11, is told to give code freely.  The prologue has to describe one of them.  Question 9.4.  **Settled (9.4):**  students get Sparky, which helps with syntax and ideas and does the math that would otherwise frustrate them.  The prologue says so.  The front page's line in `course.json` still says the helper *"will not just hand you the answer"*, and is left for Jason. |
| Processing 4.4 and later | On a high-density screen, every run prints a warning:  *"Processing now sets pixelDensity(2) by default on high-density screens."*  The school's Macs will likely show it.  Chapter 1's first Check tells students to leave it be.  Question 9.10.  **Settled (9.10):**  Jason has never seen the warning in the lab, which runs the latest Processing each year.  Chapter 1 no longer mentions it. |
| Lesson 4 Canvas page | `followMouse()` and `move()` together are *"jittery."*  With `setVelocity(4, 0)` the character parks perfectly still, just right of the mouse.  The chapter says what the code does.  Chapter 4 plan, 8.2. |
| Lesson 6 plan | The score *"climbs about sixty points a second."*  That's the rate while overlapping;  in a chase it's lower, when the coin wraps away.  The chapter says *"a point for every frame."*  Chapter 6 plan, 8.2. |
| Lesson 7 pitfalls | A stale name in a copied coin block:  verified sharper than the notes say.  With `coin3` left in `coin4`'s `moveTo()`, the game is won in under a second.  Chapter 7 plan. |
| Bonus A Canvas page | A missing file draws *"a blank or colored box."*  It stops the sketch with `NullPointerException`.  Only a PNG without transparency draws a box.  A folder named `Data` works on Windows.  Bonus A plan, 4. |
| Bonus C Canvas page | A constructor left with its old name *"becomes a method that never runs."*  It's a compile error.  And its `distanceTo()` example uses Bonus D's list.  Bonus C plan, 4. |
| The library | Eight rough edges, the `followMouse()` NaN among them, with a suggested fix for each:  the teacher reference, Part Five. |

---

## 9.  Open questions for Jason

The chapters were drafted with a default for each.  A yes or no settles most.

1. **Properties and behaviors.**  Does the C# course's spiral belong in this
   book?  The default was yes, with the nuances in section 4.  If yes, which
   nuances are wrong?
   > We can mention the words, but they're just words at this point.  6th graders are not cognatively ready for those abstract nuances.
2. **The asterisk on `extends`.**  It makes visible exactly what Guiding
   Principle 6 keeps out of the room.  Is that the facade you'd mark?
   > We don't need to use aserix with 6th graders.  That will only confuse them.
3. **Has this course run yet, with these lesson plans?**  The C# book's chapters
   describe the room.  These describe the plan, because there's no record of the
   room.  If it has run, what went differently?
   > We are running the first iteration right now--which is why we changed the ArrayList lesson into a bonus because that was a step too far to be an expecation that /every/ 6th grader can do.
4. **The helper.**  Which one do students get, and what will it do?  The prologue
   has a gap for it.
   > Student's get a Sparky helper that is designed to help them with syntax and help them with ideas and offload the math that would otherwise be frustrating and cause students to dis-engage.
5. **Homework.**  None in the plans, so no **Tonight** boxes.  Right?
   > No homework for the 6th grade class
6. **Notes.**  Do sixth graders in this course keep notes that class picks up
   from?  **Answer in your notes** assumes they do.  One per chapter, at most,
   in the draft.
   > Not explicitly.  Some may keep notes, but it is not an expecatation of the course.
7. **Units.**  Your Character (1 to 4), Your Game (5 to 7), then the bonus
   chapters?
   > Yes, that is the breakdown.
8. **The bonus chapters.**  At the back as Chapters A to D, or each placed where
   the plans say it's best taken?
   > Let's keep those at the back
9. **Why you built SpriteGame**, and when.  The prologue has a gap where the C#
   book has The World's history.
   > SpriteGame is coming from the same belief about Objects First pedagogy that I use in the high school class.  The 2021 version that started this repo was actually about the 3rd iteration of the library.  This was specifically designed for the 6th grade "Coding for Embedded Systems" class that I teach at Winsor.  This is a class that meets 2 out of every 7 class days for 2 alternating quarters.  This course is the first quarter, which ammounts to 11, 55-minute class periods (if I'm lucky).  We teach Processing and Arduino in this class--the second quarter is Arduino using the CircuitPlayground board.  So, thats why this is written in Processing.  It is a great framework for getting young kids excited specifically because it is graphical and very quick to show kids something exciting.  
10. **Processing's version in the lab**, and whether the pixelDensity warning
    shows on the students' Macs.
    > We use the latest version of Processing installed IDE every year.  I've never encountered a pixelDensity warning, so I don't think we need to worry about that.
11. **The starters' dashes.**  Fix the `—` in the starter comments, or leave
    them?
    > Fix them please.
12. **The style guide here is older.**  This repo's `meta/WRITING_COMMON_ERRORS.md`
    lacks entries 36 to 39.  Bring it up to date from OODP_Lessons, or leave
    it for the ClaudeWritingProject sync?
    > Please update this repo's copy.
13. **The book's title.**  *Make Your Own Game*, from the Canvas front page, with
    its own line *"your character, your world, your rules"* as the tagline?
    > Defer this and leave your suggestion for now, it's not a good title, but I need to think about that one more... lol.
    > Settled 2026-10-20:  *Objects First with Processing*.  The tagline stays.
