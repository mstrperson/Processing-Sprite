# Sparky Feedback, Q1 Fall 2026

What 15 sixth graders said about Sparky at the end of Q1, and what to change
in the Flint prompts before next quarter.  The data is in
[`2026-q1_reflections.json`](2026-q1_reflections.json).  Each claim below cites
the students behind it by ID.

**About the data.**  These are end-of-quarter self-reflections, four questions,
written in about ten minutes.  Question 4 asked for one time Sparky was useful
and one time it was frustrating, so every student was asked for a complaint.
Count a pattern as real when several students describe it in their own words,
not by how high the number is.  13 of 15 reflections are complete (S05 answered
only Q2; S11 left Q3 blank).  Students are de-identified.  The key is not in
this repo, and this repo is public, so keep it that way.

**What the data can't tell you.**  Which Sparky each student was talking to.
Students used both the per-lesson helpers and
[`code_helper_lessons_01_05.md`](../code_helper_lessons_01_05.md), and the two
have opposite rules about giving code.  Flint transcripts would settle it.

---

## Headline

- **Sparky is the first stop.**  8 of the 14 students who named an order go to
  Sparky first.  6 try it themselves first.  No one goes to the teacher first.
  The teacher is the backstop when Sparky fails: S02, S10, S11 and S13 each
  ended up there after Sparky.
- **Students rate Sparky as helpful overall** (S03 "almost always helpful",
  S07 "always very useful", S15 "overall, Sparky was helpful").  The
  complaints are specific and fixable.
- **What helped most was art:**  drawing characters, backgrounds, decorations
  (S01, S04, S06, S07, S08, S10, S15).
- **What went wrong most often was code that broke things:**  5 students
  (S04, S08, S09, S10, S12), and one of them lost work they never got back (S04).

---

## Changes to the prompts, most important first

### 1.  Stop breaking working code

**Evidence.**  S09 asked Sparky to remove one shape.  It said it had, but it
changed the wrong part.  S10:  "things that Sparky told me to do made errors in
other parts of the code."  S12:  "it kept giving me code with errors... that
was why I was asking sparky for help."  S08's sparkle trail stopped the sketch
from running.  S04, during Collisions:  "it ruined my code and I was unable to
get some of it back."  S04's finished game still has no collision.

**Change.**
- Return only the lines that change, never a rewritten tab, unless the
  student asks for the whole tab.  Quote the line just before and after so
  the student can find the spot.
- Before any change bigger than a few lines, tell the student to save a copy
  first (**File → Save As**, add a number to the name).  Then a bad paste can
  be undone.
- When a fix touches a student's drawing code, keep every shape they didn't
  ask about.  The code helper already says "keep their shapes, colors, and
  names."  Put that rule in every lesson helper too.
- Check the snippet against the student's actual variable and class names
  before giving it.  Most of the "code with errors" was probably names
  that didn't match.

### 2.  Say "I'm not sure" instead of guessing

**Evidence.**  S14:  "it imagined a bug in my code and wouldn't let me move on."
S04 was told by Sparky that it was "just guessing the commands."

**Change.**
- Only call something a bug when you can quote the line that's wrong and say
  what's wrong with it.
- When you can't find the problem, say so plainly and send the student to
  the teacher.  Don't make up a fix.
- If the student says the code works, believe them and move on.

### 3.  Make the rules about giving code the same everywhere, and never refuse without offering something

**Evidence.**  S03 was told "we have not covered that in this lesson, is there
anything else I can help you with?"  S06 asked for a hat on their character
during Draw Your Character.  Sparky said it couldn't help, even after S06
checked they were on the right lesson.  **The Lesson 2 Canvas page lists "how
do I put a hat on top of my character?" as a good thing to ask**
([`content/02.json`](../../canvas_import/content/02.json)).  S11 asked to see
what the score code would look like and was told they "wouldn't learn."  They
finished only after the teacher stepped in.  Meanwhile other students got
whole drawings (S01, S04, S08).  From the students' side, the rules look random.

**Change.**
- Pick one rule for all the lesson helpers and write it the same way in each.
- Replace every flat refusal with a smaller offer:
  - Something from a later lesson:  give a small version and name the lesson
    where it's taught.
  - When the helper is holding back the answer on purpose:  give a
    fill-in-the-blank version (see 4) instead of nothing.
- Don't refuse anything the lesson's own Canvas page tells students to ask.
  Check each lesson helper against that lesson's `flintHint`.

### 4.  Make fill-in-the-blank the default for drawing

