# Flint Helpers - Sparky

The prompts for **Sparky**, the AI helper students open from every Canvas lesson
page and assignment.  There's one Sparky per lesson, plus one for the whole
course.

| What | Where |
|---|---|
| The rules every Sparky follows | [`src/sparky_rules.md`](src/sparky_rules.md) |
| What each Sparky knows about its own lesson | [`src/`](src/), one file per lesson |
| The finished prompts, ready to paste into Flint | [`helpers/`](helpers/) |
| The script that puts them together | [`build_helpers.ps1`](build_helpers.ps1) |
| Student feedback, and what it changed | [`feedback/`](feedback/) |

## Building

```powershell
powershell -ExecutionPolicy Bypass -File build_helpers.ps1
```

Each file in `src/` has one line, `<!-- SPARKY RULES -->`, where the shared
rules go.  The script puts them in and writes the result to `helpers/`.  To
change how every Sparky behaves, edit `sparky_rules.md`.  To change what one
Sparky knows, edit its lesson file.  Then rebuild, and paste the changed files
into Flint.  Don't edit `helpers/` by hand:  the next build overwrites it.

## Which prompt goes where

Every Canvas Page and Assignment has an AI-helper button with
`href="PASTE_FLINT_URL_HERE"` (see [`../canvas_import/README.md`](../canvas_import/README.md)).
Make one Flint helper from each file in `helpers/`, and point that lesson's
buttons at it.

| Flint helper | Prompt | Canvas buttons |
|---|---|---|
| Lesson 1 | `lesson_01_hello_blob.md` | Lesson 1 Page and Assignment |
| Lesson 2 | `lesson_02_draw_your_character.md` | Lesson 2 Page and Assignment |
| Lesson 3 | `lesson_03_bring_it_to_life.md` | Lesson 3 Page and Assignment |
| Lesson 4 | `lesson_04_youre_in_control.md` | both Lesson 4 Pages (Mouse and Keys) and the Assignment |
| Lesson 5 | `lesson_05_build_your_world.md` | Lesson 5 Page and Assignment |
| Lesson 6 | `lesson_06_collisions.md` | Lesson 6 Page and Assignment |
| Lesson 7 | `lesson_07_build_your_game.md` | Lesson 7 Page and Assignment |
| Bonus A | `bonus_a_images.md` | Bonus A Page and Assignment |
| Bonus B | `bonus_b_sounds.md` | Bonus B Page and Assignment |
| Bonus C | `bonus_c_animation.md` | Bonus C Page and Assignment |
| Bonus D | `bonus_d_lists.md` | Bonus D Page and Assignment |
| Any lesson | `code_helper.md` | the course front page, or wherever you want a general helper |

The book's chapters are built as Word files for Flint too
(`../chapters/build/word`, see [`../chapters/PROCESS.md`](../chapters/PROCESS.md)
step 9).  Attach a lesson's chapter to its helper as a knowledge file if Flint
allows it.  [`SpriteGame_Library_Reference.docx`](SpriteGame_Library_Reference.docx)
is the older library reference.

## How Sparky gives code

All the helpers follow one rule, set after the Q1 2026 feedback:  **fill in the
blank first.**  The first time a student asks for code, Sparky gives it with
blanks for the choices that are theirs.  When they ask again, or are stuck,
Sparky gives the whole thing.  It never refuses outright.  The full set of
rules, and the student feedback behind each one, are in
[`src/sparky_rules.md`](src/sparky_rules.md) and
[`feedback/2026-q1_sparky_findings.md`](feedback/2026-q1_sparky_findings.md).
