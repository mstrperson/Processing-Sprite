# Guiding Principles for Computer Science Education (General)

These are the ten pedagogical principles behind [`lessons/GUIDING_PRINCIPLES.md`](lessons/GUIDING_PRINCIPLES.md),
abstracted away from Processing, SpriteGame, `Blob`, and 6th grade specifically.
They are the *philosophy* half of [`LESSON_DESIGN_FRAMEWORK.md`](LESSON_DESIGN_FRAMEWORK.md) —
that document is the process for building a lesson series; this one is the
set of commitments that process is trying to protect, stated so they transfer
to any language, any library, any grade band.

Each principle below states the general commitment, then shows how it
instantiated in the Processing-Sprite series as a worked example.

---

## 1. Start with the paradigm's fundamental unit, not an explanation of it

The first thing students create should be a real instance of whatever the
domain's core unit of thought is — an object, a function, a query, a
component — not a lecture about what that unit is in the abstract.

> **Processing-Sprite:** The first thing students create is a `Blob` — a live
> object on screen. Raw shapes, variables, and loops come later, always in
> service of making that object do something more interesting.

## 2. Give students one persistent, personal thread to build

A single artifact that is created early, is unmistakably the student's own,
and grows a real capability in every subsequent lesson gives every later
abstraction a reason to exist. Students learn a concept faster when it is in
service of something they already care about, rather than a standalone
exercise.

> **Processing-Sprite:** Starting in Lesson 2, students draw a custom
> character. Every lesson from that point builds it — motion, control, a
> world, a game. By Lesson 9 the game *is* their character.

## 3. Visible output before abstract explanation

Every lesson should produce something the student can see, hear, or
otherwise perceive within the first few minutes — before any abstract
concept is introduced. Delay explanation until students have something
working that they're invested in.

> **Processing-Sprite:** Every lesson produces something visible within the
> first five minutes, regardless of what concept it's building toward.

## 4. Imitate before you invent

Give students a complete, working example first. Have them *run* it, then
*modify* it, then *personalize* it. Creativity at this stage happens by
changing values — not by requiring understanding of the underlying
machinery.

> **Processing-Sprite:** Each lesson provides working example code students
> run, then modify, then personalize — never a blank file and a spec.

## 5. Treat abstraction layers as tools, not lessons

Any library, framework, or API a project depends on will contain concepts far
beyond the current grade band. Don't teach those concepts. Frame the
dependency as a toolbox of things that "know how to do stuff." Students call
its methods the way they push buttons on a machine — the button works, and
that is sufficient justification for using it.

> **Processing-Sprite:** The Sprite library contains inheritance, abstract
> classes, and reflection — years beyond 6th grade. Students call
> `blob.move()` or `player.setVelocity(3, -2)` without needing to know how
> those methods are implemented.

## 6. Give advanced syntax a one-sentence, jargon-free cover story

When the project requires students to write syntax that encodes a concept
above their level (inheritance, generics, async, pointers, decorators),
supply one plain-English sentence that explains *what to do*, not *what it
means formally*. Never introduce the technical term. Never explain the parts
of the syntax that exist purely to satisfy the language, beyond "copy this
exactly."

> **Processing-Sprite:** `class MyCharacter extends Blob` is explained as
> *"your character is built on top of Blob — it already knows how to move;
> you just add what it looks like."* The word "inheritance" is never used,
> and `super()` is described only as "the handshake — copy it exactly."

## 7. One new concept per lesson, no exceptions

Introduce at most one genuinely new idea per lesson. Everything else in that
lesson should be review or a small, safe extension of something already
seen. If a lesson feels like it needs two new ideas, split it into two
lessons.

> **Processing-Sprite:** Each of the nine lessons maps to exactly one new
> concept in the arc table (`setup()`/`draw()`, `extends`, `setVelocity()`,
> event handlers, `ArrayList`, `if`, collisions, layering, synthesis).

## 8. Establish the program's control skeleton early, and reuse it explicitly

Every language or platform a project is built on has some underlying
execution model — an event loop, a request/response cycle, a main function,
a callback structure. Name and diagram this skeleton in Lesson 1, and
reinforce the same mental model every lesson after, so students can predict
where new code goes without being told.

> **Processing-Sprite:** `setup()` and `draw()` are established as "one-time
> setup" vs. "things that repeat" in Lesson 1, and every later lesson
> reinforces that same split.

## 9. Vocabulary is introduced only once it names something already seen

Never define a term in the abstract before students have had the concrete
experience it describes. Introduce words like *variable*, *object*,
*function*, *loop* only at the moment they are useful for describing
something already on screen or already built.

> **Processing-Sprite:** Terms like *variable*, *object*, *method*, *list*
> are introduced only after the student has already seen the thing they
> name.

## 10. End every lesson with student-directed personalization

Before a lesson ends, students should modify at least one parameter or
feature of their own choosing — not a prescribed exercise, but a real choice.
This is what converts an exercise into a small project the student has a
stake in.

> **Processing-Sprite:** Every lesson closes with a "Make It Yours" section
> where students customize color, speed, behavior, or appearance before
> moving on.

---

## How This Relates to the Other Two Documents

| Document | Answers |
|---|---|
| `CS_GUIDING_PRINCIPLES.md` (this file) | *What do we believe about how CS is learned, independent of any one project?* |
| [`LESSON_DESIGN_FRAMEWORK.md`](LESSON_DESIGN_FRAMEWORK.md) | *What process turns a base project into a lesson series that honors those beliefs?* |
| [`lessons/GUIDING_PRINCIPLES.md`](lessons/GUIDING_PRINCIPLES.md) | *How did those beliefs get applied to this specific project (Processing + SpriteGame, 6th grade)?* |

When starting a new lesson series for a different project or age group, write
its project-specific Guiding Principles doc by walking through these ten
principles and asking, for each one, "what is the equivalent move for *this*
base project?" — the same way `lessons/GUIDING_PRINCIPLES.md` did for
Processing-Sprite.
