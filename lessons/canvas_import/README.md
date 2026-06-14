# Canvas Import — Processing Sprite Rubrics

These rubrics are **formative and non-scoring**. They mirror the `## Rubric` section at the
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
