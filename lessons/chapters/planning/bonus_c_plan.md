# Bonus C plan - Animate Your Character

The reasoning behind [`bonus_c_animation.md`](../bonus_c_animation.md), written
while drafting it on 2026-10-18, during the one-shot run.

---

## 1.  Sources read

`lessons/bonus_lesson_C_animation.md` (old template, teaching in HTML comments),
`lessons/canvas_import/content/12-bonus-c.json`, `examples/Lessons/BonusC_Animation`,
`AnimatedSprite.java`, and `CompoundSprite.java`.

## 2.  Shape

Standalone, one meeting, any time after Chapter 2.  Part One is the plan's
warm-up and its *"Heads up on the word frame"*.  Part Two and Part Three follow
the Canvas steps.  C.5 puts the animated player into the Chapter 7 game, which
the teacher notes call *"THE big integration question"*.

The two listings were spliced in from the verified Canvas files by script and
diffed against them.

## 3.  What the code showed

| Check | Result |
|---|---|
| the starter builds and runs | yes |
| frames 4, 12, 20, still | poses 0, 1, 2, all different.  `bC_Pose0/1/2.png` (crops) |
| `setFrameRate(4)` at frame 6 | byte-identical to pose 1 |
| `setFrameRate(20)` at frame 6 | byte-identical to pose 0 |
| the second frame made at `width/2 + 70`, trail | the character in two places.  `bC_Jump.png` |
| no `this.pose = pose;` | frames 4, 12, 20 byte-identical |
| the constructor still called `MyCharacter` | `The constructor OldName.MyCharacterFrame(OldName, int, int, int) is undefined` |
| `player.collidesWith(...)` | `The function collidesWith(AnimatedSprite) does not exist.` |
| the Chapter 7 game with an animated player, `distanceTo() < 40` | builds;  scored a coin, then hit a hazard and ended, both by distance |
| `nextFrame()` on a key, `setFrameNumber()` on a click | builds |

## 4.  Against the Canvas page

- *"Forgetting to rename the constructor when copying from `MyCharacter` -- a
  constructor whose name does not match its class becomes a method that never
  runs."*  It's a compile error, on the line that makes the frames.  The chapter
  quotes the message, with the sketch's name trimmed out:  Processing prints the
  class as `OldName.MyCharacterFrame(OldName, ...)`, with `OldName` being the
  sketch.
- The Canvas page's `distanceTo()` snippet has `collectibles.remove(i)`, which
  is Bonus D's list.  A student who hasn't done Bonus D has no `collectibles`.
  The chapter's version is the Chapter 7 coin's `if`, with `distanceTo()`.

## 5.  PRIVATE NOTES

- **`AnimatedSprite` extends `CompoundSprite`**, which keeps its frames as
  children.  `followMouse()`, `moveTo()`, `setVelocity()` and `keyboardControl()`
  are overridden to pass every change on to every child, so the poses move
  together.  `move()` moves the group and then each child by its own velocity.
  Each child also keeps its own position, which is why a frame made elsewhere
  stays elsewhere.
- **Only the current frame is drawn**, so the Blob circle under each frame never
  shows.  Each frame's radius and color in `super(...)` are carried along and
  unused.
- **`distanceTo()`** is on `Sprite`, so it works between any two sprites,
  `AnimatedSprite`, `ImageSprite`, `Blob`, in either direction.  The teacher
  reference covers it, and what it means that `collidesWith()` lives on `Blob`.

## 6.  Guesses and open questions for Jason

1. **`this` gets a second meaning here**, *the object itself*, where Chapter 1
   said it's the sketch.  The Aside says it plainly.  Both are true:  in the main
   tab, the object is the sketch.  Leave it at that?
2. **`key == 'n'`** brings in `key` and a character in single quotes, in an
   optional item.  Fine, or cut that item?
3. **The early-reader Aside on `if`**, added at the end of the run.  Bonus C can
   come right after Chapter 2, and its poses need `if`, `==`, and `else if`, which
   Chapters 6 and 7 teach.  Its starter also has `followMouse()` and the arrow
   keys, which are Chapter 4.  Fine as one Aside, or should Bonus C say it is best
   after Chapter 6?
