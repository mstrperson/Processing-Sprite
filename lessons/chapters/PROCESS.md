# The Chapter Process

How a lesson becomes a textbook chapter, for this course.  Adapted on
2026-10-18 from `OODP_Lessons/Course/chapters/PROCESS.md`, the C# course's
process, which was worked out backward from its Chapter 6.  Most of it carries
over word for word.  What changed is the source of the Steps, the way code gets
verified, and the reader.

Read [`BOOK_PLAN.md`](BOOK_PLAN.md) first.  It settles, once, what the C#
book's drafters each settled alone:  the register, the threads, and which
chapter explains which piece of syntax.  Then each lesson's plan in
`planning/`, then its chapter.  Feedback on a plan is worth more than feedback
on a chapter, because a plan error repeats in every chapter it touches.

---

## The inputs, and the rule

| Input | Where it lives | What it gives the chapter |
|---|---|---|
| The lesson plan | `lessons/lesson_0N_*/lesson_0N_*.md` | the idea, the order, the discoveries, the meeting count, Make It Yours |
| The Canvas page | `lessons/canvas_import/content/0N.json` | what students actually see:  the starter code they type or paste, the steps, the teacher's guided sequence and pitfalls.  Newer than the Lesson 1 to 4 plans, and in Jason's current prose |
| The starter | the Canvas page's `code`, which is what students type;  `examples/Lessons/Lesson0N_*` is the same code with longer comments | Part One:  the sketch students start from |
| The class work | the Canvas page's `steps` and `teacher.guided`, and the plan's **Build It Step by Step** | the Steps:  what gets built, in what order |

The C# book read its Steps off a git diff, from the starter on `main` to the
class's code on `Teacher`.  This repo has no `Teacher` branch and no record of
the room, so the Steps come from the Canvas page and the lesson plan, and every
one of them gets built for real before the chapter says what it does.  Where
the plan and the Canvas page disagree, the Canvas page is what students see,
and the chapter follows it.

**The rule:  every line of code in a chapter is real.**  It is copied from the
starter or the lesson plan, or it is a student's **Your turn** that the plan
says the student writes.  Every Check that predicts a picture was run, and the
screenshot beside it is that run's frame.  Every error a chapter quotes was
produced by building the code, and its message is copied from Processing's
output.

---

## The steps

### 1.  Inventory

Read the lesson plan, HTML comments and all, the Canvas page's JSON, teacher
section and all, and the starter sketch, every tab.  Pull the Canvas page's
code into a scratch sketch to verify it, since that's the text students type.
Read the library source for anything the chapter claims a sprite does
(`src/coxprogramming/processing/sprites/`).  Read the chapter before and the
chapter after, so this one opens where the last one left off and closes on what
comes next.  Check `BOOK_PLAN.md`'s syntax ledger for what this chapter
explains and what it points back to.

### 2.  Sort the plan's code

Sort every change the plan makes to the starter into one of three piles.

- **Built in class**, which becomes a Step:  the Build It Step by Step list,
  and the Direct Instruction demos.
- **A Your turn**, the student's to write:  Make It Yours, and the plan's
  fast-finisher notes, marked **Optional**.
- **Teacher scaffolding**, such as a demo the teacher does on the projector
  and nobody types, which the chapter describes or skips.

### 3.  Find the order

Each Step has to run at its end.  So order the changes by dependency, then by
the lesson plan's story.  Where the two disagree, the sketch has to run, and the
story bends.

### 4.  Find the discoveries

Every lesson plan has things students are meant to *find*:  the score that
races, the cloud that freezes.  Building the code turns up more, and those go in
the plan marked **found**.  The chapter sets each one up and leaves the finding
to the student.  The answers go in the plan's PRIVATE NOTES, for Jason and for
the Flint prompt.

### 5.  Verify the code

`tools/verify.sh` does it, against this repo's own `library/SpriteGame.jar`,
in a scratch copy.  The lesson's folder is never touched.

```
lessons/chapters/tools/verify.sh prep  examples/Lessons/Lesson01_HelloBlob  <scratch>/Starter
lessons/chapters/tools/verify.sh build <scratch>/Starter
lessons/chapters/tools/verify.sh shot  <scratch>/Starter  lessons/chapters/screenshots/ch01_Starter.png
```

- For every **Check** that predicts a picture, put the scratch copy in that
  state, run `shot`, and look at the frame before the chapter says what it
  shows.  The frame goes in `screenshots/`, named `chNN_What.png`.
- For every **Check** that predicts an error, make that exact edit, run
  `build`, and copy the message into the chapter.