**Evidence.**  This is the help students praised most.  S07 struggled to get
shapes in the right positions, and Sparky "helped me by giving me fill in the
blanks."  S04 liked that Sparky "gave me the code to draw them but made me add
in the code myself."  S13 liked that Sparky "asks you to change the number and
asks if your object gets bigger or smaller."  S14 liked step-by-step
questions.  S01 asked for this outright, after noticing they had started
letting Sparky do the work:  "it should tell you what line to put a code in and
encourage putting the code in yourself and understanding it all."

**Change.**  For drawing requests (a hat, an ear, hair, a trunk), give the
shape call with the position numbers measured from `pos.x`/`pos.y`.  Name the
one number to change to move or resize it.  The student types it in, runs it,
and adjusts.  This also keeps the art theirs.

### 5.  Get better at drawing what they describe

**Evidence.**  S02 asked for an elephant trunk that curves up.  Sparky kept
making it straight or curving down, "I even drew a picture on a sticky note and
it still didn't work."  S07's elephant ear came out in the wrong place.

**Change.**
- Before drawing, repeat the shape back in words:  "the trunk starts at the
  bottom of the face and curves up to the right — is that it?"
- For curves, say which number controls which way it bends.  For `arc()`,
  explain the start and stop angles in plain words.
- After two misses, stop guessing.  Give the student the numbers to change
  and let them steer.

### 6.  Always say where the code goes

**Evidence.**  S13:  "I asked Sparky where to put the line of code they gave me
but I didn't understand Sparky's response."  S11:  "I was confused on what to do
after he gave me directions."  S01 let Sparky paste code in so they wouldn't
have to find the line.

**Change.**  The code helper already requires "Where it goes."  Every lesson
helper needs the same rule, made more specific:  which tab, which function, and
the line it goes after, quoted.  "Inside `draw()`" is not enough for a student
whose `draw()` is 40 lines long.

### 7.  Use plain words, one step at a time

**Evidence.**  S10:  "it also told me to fix it using coding words that I didn't
understand yet."  S15 had to ask for it "step by step instead of all at
once."  S05 learned to use "simpler and descriptive words" so Sparky would
understand *them*.

**Change.**  Give one step and wait for the student to say it worked before
giving the next.  Use only words the course has taught by that lesson.  The
code helper's "How to talk about the hard parts" section has the approved
explanations.  Every lesson helper needs it.

### 8.  Change approach after the second try

**Evidence.**  S15:  "it kept on telling me to do the same thing when I had
already done it."  S04:  "he also began to tell me to do the same thing over
and over again."

**Change.**  The code helper already says to stop explaining when the same
problem shows up twice.  Every lesson helper needs that rule.  Add:  if the
student says they already did it, ask them to paste the code so you can see
what they actually have.

### 9.  Teach students to fix the small errors themselves

**Evidence.**  Asked what kind of problem they want to fix on their own, most
named syntax:  missing `;` or `)` (S06), doubled brackets (S01), "just a small
error" (S13), finding what and where the error is (S10, S12).  S13 got past
the early errors "by actually reading the message."

**Change.**  When the error is a missing `;`, a missing `)`, or a bracket,
don't fix it.  Show how to find it:  read the red message, go to the line it
names, check the end of the line above.  Then let the student fix it.  Doing
this a few times covers the goal most of the class named.

---

## What works, and should stay

- Drawing help, especially when the student stays in charge of the design.
- Asking the student questions (S14) and suggesting experiments (S13).
- Rewriting a tab that is full of mistakes, when the student asks for it (S09).
- Helping build game mechanics such as a score, a win and a loss, a timer
  (S02, S11).

## Course problems the prompts can't fix

- **Sounds is one of the hardest lessons** (S02, S09, S14).  It's also the
  lesson S02 is proudest of.  S02's sound site wouldn't log them in and then
  lost the music they'd saved.  Check that site, or give students a different
  source, before Bonus B runs again.
- **The code helper's lesson map is out of date.**  Its table still lists
  "A World of Objects," "If This, Then That," and "Collisions" as Lessons 5–7.
  The restructured course is Build Your World, Collisions, Build Your Game.
  Students this quarter used the old names (S12, S04), so next quarter's
  students will be on different numbers from the helper unless it's updated.
- **Character drawing is both the proudest and the hardest lesson** (proudest:
  S01, S08, S15; hardest: S01, S06, S10).  That fits finding 4:  drawing is where
  fill-in-the-blank help matters most.

## To collect next quarter

- Flint transcripts, to match each complaint to the helper that caused it.
- Add one question to the reflection:  "Which lesson were you on when this
  happened?"  Six of the Sparky complaints here can't be tied to a lesson.
