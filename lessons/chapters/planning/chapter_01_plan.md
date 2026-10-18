# Chapter 1 plan - Hello, Blob!

The reasoning behind [`chapter_01_hello_blob.md`](../chapter_01_hello_blob.md),
written while drafting it on 2026-10-18, for Jason to mark up.  Section 8 is
where feedback is most useful.

---

## 1.  Sources read

- `lessons/chapters/BOOK_PLAN.md` and `PROCESS.md`, this book's.
- `OODP_Lessons/Course/chapters/PROCESS.md`, `REVIEW.md`, the prologue, Chapter
  1, Chapter 1's plan, and Chapter 6's style notes, the model.
- `OODP_Lessons/meta/APPALACHIAN_ACADEMIC_STYLE.md` and
  `WRITING_COMMON_ERRORS.md`, in full.  These are newer than this repo's.
- `meta/GUIDING_PRINCIPLES.md`, this course's.
- `lessons/lesson_01_hello_blob/lesson_01_hello_blob.md`, HTML comments and all.
- `lessons/canvas_import/content/01.json`, the Lesson 1 Canvas page, teacher
  section and all.  **This is the most useful source for Lessons 1 to 4.**  It
  has the starter students type, the class's steps, Jason's two metaphors (the
  art table and the flipbook), and the pitfalls he expects.
- `examples/Lessons/Lesson01_HelloBlob`, the same starter with longer comments.
- `lessons/lesson_02_draw_your_character/` and `content/02.json`, for the
  hand-off.
- `src/coxprogramming/processing/sprites/Blob.java` and `Sprite.java`, for what
  a Blob does.

## 2.  The sort

There is no class code to diff.  The Canvas page's `steps` and the teacher's
`guided` list are the class work, and every change they make to the starter
sorts into a pile.

| Change | Pile | Where |
|---|---|---|
| Save as `HelloBlob`, then type the starter | **Built in class** | 1.1 |
| Run it | **Built in class** | 1.1 |
| Radius 40 to 80, then 15 | **Built in class** (the class does it together) | Step 4 |
| Color Selector, own RGB | **Built in class**, then **Your turn** | Step 3 |
| Move the blob | **Your turn** | Step 4 |
| `background(255)` to `background(0)` | **Built in class** (a Canvas step, and the DI demo) | Step 5 |
| A second blob | **Your turn**, **Optional** (Make It Yours, and "Went Beyond" on the rubric) | 1.5 |
| A scene of four or five blobs | **Optional** (the Canvas challenge) | 1.5 |
| `drawSprite()` moved into `setup()` | **added**, for Principle 8.  See 8.1. | Step 1 |
| The three errors | **added**, from the Canvas pitfalls.  See 8.2. | Step 2 |
| `color(255, 255, 0)`, white on white, `(0, 0)` | **added**, as Checks.  See 4. | Steps 3 and 4 |

## 3.  The step order, and why

| Chapter | Source | Why here |
|---|---|---|
| 1.1 | Canvas steps 1 to 4 | type, then run, before any reading |
| 1.2 | the vocabulary's *object*, and the spiral | the sentence the course is built on, before the line-by-line read |
| 1.3 | Canvas "How It Works":  the import line, making a Blob | one pass, top to bottom, through all ten lines |
| Part Two | Canvas "The two magic functions", word for word where it could be | the chapter's one idea gets a Part of its own |
| Step 1 | added | proves the idea with the student's own hands |
| Step 2 | Canvas pitfalls | after the sketch works, so every break has a known-good to go back to |
| 1.4, Step 3 | Canvas "Color is just three numbers", DI "Color and RGB - do not skip this" | the Color Selector, with real time on it |
| Step 4 | Canvas steps 5 and 7 | where and how big |
| Step 5 | Canvas step 8, DI "Demonstrate background()" | |
| 1.5 | Make It Yours, the challenge | last, and optional |

**Where the story bent.**  The Canvas page does color before position, and
radius first of all.  The chapter does Step 1 and Step 2 before any of the
make-it-yours, so the one idea comes before the personalizing.  The rest follows
the page.

## 4.  Discoveries

| Discovery | Set up in | Source |
|---|---|---|
| The blob vanishes when `drawSprite()` moves into `setup()` | Step 1, with the chapter's one **Answer in your notes** | **found**.  The plan is silent.  See 8.1. |
| `color(255, 255, 0)` is yellow | 1.4, "predict one" | the developer note:  *"make sure that we talk about color, the RGB space"* |
| A white blob on white shows as a ring | Step 3 | **found**.  Pays off in Chapter 2, when `noStroke()` arrives. |
| `(0, 0)` gives a quarter of a blob | Step 4, "predict where" | **found**.  The Canvas page says x and y are the center;  this shows it. |
| The import error says nothing about the import | Step 2 | the Canvas pitfalls:  *"the error message does not point at the missing import"* |
| A missing semicolon is reported on the next line | Step 2 | **found** while verifying |

### PRIVATE NOTES - answers, for Jason and a future Flint prompt

- **Where did the blob go (Step 1)?**  `setup()` drew it once.  The first frame
  of `draw()` called `background(255)`, which painted the whole window white,
  and every frame after did the same.  Nothing draws it again.  A good answer
  names `background()`.  A great one says "it got painted over, sixty times a
  second."  The variable still holds the blob the whole time.
- **Yellow.**  Screens mix light (additive), paint mixes pigment (subtractive).
  The chapter says only that they follow different rules.  The words *additive*
  and *subtractive* are left out on purpose, for the level.
- **The ring.**  `Blob.drawSprite()` uses whatever stroke is set, and
  Processing's default stroke is black, one pixel.  In Chapter 2 the character's
  own `noStroke()` turns it off.