- A Check about a missing `import` line has to delete the copy's `code/`
  folder first, because Processing imports every jar it finds there.
- When two frames should look the same, compare the files.  Byte-identical
  PNGs settle it.  Compare whole frames, before any crop.
- When the thing a Check is about is small in the window, crop the frame:
  `shot` takes `x y w h` after the frame number, in the sketch's coordinates.
  A crop of the real frame is still the real frame.  The plan says which
  pictures are crops.
- The command line has no mouse or keyboard.  `shot` takes `PRE='code'`, run at
  the top of every `draw()`:  set `mouseX` and `mouseY`, or press a key on a frame
  with `keyCode = UP; keyPressed();`.  To touch something that starts at random,
  point the mouse at its position every frame and let `followMouse()` chase it.
  The plan says which pictures were driven this way.
- Park the mouse off the character's row and column.  A character level with the
  mouse, a whole number of steps away, lands on it exactly, and `followMouse()`
  turns its position into NaN (the teacher reference, R.6).
- Where two frames must match and the sketch uses `random()`, put
  `randomSeed(5)` in both scratch copies' `setup()`.
- When the thing to check isn't visible, print it:  a `println()` in `PRE` reports
  a variable on a given frame.  `PRE` runs at the **top** of a frame, so a report
  on frame 2 is what frame 1 did.
- Sketches that need files get stand-ins:  `tools/make_test_art.ps1` for
  pictures, and Windows' own `C:\Windows\Media` WAVs for sounds.
- **A quoted listing longer than a screen is spliced in, never retyped.**  Write
  a placeholder in the chapter, splice the verified file in with `awk`, and `diff`
  the chapter's block against the file.

Anything the chapter claims that the scratch copy can't confirm goes in the
plan as unverified.  The command line can't see Processing's editor, so the
editor's own look (the tab menu, the Color Selector, where the message bar
sits) is described from the lesson plan, and marked so.

### 6.  Split into meetings

The meeting count comes from the lesson plan's timing.  Lessons 1 to 5 are one
meeting each, so their chapters are one piece.  Lesson 6 splits at Day 2, and
Lesson 7 at each of its three periods.  The plan records which headings start
which meeting, and `tools/build_chapter.lua` gets an entry to match.

### 7.  Write

The shape is the C# book's.

```
# Chapter N - Title
*tagline:  the lesson's one new idea*
---
Opening:  where the last chapter left us, and the problem it left behind.
"This chapter does it in N moves" table.
---
# Part One - ...                reading the starter:  ## N.1, N.2 ... sections
# Part Two - ...                building:  ## Step 1 - ..., ## Step 2 - ...
...
## Chapter summary              "You built | It's an example of" table
### New syntax in this chapter  table, with where each was met
### Vocabulary                  alphabetical, each with its section
### Check your understanding    numbered questions
## What's next
```

How a chapter runs, and how to read one, live once, in the prologue, and a
chapter leaves both out.

The marks, which the build turns into boxes:

| Marker | Written as | Means |
|---|---|---|
| **Build it.** | bold, at the start of a paragraph | type this into the sketch |
| **Your turn.** | bold, at the start of a paragraph | the student writes this, unguided |
| **Optional** | bold, inside a Your turn | nothing later depends on it |
| Aside | `> **Aside:  topic**` | a piece of Processing explained the first time it appears |
| Check | `> **Check.**  ...` | stop, run, and here is what you should see |
| Watch out | `> **Watch out.**  ...` | the mistake nearly everybody makes here |
| Screenshot | `> **Screenshot:**  caption`, then `> ![](screenshots/chNN_What.png)` | the frame the Check describes |
| Argue it | `> **Argue it.**  ...` | a choice with no settled answer, for class |

**Each chapter teaches what it needs, at the point it needs it**, and only once
in the whole book.  The syntax ledger in `BOOK_PLAN.md` says which chapter
explains what.  A later chapter points back in one line.

**Questions turn into explanations.**  The C# book's first run carried a lesson
plan's questions back into its chapters, up to eleven **Answer in your notes**
in two meetings.  A question the chapter can answer, it answers, followed by a
Check.  This course doesn't expect notes, so there's no **Answer in your
notes** box at all.  Where the chapter wants a student to think first, it asks
in a plain line, *"Make a guess before you read on,"* and the answer follows.

**Sixth-grade rules, from Jason on 2026-10-18.**  No giant asterisks:  *"That
will only confuse them."*  *Property* and *behavior* are vocabulary, used where
they name something on the screen, with no abstract nuance layered on.  The bar
for a core chapter is what every sixth grader can be expected to do.  The rest
goes in a bonus chapter, the way lists and loops did.

### 8.  Check the prose

