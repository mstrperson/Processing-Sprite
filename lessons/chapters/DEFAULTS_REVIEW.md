# Defaults review - from the one-shot run

Every **default** decision in [PROGRESS.md](PROGRESS.md), one per entry, with
room to respond.  Two pairs are linked:  #3 and #12 (BouncyWalls), and #7 and
#16 (the `followMouse()` NaN).  Changing one changes the other.

---

## Chapter 3 - Bring It to Life

### 1. The trail becomes Step 3

The Canvas *challenge* (comment out `background()` for a trail) became Step 3,
and stays on through Step 5, so the direction and wrap Checks show as a stripe
in a still picture.  So *commenting out* moved from Chapter 4 to Chapter 3 in
the ledger.


**Response:**
> Good choice, this gives a good visual check~

### 2. The word "wrapping" is held back

Wrapping can't be a surprise in a book.  The chapter holds back the word until
after the Check.

**Response:**

> This is fine

### 3. BouncyWalls promised for Chapter 7

Chapter 7 will offer `ScreenBehavior.BouncyWalls` as an optional extra, because
the Lesson 3 Canvas notes park the bounce question for Lesson 7.  *(Linked to
#12.)*


**Response:**

> Perfect. Bouncy Walls should come after the kids have seen `if` statements.  Even though it is a magical black-box setting, the intuition to talk about "if you touch the edge of the screen then change something about the character" belongs there.
---

## Chapter 4 - You're in Control

### 4. Four Parts

Four Parts, because the two control styles are two ideas.

**Response:**
> Excellent, this was a challenging section to run as one class period.  It didn't help that I was absent from class that day as well, so that also impacted it.  I think in future iterations, I will have half the class do Keyboard control and Half do mouse following, and then they will share their ideas with their table.

### 5. The space-bar brake is taught

See the Chapter 4 plan, 8.1.

**Response:**
> Good~

### 6. *Trade-off* used once

*Trade-off* is used once, in the **Argue it** about mouse or keys.

**Response:**

> This is good, because it is a game design decision.  It will heavily impact the way they play their game, so having them actively think about why they are choosing what they are choosing is good.

---

## Chapter 5 - Build Your World

### 7. The NaN goes in the teacher reference only

When the character lands exactly on the mouse, `followMouse()` divides by zero
and the character vanishes for good.  The NaN goes in the teacher reference,
with a suggested one-line fix to `followMouse()`, and the library is left
alone.  No student chapter mentions it.  See the Chapter 5 plan, 8.1.  *(Linked
to #16.)*

**Response:**

> Yes, we can leave this as a purely theoretical bug.  In practice, I have **never** seen this happen.  The math of how things move around, it is highly improbable that the character would ever actually land exactly where the mouse pointer is.

### 8. `cloud2` built with `cloud1`

`cloud2` is built with `cloud1`, where the guided notes have students add it
alone.

**Response:**

> This is fine, two instances of the same object is what we want them to see~

---

## Chapter 6 - Collisions

### 9. Steps numbered straight through

Steps numbered 1 to 10 straight through both meetings, with the meeting split
at `# Part Three`.

**Response:**

> Good.

### 10. Day 1 checkpoint stays on Canvas

The Day 1 checkpoint stays on the Canvas page, and Part Three points there.

**Response:**
> Good.

---

## Chapter 7 - Build Your Game

### 11. The win is tested by cheating

The win is tested by cheating, `goal = 1`, on Day 1.

**Response:**
> Excellent programming technique~  Force the desired condition in a test.

### 12. BouncyWalls as a one-line extra

`BouncyWalls` is offered as a one-line extra, as the Chapter 3 plan promised.
*(Linked to #3.)*

**Response:**

> Excellent.  This gives students an option for a different way games can run, so it might be worth having them write their thoughts down.

### 13. What's next

What's next points at the bonus chapters and next quarter's Arduino.

**Response:**

> Perfect.

---

## Bonus A - Images

### 14. The hitbox as a red ring

Step 4, drawing the hitbox as a red ring, is added.  It makes the
`imageMode(CENTER)` pitfall visible, and it's a habit that would serve Chapter
6 too.  See the plan, 6.1.

**Response:**

> Good.  Lets keep it here and not add more to lesson 6.

---

## Bonus D - Lists and Loops

### 15. The tagline

*"One coin is a variable.  Twenty coins is a list."*, since the plan's sources
have none that fits.

**Response:**
>  Good.  You could also lean into the absurdity of building 100 coins one by one in the code.

---

## The teacher reference

### 16. The library is unchanged

The `followMouse()` fix was proven as an override in a sketch, and the
reference suggests it.  *(Linked to #7.)*

**Response:**
> Good.

### 17. No Canvas page for the reference

A Word file for Flint, like everything else.

**Response:**
> Perfect.