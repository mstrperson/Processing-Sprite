# Chapter 2 plan - Draw Your Character

The reasoning behind
[`chapter_02_draw_your_character.md`](../chapter_02_draw_your_character.md),
written while drafting it on 2026-10-18, for Jason to mark up.  Section 8 is
where feedback is most useful.

---

## 1.  Sources read

- Everything Chapter 1's plan lists, plus Chapter 1 itself, so this one opens
  where it closes.
- `lessons/lesson_02_draw_your_character/lesson_02_draw_your_character.md`.
- `lessons/canvas_import/content/02.json`, the Canvas page, teacher section and
  all.  The starter both tabs come from, the class's steps, the belly button,
  *"Yes, up is minus.  Screens are strange that way."*, and the pitfalls.
- `examples/Lessons/Lesson02_DrawYourCharacter`, the same code with longer
  comments.
- `lessons/lesson_03_bring_it_to_life/` and `content/03.json`, for the hand-off.
- `Blob.java`, for what Blob's own `drawSprite()` draws, which is the whole of
  Step 1's discovery.

## 2.  The sort

| Change | Pile | Where |
|---|---|---|
| A new tab, `MyCharacter` | **Built in class** | 2.1 |
| Paste the class, and the main tab | **Built in class** | 2.1 |
| Run:  the blue face | **Built in class** | 2.1 |
| Change the body `fill` | **Built in class** (*"As a class, change one thing"*) | Step 3 |
| Move one eye by its offset | **Built in class** | Step 4 |
| Move where the character starts | **teacher demo** (*"Demonstrate the payoff"*), made a Build it | Step 5 |
| Personalize | **Your turn** | 2.5 |
| Update the radius in `super(...)` | **Your turn**, near the end (*"Five minutes before the end"*) | 2.5 |
| A second character class | **Your turn**, **Optional** (the challenge) | 2.5 |
| Misspell `drawSprite` | **added**.  See 8.1. | Step 1 |
| Draw the body last | **added**, from the pitfalls | Step 2 |
| An eye at fixed numbers | **added**, from the pitfalls and the DI note.  See 8.2. | Step 6 |
| Leave out `noFill()` | from the pitfalls, as a Watch out | after Step 2 |
| Delete `super(...)` | from the pitfalls, as a Watch out | 2.3 |

## 3.  The step order, and why

Part One reads both tabs, then Part Two shows that the student's `drawSprite()`
replaces Blob's, and then Part Three does the Canvas page's steps 6 to 9 in
order.

The pitfalls became Steps because each one shows something about how the class
works, and doing it on purpose shows it faster than reading about it.  Step 1
shows the Blob underneath.  Step 2 shows shapes stacking.  Step 6 shows why the
belly button matters, which the Canvas teacher notes call *"the single most
important idea in the lesson."*  So it gets the chapter's one **Answer in your
notes**, and it comes last, right before the student designs their own.

**Where the story bent.**  The Canvas page says *"Paste"* for both tabs, where
Chapter 1 said type it by hand.  The chapter follows the page.  The prologue's
"Type it by hand when you can" covers both.

## 4.  Discoveries

| Discovery | Set up in | Source |
|---|---|---|
| Misspelled `drawsprite` gives a plain outlined circle, and no error | Step 1, "predict" | **found** |
| The body drawn last paints over the face | Step 2 | the Canvas pitfalls |
| A fixed-number eye looks right, then stays behind | Step 6, the Answer in your notes | the Canvas pitfalls and DI |
| The radius changes nothing on screen | 2.5 | **found**.  Plants Chapter 6. |

### PRIVATE NOTES - answers, for Jason and a future Flint prompt

- **The misspelling.**  `drawsprite()` is a second method.  Nothing calls it.
  `player.drawSprite()` finds the `drawSprite()` the class got from Blob, which
  is `fill(myColor); ellipse(pos.x, pos.y, 2 * radius, 2 * radius);`.  So it's
  the backup color from `super(...)`, `(100, 180, 255)`, at radius 30, which is
  60 across, exactly the size of the starter's body.  The outline is
  Processing's default stroke, because the character's own `noStroke()` never
  runs.  The chapter says *"That circle was under your face the whole time."*
  That's close enough for the level:  Blob's method was always there, and the
  character's method was being called in its place.
- **Why that color** (Check your understanding, question 3).  It's the color in
  the handshake.  A student who changed the handshake's color will see their
  own.
- **Body last, no outline.**  The body's `noStroke()` runs right before its
  `ellipse`.  The smile's `stroke(30)` is earlier in the method now, so it no
  longer reaches the body.
- **The eye.**  `(388, 292)` is a spot in the window.  `pos.x - 12` is a spot
  measured from the character.  Only the second one moves with it.  The pupil
  moved and the white didn't, because only the white got fixed numbers, and the
  screenshot shows exactly that.
- **The radius.**  It's used only by `collidesWith()`.  Chapter 6.

## 5.  Syntax

### Introduced in Chapter 2

| Syntax | Where | How |
|---|---|---|
| tabs | 2.1 | Aside |
| `width`, `height`, `/` | 2.2 | Aside |
| `class`, `extends Blob` | 2.3 | prose, and the asterisk |
| the constructor, `PApplet`, `float` | 2.3 | prose, and an Aside for `float` |
| `super(...)`, the handshake | 2.3 | prose, the Canvas wording |
| `void drawSprite()`, *overriding* | 2.4 | prose, and an Aside for `void` |
| `fill`, `noFill`, `stroke`, `noStroke`, `strokeWeight` | 2.4 | prose |
| `ellipse`, `arc`, `PI` | 2.4 | prose, and an Aside for `arc` |
| shapes stack | 2.4, Step 2 | prose |
| `pos.x`, `pos.y` | Part Three | prose, the belly button |
| `rect`, `triangle`, `line` | 2.5 | a table |

