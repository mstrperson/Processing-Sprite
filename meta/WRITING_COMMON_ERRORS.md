# Writing Common Errors - prose and style

A running list of the mistakes that actually happen when an assistant drafts or
edits prose for this repository.  Every entry here was caught in real work.

Read this alongside [`APPALACHIAN_ACADEMIC_STYLE.md`](APPALACHIAN_ACADEMIC_STYLE.md).
That document says what the voice is.  This one says where it goes wrong.

**Scope is prose.**  The errors students make in C# -- "record means immutable",
picking a shuffle partner from the whole list every time -- live in the teacher
notes of the lesson that addresses each one.  When enough of those accumulate to
be worth collecting, they belong in a `CS_COMMON_ERRORS.md` beside
[`CS_GUIDING_PRINCIPLES.md`](CS_GUIDING_PRINCIPLES.md), so that the two lists
stay separately searchable.

**Adding to the list:**  when a correction happens, add the pattern, the fix, and
a command that finds it again.  An entry earns its place by being catchable.

**The corpus, and how far it stretches.**  Several entries below cite counts
measured against `teaching_philosophy.md`.  Two cautions come with those
numbers.

The first is mechanical.  That file has since been revised to meet the
rendering rules, so the counts describe it as it stood at commit `6d5ebe4`,
before the pass.  Read them there:

```bash
git show 6d5ebe4:meta/teaching_philosophy.md
```

The second matters more, and it reaches past that one file.  **No prose in this
project is purely Jason's.**  Every document here -- the lessons, the starters,
the Flint prompts, the Canvas content, and the two style guides in this folder
-- was drafted or edited with an assistant in the room.  He said so directly on
2026-09-13, about the very files he had handed over as examples of his voice:

> *"No prose in this project is purely my own prose.  So these errors might be
> sneakily in any of the documents.  Even the ones I provided you for examples."*

Two consequences, and the second is the one that bites.

The mild one:  where an entry below says "his own writing", read "a document he
shaped closely."  It is strong evidence for what he *endorses*, having read every
line and argued about many of them, and weaker evidence for what he would write
alone.

The sharp one:  **a count of instances in this repository measures one thing,
and it is how often a tic survived review.**  A pattern appearing a dozen times
across the course is a dozen chances it went unnoticed, and reading those as
deliberate style is how an assistant talks itself out of a correction it was
just given.  Entry 24 records a case where exactly that happened.  When a count
is doing the arguing, say what the count establishes and stop there.

---

## Rendering rules

These three are mechanical, and they are the ones most likely to survive a
careless pass because they look like noise.

### 1.  The typographic em-dash

Em-dashes belong in this prose and they are used heavily.  Write them as `--`
with a space on each side.

| | |
|---|---|
| Looks like | `a trade — and here is what you pay` |
| Write | `a trade -- and here is what you pay` |

The HTML entity `&mdash;` is the same error wearing a costume.  So is `&ndash;`.

**Why it matters:**  the typographic character has become a marker that gets
written work dismissed as machine output before anyone reads the argument.  The
goal is prose that reads as thoughtfully crafted and AI-assisted, so the tell
comes out.

**Headings take a single hyphen.**  `# Lesson 1 - First Objects`, with prose
keeping `--`.

```bash
grep -rn '—\|&mdash;\|&ndash;' --include='*.md' --include='*.json' .
grep -rnE '^#{1,6} .* -- ' --include='*.md' .
```

**This entry governs the character.  Entry 25 governs the job**, and the two
come apart:  a `--` can be spelled correctly and still be the wrong mark.

### 25.  The paired em-dash is an assistant tic, and his dash is a separator

Numbered 25, placed here because it governs the same mark as entry 1.

**An assistant brackets with `-- ... --`.  Jason does the job with four other
marks, and he said so plainly on 2026-09-13:**

> *"I basically never use -- the way you do bracketing things.  I do use them as
> a separator, but it's more like a `;` on steroids."*

That splits one habit into two facts.  **His dash is a single mark that separates
two clauses** with a harder break than a semicolon, where the second elaborates,
turns, or gives the reason.  Eighteen of them work that way in
`teaching_philosophy.md`:

```
I give them the same non-answer -- because the lesson has nothing to do with
                                    the form of the question
I hold authority in my classroom, and I use it -- but I try to use it honestly
the answers are already in the people -- the educator's job is to create the
                                         conditions in which people find them
```

**A pair of them is the tell.**  Every paired dash in that file arrived from an
assistant, and he converted ten on the day this entry was written.  An aside
gets sorted by what it does:

| Mark | The aside is | Example |
|---|---|---|
| `[...]` | a **gloss** -- defines, attributes, or unpacks the term just before it | `Rules-based reasoning [the ability to apply given procedures to expected problems] is the foundation` |
| `(...)` | a **concession** -- qualifies or limits the claim | `a ranked hierarchy (even one that officially discourages ranking) hands students` |
| `<...>` | an **inline mutter** -- rides inside the host sentence without stopping it | `technological landmines <of which we have many> laying around the school` |
| `/.../` | a **re-read** -- makes a seasoned reader take the phrase twice | `good trouble, /necessary trouble/` |
| `\...\` | unsettled.  See below. | `\because\` |
| `;` between items | a **mid-sentence enumeration** | `shaped by their family; their culture; their class; their language community; their prior schooling` |
| commas, or unmarked | the aside stands on its own | `the careful use of grades, in genuine, good-faith dialogue rather than entrenched camps, produces` |

**The test for the gloss is whether a reader who already knows the term could
skip it.**  A gloss is silent;  a separator is voiced.  That lines up with the
split entry 24 draws between information and emphasis.

**`<...>` and `[...]` turned up in the same paragraph on 2026-09-13, doing
visibly different jobs.**  A casual email, to a superior who knows his habits:

> It is one of those technological landmines <of which we have many> laying
> around the school that have \always been there\ [...] [I know I've taught a
> handful of kids over the years when it was useful to do so.]

The square brackets carry **a complete sentence that could stand alone** -- an
admission, its own beat, and the reader stops for it.  The angle brackets carry
**four words that are grammatically part of the host sentence**, and the voice
does not stop.  So the distinction is not gloss-versus-concession.  It is
whether the aside halts the line or rides along inside it.

**He does not choose between them consciously**, which he said on 2026-09-13:

> *"`<...>` is a distinct form, and I don't consciously chose which one.... lol"*

That decides the method.  Asking him will not settle it, so the rule has to come
off the corpus -- and a repository-wide search the same day found **no instance
outside this entry**.  The mark does not survive into the register this
repository is written in, which is a fact about the corpus and not yet a fact
about the mark.

**Two readings were available, and the second instance killed one of them.**
Both are recorded here, because the way the loser failed is the useful part.

- **Scope.**  `[...]` stops the line;  `<...>` rides inside it.  All four
  `[...]` in `teaching_philosophy.md` interrupt a subject from its verb, and the
  email's bracket is a whole standalone sentence between two others.  The angle
  brackets are the only mark in the table above that is grammatically continuous
  with its host sentence.
- **Voice.**  `[...]` is the writer stepping outside the sentence to address the
  reader;  `<...>` is the same voice continuing, quieter.  This is the entry's
  own *"a gloss is silent;  a separator is voiced"* test carried one mark
  further.  You would **say** `<of which we have many>` aloud, dropped into an
  aside voice.  You would **skip** `[the ability to apply given procedures to
  expected problems]` when reading to someone who already knows the term.

**The provenance tips toward voice.**  Entry 22 records where these marks come
from:  1990s plain-text internet convention, where `<g>` and `<ducks>` carried
tone inline.  An emote tag is performed by definition, which is the voice test
exactly, and it makes no claim about grammar at all.

**Then a separating case arrived the same day, and it went to voice.**  Dropped
into a conversation about how many axes a person has:

```
<... what about a continuum-of-axes... like uncountably infinite coordinates...>
```

Freestanding.  No host sentence, and so nothing to be grammatically continuous
*with*.

- **Scope predicted `[...]`.**  The remark stops the line rather than riding
  inside one, because it *is* the line.
- **Voice predicted `<...>`.**  It is plainly something he would say aloud,
  tossed sideways, rather than a note set down for a reader.

**Scope is falsified.  Voice stands**, and it now covers two instances of
different shapes -- one clause riding inside a sentence, one whole remark
standing alone -- which is the variation a rule needs before it is worth
trusting.

**The context gets its asterisk.**  The instance arrived while the mark was
under discussion, which is the worst sampling condition there is.  He reported
it as organic and he is the authority on that, so the caveat gets recorded and
the instance gets kept.

**The composition is worth noticing separately.**  He wrote it `<... text ...>`,
with an ellipsis inside each boundary, so the thought fades in and fades out --
notated as speech that was already running when you caught it.  That is the
voice reading arriving a second time inside the same instance, by a different
route.

**The rule, then.**  Read it aloud as performance.  What you would **say** takes
angle brackets.  What you would **footnote** takes square ones.  Grammar is a
consequence rather than the criterion:  things you perform tend to be
continuous because speech is continuous, and that correlation is exactly what
made the scope reading look right while the sample was one.

**The last two rows matter as much as the brackets.**  One of the ten came back
as *"I would just not use the --"*, and the sentence took plain commas.  Reach
for a different bracket only after the aside has failed to survive without one.

**A mid-sentence enumeration takes semicolons, and the sentence gives way.**

> *"I use `;` separated style for mid-sentence enumerations.  If that means a
> sentence has to be re-built, then so be it."*

That last clause is the operative half, because the two enumerations left in
`teaching_philosophy.md` both had the list interrupting a verb from its object,
so each would have had to break its own sentence to take semicolons.  Both
became two:

```
was   Every student I teach has been shaped -- by their family, their culture,
      their class, their language community, their prior schooling -- into
      particular assumptions about what counts as intelligence...

is    Every student I teach has been shaped by their family; their culture;
      their class; their language community; their prior schooling.  That
      shaping produced particular assumptions about what counts as
      intelligence...
