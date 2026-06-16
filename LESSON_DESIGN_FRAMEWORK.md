# STEM Lesson Design Framework

A language-agnostic process for turning a base-code project into a structured
lesson series for middle school (grades 6–8) computer science or STEM students.

---

## What This Framework Produces

Following this process yields two artifacts:

| Artifact | What it is |
|----------|------------|
| **Guiding Principles doc** | A project-specific philosophy document — the "why" behind every teaching decision. Lives with the project. |
| **Lesson Series** | 6–10 numbered lessons plus optional bonus/extension lessons, each with teacher notes, starter code, and a student-facing activity. |

The framework below is the *process* for building those two artifacts.
The [Processing-Sprite lessons](lessons/) folder is a reference implementation.

---

## Phase 1 — Foundation Analysis

Before writing a single lesson, understand exactly what the base project
gives students for free and what requires deliberate setup.

### 1A. Map the API Surface

Walk through every class, function, or concept a student will touch and answer:

- **What does it do in one sentence?**  Write this as if explaining to a 6th grader.
- **What is visible immediately?**  Can a student call one line of code and see something on screen (or get a result)?
- **What prerequisite knowledge does it require?**  Variables? Loops? A class definition?
- **What can go wrong silently?**  (e.g. a method that does nothing when a required value is 0)

> **Output:** A table of every student-facing feature with its plain-language description,
> its prerequisites, and any hidden gotchas.

### 1B. Identify the "Hello World" Moment

Find the *single call* or *minimal snippet* that produces something
satisfying with the least prior knowledge.  This becomes Lesson 1.

Rules for the Hello World moment:
- Must produce a **visible or tangible result** (something on screen, a sound, a robot moving)
- Must require **no more than 3–5 lines** of code the student writes
- Must work **without the student understanding how** — the "wow before the why"

### 1C. Find the Concepts-to-API Map

List the CS/STEM concepts you want to teach (variables, loops, conditionals,
functions, objects, etc.) and map each one to the feature of the base project
that makes it feel *necessary*, not arbitrary.

Students learn best when a concept is introduced to *solve a problem they
already feel*, not as an abstract prerequisite.

> **Example from Processing-Sprite:**  `ArrayList` was introduced in Lesson 5
> because by that point students had 10 items to manage and could feel the
> pain of 10 separate variables.

---

## Phase 2 — Pedagogical Decisions

These are the choices that shape the entire lesson arc. Make them explicitly
and record them in the Guiding Principles doc — they will inform every
ambiguous decision that comes later.

### 2A. Choose an Entry Approach

Pick *one* of these (or define your own) and commit to it:

| Approach | First thing students do | Best when |
|----------|------------------------|-----------|
| **Objects First** | Create and use an object before writing any functions | The base project has a clear "thing" students can instantiate immediately |
| **Imperative First** | Write sequential instructions, add structure later | The base project is procedural (scripts, commands, queries) |
| **Output First** | Produce a result first, explain the mechanism later | The base project produces compelling output quickly (data viz, sound, graphics) |
| **Problem First** | Present a challenge, introduce tools as they are needed | Students are motivated by solving a specific authentic problem |

> **Processing-Sprite chose Objects First** because `new Blob(...)` produces
> a visible circle in 3 lines — students experience "object as thing" before
> they hear the word "object."

### 2B. Define the Narrative Thread

A **narrative thread** is a single persistent element that runs through every
lesson, so students always have context for what they are building.

Properties of a good narrative thread:
- It is **student-owned** — they personalize it early and it becomes "theirs"
- It **grows with the curriculum** — each lesson adds a meaningful capability
- It **anchors abstract concepts** — "why does this matter?" always has an answer

> **Processing-Sprite thread:** The student's custom character (`MyCharacter`).
> Created in Lesson 2, it moves in Lesson 3, responds to input in Lesson 4,
> lives in a world in Lesson 8, and is the hero of a full game in Lesson 9.

If no single thread is obvious, look for an artifact that:
- Can be *created* in Lesson 2
- Can be *controlled* by Lesson 4
- Is *part of a larger system* by Lesson 6–7
- Is the *centerpiece of a capstone* by the final lesson

### 2C. Set the Guardrails

Write down the things you will NOT do in this lesson series, no matter how
tempting.  These prevent scope creep and protect students from
demotivating complexity.

Common guardrails for middle school:

- **Do not introduce abstraction before the need is felt.**
  Three similar lines of code is better than a premature helper function.
- **Do not use domain jargon until students have experienced the concept.**
  "This is called a loop" comes *after* they have written one, not before.
- **Do not require understanding of how something works in order to use it.**
  Students can use `collidesWith()` before they can implement it.
- **Do not stack more than one new concept per lesson.**
  If a lesson feels like it needs two new ideas, split it.
- **Do not let the final lesson be open-ended without structure.**
  A capstone needs a scaffold, not just "make whatever you want."

Record your project-specific guardrails in the Guiding Principles doc.

---

## Phase 3 — Lesson Arc Design

Design the full arc before writing any individual lesson.  The arc is a
table with one row per lesson showing the new concept, the API feature that
teaches it, and what the narrative thread gains.

### Arc Table Template

| # | Title | New Concept | API / Feature | Thread Gains |
|---|-------|-------------|---------------|--------------|
| 1 | Hello, [Thing]! | setup, output, the project exists | Hello World moment | Student sees the thing |
| 2 | Make Your [Thread] | objects / creating things | core class constructor | Thread is created and visible |
| 3 | Bring It to Life | state change over time | update / move / tick | Thread does something on its own |
| 4 | You're in Control | input / events | keyboard / mouse / sensor input | Thread responds to the student |
| 5 | A World of [Things] | collections, iteration | list + loop over multiple objects | Thread has a world to interact with |
| 6 | Decisions | conditionals, variables | if/else + game/sim state | Thread reacts to conditions |
| 7 | [Core Mechanic] | interaction between objects | the project's signature feature | Thread interacts with the world |
| 8 | Build the World | composition, layering | combining multiple features | World becomes complete |
| 9 | Capstone | synthesis | all prior concepts | The full artifact is playable/runnable |

