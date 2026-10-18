# Bonus A plan - Images

The reasoning behind [`bonus_a_images.md`](../bonus_a_images.md), written while
drafting it on 2026-10-18, during the one-shot run.

---

## 1.  Sources read

`lessons/bonus_lesson_A_images/bonus_lesson_A_images.md` (old template, teaching
in HTML comments), `lessons/canvas_import/content/10-bonus-a.json` (the steps,
*"The two rules, side by side"*, and the pitfalls), `examples/Lessons/BonusA_Images`,
and `ImageSprite.java`.

## 2.  Shape

Standalone, one meeting, any time after Chapter 4, as the Canvas page says.  It
builds into the student's own sketch, so the Canvas page's sample sketch is
quoted in pieces:  the trees in Step 1, the class in Step 3.

Part Two before Part Three, as the Canvas steps have it:  *"Start with the easy
one."*  Step 4, the hitbox ring, is **added**.  It turns the plan's *"the radius in
`super()` is the hitbox"* into something a student can see, and it shows the
`imageMode(CENTER)` pitfall, which is otherwise invisible.  See 6.1.

## 3.  What the code showed

| Check | Result |
|---|---|
| the Canvas sample sketch, with art in `data` | runs.  `bA_Start.png` |
| a name that doesn't match, `"pine.png"` | the *"missing or inaccessible"* message, once per `loadImage()`, then `NullPointerException` the first time it's drawn |
| capitals that don't match, `"Tree.PNG"` | `This file is named tree.png not Tree.PNG. Rename the file or change your code.` |
| a folder named `Data` | **works**, on this machine's case-insensitive file system |
| `hero_white.png` | the white box.  `bA_White.png` (crop) |
| `imageMode(CENTER)` left out, ring drawn | the picture down and right of the ring.  `bA_NoCenter.png` |
| with it, ring drawn | the picture in the ring.  `bA_Center.png` |
| `player.collidesWith(tree1)` | `The method collidesWith(Blob) in the type Blob is not applicable for the arguments (ImageSprite)` |
| `tree1.collidesWith(player)` | `The function collidesWith(...MyImageCharacter) does not exist.` |
| a full-window background picture | `bA_Background.png` |
| a drifting, tilted tree | builds and runs |

The art is stand-in art, drawn by `tools/make_test_art.ps1`:  a 64-by-64
character with a transparent background, the same on white, a tree, and a
gradient sky.

## 4.  Against the Canvas page

- *"If you get a blank or colored box:  the file name does not match, the file
  is not in `data/`, or the PNG has no transparency."*  Only the last makes a
  box.  A missing file stops the sketch with a message and a
  `NullPointerException`.  The chapter gives each its own Watch out.
- *"`Data`, `datas`, or created in the wrong directory"*:  `Data` works on
  Windows, and the students' Macs are case-insensitive by default too.  The
  chapter says to name it `data` and makes no claim about `Data`.
- *"Trying `collidesWith()` on an `ImageSprite`.  It will not compile, and the
  error will not explain why."*  True for `tree1.collidesWith(...)`.  The other
  way round, `player.collidesWith(tree1)`, the message is fairly clear, and that's
  the one the chapter quotes.

## 5.  PRIVATE NOTES

- **`ImageSprite`** extends `Sprite` directly, so it has `move()`, `followMouse()`
  and the rest, and no radius.  `collidesWith()` is on `Blob`, and takes a
  `Blob`.  A Blob can collide with an `ImageSprite` by distance only:
  `player.distanceTo(tree1) < something`.  The teacher reference covers it.
- **The missing-file crash.**  `loadImage()` returns `null`, and
  `ImageSprite.drawSprite()` passes it to `image()`, which throws.  The library
  could check for `null` and draw nothing, or a placeholder.  The teacher
  reference suggests it.
- **The capitals message** is Processing's own, and it fires even on a
  case-insensitive file system.  Good news for students.

## 6.  Guesses and open questions for Jason

1. **The hitbox ring (Step 4) is mine.**  Three lines, and it's a debugging habit
   worth having.  It would fit Chapter 6's Step 2 (*"generous or precise"*) just
   as well.  Move it there, or put it in both?
2. **`radius`** is Blob's protected field, used bare in the ring.  It works,
   because the class `extends Blob`.  The chapter doesn't explain why it can see
   it.