```

The second case took a colon to introduce the list and a fresh sentence to carry
what followed it:  `a dialog with a student or a group:  a question asked back;
a redirect; a "what happens if you try it the other way."  That dialog is woven
so thoroughly...`

**Trailing enumerations keep their commas.**  The rule names mid-sentence lists,
and the same sentence above ends on `what counts as intelligence, what counts as
good work, what counts as appropriate behavior..., and who belongs in rooms like
this one` -- untouched, because the list closes the sentence instead of
interrupting it.

**`/.../` survives into a formal document, and an earlier draft of this file had
that wrong.**  It was recorded here as a plain-text substitute for italics,
bound to the informal register.  He corrected it on 2026-09-13:

> *"`/necessary trouble/` is one I would actually bracket with `/` even in a
> formal setting \because\ it makes the seasoned reader read it twice."*

So the job is **forcing a second pass**, and the register follows the job rather
than the other way round.  Entry 22 carries the corrected version.

**`\...\` is a real mark of his, and its rule is genuinely open.**  Two accounts
from him on 2026-09-13, a few minutes apart:

> *"I just realized that I use \ too, and even I don't know what the difference
> is other than vibes, but the \because\ there was one."*

> *"The \because\ goes that way because I'm mentally leaning in a different
> direction than when I write `/necessary trouble/`.  I think it is a call back
> to something that it is emphasising.  Emphasising repetition.  Emphasising the
> directed focus... need to see more examples probably."*

**The leading hypothesis is his, and it is that the lean of the stroke carries
the direction of the reference.**  `/forward/` marks something the reader takes
again and carries on with -- `/necessary trouble/` escalates `good trouble` into
new ground.  `\backward\` points at something already on the page, so the mark
says *look back at what I just said*.  `because` fits:  it is the hinge joining
a claim to the reason it rests on, and stressing it aims the reader back at the
claim.

A weaker second hypothesis, which prompted his:  `because` is a **connective**,
and entry 22 finds five of his six italics falling on small function words at
the joint of an argument.  He called that *"onto something"* while landing
somewhere else, so treat the two as compatible rather than competing.  The
connective may be *what* gets marked and the lean *which way it points*.

**Both stay open, and he has said so outright.**  One instance supports the two
readings equally well, which is the definition of too little evidence.

### Collecting instances, since that is what would settle it

His informal writing lives outside this repository, so these arrive one at a
time.  Log each one here as it turns up.  Four fields decide between the
hypotheses:

| Marked | Mark | Points at | Register |
|---|---|---|---|
| `because` | `\` | the claim in the preceding clause | informal, a chat message |
| `always been there` | `\` | his own two earlier sentences, which both say they always had it | casual, an email to a superior |

**What each hypothesis predicts**, so a future instance can falsify one:

- **The lean hypothesis** predicts `/` on anything new or escalating and `\` on
  anything referring back, whatever the part of speech.  A `\...\` on a fresh
  noun phrase would break it.
- **The connective hypothesis** predicts both marks land mostly on conjunctions
  and prepositions.  A `/.../` on a content phrase already breaks it, since
  `necessary trouble` is one.
- **A third reading, untested and the assistant's:**  the stroke is a pitch
  contour, `/` rising and `\` falling, so `\...\` would carry weariness or
  deadpan rather than reference.  Nothing separates it from the lean hypothesis
  yet, because both instances are backward-pointing *and* flat in tone.  A
  `\...\` that is resigned without pointing back would split them.

**The second instance arrived 2026-09-13, and it earns its keep by varying
everything except the thing under test.**  Different register (a work email, not
a chat), different part of speech (a verb phrase, not a conjunction), different
host sentence.  What holds constant is that the marked phrase points backward.

**It kills the connective hypothesis.**  `always been there` is a content
phrase, and the connective reading predicted conjunctions and prepositions.
With `/necessary trouble/` already breaking it from the other side, both marks
now carry a counterexample.  The connective observation survives as a fact about
*what he italicises*, which entry 22 measures separately, and stops being an
account of these two marks.

**And it lands on his own guess.**  He said *"a call back to something that it
is emphasising.  Emphasising repetition."*  In the email the marked phrase is
the third time in six lines that he says the capability was always there:

```
they've always had access to print to any printer that is in a "public space"
they've always had that ability too.  We've just never told them they could.
...technological landmines... that have \always been there\
```

So the sharper form of the lean hypothesis is that **`\...\` falls on a
restatement, and the mark means *yes, this again*.**  That is narrower than
"points backward", and it is testable:  a `\...\` on a backward reference that
is not a restatement would force the looser form back.

**He confirmed it the same day, and named the mechanism:**

> *"now that you say it it is obvious that the `\...\` is highlighting the
> repeated emphasis that i've done repeatedly.  (and the rule-of-three is
> real)"*

That moves the reading from confirmed-by-inference to confirmed-by-the-author,
and it adds a structural claim the three-line block above already satisfies:
the marked phrase is **the third member of a rule of three**, and the mark is
what closes the set.  Entry 27 carries the rule of three on its own, because it
turns up in places that have nothing to do with this mark.

**What stays open is whether *third* is load-bearing or incidental.**  A `\...\`
on the second of two would settle it, and so would one on the fourth of four.

**Two instances, both informal, and that is not evidence about register.**
Every instance of this mark reaches the repository through casual writing,
because casual writing is the only corpus that produces them.  This file filed
`/word/` as informal-only twice on exactly that reasoning and was wrong both
times.  The register column is a record, not a finding.

**A single dash is untouched by any of it.**  Several survive in that file doing
ordinary work:  `the same non-answer -- because the lesson has nothing to do
with the form of the question.`

**Shape to look for:**  the converted glosses all interrupt a subject from its
verb.  `Subject [gloss] verb` is the strongest signal, and four of the six
brackets in that file have exactly that form.

```bash
grep -rnE '[a-z,"] -- [^.]{5,120} -- [a-z]' --include='*.md' .
```

That finds pairs.  Read each and ask which of the five jobs it is doing.

### 26.  Prefix hyphens are his, and they are inconsistent on purpose

The shortest entry here, and the rule is to keep your hands off.

> *"I also un-necessarily hyphenate prefixes sometimes, but not always."*
> -- 2026-09-13

He writes `re-read`, `re-run`, `re-check`, `re-parse`, `re-learned`,
`pre-formed`, `non-answer`, `over-engineering`, `un-necessarily`.  He also
writes `rebuild`.  The same prefix goes both ways in the same document, and
**the inconsistency is the feature.**

**When editing, leave every one of them exactly as written, in both
directions.**  A pass that regularizes prefix hyphens looks like tidying and is
deletion.  This is entry 15 territory:  a rule applied evenly to something the
author varies on purpose takes the variation out.

**When drafting, vary them.**  His instruction, and it is the unusual half:

> *"If you're generating text, the hyphenation rule should be a probabalistic
> thing, lol."*

So the failure mode in a draft is a *consistent* choice.  Hyphenate every `re-`
and the prose acquires a rule he lacks;  leave them all bare and it acquires the
opposite rule.  Either way the text announces that a machine settled the question
once and applied it evenly, which is the same tell entry 1 is about, wearing
different clothes.

**This is the only entry in the file that asks for inconsistency**, so it is
worth saying why it can.  Everywhere else, a rule of his is a rule.  Here the
variation *is* the pattern, and reproducing the pattern means reproducing the
variation.

There is no grep worth running.  The rule has no violations to find in his
prose, and in a draft the thing to look for is a run of the same choice.  When a
spell-checker, a linter, or your own eye offers to normalize `re-read` into
`reread`, decline.


### 2.  One space after a sentence

Every sentence-terminal mark takes two spaces:  periods, question marks,
exclamation points, and colons.

**Why it matters, and this one is load-bearing:**  Jason is dyslexic, and the
double space is what lets him see where one sentence ends and the next begins.
Treat it as an accessibility requirement.  A formatter or a linter that
normalizes it away has broken something real.

```bash
grep -rnE '[a-z)][.?!:] ["A-Z]' --include='*.md' .
```

**In HTML output, emit `&nbsp;` for the second space.**  HTML collapses runs of
whitespace, so a double space typed into the source renders as one.  Canvas's
rich text editor and macOS text substitution both fight a hand-typed double
space as well.  Any generator producing HTML should convert `([.?!:])  ` into
`$1&nbsp; ` on the way out, which keeps the source as plain prose and the page
readable.

I got this wrong once by advising against it as over-engineering.  For an
accessibility habit the entity is the correct tool, and the live Canvas page was
already using it by hand.

### 3.  Definition by negation

The single most persistent tic, and the one that reads most obviously as
borrowed cleverness.

**This entry has now had its count wrong twice, in two different ways, and both
are worth keeping.**

The first time the word count read eighteen thousand, which is the file's size in
**bytes** off `ls -l`.  `wc -w` and `wc -c` disagree by a factor of six on
ordinary prose.

The second time the instance count read "roughly four times in three thousand
words."  A full audit of `teaching_philosophy.md` on 2026-09-13 found **19
instances of the banned family in 3,070 words**, of which **7 are the
setup-and-knockdown shape** this entry bans:

```
rather than  6     never  5     without  4     nothing  3     neither  1
```

The likely cause is `grep -c`, which counts matching **lines**.  That file runs
130 lines for 3,070 words, so a paragraph carrying three instances counts once.
Measure with `grep -o | wc -l` and the number roughly quadruples.

*(Later the same day the file lost a sentence to entry 8, so it now runs 3,058
words.  Both instance counts held.  Re-measure before quoting these.)*

**What survives the correction.**  The comparison figure of sixty-one in an
assistant draft is unreproducible now, so treat the ratio as folklore.  The shape
holds up:  his 7 setup-and-knockdowns sit in concessions, repudiations, and one
deliberate antithesis, each doing a job the sentence needs.  An assistant draft
reaches for the same construction as a way of sounding clever.  **The rule stands
on what the negations are doing.  The count was always the weaker half of the
argument.**

Two lessons, and the second is the one that keeps biting:  check a count before
it goes into an argument, and check what the counting tool counts.

| Looks like | Write |
|---|---|
| `a map, not a grade` | `a map:  where you are and what to try next` |
| `It is a trade, not a free win.` | `It is a trade.  Here is what you pay.` |
| `nothing outside can call it` | `only this file can call it` |
| `does not compile` | `the compiler rejects it` |
| `no fixed list` | `you can add to the list` |
| `Do not settle it.` | `Leave it open.` |

The ban covers the whole family:  `never`, `nothing`, `nobody`, `neither`,
`without`, `none`, and `rather than` or `instead of` when they are doing
setup-and-knockdown work.  Imperatives count too, so `Do not cut the warm-up`
becomes `Protect the warm-up`.

**The method:**  rewrite the negative as a positive assertion.  A positive form
almost always exists, and reaching for it forces more precision than the
negative had.

**The one exception is citation.**  Keep a negation when it is somebody else's
words:  a compiler error (`'minValue' cannot be greater than maxValue`), a book
title (*Consider static factory methods instead of constructors*), or a
quotation of the text being replaced.

**Deadpan keeps its negation too.**  A line that parodies a stock sign or phrase
is quoting it, and the joke lives in the quotation.  The museum opening in the
compiled book reads *"The museum of bad dice is open.  Please don't roll the
exhibits."*  He kept it on 2026-10-12:

> *"that /does/ sound like something I would say [and I would say it totally
> deadpan]"*

So the test is whether the reader can hear the original:  `Please don't touch
the exhibits` is under that line, and the positive form would lose it.

**The positive form has a failure mode of its own.**  Entry 29 has it.

### 29.  "Stays" as the positive rewrite - EXPERIMENTAL

Numbered 29 and placed here, because it is entry 3's own fix going wrong.

**This entry is an experiment, adopted tentatively on 2026-09-23.**  If a fix
made under it ever reads weird to Jason, suspect this entry first.  Come back
here, log the case in the table at the bottom, and narrow the rule or retire it.
[`WRITING_OPEN_THREADS.md`](WRITING_OPEN_THREADS.md) carries it as an open
thread until it has earned a place.

**The shape.**  An abstract thing "stays" a quality or an owner, as though it
were keeping itself that way on its own effort:  `the figuring-out part stays
yours`, `the operation stays explicit`, `middles stay honest`, `the list stays
open`.  He flagged the first of those on 2026-09-23, in a Flint caption an
assistant had just written:

> *"the word `stays` there just sounds weird."*

**Where it comes from.**  It is what an assistant reaches for when entry 3 asks
for a positive form.  The caption had read `it will not just hand you the
answer`, and one rewrite turned it into `the figuring-out part stays yours`.
Entry 3's own table taught the move, turning `no fixed list` into `the list
stays open` until the same day.  So this is entry 8's personified `holds still`
arriving through a different verb:  a value, a part, or a quality given a will
to remain as it is.

**The fix:**  put the person or the action back in.  `you keep`, `you get to`,
plain `is`, or the concrete verb the sentence was avoiding.

| Was | Is |
|---|---|
| `The figuring-out part stays yours!` | `You get to do the figuring out!` |
| `...in the starter so the operation stays explicit.` | `...in the starter, so students can see the operation written out.` |
| `Everything from Lessons 1-4 stays.` | `You keep everything from Lessons 1-4.` |
| `All your game logic stays -- you are adding a world around it.` | `Keep all your game logic -- you are adding a world around it.` |

The last two rows are the weakest.  Bare `stays` for code carrying over into a
new lesson reads clipped more than weird, and those are the likeliest fixes to
come back.

**The literal sense is fine, and it is most of the uses.**  A thing on screen or
a value in memory sitting unchanged is exactly what the word means:  `a
rectangle that stays put`, `each picture stays on screen`, `velocity stays set
after key release`, `child sprites stay in formation`.  A student can watch
every one of those happen.  The test is whether you could point at the thing
while it does it.

**Left alone at adoption.**  This file and its neighbours in `meta/` carry about
twenty of the abstract shape (`stays settled`, `the family stays out of it`,
`a comma that helps a first read stays`).  Per the caution at the top, that
count measures how often the tic survived review.  They were left as written
while the experiment runs.

```bash
grep -rniE '\bstay(s|ed|ing)?\b' --include='*.md' --include='*.json' --include='*.ps1' .
```

Read each hit and ask whether you could point at it.

**The log.**  Fixes made under this entry that Jason later found weird, and
abstract `stays` turning up in his own writing from outside the repository.
Either one narrows the rule.

| Date | Text | Outcome |
|---|---|---|

---

## Voice

### 22.  Register settled before the first sentence

Numbered 22 so the cross-references in entries 1 through 21 keep pointing where
they point.  It sits at the head of this section because it runs ahead of every
other entry in it.

**Answer three questions in one line before drafting a word:**

| Question | What it settles |
|---|---|
| Who is the audience? | Vocabulary, how much gets assumed, what needs spelling out |
| How serious is it? | Whether a joke belongs in the room at all |
| What is the vibe? | Which of his registers this document is written from |

**Where it came from.**  On 2026-09-09, an email to the Winsor student body about
the FIRST Tech Challenge season Kickoff.  The first draft arrived in the register
of `teaching_philosophy.md`, because "email to the student body" sounded
institutional.  His correction:  *"this one can be less formal.  it is in my
character as the whimsical, eccentric robotics mentor/teacher.  Think Cliff Stoll
vibes."*

**The rule.**  [`APPALACHIAN_ACADEMIC_STYLE.md`](APPALACHIAN_ACADEMIC_STYLE.md)
says what the voice is.  The register inside that voice moves with the role he is
writing from.  A letter to administrators and an email from the robotics mentor
are one voice at two settings.  So the question to ask is which hat he is
wearing, and the document type answers it badly:  "school-wide email" covers a
fire-drill notice and a Kickoff invitation both.

Ask, and ask early.  A register named in one line gets corrected in one line.  A
register recovered from a finished draft costs a rewrite, and this one cost two.

**Then hold it, which is the half that hides.**  The Kickoff email was rewritten
for the whimsical mentor and measured at **zero contractions per thousand
words** -- the same score as `teaching_philosophy.md`, a formal essay written to
administrators.  Second person had climbed sevenfold and every verb had stayed in
Sunday clothes.  A declared register with the old prose underneath it sits one
edit away from looking finished.

Entry 4 is this same error from the other end.  There a contraction count taken
from a formal essay became a rule banning contractions everywhere.  Here a
declared informal register kept the formal count.  Both come from treating one
document's numbers as the voice.

**What survives a register shift.**  Entries 1 through 3 are mechanical and hold
at every setting.  Entry 11 holds too, and the interaction is worth naming:  the
load-bearing sentence stays plainest wherever the dial sits.  In the Kickoff
email the whimsy runs everywhere except the apology for a date that collided with
Rosh Hashanah, which is the highest-stakes passage in the document and is written
flattest on purpose.  A register governs the prose around the important sentence.

**What moves with the dial:  entry 24.**  How hard the comma rules get enforced
is itself a function of register, and he said so directly on 2026-09-13:

> *"The more casual the register, the more willy-nilly we can be with comma
> rules, and ambiguity in sentence construction is sometimes on purpose."*

So a rule that reads mechanical is graded.  At the instructional setting, where
a student parses a paragraph alone at home, a comma that marks a clause boundary
earns its place.  At the whimsical setting, a comma-free run is a rhythm and a
double reading can be the joke.  **Settle the register first, then decide how
tightly entry 24 binds.**  Read the two together.

**The check.**  Register leaves countable traces, so a declared register is
testable.  Run this over the draft and over a document already in the register
you want, then compare the two.

```bash
register() {
  for f in "$@"; do
    w=$(wc -w < "$f")
    c=$(grep -oiE 'n[^[:alnum:] ]t\b|[^[:alnum:] ](re|ve|ll|m)\b|\b(it|that|there|here|what|who|let|we|you|they)[^[:alnum:] ]s\b' "$f" | wc -l)
    y=$(grep -oiE '\b(you|your|yours)\b' "$f" | wc -l)
    m=$(grep -oiE '\b(moreover|furthermore|therefore|thus|hence|accordingly|pursuant|whereby|herein|in order to|at this time|please be advised|kindly)\b' "$f" | wc -l)
    awk -v f="$f" -v w="$w" -v c="$c" -v y="$y" -v m="$m" \
      'BEGIN{printf "%-30s %5d words  contr %5.1f  2nd %5.1f  formal %5.1f\n", f, w, c*1000/w, y*1000/w, m*1000/w}'
  done
}
```

Two measured poles, for calibration.  Both figures are per thousand words:

| Document | Contractions | Second person |
|---|---|---|
| `teaching_philosophy.md`, formal essay to administrators | 1.6 | 1.0 |
| The Kickoff email as he sent it, whimsical robotics mentor | 23.4 | 28.1 |

**His own informal markers, taken from the version he actually sent.**  Editing
the Kickoff draft he rewrote my closing, *"I would like us in the room when it
does,"* as *"It's gonna be a party~"*.  Two things there.  `gonna` is a register
the draft had reached for and missed, and the tilde is his:  it turns up in his
own messages, `Class III~Class VII` and `permission slips to their parents~`.  So
his informal setting carries a punctuation mark of its own, and a draft that
arrives at the whimsical setting through vocabulary alone is still a step short.

**The principle underneath the markers**, in his words on 2026-09-13:

> *"It's all about encoding emotion into plain-text for informal situations."*

That is the category, and most of the marks are instances of it.

**And the grammar has a provenance**, which he gave the same day:

> *"[my more devious brain, trained by the internet of the 90's and early
> 2000's, is why I use `\` and `/` for emphasis]"*

That is worth more than an anecdote, because it supplies a mechanism the
hypotheses in entry 25 were missing.  Plain-text emphasis in that era had a
settled vocabulary -- `*bold*`, `_underline_`, `/italics/` -- and in a medium
where ASCII is the only resource, **the shape of the glyph is the only semantic
material available**.  A mirrored character is therefore a natural way to spell
a mirrored function, which is what the lean hypothesis claims and previously had
no account for.

**The same instinct draws fish.**  Offered unprompted, as the clinching case:

```
>*))}}}==--<
```

Nobody reads that as punctuation.  Every glyph in it was picked for what it
looks like rather than what it means, which is the identical move `/` and `\`
make when they mark emphasis by leaning.

It also argues mildly **against** the assistant's pitch-contour reading in entry
25.  ASCII art is pictorial, not prosodic -- it is about what a character looks
like, not what a voice does -- so a spatial reading of the lean sits closer to
the instinct actually on display here than an auditory one does.

**A third mode, and the bottom of the dial.**  Offered as a test the same day:

```
,,|,, >.< ,,|,,
```

Two hands with the middle finger raised, flanking a face with its eyes squeezed
shut.  Comic exasperation rather than hostility -- `>:(` would be real anger.
That completes a set.  The fish is **shape-as-picture**, `/` and `\` are
**shape-as-lean**, and this is **shape-as-body**:  a gesture and an expression
built out of punctuation.  Taken together, his stated principle stops reading as
a description of several marks and starts reading as one instinct at different
volumes, with `/word/` at the quiet end and this at the loud one.

**And it carries a gate that register alone does not describe:**

> *"It only belongs in the most informal register where all recipients are
> trusted."*

Two conditions, not one.  An informal document with unknown readers -- a public
post, a mass email, anything forwardable -- passes the register test and fails
the trust test.  So the dial this file has been describing needs a second axis:
**trust gates the bottom of the range, and register gates the rest.**

**Which makes the rule for an assistant asymmetric.**  Recognise these marks and
leave them where they are;  never manufacture one.  An assistant cannot audit
who will end up reading a draft, and getting that wrong fails in a way that is
not recoverable by editing.

**It also places `<...>`.**  The same era wrote inline pseudo-tags -- `<g>`,
`<ducks>`, `<vbg>` -- an aside in angle brackets carrying tone or action inside
the line, in the speaker's own voice, never stopping it.  `<of which we have
many>` is that form doing ordinary work, and the lineage favours the **voice**
reading over the **scope** reading in entry 25:  an emote tag is performed by
definition, and it says nothing about grammar.  A second instance the same day
falsified scope outright, so the lineage and the corpus now agree.

**And it dates the rest of the inventory.**  `=P` with `=` eyes rather than `:`
eyes is the same vintage, and so is `~word~`.  The consequence for an editor is
that these are **conventions with native speakers, not private idiosyncrasies**.
Other marks from the same dialect -- `_word_`, `<g>`, `*shrug*`, `</sarcasm>` --
should be read as in-dialect rather than repaired, if they turn up.

**One free data point arrived inside that message.**  He wrapped the whole
remark in `[...]`:  a standalone unit, the writer stepping outside to comment on
himself, addressed to the reader.  That is a fifth `[...]` instance, and it fits
both readings in entry 25 without separating them.

**`/word/` is the exception, and this file recorded it wrongly twice.**  It began
as a constraint -- it is what italics become in **a plain-text-only environment,
writing on the board** -- so the first draft filed it as a board habit.  The
second draft filed it as informal-only.  Both are wrong, and he settled it on
2026-09-13:

> *"`/necessary trouble/` is one I would actually bracket with `/` even in a
> formal setting \because\ it makes the seasoned reader read it twice."*

**The job is forcing a second pass, and the job travels to every register.**  The
plain-text origin explains where the mark came from;  it stops explaining where
the mark is allowed.  Entry 25 carries it beside the other bracketing marks,
which is where it belongs.

`\word\` belongs to the same family and its rule is open.  Entry 25 has the one
data point and a hypothesis.

The tilde does three separate jobs, which is entry 8's problem in a punctuation
mark:

| Form | Job | Evidence |
|---|---|---|
| `~word~`, `~a whole phrase~` | fun-emphasis;  the playful cousin of italics, and it spans a phrase or part of a sentence as readily as a word | named 2026-09-13;  the phrase span 2026-09-23 |
| `party~` | trailing tone marker, softening the line it ends | `It's gonna be a party~`, `permission slips to their parents~` |
| `Class III~Class VII` | a range, meaning *through* | his own messages |

So a bare grep for `~` returns all three mixed together.  Read what sits on each
side of it.

**The ellipsis varies in length, and this entry's first reading of it was
wrong.**  One casual email, 2026-09-13, uses three different dot counts inside
six lines:

| Form | Example |
|---|---|
| `..` | `So like.. yeah.` |
| `...` | `And as for scanning... they've always had that ability too.` |
| `....` | `We've just never told them they could.  .... And we /do not/ have a mechanism` |

The draft of this entry read that as an analog scale, more dots meaning a longer
pause.  **He corrected it the same day, and the correction is the useful part:**

> *"`...` also tends toward a rule-of-three as well... except when it
> doesn't..."*

So the three-dot form is **an attractor, not a measurement**.  It gets pulled to
three by the habit entry 27 describes, and the counts on either side are
departures from that default rather than points on a ruler.  Whether `..` and
`....` encode anything systematic is unestablished, and he warned against
systematising it in the same breath that he confirmed it.

**What survives is the observation that does not depend on the ladder.**  The
four-dot form follows a sentence that already closed with its own period and the
usual two spaces, so it is not a terminal ellipsis at all.  It is a mark
standing alone in the gap between two sentences.  A tidying pass that corrects
it to three dots, or glues it to the sentence before, removes a beat he put
there on purpose.

**`=P` defuses the sentence it follows.**  Same email, placed after the darkest
line in it:

> I've worked at schools where that unannounced scanner privilege absolutely
> would have seen teachers getting inappropriate scans delivered anonymously to
> their inbox =P

Nose-less, and `=` eyes rather than `:` eyes.  The job is to mark the sentence
before it as wicked rather than as an accusation about the present school.  An
editor who strips it as noise takes away the only thing keeping that sentence
from reading as a complaint about colleagues.

**At the most informal setting he stops writing complete sentences**, and this
is the marker that matters most to an editor, because it is the one a tidying
pass destroys while believing it is helping.  A fragment there is the register,
and repairing it into a full sentence moves the passage back up the dial.

[`APPALACHIAN_ACADEMIC_STYLE.md`](APPALACHIAN_ACADEMIC_STYLE.md) already asks for
purposeful fragments to be kept, twice.  What it adds here is the reason:  the
fragment is carrying a register, so the repair costs more than a rhythm.

**Which turns the caution into a technique.**  Entry 22 opens by
settling register before the first sentence, and that holds for a document.
Inside one, a deliberate drop for a paragraph or a line is a real move, and
these are how it gets signalled:

> *"When a document calls for a deliberate register-shift mid-page, that is one
> of the tells."*

So a fragment landing in the middle of formal prose deserves a second look
before it gets repaired.  Ask whether the passage just changed register on
purpose.  Where it did, the fragment is load-bearing and the paragraph around it
is doing something the full sentence would flatten.

Counting his emphasis devices so far.  At **every** setting:  `*italics*`,
`**bold**`, the emphatic comma of entry 24, and `/slashes/` for a re-read.
**Below the formal line:**  the tilde in its three jobs, the sentence fragment,
the dot-count pause, `=P`, and `<...>` for an aside muttered without stopping.
**Below that again, and gated on trust rather than register:**  gesture art on
the order of `,,|,, >.< ,,|,,`, which needs an audience he knows as well as an
informal setting.  `\backslashes\` are his and the rest of their rule is open --
entry 25 holds what is known, and warns against reading their register off a
sample drawn entirely from casual writing.

**What he italicizes, measured.**  `teaching_philosophy.md` spends about 3,070
words on six italics, two emphatic commas, and zero bold.  A formal document at
this setting is spare with emphasis, and every mark is placed hard.

| The italicized word | The sentence |
|---|---|
| `*to*`, `*about*` | I write *to* students and families, not *about* them. |
| `*to*` | I write and speak *to* a person. |
| `*participant*` | engage those standards as a *participant* who chose to enter them |
| `*default*`, `*this*` | the one-dimensional numeric grade as the *default* instrument in *this* environment |

**Five of the six are small words, and that is the rule.**  He marks the word
the distinction turns on, which is usually a preposition, a determiner, or a
qualifier the eye would skate over.  A two-letter preposition carries the whole
moral claim in the first row, and the italics are what stop the reader on it.

The instinct to correct here is the obvious one:  reach for the impressive noun.
`*participant*` is the only content word in the set, and it is the thesis word of
its section.

**The last row is the sharpest and the easiest to miss.**  Both marks sit in a
concession, and both are scope limiters.  He is narrowing a claim so precisely
that the italics say *read the boundary, exactly here* -- `default` rules out
"never use grades" and `this` rules out "in every school."  Emphasis doing
defensive work, which pairs with entries 10, 20 and 21.

**The test when drafting:**  find the sentence where the argument turns on a
contrast, then ask which single word the contrast lives in.  Where that word is
small, mark it anyway.

The position of that edit is entry 12 landing on schedule.  My closing was the
composed literary one, sitting exactly where entry 12 says a reached-for landing
collects, and it was the sentence he replaced.

The apostrophe is written as the bracket expression `[^[:alnum:] ]`, which keeps
the pattern clear of entry 18's quoting trap and matches a straight and a curly
apostrophe alike.  Verified in both directions:  four hits on `I'm sorry, I
won't, we'll see, that's it`, zero on that same sentence spelled out, and zero on
`the author's argument, the students' work`, so possessives leave the count
alone.

### 30.  Naming the register right and still manufacturing it

2026-09-23, a low-formality note to the robotics team.  He named the target
register himself: *"lean just a bit more Cliff Stoll for this one"* -- the same
reference entry 22 already has on file for this exact audience.  The result still
came back wrong:  *"I love it but it doesn't sound like me at all."*

**Naming the register correctly does not excuse the sentences from being
invented.**  The draft added *"extra glory,"* *"independent operators,"* and a
*"checks notes"* aside -- none drawn from anything he had written, all built to
perform "whimsical" from the outside.  This is entry 5's failure again, one
level up:  entry 5 is manufacturing a *voice* from a description of the man;
this is manufacturing a *bit* from the name of a register.  Both skip the same
step, which is reading what he actually writes at that setting before adding
anything to it.

**Then he supplied the real thing**, unedited, and it is worth reading whole
because it is the calibration sample entry 22 was missing:

> Hey everyone! It's that time again~ Cambridge Science Carnival is **A WEEK
> FROM SUNDAY**!
>
> We need folks to run the booth.  If you're new, our whole deal is we let the
> little kids running around *drive last year's robot*.  SO!  We need to: a.
> Make sure Billy is still working...  and b. Get folks to commit to being
> there on that Sunday.

Measured against the manufactured draft:  no invented asides, no reaching for a
clever aside about the event itself.  The whimsy is load-bearing and concrete --
a named robot (`Billy`), a real recurring bit (little kids drive it), a genuine
excited fragment (`SO!`) -- not decoration draped over the announcement.  The
caps-for-emphasis, the trailing `~`, and the loose `a.`/`b.` list inline in a
sentence all match markers entry 22 already had on file;  what was missing was
that the whimsy has to be *about something true*, not just *in a playful
shape*.

**He also flagged that the sample is left exactly as sent, mistakes included**,
because the inconsistency is itself information:  *"it contains information
about the inconsistency and mistakes that I let slide."*  Do not clean a
reference sample of this kind before reading it for calibration -- the sloppiness
is the data.  This is a narrower case than entry 3's general rule against
silently fixing his text:  here the imperfection is the thing being logged, not
an incidental error riding along with content that matters more.

**One factual correction that came with it:**  he confirmed `4 October` as a
genuine date format he uses, not an error to normalize toward `October 4th`.
Entry 3's caution about silent fixes applies here too -- a date order that looks
like a slip may be his.  Check before converting one to the other.

**The test going forward.**  Before returning a draft in a named reference
register, ask what specific, concrete thing in *this* situation the whimsy would
actually attach to -- a real detail, a real running bit, a real name -- and if
nothing concrete is available, that is the signal the draft is about to
manufacture one.  A register can be correctly named and still fail if what fills
it is invented rather than found.

### 4.  Inferring the voice from samples

An assistant measured contraction counts in `teaching_philosophy.md`, found two
against twenty-three uncontracted forms, and turned that into a rule banning
contractions.  That document is a formal essay written to administrators.  The
style guide asks for prose that stays *speakable*, which points the other way
entirely.

**The fix:**  read [`APPALACHIAN_ACADEMIC_STYLE.md`](APPALACHIAN_ACADEMIC_STYLE.md)
first.  Ask for a guide when one seems likely to exist.  Statistics over a
sample tell you what one document did, and the guide tells you what the voice is.

### 5.  Manufacturing the voice

The guide is explicit about this and it deserves repeating:  work from Jason's
actual language.  Adding dialect, phonetic spellings, rustic imagery, or folksy
sayings produces a costume.  "Appalachian Academic" describes plain speech
carrying scholarly substance, and the plainness lives in word choice and
cadence.

The harder line:  writing in his voice stops short of inventing personal
relationships, experiences, regional memories, or claims of shared identity.

**A subtler form:  borrowing a phrase and softening what it weighs.**  I wrote
"Print them.  Sit with it." about five deliberately broken `Card` objects, and
"the consequence worth sitting with" about a property that reads the same as a
field.  *Sitting with* something carries moral weight.  It is what a person does
with grief, or guilt, or a decision that cost somebody else.  Ordinary academic
confusion asks far less than that, and spending the phrase there wears the
register down for everybody who needs it later.

Jason uses it once, in `teaching_philosophy.md`:  "tolerance for sitting with
unresolved problems", meaning genuine ambiguity a person has to endure.  That is
the real sense, and it is the only one in his writing.

**The test:**  ask what the phrase costs the person doing it.  Where the honest
answer is "some attention", write `look at`, `read it back`, or `notice`.  This
is the same failure as entry 8 seen from the other side:  there a word was
stretched to cover four jobs, here a phrase was borrowed at full weight and
spent on a small one.

```bash
grep -rniE '\b(sit|sitting|sat) with\b' .
```

### 23.  The metaphor that arrives before its setup

Numbered 23 so the cross-references in entries 1 through 22 keep pointing where
they point.  It belongs here, beside entry 5, because it is the third way a
borrowed phrase goes wrong.

Entry 5 covers a phrase invented to sound like Jason, and the sub-point above
covers one of his borrowed at full weight and spent on something small.  This is
the remaining case:  **his phrase, at its right weight, placed before the thing
that earns it.**

**Where it came from.**  On 2026-09-10, the Anvil review prompts in
`Course/flint/`.  Jason flagged *"put a door on it"* as weird language.  The
phrase is his, four times over -- `lesson_02_validation_and_factories.md` has
"Today we put a door on that moment", `Dice.cs` has "One door in", and Scene 3
prints "the same door everything else goes through".  In the lesson plan it
arrives *after* board item 3, titled "One door", has introduced the constructor
as the door and the factories as the way in.

The draft used it in board item 1, two items early.  So the metaphor named a
thing the reader had yet to meet, and it read as invented even though every word
of it was his.

**Why compression causes it.**  These prompts are written to a hard character
budget, and a trimming pass cuts setup sentences first -- they explain, so they
look expendable, where the payoff line is vivid and looks load-bearing.  Cut
enough setup and the payoff stands alone.  Six trim passes on that
file removed the sentence that introduced the door and kept the one that used it.

**The fix:**  for each figure of speech, find the sentence that introduces it and
check it still comes first.  Where the setup is gone, either restore it or say
the thing plainly:  "One moment is left, and closing it is the whole of today."

**The check** is provenance plus position, and a grep only does the first half.

```bash
grep -rniF 'put a door' Course/lessons Course/starters   # is the phrase his?
```

A hit means the phrase is safe to use;  it leaves open whether this document has
earned it yet.  Read the paragraphs above each use.  The same pass
catches the related damage:  a trim that clips a phrase to something ungrammatical
("has met the design working", from his "has met the design working correctly")
and a trim that paraphrases him where his own words fit ("A metaphor in place of
the word", from his "Hiding the word behind a metaphor").  **After any length-driven pass,
diff the trimmed prose against the source it restates.**

### 27.  The rule of three is a real pull, and it runs below the sentence

Named by him on 2026-09-13, in parentheses, while he was confirming something
else:

> *"(and the rule-of-three is real)"*

It shows up at two different scales inside one casual email, which is why it
earns an entry instead of a line.

**At the scale of the argument.**  The email states one proposition three times,
and the third carries a `\...\`:

```
they've always had access to print to any printer that is in a "public space"
they've always had that ability too.  We've just never told them they could.
...technological landmines... that have \always been there\
```

**At the scale of the punctuation.**  The ellipsis gets pulled toward three dots
for the same reason, which is how entry 22's dot-count reading got corrected:

> *"`...` also tends toward a rule-of-three as well... except when it
> doesn't..."*

**The second half of that sentence is the entry.**  A pull is not a rule, and he
said so in the act of naming it.  Three is where his prose settles when nothing
pushes it elsewhere.  It is not a target, and a draft that manufactures a third
item to complete a set has learned the pattern and missed the point -- which is
entry 24's lesson arriving in different clothes.  The habit is real;  the sweep
is the failure mode.

**Where it earns its place when drafting in his voice:**  a restatement that
wants emphasis tends to arrive third rather than second.  Where a passage has
said a thing twice and is reaching for the close, three is the shape it is
reaching for.

**The malignant form, caught 2026-10-11.**  The postscript's first draft
described this very file as *"one numbered entry per mistake, each one caught
in real work"*.  The sentence had already said what the file is, and the two
trailing phrases were added to finish a rhythm.  He flagged it, then said *"It's
not the only example,"* and a reread found the same thing all through the draft.
He drew the line himself:  *"Three beats alone doesn't mean something is wrong,
but you've correctly identified the malignant pattern."*

So the count is never the problem.  The problem is a beat that exists **to
complete the shape**.  It turns up in four forms:

- **The stacked tail:**  a sentence that was finished, with one or two
  descriptive phrases bolted on after a comma.
- **The filler member:**  a list's third item that restates the first two, or
  was invented to fill the slot.
- **Bent parallels:**  matched clauses (`X says what...  Y says where...  Z holds
  what...`) whose content got shaped to fit the pattern.
- **The vouching beat:**  a sentence after the point that tells the reader the
  point mattered (`That turned out to be the right order.`, `That's the whole
  economy of the thing.`), which is entry 36 arriving as rhythm.

**The test:**  delete the beat and reread.  If the sentence lost a fact, keep it.
If it lost only its cadence, the beat was filling the shape.

**Knowing the rule did not prevent it.**  The drafter had read this entry, and
the draft still broke it, in a paragraph about the rules.  So treat this as a
check that runs on every draft, after drafting, beat by beat.

### 31.  Spelling gets corrected, every time

Jason is dyslexic, and asked for this plainly on 2026-10-06:

> *"please do correct my spelling unless I explicitly say I spell a word
> incorrectly on purpose ... I have dyslexia, so spelling sucks"*

So a misspelling is never voice.  Fix it in anything drafted from his raw
material, without asking and without a list of corrections.  Look hardest for
real-word swaps, since a spell-checker passes them:  `axels` for `axles`,
`recal` for `recall`, `infact` for `in fact`, `lions share` for `lion's share`.
Titles and brand names get checked too:  `The Machinery Handbook` is
*Machinery's Handbook*.

**The exceptions are the ones he names, and only those.**  Keep this table
current:

| His spelling | Not | Since |
|---|---|---|
| `grey` | `gray` | 2026-10-06 |

This is different from entry 26 and entry 22.  Prefix hyphens and the
plain-text marks are deliberate even when they look like mistakes.  A
misspelled word is not, unless it is in the table above.

### 32.  "Even" lands on the capper

Found 2026-10-06 in raw notes for a nomination, and confirmed by Jason the
same day:  *"I didn't even realized that I use 'even' that way, but you're
right."*

> we now have 7th and 8th graders, and **even** some 6th graders who come to
> meetings sometimes just because they're really excited to be there

> And then we **even** referenced The Machinery Handbook

> She's **even** willing to do sports workouts in sports she isn't a part of.

Each time, `even` sits on the last and biggest item, the one that tops what
came before.  It is entry 27 working at the scale of a single word:  the
escalation arrives at the end of a run, and `even` announces it.

Two more the same day, in one short story about a deadline:  *"worked long
hours (**even** staying at school later than they're supposed to)"* and
*"They **even** showed up to school and got security to let them in on a day
that school was closed."*  Same job both times.

**When drafting in his voice:**  where a list or a run of examples builds to a
capper, `even` is his word for the turn.  Do not spend it on an item that does
not top the others.  Confirmed for the casual register, writing to a trusted
reader.

### 33.  The plain truth rides in the parenthesis

Same notes, same confirmation:

> Winsor is already well known as an Academically rigorous (sometimes
> unhealthily so) place.

> She isn't a student who wants to get the highest grade at the expense of her
> class mates (those students do exist).

> (sorry, I can't recal the specifics of any of these events)

The main sentence stays fair and the frank part comes in a lower voice beside
it:  a criticism, an admission, a limit on the evidence.  This is a job for
`(...)` that entry 25's table does not yet name.

**For an editor:**  the parenthesis is often the most honest line in the
passage.  Do not cut it as an aside.  When the audience needs it softened,
change the wording and keep the point.  Entry 34 covers how he flags that.

### 34.  "Hard to say politically correctly" hands the wording over

> It's hard to say politically correctly, but that spirit also translates into
> how she approaches her academic work in this hyper-competitive environment.

This sentence states the point in full, to a trusted reader, and asks for help
fitting it to the real audience.  It is not a retreat from the point.  The
right response keeps the claim and finds the words.  In the nomination, it
became *"At a demanding school where grades can feel like a contest, Lucy
competes without stepping on anyone."*

The failure is reading it as permission to drop the point.  Confirmed
2026-10-06.

### 35.  Numbers come as honest ranges

> 5 or 6 kids ... between 10 and 15 teams ... hundreds of small children (like
> 5~10 years old)

He gives a number exactly as precise as what he knows, and no more.  Carry the
range into the draft as written.  Turning `5 or 6` into `six` or `10 to 15`
into `a dozen` invents a fact (see the style guide on never inventing
evidence).  Confirmed 2026-10-06.

### 36.  The commentary line

Found 2026-10-06, when Jason bolded five lines in a nomination draft as
sounding off without knowing why.  Every one was the assistant's sentence, and
every one told the reader what to make of the evidence instead of adding any:

| Bolded | What it was doing |
|---|---|
| `Her kindness is real, and under it is a fierce competitor.` | Vouching against a doubt nobody raised.  Also inverted syntax no one says aloud. |
| `That is Inclusion and Teamwork as daily practice.` | Labeling the paragraph's evidence at the close (entry 12). |
| `Our alumni come back, and my only fellow mentor is a former team member.` | The one sentence in the box where the subject was not the student.  It left the judge to supply the logic linking it to her. |
| `A small team lives or dies on who shows up, and Lucy brought them.` | A stock phrase on the load-bearing sentence (entry 11), then a manufactured landing. |
| `Younger students know her story.` | Reporting what is in other people's heads, as a trailer for the next sentence. |

**Why the ear catches it:**  in a document built from facts, every sentence
but these says something that happened.  The commentary line is the
drafter's voice cutting in, and it is the only line a skeptical reader can
argue with.  In a nomination it is also the only line the student cannot
back up in an interview.

**The fix:**  delete it and read the paragraph again.  Usually the evidence
already lands.  Where the line was carrying a real connection, as with the
alumni sentence, write the connection out plainly.  Where it drifted from his
raw words, go back to them:  *"Her kind demeanor and gentle nature are
innate, and sometimes hide how competitive she actually is"* became `She is
kind and gentle by nature, and that sometimes hides how competitive she is.`

**A second check while you are there:**  one of these lines also overclaimed.
His notes said the core of the team was *"primarily friends she has
recruited,"* and the commentary version made it all of them.  A summarizing
sentence drops qualifiers, so compare it against the source.

### 37.  "Landed," meaning it got through

2026-10-11.  A prologue draft said the cards are *"where you find out whether
it landed,"* meaning whether the idea got across.  He flagged it the same day:

> *"I found a sentence where you used "landed" in the script-kiddy way (which I
> abhor)."*

**The shape.**  `land` for an idea, a point, a joke, or a lesson reaching its
audience:  `did that land?`, `the point lands`, `find out if it landed`.  It is
borrowed slang, and it reads as borrowed.

**The literal sense is fine, and in this course it is most of the uses.**  A
die lands on a number, a card lands between two others, a roll lands out of
range, a value lands in the wrong field.  The test is entry 29's:  could you
watch it land?

**The fix:**  say what happened.  `whether you can do it alone`, `whether they
understood`, `it worked`, or the concrete verb the sentence was avoiding.

**This file has the shape too, and so does the style guide**, applied to
prose:  `end a passage when its thought has landed`, `a closing has to land`,
`the evidence already lands`.  That is the same borrowed sense, with a sentence
as its subject.  Left as written, pending his ruling on whether a sentence can
land.  Per the caution at the top, the count measures how often it survived
review.  `Course/README.md` has one as well (*"this is where you find out if it
landed"*), which is probably where the prologue draft picked it up.

```bash
grep -rniE '\bland(s|ed|ing)?\b' --include='*.md' .
```

Read each hit and ask whether you could watch it land.

### 38.  "Dice" and "data" are singular and plural

2026-10-11.  He settled it plainly:

> *"Dice is like fish.  it is both Singular and Plural.  Just use it that way
> with zero acknowledgement and zero explanation.  It is correct."*

> *"(The same is true for Data ... Data is both singular and plural, and people
> need to just fukkin accept that we don't speak classical latin)"*

So:  `a dice`, `one dice`, `the dice is sealed`, `the data is fixed`.  Never
`die` for one of them.  And never a gloss, footnote, or aside explaining the
choice, because an explanation concedes the pedant's point and is the error
too.

**Code and quoted output keep their own text.**  A comment in the repository
that says `each die`, or program output that prints `one die`, is a citation
under entry 3's exception, and it stays as written.

**The general rule behind it.**  Where a plural is a pedant's argument,
usually a Latin or Greek plural, he takes the everyday English side.  He also
said he might not know a word is contested:

> *"if there are other rules that I haven't though about where it is utterly
> pedantic to argue about the plural of a word, assume I'm going to land on
> that same side of the fence, but it is worth asking cause... I might not even
> know it's contraversial"*

So default to the everyday side, ask him once when a new word comes up, and
log his answer in the table.

| Word | Use | Never | Since |
|---|---|---|---|
| dice | singular and plural, for the thing you roll | `die` (which is the forming tool) | 2026-10-11 |
| data | singular and plural (`the data is`) | `datum` | 2026-10-11 |
| indexes | the plural, for arrays and lists | `indices` | 2026-10-11 |
| schemas | the plural | `schemata` | 2026-10-11 |
| formulas | the plural | `formulae` | 2026-10-11 |
| media | singular (`social media is`) | | 2026-10-11 |
| criteria, phenomena | singular as well as plural (`a criteria`) | | 2026-10-11 |
| they | singular (`each player rolls their own dice`) | | 2026-10-11 |
| dwarfs, dwarves | either, interchangeably.  The adjective is `Dwarven` | `Dwarfen` | 2026-10-11 |
| staffs, staves | two different words.  `Staffs` are walking sticks or wizards' staffs.  A `stave` is a building material, a strip of wood like a barrel's.  He pronounces them differently. | `staves` for more than one staff | 2026-10-11 |

**Asked and left standard:**  `less` with countable nouns.  He didn't take that
one, so `fewer cards` it is.

```bash
grep -rnwE 'die|datum' --include='*.md' .
```

Read each hit.  Skip code fences and quoted output, and leave the verb alone
(`die` in a game is fine).

**`Die` is a real noun of his, for a different thing.**  In metalwork and
injection molding, a die is the tool that forms the part, and that is the only
noun sense he uses it for.  So a die in a forming process stays `die`.  Its plural goes both ways, and
he drops the `s` about as often as he keeps it:  `a pair of die` and `a pair of
dies` are both his.  Vary it in a draft, the way entry 26 varies prefix
hyphens, and leave either one alone when editing.  A single `die` can also
mean the whole tool, both mated halves together, so `the die` and `a pair of
die` may name the same object.  Read which one from context, and leave it.
**The one plural that is
wrong for the tool is `dice`.**  The rule above is about the thing you roll.

His own test case, and his correction of the assistant's version of it:

> *"a single pair of die are used to cast a single dice ;)"*

**A tooling note from the same day.**  The first sweep for this rule ran in
Windows PowerShell 5.1 and used the `` `u{0} `` escape to mask inline code.
5.1 lacks that escape, so the mask and the restore pattern both went wrong:
22 lines lost their digits (`+5` became `+`, `d20` became `d`) and gained
junk around every code span.  The lines were restored from a grep taken just
before the sweep.  Two of the files had no git history.  For edits like this,
build the mask with `[char]0` or do the work in pandoc's Lua, and take a copy
of every file first.

### 39.  The giant asterisk, for the monster under the facade

2026-10-12.  When he introduces a topic with something enormous underneath it,
he marks it, and says so in the room:

> *"I will often, almost always, draw attention to that with a giant asterix (I
> will even vocally say \asterisk\ that's how I pronounce it and draw it in the
> air with my hands)."*

> *"I generally don't explain the asterix in the moment"*

> *"it is a queue to students that I'm oversimplifying a complex topic for
> their understanding level"*

**What it means.**  *There is a monster under this, and today you get the
facade.*  In his words, from the correction below:  *"the asterix is for
letting students know that a lovecraftian monster is hiding under the fascade
i'm introducing."*  His examples are the kind to look for:  storing a variable
"in memory" while leaving stack and heap allocation out of the room, and a
blanket statement that introduces a topic while it ignores important
exceptions to the rule.

**It's rare, and it's for the arcane.**  He named what warrants it:

> *"Talking about memory allocation, reference types as pointers, looking at a
> "Stack Trace"on an exception and talking about it as if it were "The Stack".
> It's mostly reserved for the arcane language that students will encounter if
> they pursue the topics more deeply on their own or in the future."*

So the monster is machinery a student will meet later, under its own technical
names:  memory, addresses and pointers, the stack and the heap.  In this book
that's four places so far.  Chapter 1 has two:  **objects have properties
and behaviors**, which he marks himself the first time he says it, and
**reference type**, where a variable holds *where the dice are*.  The third is
*the call stack* in Chapter 2's exception aside, met through a stack trace.
The fourth is **monads** in Chapter 5, named once, as the family that result
types and option types belong to.  It's never something to go looking for
places to add.

**Demystifying it later doesn't retire it.**  He expects a later chapter to
take on value types against reference types:

> *"eventually we may talk about Value types vs. Reference Types, and will
> demystify a bit, but it will still be an * worthy topic."*

A chapter that lifts part of the facade still stops short of the machinery, so
the topic keeps its asterisk there too.

**A sentence that needs one, and isn't fundamental, is a bad sentence.**
Rewrite it until it's accurate at the level it's pitched.  Usually that means
scoping it:  `The compiler picks which method runs` became `For an extension,
the compiler picks which method runs`.

**The shape.**  One oversized asterisk, right after the facade, and nothing
else.  A footnote, a `more on this later`, or a gloss would be explaining it in
the moment, so leave all three out.  Like the rest of his conventions, the book
never explains it.

**In the source.**  A span right after the word, with no space:
`**reference type**[*]{.iceberg}`.  The build sets it large and in the heading
color, in Word and on Canvas.  A plain `*` would be read as emphasis.

**The first pass got this backwards, 2026-10-12.**  Given the habit, an
assistant read all six chapters for "well, actually" sentences and placed
seventeen asterisks.  The first one he read was after *"That's the whole of
what `record` decides"*:

> *"If you need to put an asterix on a sentence like that, it's a bad
> sentence.  Don't look for places to insert an asterix.  Avoid sentences that
> would need one unless it is fundamental to the topic at hand."*

One survived, on **reference type** in Chapter 1:  the box picture there is
exactly the "in memory" facade.  Five inaccurate sentences were rewritten, and
the rest came out.  The pull to complete a set is entry 27's, and here it ran
as a search:  told what a mark is for, the assistant went to fill every slot
the mark could take.

```bash
grep -rn '{.iceberg}' --include='*.md' Course
```

Expect a handful in the whole book.  For each hit, name the monster.  If you
can't, rewrite the sentence and take the asterisk out.

### 6.  The writer goes missing

Drafts drift into an impersonal register, especially in documents that feel
institutional.  His voice uses first person, and a guiding-principles document
for a course is his argument.  It should sound like one.

Watch for the hedge, too.  `This document explores the relationship between...`
hedges the claim away.  When the intent is to persuade, say so.

### 7.  Everything becomes bullets

From the style guide:  use headings and lists when they help a reader navigate,
and keep an essay as prose by default.

Assistant drafts run bullet-dense, because bullets feel organized and cost less
to write than a paragraph that has to hold an argument together.  A guiding
principles document, a rationale, or anything making a case wants connected
prose.  A step list, a reference table, or a lookup wants a list.

### 8.  "Holds" doing four jobs at once

Jason uses `hold` in one sense, the ordinary one:  to hold a position.  "I hold
authority in my classroom."  "I hold my own view firmly."  "Constructionism
holds that people learn by making."

**This entry has now had its count wrong three times, and the third correction
took the claim with it.**  It said nine, then thirteen.  The real figure is
**twelve uses in `teaching_philosophy.md`, and eleven of them are his sense.**

Jason found the twelfth on 2026-09-13, in the reference document itself:

> I hold the student's dignity while I hold the standard, because those two
> things are not in conflict.

*"This line uses the word hold in a way that I never would."*  And the failure is
worse than a single stretched word, because the parallel construction claims the
two are the same act.  `hold the standard` is his sense exactly.  `hold the
student's dignity` is a different verb wearing the same coat -- dignity is
something a teacher protects or refuses to spend, and a stance is something a
teacher takes.  The symmetry does the persuading while the meaning thins out.

**Every earlier version of this entry rested on unanimity, and unanimity is what
broke.**  What survives is stronger for being falsifiable:  eleven of twelve is
still a decisive pattern, and the twelfth is the entry's own anti-pattern sitting
in the document the entry was measured against.  That is exactly what the caution
at the top of this file predicts, arriving on schedule.

Worth noticing that the same sentence carried an entry 3 negation in its closing
clause, *"are not in conflict."*  Two anti-patterns in one line of the reference
corpus.  The quotation above stays exactly as it was written, per entry 15.

**Resolved the same day.**  The line now reads:

> I protect the student's dignity while I hold the standard.

One verb per job, the negation gone, and the paragraph ends on the concrete act.
The *"they work together"* claim had already opened that paragraph four sentences
earlier, which is where it belongs -- so the old closing clause was entry 12
as well, a landing reached for after the thought had landed.

`teaching_philosophy.md` now carries **eleven uses of `hold`, and all eleven are
his sense.**  Be precise about what that means.  The unanimity claim was false
when this entry made it, and an edit afterward made it true.  A claim repaired by
changing the evidence is a different animal from a claim that was right, and the
order of events is the part worth keeping.

An assistant draft grew a second sense, in which a value is personified as
keeping itself motionless:  the data *holds still*, the type *holds it that
way*, dice that *hold still*, behavior that *held*.  Twenty-eight of those
across the course, including the sentence opening the whole three-lesson
argument.  It reads as invented vocabulary, and to a fourteen-year-old it is a
riddle.

**The fix:**  say `fixed`.  "The data is fixed once it is built."  "Because the
type guarantees it."  The rubric already carried the plain phrasing -- *what is
fixed for good and what can change* -- so the words were sitting right there.

**A second sense went the same way:  possession.**  Where `hold` would mean
*has*, he writes `has`.  A record that **has** a `List`, the values it **has**,
you **have** a key from a save file.

**The exception is the bucket.**  `holds` earns its place while the container
analogy is switched on and doing the teaching -- Lesson 1 draws variables as
boxes on the board, and "what a variable holds" is the whole point of that
picture.  "Who is holding the card" is the same thing:  the Cards argument turns
on whether the person physically holding it knows what it is.

The test is the analogy rather than the word.  **The same variable takes either
verb depending on whether the bucket is in play**, so later lessons say a
variable *has* a particular value once the container picture has done its job
and been put away.  Ask which one the sentence is thinking with.

So the word splits three ways:  staying constant becomes `fixed`, possession
becomes `has` unless the bucket is on the board, and holding a position is his
and stays.

These senses stay, and they are why a bare grep for the word is useless:

| Keep | Because |
|---|---|
| `what a variable holds` | the bucket is switched on;  Lesson 1 draws it as a box |
| `who is holding the card` | the physical act is the argument |
| `hold back`, `hold the line` | ordinary idiom |
| `hold both columns as equals` | his own sense |

```bash
grep -rniE '\b(holds?|holding|held) +(still|steady|together|for good)' .
```

**The general lesson.**  A word appearing ninety times across a repository is
doing several different jobs.  Sort the senses before touching any of them, and
read the author's own writing to find out which sense is theirs.

### 9.  The softened directive

An instruction gets dressed as a gentle observation so it will land easier.  The
command survives the costume, and what the reader hears is a writer working
around them.

| Looks like | Write |
|---|---|
| `You might want to run it first` | `Run it first` |
| `It may be worth checking the generator` | `Check the generator` |
| `Consider using a record here` | `Use a record here` |
| `One option would be to split the lesson` | `Split the lesson` |

This is the imperative twin of the hedge in entry 6.  There a claim goes soft;
here an instruction does.  Both come from the same reflex, a wish to sound less
bossy than the sentence actually is.  The softening leaves the command exactly
where it was and lays a coat of apology over it, so the reader ends up knowing
two things:  what they are being told, and that the writer was uneasy about
telling them.

**The boundary is whether the choice is real.**  Where the reader genuinely
picks, `you can` and `one option is` are accurate and they stay.  Where the
writer has already decided, the imperative is the honest form.  Ask what happens
if the reader declines.

```bash
grep -rniE '\b(you (might|may) (want|wish) to|it (might|may) be (worth|helpful|useful)|consider (adding|using|trying|making)|one option (is|would be)|feel free to|you could (try|also)|perhaps (try|add|use))' --include='*.md' --include='*.json' .
```

### 10.  The concession arrives last

Jason's arguments open with the unflattering part.  *"I should be plain about my
own temperament, since it bears on how I do this work.  I run hot, and I do not
apologize for it."*  *"I will also say plainly that I do not hold this position
as gospel."*  The concession comes first, and the case gets made from there.

A draft that leads with the pitch and files the weakness at the end has the same
two pieces in the opposite order, and it reads as sales.  Conceding first reads
as trust, and it earns the turn.

**This is the first thing a tidying pass throws away**, because a concession at
the top looks like a soft opening, and an editor's hand moves it down.  Check
the order after any revision that tightened a passage.

**The boundary is genre.**  Concede-first governs an argument, where an admission up
front earns the case a hearing.  A warm letter works the other way.  Revising a first
letter to a parent, Jason put the pleasure of the thing first and the limitation second:
*"It's good to get to work with Anika in upper school now after teaching her in lower
school classes.  I have a decent sense of her at school, but not so much everything
outside."*  An assistant draft had opened that paragraph on the limitation by itself, and
he called it "not particularly warm."  Both orders concede.  The question is what the
passage is for, so ask whether the reader is being persuaded or greeted.

The grep finds the markers, and reading tells you where they sit.  A marker in
the first third of a section is carrying the argument.  One in the closing
paragraph has become a disclaimer.

```bash
grep -rniE '\b(that said|to be fair|of course|admittedly|granted|it is true that|i am (fully )?aware|i will also say|to their credit)\b' --include='*.md' .
```

### 20.  The invented concession

Numbered 20 so the cross-references in entries 11 through 19 keep pointing where they
point.  It belongs here, beside entry 10.

Entry 10 asks for the concession first.  A draft that has absorbed that rule and lacks
anything to concede will manufacture something, and the invention is harder to catch than a
misplaced concession, because the shape looks right.

Three of these landed in six parent letters on 2026-09-09.

| Written | The trouble |
|---|---|
| `I'll admit it duplicates an email you're already sending` | The ask was a cc.  It duplicates a keystroke. |
| `I have a welcome survey, which is thin material` | He taught that student in lower school. |
| `my sense of her is a year old and mostly from a distance` | Invented from an enrollment date.  He was meeting her for the first time. |

The first invents a cost.  The second and third invent a fact, which puts them alongside
the style guide's ban on inventing experience, and a parent is the reader likeliest to know
it is wrong.

**Why the shape survives review:**  a fabricated concession reads as humility, so it
flatters the draft and the drafter both.  It also misdescribes the ask.  "Just cc me"
states the size of the favor;  the invented version made a keystroke sound like an errand.

**The fix:**  name the actual weakness before writing the sentence.  Where one exists,
concede it.  Otherwise state the ask at its true size and move on.  Where the concession
would be a fact about a person, go and get the fact.

**The tell** is a concession about the writer's own knowledge of somebody:  how long he has
known her, how well, what he has to go on.  Those are facts he holds and an assistant
lacks, so they arrive by guess.  Ask.

```bash
grep -rniE "i'?ll admit|i (should|will) be plain|thin material|(all|only) i have|(what|all) i have (of|on) (her|him|them)|mostly from a distance|i (barely|hardly) know" --include='*.md' .
```

It hits Jason's own genuine concessions as well, `I should be plain about my own
temperament` in `teaching_philosophy.md` among them, and those are the model rather than
the error.  So read each hit.  The question a grep cannot answer is whether the weakness is
real, which is the whole of this entry.

### 21.  The concession that assesses the reader

A concession is about the writer.  Point it at the reader's family and it turns into an
appraisal of them.

Repairing the fabrication in entry 20, an assistant wrote to a parent:  *"Knowing Anaya
tells me plenty about your family and fairly little about Isha herself."*  The intent was
sound, to avoid treating two sisters as one person.  What the sentence delivers is a report
on what the writer has worked out about a family from watching one of its children.
Jason's verdict was "creepy," and it is the right verdict.

**The fix:**  keep the knowledge claim on the writer and the student.  *"Isha and I are
starting fresh, though, and I mean to know her on her own terms."*  Same respect for her
separateness, and the family stays out of it.

**The test:**  read the sentence back as though the reader had written it about you.  A line
that would unsettle you coming the other way is doing this.

**Why it comes up here:**  entries 20 and 21 both arrived from one paragraph on 2026-09-09.
The first repair for a fabricated concession overshot into this, so a correction can hand
you the next error.  Read the replacement as carefully as the original.

```bash
grep -rniE "tells me (a lot|plenty|much|something) about (you|your)|(what|how much) i (know|can tell) about (you|your)|i can tell (a lot|that) (about|from) you" --include='*.md' .
```

**The variant that grants permission.**  One step further out than the entry
above, and it arrived from the same week's work.  Apologizing in the Kickoff
email for a date that collided with Rosh Hashanah, an assistant wrote *"If you're
observing, observe -- that's the right call and it's yours to make."*  Jason cut
the sentence whole.

The apology had already finished at *"I'm sorry."*  What followed ruled on the
reader's religious observance and then granted authority the reader held the entire
time.  Entry 21's original sentence reported on a family;  this one issues a
permit.  Both raise the writer a step above the reader while sounding generous,
which is why both survive a read-through.

**The test:**  ask what standing the writer has to say it.  Where the answer is
that the reader decides, apologize and stop.

The apostrophe in the pattern below is written as `.` so the pattern stays clear
of entry 18's quoting trap and catches a straight and a curly apostrophe both.

```bash
grep -rniE 'that.s (the right|your) call|it.s yours to (make|decide)|the call is yours|as (you|is) right for you|whatever you decide is' --include='*.md' .
```

---

## Where the ornament lands

Two entries about *where* to look.  Both say the same thing from opposite ends:
a limited editing pass finds more by aiming than by sweeping.

### 11.  Ornament on the load-bearing sentence

Fancy words gather where the stakes are highest.  The sentence carrying a
paragraph is the one a writer reaches on, and the reach shows up as abstraction,
stacked modifiers, and a word that would sound strange spoken aloud.

**The rule runs backwards from intuition:**  the more a sentence has riding on
it, the plainer it should be.  A line that is both the most important in its
paragraph and the most decorated in its paragraph is showing nerves.

**The test:**  find the sentence you would keep if you could keep one.  Then
weigh it against its neighbors.  Where it is the longest and the most Latinate
of the group, rewrite it flat and read the paragraph again.  Usually the
paragraph gets faster and the claim gets louder, which is the tell that the
decoration was muffling it.

**Where this entry came from, and what has since confirmed it.**  Every other
entry here was earned by a correction Jason made to a draft.  This one arrived
from an assistant reading its own drafting habits, and an audit of
`teaching_philosophy.md` found the pattern absent from his prose.  So it began as
a description of what assistants do to his writing, resting on introspection.

A correction on 2026-09-09 settled it.  In a parent letter Jason changed *"their
classmates are carrying similar things"* to *"dealing with similar things."*  The
figure sat in the closing sentence of its paragraph, which is the position this
entry predicts, and *carrying* is the borrowed weight entry 5 describes being
spent on something small.  The entry now rests on a real correction, and the
footing is as firm as entry 3 or entry 8.

The word list below is a seed, and a seed planted by the same introspection.
Grow it from real corrections, the way every other entry here was grown, and
prune the words that keep turning up honest.  `fundamental` is already one of
those:  in `CS_GUIDING_PRINCIPLES.md` it names the paradigm's basic unit, which
is the word doing its literal job.  The ornament is `fundamentally` sitting in
front of a claim to lend it weight.

```bash
grep -rniE '\b(crucible|tapestry|testament to|profound(ly)?|fundamental(ly)?|at its core|the very (fabric|heart)|underscore[sd]?|illuminate[sd]?|resonate[sd]?|nuanced|intricate|delve|myriad|realm of|serves? to|speaks to)\b' --include='*.md' .
```

### 12.  The closing sentence

Stock phrasing clusters at the end of a section and at a transition.  A middle
paragraph has content to carry it, so it stays honest.  A closing has to land,
and landing is where a writer reaches for a shape borrowed from somewhere else.

The style guide already says to end a passage when its thought has landed.  This
entry says where to find the passages that failed to.

**Spend a limited pass here.**  Reading every last sentence in a document takes a
minute and turns up more than an even sweep of the whole thing.

This command prints the last prose line of every section, which is the
shortlist.  It steps over fenced code, tables, block quotes, horizontal rules,
and the `<!--` / `-->` that wrap the teacher notes, because a first version that
kept them buried the real closings under a list of stray backticks.  Prose
inside a teacher-note comment still gets read, which is right:  those notes are
addressed to a colleague and they close the same way.

The block below opens on **four** backticks, because the awk script matches a
fence and a three-backtick fence would close on its own pattern:

````bash
find . -name '*.md' -not -path './.git/*' -not -path './bin/*' -not -path './obj/*' \
  -exec awk '
    /^```/        {f=!f; next}
    f             {next}
    /^#{1,6} /    {if(p)print FILENAME":"pn": "p; p=""; next}
    /^(---|\||>|<!--|-->)/ {next}
    NF            {p=$0; pn=FNR}
    END           {if(p)print FILENAME":"pn": "p}' {} \;
````

It prints the last *line*, so a wrapped sentence arrives as its tail.  Treat
each hit as a line number to go read.

Read the output as a list.  Side by side the reached-for closings stand out
against each other, where each one hides well enough inside its own paragraph.

---

## Applying a rule across a repository

### 13.  Structural punctuation is exempt

A global find-and-replace for prose punctuation will hit syntax that only looks
like prose.  Every one of these was a real near-miss:

| Exempt | Example |
|---|---|
| JSON keys | `"key": "value"` |
| YAML frontmatter | `name: ascii-typography` |
| CSS declarations | `color: #fff` |
| URLs | `https://example.com` |
| Ordered-list markers | `1. Run it` |
| Column-aligned comment labels | `// TODO (Step 4):` |
| C# nullable types | `Dice? ByName(string? key)` |
| Abbreviations and honorifics | `Dr. John Wells`, `Ph.D.`, `e.g.` |

The honorific is the quiet one.  `Dr. John Wells` in `teaching_philosophy.md`
matches every sentence-break pattern in this file, and it is correct as it
stands, because the period ends an abbreviation and a sentence continues through
it.  A period followed by a capitalized word is a sentence break only when a
sentence actually ended.  Audit that shape by eye;  the list of honorifics is
short enough that a false positive announces itself.

The list markers deserve a note.  Protect them by **position**, since a
sentence can legitimately end on a digit:  `Read Scene 1.  Which exhibit
worries you most?`  Match `^\s*\d+\.\s` at the start of a line, hold that part
aside, and apply the rule to the rest.

The C# nullable is the genuine landmine, because `Dice? ByName` is
indistinguishable from a sentence by pattern alone.  Apply the rule, then repair
it in `.cs` files only.  That repair is safe there because every prose sentence
in those comments ends on a lowercase word.

### 14.  Generated files keep their own copy

Fixing the source and declaring victory leaves behind whatever the build step
writes from its own hardcoded strings.  In this repository the Canvas HTML is
generated from JSON by a PowerShell script, and that script carried four pieces
of prose of its own:  a banner, a stage-table footer, a helper-box caption, and
a file header.

**Check the generator, then rebuild, then audit the output.**

### 15.  Self-referential examples break

Applying a rule to the document that documents the rule turns the examples into
nonsense.  A memory file explaining that `Dice? ByName` must stay single-spaced
had its own example double-spaced.  Another said `the typographic -- has become
a tell`, which now says something else entirely.

When a document quotes the thing it is correcting, that quotation is a citation
and it stays exactly as written.

### 16.  The rule hides behind markup

A sentence that ends inside bold puts the closing `**` between the punctuation
and the space, so an audit anchored on `[.?!:] [A-Z]` walks straight past it.
`**Face up or face down.** Is that a fact about the card` is a single-spaced
sentence break wearing a costume.  One pass over this repository found a hundred
and three of them after two earlier passes had reported clean.

The capital-letter anchor misses two more shapes.  A colon inside bold usually
introduces a lowercase clause, `**The method:** rewrite the negative`, and it
still takes two spaces.  So does a sentence ending on a digit or a brace.

```bash
grep -rnE '[a-z)][.?!:](\*\*|\*) [^ ]' --include='*.md' --include='*.json' .
```

Requiring the emphasis marker is also what keeps the pass clear of the exempt
syntax in entry 13.  `// TODO (Step 4): sides is wide open` and `Dice? dice`
carry no markers, so a marker-anchored pattern leaves them alone by
construction, and the landmine defuses itself.

---

## Verifying the work

Four ways an audit reported clean when the work was still dirty, and one check
that runs on the ear.

### 17.  Case-sensitive search

`grep 'nothing'` misses `Nothing` at the start of a sentence, which is where it
most often appears.  Roughly a dozen instances survived a first pass this way.
Use `grep -i` for prose audits.

### 18.  Backticks inside a double-quoted shell string

```bash
grep -ohE "[a-z)\`*]\. [A-Z]" $FILES     # backtick opens command substitution
grep -ohE '[a-z)`*]\. [A-Z]' $FILES      # single quotes keep it literal
```

The first form reported zero matches across nine hundred real ones, and the
count looked like success.  **A surprising zero deserves a sanity check against
a pattern known to match.**

**A surprising hundred deserves the same check.**  Auditing
`teaching_philosophy.md` for single-spaced sentences, I wrote
`[a-z)"][.?!] [^ ]{0,30}` and got about a hundred hits in a file that a
narrower pattern had just called nearly clean.  The `{0,30}` was the bug:  it
matches zero characters, so every *correctly* double-spaced sentence matched on
the period, one space, and an empty tail.  `{1,30}` cut it to a single hit, and
that hit was `Dr. John`.  Any quantifier that can match zero can turn the compliant
text into the report.  Sanity-check a count in both directions, against text you
know is dirty and text you know is clean.

The same family, one layer up:  a heredoc written through a tool call can
arrive with its backslashes already consumed, so a script that reads correctly
in the message writes `\|` as `|` and `\x{2014}` as the character itself.
Building the backslash with `chr(92)` sidesteps the whole question.  When a
generated file shows the right characters and the wrong escapes, suspect
transit before suspecting the regex.

Perl's own escapes bite the same way.  Writing a documented `grep` pattern
into a file through a double-quoted string turned `\b` into an actual
**backspace**, 0x08.  It is invisible in every editor, it survived two readings
of the file, and `cat -A` was what finally showed it, as `^H`.

I then made the same mistake a second time while writing this very entry, which
is the argument for the rule:  anything that writes a regex into prose should
build the backslash with `chr(92)` rather than type it.  A sweep for control
characters is cheap and worth running after any such edit:

```bash
grep -rnP '[\x00-\x08\x0b\x0c\x0e-\x1f]' .
```

Run the audit through the same engine that ran the fix.  A pass applied with
perl and checked with grep is two regex dialects and two different ideas about
what counts as one character, and the disagreement shows up as either a
phantom hit or a silent miss.

**A multi-word phrase wraps, so a line-based search misses it.**  Checking which
figures of speech in a draft were Jason's, a `grep -F` for each phrase reported
"no source" for several that are plainly in the lesson plans:  the source wraps
"a good / afternoon ahead" and "Teach up / to the edge" across a line break, and
`grep` reads one line at a time.  Acting on that report would have stripped his
own phrases as inventions.  Flatten both sides before comparing:

```python
import re
flat = lambda t: re.sub(r'\s+', ' ', t).lower()
```

The same run had a second failure worth knowing:  **`grep` on this machine is
`ugrep`**, which took an unquoted shell variable holding several paths as one
filename and only warned, so every count came back zero.  Pass
paths as a shell array, and treat a zero from a multi-path search as suspect
until one known-present phrase confirms the invocation.

### 19.  Reading it as spoken

The check a pattern will always miss.  Read the passage as though speaking it to
the person it addresses.  Keep the lines you would actually say to them, and
rewrite the rest.

**This works well before you can diagnose the problem**, which is what makes it
the first check to run.  The ear rules, and the reason can come afterward.
Every other entry in this file is a name for something the ear had already
caught.

It finds them one register at a time.  A softened directive sounds evasive out
loud.  An ornamented sentence sounds like a speech.  A definition by negation
sounds like somebody arguing with a person who left the room.

When your own ear has gone stale on a draft, hand it to the machine:

```powershell
Add-Type -AssemblyName System.Speech
$s = New-Object System.Speech.Synthesis.SpeechSynthesizer
$s.Rate = -1
$s.Speak((Get-Content -Raw .\Course\lessons\lesson_01_first_objects.md))
```

```bash
say -f Course/lessons/lesson_01_first_objects.md    # macOS
```

Feed it a passage at a time.  A whole file read aloud turns the markup into
noise, and attention goes with it.

---

---

## Punctuation he sets by ear

### 24.  The comma before a trailing adverb

Jason drops it.  The rule arrived on 2026-09-13, from two lines in
`lesson_02b_primitive_obsession.md` -- *"repairing a bad value into a legal one,
quietly"* and the step heading *"Count the cost, honestly."*

His words for it:  *"I would not put a comma in either of these sentences
(proper english be damned)."*  The parenthesis is the useful part.  He knows the
comma is defensible and he is overruling it on sound, which means the rule lives
in entry 19's territory -- read it as spoken, and the ear decides.

**Read the limit before the rule, because this entry has tried three times to
become a procedure and the job resists one.**  He settled it on 2026-09-13:

> *"There is no one right answer for any arbitrary sentence, because the use has
> to be context aware.  And it has to be aware of the /intent/ of the word."*

Everything below sorts one mark into three jobs.  What decides which job a
particular comma holds is the writer's intent, and intent lives outside the text
the grep can see.  So this entry is **a way of seeing, and the call still needs
the author.**

That makes the practical rule short.  In a draft of your own, cut the
afterthought comma on sight.  In his prose, bring the candidates to him.  **The
failure mode this entry keeps recording is the sweep** -- three times now, each
time a grep result read as a verdict.  Entry 13 is the same lesson about
punctuation that looks like prose, and entry 8 about a word doing several jobs.
This is both of those at once.

**Why it matters.**  The comma turns the adverb into an afterthought, a thing the
writer thought of late and tacked on.  Without it the adverb does its work inside
the sentence, and the claim arrives whole.  *Repaired quietly* is one fact.
*Repaired, quietly* is a fact plus a raised eyebrow.

**The first draft of this entry got its reasoning wrong, and the way it went
wrong is worth more than the rule.**  It swept the repository, found the pattern
in a dozen places Jason had signed off on, and concluded that those must be
deliberate beats and the rule must therefore have a boundary around them.

He corrected that immediately:

> *"No prose in this project is purely my own prose.  So these errors might be
> sneakily in any of the documents.  Even the ones I provided you for examples."*

So the count measured one thing:  how often that tic survived review.  Every
document here was drafted or edited with an assistant in the room, so a pattern
appearing twelve times is twelve chances it went unnoticed.  **Read the section
at the top of this file before any entry leans on a count again.**

**The counterweight, in his words:**

> *"My relationship with commas is strained at best.  So we do have to balance my
> own propensity for just dropping them with making the text parsable by a
> teenager."*

That is the whole boundary, and it is worth stating as a rule because the two
pressures pull opposite ways.  His ear says drop it.  The reader is a teenager
meeting C# for the first time, working through technical prose where a clause
boundary is genuinely load-bearing.  **A comma that helps a first read stays.  A
comma that only slows one down goes.**

This is the same split entry 13 draws for punctuation that looks like prose and
is really syntax.  Here the split runs between the **afterthought comma**, which
is decoration, and the **structural comma**, which is navigation.  Cut the first
one on sight.  Leave the second one alone.

**And there is a third job, which he uses on purpose.**

> *"The `, deliberately,` there is actually correct, because it forces the
> reader to pause on that word.  That is a way that I sometimes insert commas in
> places plain english might not.  For Emphasis."*

The **emphatic comma** isolates a word so the reader has to stop on it.  It runs
the opposite direction from the rule at the top of this entry, and it is a
device, and he uses it on purpose.  From `teaching_philosophy.md`:

> The arc of a course or an advisory relationship should move, deliberately,
> toward the student needing less from me, because they are growing.

`deliberately` is the load-bearing word in that sentence.  The claim is that the
fading is designed, and the commas make the reader stop and take it.

**So one mark is doing three jobs, and this is entry 8's problem in
punctuation.**  A bare grep finds the mark and leaves the job it holds entirely
open.  Sort the senses before touching any of them:

| The comma is | It is doing | Do |
|---|---|---|
| an afterthought | decoration | cut it |
| structural | navigation, for a reader parsing at speed | keep it |
| emphatic | forcing a pause on the word it isolates | keep it, and it was a choice |

**And the dial this sits on is register.**  Entry 22 settles that before the
first sentence, and it settles how tightly this entry binds:

> *"The more casual the register, the more willy-nilly we can be with comma
> rules, and ambiguity in sentence construction is sometimes on purpose."*

So the two rows below are a dial with settings along it.  At the instructional
setting -- a lesson README, a Canvas page, a starter file a student opens alone
-- the parsing cost is real and the structural comma wins most arguments.  At
the whimsical setting the comma-free run is a rhythm, and a sentence with two
readings may be carrying both on purpose.  **Settle the register first.  Then
run the test.**

**Two questions that sort the candidates.**  They sort;  they decide only the
clearest cases, per the limit at the top.

**First, delete the comma and read the line at speed.**

| Delete it and... | Then |
|---|---|
| the sentence has one reading | decoration, or emphasis.  Go to the second pass. |
| the reader has to back up and re-parse | navigation.  Keep it at the instructional setting, and weigh it against the rhythm at the casual one. |

**Then, for anything that survived deletion, ask what the isolated word is
doing.**  An emphatic comma deletes cleanly, which is exactly why the first pass
walks straight past it.  Look at the word between the commas and ask whether the
sentence wants weight on it.  Where the surrounding prose pays that weight off,
the comma was a choice.

`deliberately` is the whole claim of its sentence, so the pause earns its place.
`quietly` in *"repairing a bad value into a legal one, quietly"* is a detail of
the definition, so the comma was decoration and he cut it.

**This pass exists because the entry lost one.**  A teacher note in Lesson 3
read *"Now run it.  Everything works, beautifully.  That's the point."*  The
first pass deleted the comma cleanly, so the sweep took it.  That warm-up turns
on code that works perfectly being exactly the problem, the pause on
`beautifully` is what makes the irony land, and *"That's the point"* is the
sentence that pays it off.  The comma was restored.  **When the next sentence
explains why a word matters, the comma isolating that word is load-bearing.**

`Push back once clearly` makes `once clearly` read as a unit before the reader
works out that both words modify `push back`, so that comma is navigation and it
stays.  The difference is a reader's second pass, and a lesson a student reads
at home has somebody to ask only in class.

**The corrections, with the job each comma was holding:**

| Was | Is | The comma was |
|---|---|---|
| `repairing a bad value into a legal one, quietly.` | `...into a legal one quietly.` | decoration |
| `Count the cost, honestly` | `Count the cost honestly` | decoration |
| `The instance method wins, quietly, and...` | `The instance method wins quietly, and...` | decoration, doubled |
| `*(The instance method, quietly.)*` | `*(The instance method quietly.)*` | decoration |
| `Everything works, beautifully.` | *restored* | **emphasis** -- see above |

**A bracketed adverb is the same error wearing a second comma.**  The fourth row
has commas on both sides, and an earlier draft of this entry exempted that shape
on the grounds that deleting one comma is ungrammatical.  Jason ruled otherwise
on 2026-09-13:  delete the first one and let the second do the work it was
already doing.

**Where deleting it breaks the line, reorder.**  That is an author's call rather
than a sweep's, and his own ruling shows the shape of it:

| Was | Is |
|---|---|
| `answered today, finally` | `finally answered today` |
| `Ask which, early.` | `Ask which one first.` |

Three shapes turn up in this repository that the grep catches and the rule leaves
alone.  Each one keeps its comma for a different reason, and the reasons are
worth telling apart.

- **The comparative** keeps it on grammar.  *"one object with two names, exactly
  as they were that morning."*  `exactly` points forward at `as`, so the comma
  belongs to the clause ahead of it.
- **Stacked adverbs** keep it on navigation, by the test above.  *"Push back
  once, clearly:"*
- **The sentence adverb** keeps it because there is no comma-free reading.
  *"Then, honestly, the cost:"* uses `honestly` to mean *to be honest*, so it
  comments on the whole clause.  Tell it from a manner adverb by asking what it
  modifies:  *count the cost honestly* describes the counting, while *honestly,
  the cost* describes the speaker.

```bash
grep -rnE ',\s+[a-z]+ly[.:;)"]|,\s+[a-z]+ly$' --include='*.md' --include='*.cs' --include='*.json' .
```

Expect about half the hits to be one of the shapes above.  The
grep finds the pattern;  reading aloud tells you which kind it is.

### 28.  Consistent punctuation is the tell, and his students find it

Entry 24 records three times a sweep toward consistency went wrong.  This entry
says what the sweep costs, and the evidence for it comes from outside this
repository.

**His students can tell when he has used an assistant to edit something, and
what they notice is that the punctuation is too consistent.**  He said so on
2026-09-19:

> *"students are the most perceptive since they see more of my writing than
> anyone else.  They can tell when i use you to edit something because my
> punctuation is always too consistent"*

**That outweighs any count in this file.**  The caution at the top says a tally
of instances here measures how often a tic survived review, because he shaped
every document in the repository.  His students read his prose from outside that
loop, in volume, across years, and they hold a baseline nobody working inside it
can reconstruct.  It is the one piece of external evidence the file has.

**The tell runs opposite to the one everybody watches for.**  Entry 1 guards the
em-dash, which is a character a reader can search for.  This one is an absence:
every list punctuated the same way, every series comma doing the same job, every
enumeration resolved toward the same mark.  A pass that tidies all of them makes
the writing read *less* like him, whatever it does for the rule book.

His own framing, from the same exchange:

> *"I am nothing if not inconsistent with my punctuation.  And sometimes
> deliberate violation of rules is indistinguishable from me just not being a
> good writer.  It's part of what makes my writing recognizable."*

**The counterweight is register, and he named it in the same breath:**  *"Don't
want to be too flipant with my punctuation in a formal register like this
though."*  Entry 24's dial already describes the range.  A lesson or an email can
run loose.  A memo to school leadership stays short of flippant, and the
structural comma wins more arguments there than it would in a starter file.

**The check runs on your own diff rather than on the text.**  This error hides as
an absence, so a grep of the document finds nothing.  After an editing pass, list
every punctuation change you made and ask whether they all run the same
direction.  Where they do, you have normalized rather than edited.

```bash
git diff -U0 -- '*.md' | grep -E '^[+-].*[,;:]'
```

**Worked example, 2026-09-19.**  Editing `docs/google-group-reform.md`, three
comma candidates went to him one at a time per entry 24.  He kept two of them
[one as a deliberate pause in speech, one as a probabilistically expected comma]
and changed the third to semicolons.  The document now carries two lists
punctuated differently on the same page, and he declined the offer to make them
match.  That is the correct outcome.

---

## The shape of a good fix

Most entries here share a structure worth naming.  A rule that reads as
mechanical almost always has a boundary where the mechanism stops applying, and
that boundary is usually the difference between **prose** and **syntax**, or
between **composition** and **citation**.

Find the boundary before running the pass.  Then verify with a search built
from the opposite assumption, and read a sample of the output before
trusting the count.
