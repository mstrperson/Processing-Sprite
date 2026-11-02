# Appendix 3 - The Sparky Prompts

*What every Sparky is told, word for word.*

---

Students in this course have an AI helper called **Sparky**.  It runs on
Flint, and every Canvas lesson page and Assignment has a button that opens the
Sparky for that lesson.  The prologue tells students what Sparky is for, and
every chapter has an **Ask Sparky** box with good questions to start with.

This appendix is the other side of that.  It prints the instructions each
Sparky is given.  A teacher can read exactly what students are hearing, and
Part One says how to change it.  The prompts below are put in from the course's repository each time
the book is built, so they match what's pasted into Flint.

| Part | What it covers |
|---|---|
| One | **What Sparky is for.**  The goals, where the rules came from, and how to set the helpers up. |
| Two | **The shared rules.**  The rules every code Sparky follows. |
| Three | **The lesson Sparkys.**  What each lesson's Sparky knows about its lesson. |
| Four | **The other two.**  The Sparky for saving and handing in, and the one for any lesson. |

---

# Part One - What Sparky is for

## A3.1  The goals

Sparky has three jobs.

1. **Syntax.**  The exact spelling of a method, a missing semicolon or brace,
   what a red error message means.  A sixth grader can lose a whole class to a
   capital letter.  None of that is what the lesson is teaching.
2. **Ideas.**  When a student is stuck on what to make, Sparky offers two or
   three and lets the student pick.
3. **The math.**  Placing a hat on a character's head is arithmetic from
   `pos.x` and `pos.y`, and so is the curve of a smile.  That work is
   frustrating at eleven, and it's where students give up.  Sparky does the
   numbers so the student gets back to building.

Some things belong to the student, and the rules keep them there.  The student
decides what the character looks like, what the world is, and what the game is
about.  The student types the code in.  Sparky coaches students to find small
errors on their own, and it gives code with blanks first.  When the student
asks again, Sparky gives the whole thing.  It never refuses outright.

The teacher is the backstop.  When Sparky misses twice, or says it isn't sure,
it sends the student to the teacher, and the prologue tells students to do the
same.

## A3.2  Where the rules came from

At the end of the first quarter, in the fall of 2026, fifteen students wrote
about Sparky.  Most of them went to Sparky first when they were stuck, and none
went to the teacher first.  They rated it helpful overall.  The help they liked
most was drawing:  characters, backgrounds, and decorations.  The most common
complaint was code that broke a sketch that had been working, and one student
lost work for good.

The shared rules in Part Two answer those findings.  Sparky gives only the
lines that change.  It tells the student to save a numbered copy before a big
change, and it says "I'm not sure" when it can't find the problem.  It
repeats a shape back in words before drawing it.  And code comes with blanks
first, because students said that was the help that worked best.

The full findings, and the reflections behind them, are in the repository
under `lessons/flint/feedback/`.

## A3.3  How a prompt is put together

Each lesson's Sparky is two files joined together:  the **shared rules**,
which every code Sparky gets, and a **lesson file** about that one lesson.  The
script `lessons/flint/build_helpers.ps1` puts the rules into each lesson file
and writes the finished prompts to `lessons/flint/helpers/`.  Those are the
files to paste into Flint.

Part Two prints the shared rules once.  Parts Three and Four print each lesson
file, with a line where the rules go.  A lesson file has the same sections in
the same order.

| Section | What it gives Sparky |
|---|---|
| This lesson | What students build today, and what changes in their sketch. |
| Words students know by now | The vocabulary so far, and what's still to come.  Sparky keeps to these words. |
| Good things to ask | The questions Canvas and the chapter's **Ask Sparky** box suggest.  Always in scope. |
| Starter code | The lesson's code, for a student who missed class or wants to start over. |
| Common problems and their fixes | What goes wrong, matched to what students say.  For Sparky only. |
| Later lessons, if they ask | A small preview of what's coming, and which lesson teaches it. |

The Saving and Handing In Sparky is different.  It does no code, so it gets
none of the shared rules, and it has rules of its own.  The most important is
a list of things it must never tell a student to delete.

## A3.4  Setting them up in Flint

Make one Flint helper from each file in `lessons/flint/helpers/`.  Each Canvas
button has a key, and the Canvas importer fills in each button's link from a
file of keys and Flint links.  The repository's `lessons/flint/README.md` has
the steps.