- **The quarter blob.**  The blob's center is on `(0, 0)`, so the parts with
  negative x or negative y are off the window.

## 5.  Syntax

### Introduced in Chapter 1

Checked against BOOK_PLAN's ledger.  Every row is Chapter 1's.

| Syntax | Where | How |
|---|---|---|
| sketch, ▶ Run, ■ Stop | 1.1 | prose |
| `//` comments | 1.3 | Aside |
| `import`, *library* | 1.3 | prose, two sentences.  The Canvas teacher note says *"That is the whole explanation.  Do not go further."* |
| a variable, `Blob myBlob;` | 1.3 | prose.  The box picture, switched on. |
| `setup()`, `draw()`, braces, *function* | 1.3, Part Two | prose |
| the semicolon | 1.3 | Aside |
| `size()`, *pixel* | 1.3 | prose |
| x and y | 1.3 | Aside |
| `new Blob(this, x, y, radius, color)` | 1.3 | a table of the five |
| the dot, *method* | 1.3 | Aside |
| `background()` | 1.3, Step 5 | prose |
| *frame* | Part Two | prose, with the flipbook |
| reading an error | Step 2 | Aside |
| `color(r, g, b)`, RGB | 1.4 | prose and a table |
| `NullPointerException` | 1.5 | Watch out |

### Assumed

Nothing.  The prologue promises a reader who has never seen code.

### Left for later, on purpose

- Velocity, and the seven-number `Blob`.  The Canvas notes:  *"The no-velocity
  constructor... is used deliberately.  Velocity is Lesson 3."*
- `random()`.  Chapter 3.
- The smear when `background()` comes out.  It needs motion, so Chapter 3.

## 6.  Verification log

Everything ran on 2026-10-18 with
[`verify_ch01.sh`](verify_ch01.sh), against the Canvas page's starter and this
repo's `library/SpriteGame.jar`, in Processing 4.5.2's command line.

| Check | Result |
|---|---|
| the starter builds and runs | `Finished.`  Frame:  `ch01_Starter.png` |
| `drawSprite()` in `setup()` | runs, empty white window.  `ch01_InSetup.png` |
| no import line | `NoImport.pde:3:0:3:0: Cannot find a class or type named “Blob”` |
| no semicolon after `size(800, 600)` | `NoSemi.pde:8:1:8:1: Syntax Error - Missing ';'?`  The `size` line is line 7. |
| `drawsprite` | `Caps.pde:13:0:13:0: The function drawsprite() does not exist.` |
| `color(255, 255, 0)` | yellow.  `ch01_Yellow.png` |
| `color(255, 255, 255)` | a black ring on white.  `ch01_White.png` |
| `(400, 100)` | near the top.  `ch01_Up.png` |
| `(0, 0)` | a quarter blob in the corner.  `ch01_Corner.png` |
| `background(0)` | red blob on black, outline invisible.  `ch01_Black.png` |
| a friend at `(550, 200)` | two blobs.  `ch01_Two.png` |
| a friend declared and drawn, never created | builds;  runs, then `NoNew.pde:15:0:15:0: NullPointerException` |

**Unverified, because the command line can't see the editor:**

- That the editor shows these messages in the strip under the code, and
  highlights a line.  From the lesson plan and Processing's usual behavior.
- That the editor's message reads the same as the command line's, quote marks
  and all.  The import message came back with curly quotes, `“Blob”`, and the
  chapter copies it that way.
- The Color Selector's look, and that it shows R, G, and B.  From the Canvas
  page.
- That the `pixelDensity` warning appears on the students' Macs.  It printed on
  this machine, on every run.

## 7.  Meeting split

One meeting, one piece.  No split.

## 8.  Guesses and open questions for Jason

1. **Step 1 is mine.**  The plan and the Canvas page are silent on moving
   `drawSprite()` into `setup()`.  It's there because Principle 8 asks for the
   setup/draw model to be *established*, and the blob sits still, so nothing
   else in the lesson shows `draw()` repeating.  Keep it, or cut it?
2. **Step 2, breaking it on purpose.**  The Canvas page names the import and the
   semicolon as *"the two failures you will see."*  The chapter makes both, plus
   the capital letter, before the student hits them by accident.  Three, or the
   two you named?
3. **The one Answer in your notes** is "where did the blob go?"  Is that the
   question you'd want the room to start from?
4. **The asterisk on properties and behaviors.**  BOOK_PLAN question 9.1.  This
   is where it lands, if it lands.
5. **`this`.**  The chapter says it's *"the sketch the blob belongs to.  Copy it
   exactly, every time."*  The Canvas page says *"this sketch... never change
   it."*  Same instruction, positive form.
6. **Length.**  2,950 words of prose, against BOOK_PLAN's 1,800 to 2,800.  The
   overage is the line-by-line read in 1.3, and the three errors.  First cuts,
   if it's too long:  the comments Aside, and the `(400, 100)` screenshot.
7. **The pixelDensity line** in the first Check.  Keep it only if the lab's
   Macs print the warning.
8. **The opening** (`book/opening_01.md`) is the empty white window from Step 1.

### Settled 2026-10-18, from Jason's answers in BOOK_PLAN section 9

- **3, the Answer in your notes:**  gone.  Notes aren't an expectation of the
  course.  Step 1 now asks *"Where did the blob go?  Make a guess before you
  read on."* in plain prose, and the answer follows.
- **4, the asterisk:**  gone.  1.2 now defines *property* and *behavior* as two
  plain words with concrete examples.  The "say it out loud" and "say it again"
  lines came out with it, and so did the first line of Check your
  understanding question 1.
- **7, the pixelDensity line:**  gone.  Jason has never seen the warning in the
  lab.
- Still open:  1, 2, 5, 6, and 8.