The voice rules are in OODP_Lessons' `meta/APPALACHIAN_ACADEMIC_STYLE.md` and
`meta/WRITING_COMMON_ERRORS.md`, which are newer than this repo's copies.  Every
drafter reads both in full.  The mechanical ones get a grep before a chapter is
done:

| Rule | Find it |
|---|---|
| two spaces after every sentence, and after a colon | `grep -nE '[a-z)][.?!:] ["A-Z]'` and `grep -nE '[a-z)][.?!:](\*\*\|\*) [^ ]'` |
| no typographic dashes;  `--` with a space each side | `grep -n '—\|–'` outside quoted code |
| no paired `-- ... --` brackets | `grep -nE ' -- [^.]{5,120} -- '` |
| headings take a single hyphen | `grep -nE '^#{1,6} .* -- '` |
| no definition by negation | read for `not`, `never`, `nothing`, `without`, `rather than`, `instead of` doing setup-and-knockdown work |
| no abstract "stays" (entry 29) | `grep -niE '\bstay(s\|ed\|ing)?\b'`, and ask whether you could point at it |
| no "landed" meaning got-through (entry 37) | `grep -niE '\bland(s\|ed\|ing)?\b'`, and ask whether you could watch it land |
| no commentary lines (entry 36) | read every paragraph's last sentence:  does it add a fact? |
| no beat that only completes a shape (entry 27) | delete each comma-tail, third item, and vouching sentence, and reread |
| the register (entry 22) | the `register` function:  contractions near the prologue's rate |
| no asterisks in this book | `grep -n '{.iceberg}'` finds nothing |

### 9.  Build

```
pandoc lua lessons/chapters/tools/build_chapter.lua 00 01 02 03 04 05 06 07 A B C D R
pandoc lua lessons/chapters/tools/build_chapter.lua book
powershell -ExecutionPolicy Bypass -File lessons/chapters/tools/finish_book.ps1
```

On a Mac, the last line is `osascript lessons/chapters/tools/finish_book.applescript`
instead.  It does the same steps in Word for Mac, in about two and a half
minutes.  Leave Word alone while it runs.

The tools, all in `tools/`:

| Tool | What it does |
|---|---|
| `verify.sh` | `prep`, `build`, and `shot` a scratch copy of a sketch, with `PRE` and crops |
| `canvas_sketch.ps1` | writes a lesson's Canvas code into a sketch, with the last lesson's tabs carried in.  Use its parameter names. |
| `make_test_art.ps1` | stand-in pictures for Bonus A and Bonus C |
| `make_art/` | a Processing sketch that draws the book's cover, each chapter's title-page picture, and the spot pictures, into `build/book` |
| `check_prose.sh` | step 8's mechanical checks, on any chapter |
| `verify_all.sh` | reruns every `planning/verify_*.sh`, and compares the new pictures with the book's |
| `build_chapter.lua` | Word files, Canvas pages, and the book |
| `finish_book.ps1` | lays out the book in Word, exports the PDF, and cuts each meeting's PDF from it |
| `finish_book.applescript` | the same, in Word for Mac.  Its header says where it differs. |

If `finish_book.ps1` stops partway, Word is left running as an `/Automation`
process.  Stop that one, and only that one, before running it again.

The first makes one Word file per meeting, for Flint, in `build/word`, and one
Canvas page per meeting in `build/canvas`.  Screenshots are embedded in the Word
files.  On a Canvas page each one is an `<img>` with a `SCREENSHOT` comment
above it:  upload the PNG to the course's Files and point the `src` at it.
`lessons/canvas_import` is left alone.

The second and third make the printed book, `build/book/Book_Draft.pdf`, and
cut each meeting's PDF out of it into `build/pdf`, so a handout and the book
agree page for page.  The cover, each chapter's title-page picture, and the
spot pictures `finish_book.ps1` puts in large gaps come from `tools/make_art`,
a Processing sketch:  `Processing cli --sketch=lessons/chapters/tools/make_art
--run`, then build the book again.  Each chapter's title page takes its opening from
`book/opening_NN.md`:  one mildly amusing line of prose, then a moment quoted
from the chapter, where its problem first shows.  The opening prints unlabeled.

---

## What this process can't know

- **What happens in the room.**  The chapters are built from the plan, before
  or without a record of the class.  Where a lesson has run, what the room did
  should win.
- **Processing's editor.**  The command line builds and runs sketches, and it
  can't see the editor.  The tab menu, the Color Selector, and the message bar
  come from the lesson plans.
- **Jason's call on what's a discovery.**  Where a plan is silent, the drafter
  guessed, and the plan says so.