| Flint helper | File | Canvas buttons | Key |
|---|---|---|---|
| Lesson 1 | `lesson_01_hello_blob.md` | Lesson 1 Page and Assignment | `flint:lesson-01` |
| Lesson 2 | `lesson_02_draw_your_character.md` | Lesson 2 Page and Assignment | `flint:lesson-02` |
| Lesson 3 | `lesson_03_bring_it_to_life.md` | Lesson 3 Page and Assignment | `flint:lesson-03` |
| Lesson 4 | `lesson_04_youre_in_control.md` | both Lesson 4 Pages and the Assignment | `flint:lesson-04` |
| Lesson 5 | `lesson_05_build_your_world.md` | Lesson 5 Page and Assignment | `flint:lesson-05` |
| Lesson 6 | `lesson_06_collisions.md` | Lesson 6 Page and Assignment | `flint:lesson-06` |
| Lesson 7 | `lesson_07_build_your_game.md` | Lesson 7 Page and Assignment | `flint:lesson-07` |
| Bonus A | `bonus_a_images.md` | Bonus A Page and Assignment | `flint:bonus-a` |
| Bonus B | `bonus_b_sounds.md` | Bonus B Page and Assignment | `flint:bonus-b` |
| Bonus C | `bonus_c_animation.md` | Bonus C Page and Assignment | `flint:bonus-c` |
| Bonus D | `bonus_d_lists.md` | Bonus D Page and Assignment | `flint:bonus-d` |
| Saving and Handing In | `files_helper.md` | the **Saving and Handing In Your Work** help page | `flint:files` |
| Any lesson | `code_helper.md` | the course front page, or anywhere a general helper fits | none |

If Flint takes knowledge files, attach each chapter's Word file from
`lessons/chapters/build/word/` to its lesson's helper.  The Saving and Handing
In Sparky gets Appendix 1.

## A3.5  Changing a Sparky

To change how every Sparky behaves, edit `lessons/flint/src/sparky_rules.md`.
To change what one Sparky knows, edit its lesson file in the same folder.  Then
run `build_helpers.ps1` and paste the changed files from `helpers/` into Flint.
A change to the shared rules changes every code Sparky, so all twelve need
pasting again.  The next build of this book prints the new version here.

Each lesson's good things to ask are in three places:  the Sparky's lesson
file, the Canvas lesson page, and the chapter's **Ask Sparky** box.  Change all
three together.

---

# Part Two - The shared rules

## A3.6  Every Sparky's rules

Every code Sparky gets these rules, from `sparky_rules.md`, in place of the
line that says so in its lesson file.

<!-- SPARKY PROMPT sparky_rules.md -->

---

# Part Three - The lesson Sparkys

## A3.7  Lesson 1, Hello, Blob!

From `lesson_01_hello_blob.md`.  Canvas key `flint:lesson-01`.

<!-- SPARKY PROMPT lesson_01_hello_blob.md -->

## A3.8  Lesson 2, Draw Your Character

From `lesson_02_draw_your_character.md`.  Canvas key `flint:lesson-02`.

<!-- SPARKY PROMPT lesson_02_draw_your_character.md -->

## A3.9  Lesson 3, Bring It to Life

From `lesson_03_bring_it_to_life.md`.  Canvas key `flint:lesson-03`.

<!-- SPARKY PROMPT lesson_03_bring_it_to_life.md -->

## A3.10  Lesson 4, You're in Control

From `lesson_04_youre_in_control.md`.  Canvas key `flint:lesson-04`.

<!-- SPARKY PROMPT lesson_04_youre_in_control.md -->

## A3.11  Lesson 5, Build Your World

From `lesson_05_build_your_world.md`.  Canvas key `flint:lesson-05`.

<!-- SPARKY PROMPT lesson_05_build_your_world.md -->

## A3.12  Lesson 6, Collisions

From `lesson_06_collisions.md`.  Canvas key `flint:lesson-06`.

<!-- SPARKY PROMPT lesson_06_collisions.md -->

## A3.13  Lesson 7, Build Your Game

From `lesson_07_build_your_game.md`.  Canvas key `flint:lesson-07`.

<!-- SPARKY PROMPT lesson_07_build_your_game.md -->

## A3.14  Bonus A, Images

From `bonus_a_images.md`.  Canvas key `flint:bonus-a`.

<!-- SPARKY PROMPT bonus_a_images.md -->

## A3.15  Bonus B, Sounds

From `bonus_b_sounds.md`.  Canvas key `flint:bonus-b`.

<!-- SPARKY PROMPT bonus_b_sounds.md -->

## A3.16  Bonus C, Animate Your Character

From `bonus_c_animation.md`.  Canvas key `flint:bonus-c`.

<!-- SPARKY PROMPT bonus_c_animation.md -->

## A3.17  Bonus D, Lists and Loops

From `bonus_d_lists.md`.  Canvas key `flint:bonus-d`.

<!-- SPARKY PROMPT bonus_d_lists.md -->

---

# Part Four - The other two

## A3.18  Saving and Handing In

From `files_helper.md`.  Canvas key `flint:files`.  This Sparky does no code,
and it gets none of the shared rules.

<!-- SPARKY PROMPT files_helper.md -->

## A3.19  Any lesson

From `code_helper.md`.  No Canvas key:  link to it from wherever a general
helper fits.

<!-- SPARKY PROMPT code_helper.md -->
