# Canvas Import — Processing Sprite

This folder holds everything needed to put the lesson series into Canvas:

| What | Where |
|---|---|
| **Course front page, Lesson Pages, Assignments, and teacher copies** as Canvas-ready HTML | [`html/`](html/) — see [`html/README.md`](html/README.md) |
| Lesson content, one JSON file per lesson (the source the HTML is built from) | [`content/`](content/) |
| Course-level content for the front page — **the course title lives here** | [`course.json`](course.json) |
| The generator that turns the JSON into HTML | [`build_canvas_html.ps1`](build_canvas_html.ps1) |
| Non-scoring rubrics as a CSV, for Canvas's rubric importer | [`canvas_rubrics.csv`](canvas_rubrics.csv) |

## Building the HTML

```powershell
powershell -ExecutionPolicy Bypass -File build_canvas_html.ps1
```

Reads every `content/*.json` and writes 3 files per lesson into `html/` — a student-facing
Page, a student-facing Assignment, and a teacher copy — plus `front-page.html` from
`course.json`. 12 lessons → 37 files.

Each output file is a **body fragment**: copy the whole file and paste it into the Canvas
HTML editor (the `</>` button in the Rich Content Editor). There are no `<style>` or
`<script>` tags and no external assets, so Canvas strips nothing.

**Before publishing:** every Page and Assignment has an AI-helper button with a placeholder
`href="PASTE_FLINT_URL_HERE"`, flagged by a `<!-- FLINT-LINK -->` comment. Swap in the Flint
chat URL for that lesson — two per lesson, one on the Page and one on the Assignment.

**The front page** (`html/front-page.html`) is a Canvas Page you then set as the course home
(Pages → ⋮ → *Use as Front Page*, then Home → *Choose Home Page* → *Pages Front Page*). It
carries the course overview, the goals, the four stages, and an index of all 12 lessons. Its
24 links are `LINK_*` placeholders — build the lessons first, then click each link in the
Canvas editor and re-point it at the real item. The full token list is in
[`html/README.md`](html/README.md).

**Teacher copies** open with a red "keep this page unpublished" banner. They carry the direct
instruction notes, guided-activity script, common mistakes, and wrap-up answers that are held
in HTML comments in the source `.md` files. Put them in an unpublished module.

To change wording, edit the lesson's JSON in `content/` and re-run the build. Do not edit the
generated HTML by hand — the next build overwrites it.

---

## The rubrics

These rubrics are **formative and non-scoring**. They mirror the `Rubric` section at the
end of each lesson file. Their job is to give a student (and you) a clear picture of where
they are and what to try next — a *map*, not a grade. There are no points, no mastery
numbers, and nothing that produces a rankable score.

This is a deliberate choice for a non-credit course: a consequential-looking number applied
to creative, exploratory work does more harm than it measures. The rubric describes the
work against a stated standard; it does not rank the student.

## The four stages

Every lesson uses the same named ladder. Each stage includes the one before it.

| Stage | Meaning |
|---|---|
| **Getting Started** | Not running yet — paired with a specific next step to try. |
| **Got It Working** | The lesson's thing runs / happens on screen. |
| **Made It Mine** ⭐ | …and the student made it personal. **The goal for everyone.** |
| **Went Beyond** | …and the student went somewhere the lesson didn't ask for. |

"Went Beyond" has **no fixed list** — the examples in each lesson are starting points, not a
checklist. Going somewhere the lesson didn't anticipate is the whole point.

---

## File — `canvas_rubrics.csv`

One row per lesson (1–9 plus the two bonus lessons), with the standard and the four stage
descriptions. No point columns.

**To use it in Canvas as a no-points rubric:**
1. Go to **Course → Rubrics → + Rubric**.
2. Add one criterion for the lesson; paste the **Standard** as the criterion description.
3. Add four ratings using the stage columns (Getting Started → Went Beyond).
4. Check **"Remove points from rubric"** (and leave "Use this rubric for assignment grading"
   *off*) so it stays purely descriptive feedback.
5. Attach it to the assignment/page for that lesson.

You can also hand the CSV (or the lesson-file rubric) to students directly as a
self-assessment — it's written to them in plain language.

---

## Why there's no Outcomes file

An earlier draft included a Canvas **Outcomes** import (`canvas_outcomes.csv`). It was
removed on purpose: Canvas Outcomes cannot exist without mastery *points* that feed the
Learning Mastery gradebook — i.e., exactly the flat, rankable instrument this course avoids.
If this course ever becomes credit-bearing and a standards-based Outcomes record becomes
genuinely useful, that file can be regenerated from the same stage descriptions.

---

*Source of truth: the `## Rubric` section at the end of each `lessons/lesson_*.md`.*
*If you edit a rubric, update the lesson file and regenerate this CSV to match.*