**Slot 7** is deliberately left as "[Core Mechanic]" — fill it with the
feature that is most specific to your base project (collision detection,
data filtering, API queries, sensor thresholds, etc.).

### Bonus / Extension Lessons

Design one or two bonus lessons that can be inserted anywhere after Lesson 4
without disrupting the arc.  These should:
- Teach a concept that enriches but is not required for the capstone
- Be self-contained (a student who skips them is not blocked)
- Address a common "what if I want to..." question students will ask naturally

> **Processing-Sprite bonuses:** Images (Bonus A) and Sound (Bonus B) —
> neither is needed for the final game, but both make the game more personal.

---

## Phase 4 — Per-Lesson Scaffolding

Every lesson uses the same template.  Consistency lets students focus on the
content rather than figuring out how the lesson is structured.

### Lesson Template

```
# Lesson N — Title

## Learning Goals
- (2–3 bullet points, written as "students will be able to...")
- Use student-facing language, not CS jargon

## New Vocabulary
- **term** — one-sentence plain-language definition tied to something
  concrete in the project, not an abstract definition

## Warm-Up  (~5 min)
<!-- Discussion question or quick sketch/prediction activity.        -->
<!-- Gets students thinking about the concept before touching code.  -->

## Direct Instruction  (~10 min)
<!--
Teacher-facing notes in HTML comments (invisible to students).
Cover:
  - The one new concept for this lesson
  - The specific API calls / syntax being introduced
  - A concrete demonstration to run on the projector
  - Common misconceptions to address preemptively
-->

## Guided Activity  (~20 min)
<!-- Step-by-step instructions the class follows together.           -->
<!-- Each step should produce a visible/testable result.             -->

## Starter Code
(Runnable code snippet the student begins with — must work out of the box
with zero modifications.)

## Make It Yours  (~remaining time)
Open-ended extension prompts that push the student to personalize:
- At least one "change X to see what happens" prompt (low floor)
- At least one "add Y to your project" prompt (higher ceiling)
- Optional challenge for students who finish early

## Wrap-Up  (~5 min)
<!-- Exit ticket or share-out prompt. One sentence per student.     -->

## Teacher Notes
<!--
Implementation notes, common bugs, pacing advice, differentiation
suggestions.  Anything a substitute teacher would need to run this lesson.
-->
```

### Starter Code Guidelines

Every lesson's starter code must satisfy these rules:

1. **Runs immediately with no modification** — a student who does nothing
   except open the file and press Run sees something happen.
2. **Contains only concepts already taught** — no mystery syntax.
3. **Uses placeholder comments to mark where students will work**
   (e.g. `// YOUR CODE HERE` or `// CHANGE THIS`).
4. **Advances the narrative thread** — the thread element from the previous
   lesson is present and the new lesson's changes are clearly additive.
5. **For multi-file projects:** include all required files, even if some are
   just empty shells with a guiding comment.

---

## Guiding Principles Document

The Guiding Principles doc is a 1–2 page reference that captures all the
decisions from Phases 1–3 *for a specific project*.  Write it before writing
any lessons.  It answers "why did we do it this way?" for every future
ambiguous decision.

### Minimum Sections

```
# [Project Name] — Lesson Series Guiding Principles

## The Base Project
What the project is, who built it, what it gives students.

## Audience
Grade level, prior experience assumptions, course context.

## Entry Approach
Which approach was chosen (Phase 2A) and why.

## Narrative Thread
What the thread is, where it is created, how it evolves.

## Concept Progression Table
The completed arc table from Phase 3.

## Guardrails
The explicit "we will not do this" list from Phase 2C.

## Library / API Quick Reference
A student-facing cheat sheet: the 10–15 most-used calls with one-line
descriptions in plain language.
```

---

## Checklist Before Writing Any Lesson

- [ ] Hello World moment identified (Phase 1B)
- [ ] Concepts-to-API map complete (Phase 1C)
- [ ] Entry approach chosen and written down (Phase 2A)
- [ ] Narrative thread defined with a lifecycle sketch (Phase 2B)
- [ ] Guardrails listed (Phase 2C)
- [ ] Full arc table complete, all 9 slots filled (Phase 3)
- [ ] Bonus lesson slots planned (even if not yet written)
- [ ] Guiding Principles doc drafted
- [ ] Lesson 1 starter code confirmed to run with zero modification

---

## Reference Implementation

The Processing-Sprite lesson series is the reference implementation of this
framework.  When in doubt about how to apply a step, look at what was done
there.

| Framework element | Where to find it |
|-------------------|-----------------|
| Guiding Principles doc | `lessons/GUIDING_PRINCIPLES.md` |
| Completed arc table | `lessons/GUIDING_PRINCIPLES.md` — Lesson Arc section |
| Lesson template in use | Any `lessons/lesson_0N_*.md` file |
| Starter code | `examples/Lessons/Lesson0N_*/` |
| Narrative thread lifecycle | `MyCharacter.pde` appears in Lessons 2–9 |
| Bonus lessons | `lessons/bonus_lesson_A_images.md`, `bonus_lesson_B_sounds.md` |
| Guardrails in practice | `lessons/GUIDING_PRINCIPLES.md` — Guiding Principles section |