### Pointed back to

`drawSprite()` and the dot (Chapter 1), the Color Selector (Chapter 1), the
outline on the white blob (Chapter 1), the five things a Blob needs (Chapter 1).

### Guardrails, checked

- *Inheritance* appears nowhere.  `extends` is *built on top of*, in the Canvas
  page's own sentence.
- `abstract` appears nowhere.
- `super(...)` is the handshake.  The chapter adds one thing the Canvas page
  leaves out:  its five values are a Blob's five, from Chapter 1.  That's a
  description of what's in the parentheses, which the student can check by
  eye, and it stops short of saying what `super` means.  See 8.3.
- *Overriding* is used, once, because the Canvas page's goals and checklist use
  it (*"Override `drawSprite()`"*).  BOOK_PLAN's guardrail list had it out.
  The Canvas page wins.

## 6.  Verification log

Everything ran on 2026-10-18 with [`verify_ch02.sh`](verify_ch02.sh), against
the Canvas page's two tabs and this repo's `library/SpriteGame.jar`.

The pictures are **crops** of the real frames.  The character is 60 pixels
across in an 800-by-600 window, and at book size the whole window made the
face a speck, too small to see an eye left behind.  So every frame is cropped to
the middle of the window (260 by 180), or, for the two Steps that move the
character to `(200, 150)`, to the window's top-left 400 by 300.  The
comparisons (`cmp`) ran on whole, uncropped frames.  Chapter 1's pictures are
whole windows, because where the blob sits in the window is what they show.

| Check | Result |
|---|---|
| the starter builds and runs | `Finished.`  `ch02_Starter.png` |
| `drawsprite` in the class | builds, runs:  a plain blue circle, black outline.  `ch02_Misspelled.png` |
| the body moved below the smile | a plain blue circle, no outline.  `ch02_BodyLast.png` |
| no `noFill()` before the `arc` | the smile fills in dark.  `ch02_NoNoFill.png` |
| the `super` line deleted | `MyCharacter.pde:11:0:11:0: Implicit super constructor Blob() is undefined. Must explicitly invoke another constructor` |
| a new body `fill` | not run.  A color change, with nothing to predict but the color. |
| the left eye at `pos.x - 20`, both lines | `ch02_EyeSlide.png` |
| the character at `(200, 150)` | `ch02_Moved.png` |
| the eye at `(388, 292)`, character at the center | byte-identical to `ch02_Starter.png` (`cmp`) |
| the eye at `(388, 292)`, character at `(200, 150)` | the white stays in the middle.  `ch02_FixedEyeMoved.png` |
| the radius at `100` | byte-identical to `ch02_Starter.png` |
| a tab file named `MyCharacter.pde.pde` | builds and runs.  The Canvas pitfall about it is harmless, so the chapter leaves it out. |

**Unverified:**  the tab-bar arrow and the New Tab dialog (from the Canvas
page), and the `rect` example in 2.5's table, which is arithmetic from
Processing's documented `rect(x, y, w, h)`.

## 7.  Meeting split

One meeting, one piece.  The Canvas timing says it *"can stretch to two if
students are deep in it,"* which would be the flex day.  Section 2.5 is where
that second meeting would start, and the build needs no change for it.

## 8.  Guesses and open questions for Jason

1. **Step 1 is mine.**  The misspelling is the clearest picture of *your
   drawing replaces Blob's* the code offers, and it builds with no error, so it
   surprises a student who learned in Chapter 1 that a lowercase `s` stops the
   sketch.  Too much, for a lesson about drawing?
2. **Step 6 puts the hard-coded-coordinates bug in on purpose.**  The Canvas
   teacher notes say to hunt for it while circulating.  The chapter hands it to
   every student instead, then has them take it back out.  Is that the right
   trade, or does it plant the habit?
3. **The handshake's five values.**  The chapter points out they're the five
   things a Blob needs.  Is that further than you want `super` to go?
4. **The asterisk on `extends`.**  BOOK_PLAN question 9.2.
5. **The spiral nuance** here is "your character gets every one of Blob's
   properties and behaviors, and you swap out one behavior."  Right?
6. **Length.**  2,970 words of prose.  First cuts:  the `float` Aside, and Step
   2 (fold it into a Watch out).
7. **The tilde.**  *"Goodbye, starter blob~"* is from the Canvas rubric's Made
   It Mine stage.  Kept, since it's yours and the register is this one.
8. **The opening** is the eye left behind (`book/opening_02.md`).

### Settled 2026-10-18, from Jason's answers in BOOK_PLAN section 9

- **4, the asterisk:**  gone.  The sentence is the Canvas page's own, *"built on
  top of Blob,"* with nothing after it.
- **5, the spiral nuance:**  declined.  The words stay where they name
  something concrete:  *"Your character gets all of Blob's properties and
  behaviors, for free... you'll swap out one behavior, `drawSprite()`, for your
  own."*  The restated sentence, *"Objects have properties and behaviors,"*
  came out.
- **The Answer in your notes** in Step 6 is now a plain *"Make a guess before
  you read on."*
- Still open:  1, 2, 3, 6, 7, and 8.
