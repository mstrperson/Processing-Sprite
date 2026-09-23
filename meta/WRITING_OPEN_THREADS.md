# Writing - open threads

A worklist, paired with [`WRITING_COMMON_ERRORS.md`](WRITING_COMMON_ERRORS.md).
That file holds settled rules.  This one holds what is still in the air, so a
session can pick up mid-thought.

**Last worked:  2026-09-13.**  Everything below is uncommitted at that point.

---

## 1.  Eight paired em-dashes in the course material

Entry 25 settled that `-- ... --` bracketing is an assistant tic and Jason
sorts asides with `[...]`, `(...)`, `/.../`, `;`, or leaves them bare.
`teaching_philosophy.md` is fully converted;  the course material is untouched.

```bash
grep -rnoE '[a-z,"] -- [^.]{5,110} -- [a-z]' --include='*.md' --include='*.cs' Course
```

| File | Count |
|---|---|
| `Course/GUIDING_PRINCIPLES.md` | 2 |
| `Course/lessons/` | 4 |
| `Course/starters/`, `Course/flint/` | 3 |

**The open question is register.**  The essay is formal prose to
administrators.  The course material is instructional, aimed at teenagers, and
entry 24 already found that parsing load pulls the other way there.  So the
rule may land differently, and Jason has yet to rule.

Ask before sweeping.  That is the lesson of entry 24, learned three times.

## 2.  The `\...\` mark

Entry 25 holds the evidence.  Sample size is **two**, after the casual email of
2026-09-13, and the second instance did real work:  it killed the connective
hypothesis, and it sharpened the lean hypothesis into *the mark falls on a
restatement, and means "yes, this again."*

**He then confirmed it outright**, and added that the marked phrase is the third
member of a rule of three -- *"(and the rule-of-three is real)"*.  That habit is
now entry 27 on its own.

Still open, and narrower than before.  Three cases would move it:

- a `\...\` on the **second of two**, or the **fourth of four**, which settles
  whether *third* is load-bearing or incidental
- a `\...\` that points backward without restating, which forces the looser
  "points back" form
- a `\...\` that is weary or deadpan without pointing back at all, which would
  split the third reading (the stroke as a pitch contour) away from the lean

His instances live outside this repository and arrive one at a time, so **add
rows as they turn up.**  A repository-wide search on 2026-09-13 found nothing
beyond the two logged instances and the entry's own discussion of itself.

Do not read register off the log.  Both instances are informal because informal
writing is the only place instances come from.

## 3.  The `<...>` mutter -- rule found, register open

A new mark, now the sixth row in entry 25's table of how an aside gets sorted.
Two instances, and the second one falsified the competing reading, so **the rule
is usable:**  read it aloud as performance -- what you would *say* takes angle
brackets, what you would *footnote* takes square ones.

What is still open is the same thing that is open for `\...\`, and for the same
reason.  Both instances are informal, because informal writing is the only place
instances come from.  **Whether `<...>` ever survives into a formal register is
untested**, and this file has twice mistaken a mark's origin for its permissions
(see `/word/` in entry 22).  Log a formal-register instance if one appears.

Worth keeping in view:  he does not choose between the marks consciously, so
asking cannot settle anything here.  Only the corpus can.

## 4.  The dot count -- mostly closed, and the closing is a caution

The draft read `..` / `...` / `....` as an analog pause scale.  **He corrected
it:**  *"`...` also tends toward a rule-of-three as well... except when it
doesn't..."*  So three dots is an attractor, not a measurement, and the ladder
is gone from entry 22.

What is left worth watching is the **four-dot form standing alone between two
complete sentences**, which is not a terminal ellipsis at all and is the easiest
thing here for a tidying pass to destroy.  Log one if it turns up outside that
single email.

## 5.  Lesson 2's meeting count

The clamp cut Lesson 2 to `Of()` plus two guard clauses.  The lesson plan and
`GUIDING_PRINCIPLES.md` still say **two meetings**, with Meeting B now carrying a
recap, two short steps, and thirty minutes of Cards.

That may be right, since Cards is the assessment and it wants the room.  It may
also be one meeting now.  Flagged in an earlier session and still undecided.

## 6.  Flint activities for Lesson 2b

Both prompts are written -- [`lesson-02b-primitive-obsession.md`](../Course/flint/lesson-02b-primitive-obsession.md)
and its review -- and both are still waiting on a Flint activity.  Until one
exists, `flintUrl` in `canvas/content/02b.json` stays empty and both generated
pages emit `PASTE_FLINT_URL_HERE` behind a `<!-- FLINT-LINK -->` comment.

Same for the Canvas front page:  `LINK_BONUS_2b_PAGE` and
`LINK_BONUS_2b_ASSIGNMENT` need re-pointing once the Canvas items exist.

---

## What got settled on 2026-09-13, so it stays settled

Recorded in `WRITING_COMMON_ERRORS.md` unless noted.

- **Entry 24**, the comma before a trailing adverb, and its limit:  the mark
  does three jobs, intent decides which, and a sweep is the failure mode.
- **Entry 25**, paired dashes as an assistant tic, with the five ways an aside
  gets marked instead.
- **Entry 26**, prefix hyphens:  leave his alone, and vary your own.
- **Entry 22** gained the plain-text emphasis markers, the three jobs of the
  tilde, the sentence fragment as a register signal, and a measurement of what
  he italicizes.  Five of his six italics fall on small function words.
- **Entry 3's count was wrong** and is now measured:  19 instances, 7 of them
  setup-and-knockdown.  `grep -c` counts lines.
- **Entry 8's unanimity claim was false** and is now 11 of 11, after the line
  that broke it got fixed.  The entry keeps the order of events visible.
- The course clamp:  Lesson 2 is one factory method, Lesson 2b exists, parsing
  is deferred to a lesson of its own.
- Flint prompts have no meaningful length limit.  The real cap is about 24,000
  words and these run near 2,000.
- **The connective hypothesis for `\...\` is dead.**  A second instance landed
  on a verb phrase, and `/necessary trouble/` had already broken it from the
  other side.  Entry 25 carries the log and the sharpened lean hypothesis.
- **The `<...>` rule is found, and the scope reading is dead.**  A freestanding
  instance with no host sentence broke it;  the voice test survived and is
  usable.  Entry 25 carries both, and why the loser looked right at n=1.
- **The marks have a provenance, and it supplies a mechanism.**  1990s
  plain-text internet convention, in his words, which is why glyph *shape*
  carries meaning at all -- and which dates `=P`, `~word~`, and the `<g>`-style
  inline tag.  Entry 22 holds it, along with the trust axis:  the bottom of the
  range is gated on who is reading, not on how formal the document is.
- **A casual email corroborated three standing findings** from a register they
  had never been tested in.  Two spaces after a sentence survives casual
  writing;  a passage thick with asides used `<...>`, `[...]`, `/.../` and four
  dots while using **zero** paired dashes, which is entry 25 holding up where he
  is least self-conscious;  and the whole thing closes on a fragment, which is
  entry 22's register signal.
