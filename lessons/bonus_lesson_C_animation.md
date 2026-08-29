# Bonus Lesson C — Animate Your Character

> **When to use this lesson:** Drop in any time after Lesson 2 (you need a character to
> animate). It shines most **during Lesson 9**, when students want their character to feel
> alive instead of sliding around as a single frozen drawing. Pairs naturally with Bonus
> Lesson A (Images) — image frames animate the same way. Teachable in one period.

## Learning Goals
- Understand animation as a *flipbook*: several still pictures shown fast, one after another
- Draw your character in 2–4 slightly different **poses** (frames)
- Use `AnimatedSprite` to hold those frames and flip between them automatically
- Control how fast the animation plays with `setFrameRate()`

## New Vocabulary
- **animation frame** — one still picture in the flipbook (one *pose* of your character)
- **`AnimatedSprite`** — a library object that holds several frame sprites and draws one at a time
- **frame rate (animation)** — how many *game* frames each picture stays on screen; `8` means "hold each pose for 8 game frames." Smaller = faster.
- **pose** — one version of your character's drawing (mouth open vs. closed, legs together vs. apart)

> Heads up on the word *frame*: a **game frame** is one run of `draw()` (about 60 per second, from Lesson 3). An **animation frame** is one picture in your flipbook. `setFrameRate(8)` connects them: hold each animation frame for 8 game frames.

## Warm-Up  (~5 min)

<!-- Prompt: "Have you ever made a flipbook in the corner of a notebook? How does a cartoon -->
<!-- make a character walk? It's just drawings, shown fast. Remember from Lesson 1 — draw() -->
<!-- is already a flipbook, drawing a new frame ~60 times a second." -->

## Direct Instruction  (~10 min)

<!--
Key things to demonstrate:

The flipbook idea:
  - Animation = a few still pictures ("frames"), shown quickly in order, looping
  - Connect to draw() from Lesson 1: draw() is the flipbook engine; AnimatedSprite is the
    flipbook the engine flips through

One pose at a time — the frame class:
  - A "frame" is just a drawing, like their MyCharacter from Lesson 2
  - Add a "pose" number so the SAME class can draw a few slightly different versions
  - Demonstrate: keep the body/eyes the same, change ONLY the mouth (or legs) per pose
    "Only change what should move — keep everything else identical, or it looks jittery"

Building the AnimatedSprite (the one new idea):
  - AnimatedSprite.FromSprite(firstFrame).AddFrameSprite(next).AddFrameSprite(next).setFrameRate(8)
  - "FromSprite starts the flipbook; AddFrameSprite adds another page; setFrameRate sets the speed"
  - CRUCIAL: create every frame at the SAME x, y — otherwise the character jumps when the
    page turns
  - setFrameRate: game-frames-per-picture. Demo setFrameRate(4) (fast) vs setFrameRate(20) (slow)

Moving it — it's just a sprite:
  - player.move() / player.followMouse() / player.keyboardControl() all work, same as before
  - player.drawSprite() draws the current pose AND advances the flipbook automatically

One honest caveat (for Lesson 9): an AnimatedSprite is NOT a Blob, so collidesWith() is not
available on it. For collisions in a game, use distanceTo() — shown in Make It Yours.
-->

## Guided Activity  (~20 min)

<!-- Step-by-step:
1. New tab "MyCharacterFrame" — paste their Lesson 2 character drawing, add an int pose field
2. Make pose 0 and pose 1 differ in ONE thing (the mouth)
3. In the main tab, build the AnimatedSprite from two frames, run it — watch it talk
4. Add a third pose, then let them branch off and personalize
-->

## Starter Code

**New tab — MyCharacterFrame.pde:**
```java
// MyCharacterFrame — ONE POSE of your character.
// It's just like your MyCharacter from Lesson 2, but the "pose" number lets you
// draw a few slightly different versions. AnimatedSprite flips between them.
class MyCharacterFrame extends Blob {

  int pose;  // which version to draw: 0, 1, 2, ...

  MyCharacterFrame(PApplet p, float x, float y, int pose) {
    super(p, x, y, 30, color(100, 180, 255));  // same handshake line as MyCharacter
    this.pose = pose;
  }

  void drawSprite() {
    // --- Body (same in every pose) ---
    fill(100, 180, 255);
    noStroke();
    ellipse(pos.x, pos.y, 60, 60);

    // --- Eyes (same in every pose) ---
    fill(255);
    ellipse(pos.x - 12, pos.y - 8, 16, 16);
    ellipse(pos.x + 12, pos.y - 8, 16, 16);
    fill(30);
    ellipse(pos.x - 12, pos.y - 8, 8, 8);
    ellipse(pos.x + 12, pos.y - 8, 8, 8);

    // --- Mouth: CHANGES with the pose — this is what makes it animate! ---
    stroke(30);
    strokeWeight(2);
    noFill();
    if (pose == 0) {
      arc(pos.x, pos.y + 6, 24, 18, 0, PI);   // open smile
    } else if (pose == 1) {
      arc(pos.x, pos.y + 6, 24, 8, 0, PI);    // smaller smile
    } else {
      fill(30);
      ellipse(pos.x, pos.y + 10, 12, 12);     // round "talking" mouth
    }
  }
}
```

**Main sketch tab:**
```java
// Bonus Lesson C — Animate Your Character
import coxprogramming.processing.sprites.*;

AnimatedSprite player;

void setup() {
  size(800, 600);

  // Build the flipbook from several poses — all at the SAME spot so it doesn't jump.
  // AnimatedSprite shows one pose at a time and flips between them for you.
  player = AnimatedSprite.FromSprite(new MyCharacterFrame(this, width/2, height/2, 0))
      .AddFrameSprite(new MyCharacterFrame(this, width/2, height/2, 1))
      .AddFrameSprite(new MyCharacterFrame(this, width/2, height/2, 2))
      .setFrameRate(8);   // hold each pose for 8 game frames; smaller = faster

  player.setVelocity(4, 0);  // gives followMouse() a speed to move at
}

void draw() {
  background(240);

  // --- Option A: follow the mouse ---
  player.followMouse();
  player.drawSprite();   // draws the current pose, then turns the page for you

  // --- Option B: arrow-key control ---
  // (comment out Option A above, uncomment these two lines, keep keyPressed below)
  // player.move();
  // player.drawSprite();
}

// Used with Option B (arrow keys)
void keyPressed() {
  player.keyboardControl();
}
```

## Make It Yours  (~10 min)

- Add a 4th pose. Try animating **legs or arms** instead of the mouth — make it walk
- Change `setFrameRate()` — try `4` (fast and frantic) and `20` (slow and calm)
- Add more frames for smoother motion (more pages = smoother flipbook)
- Make a second animated creature (a pet?) with its own `setVelocity()` drifting across the scene
- **Plug it into your Lesson 9 game:** an `AnimatedSprite` is *not* a `Blob`, so `collidesWith()`
  won't work on it. Use `distanceTo()` instead:
  ```java
  if (player.distanceTo(coin) < 40) {   // 40 = how close counts as "touching"
    collectibles.remove(i);
    score = score + 1;
  }
  ```
  Pick a number that matches your character's size.

## Wrap-Up  (~5 min)

<!-- Exit question: "What's the difference between a game frame and an animation frame? -->
<!-- What does setFrameRate(4) do compared to setFrameRate(20)?" -->

## Teacher Notes

<!-- THE big integration question (Lesson 9): AnimatedSprite extends CompoundSprite, not Blob, -->
<!-- so it has NO collidesWith(). Use distanceTo(otherSprite) < threshold for collisions. -->
<!-- distanceTo() is inherited from Sprite and works between any two sprites. -->
<!-- Frames MUST be created at the same x, y or the character visibly jumps when frames switch. -->
<!-- frameRate is game-frames-PER-picture (a ratio), not pictures-per-second. Smaller = faster; -->
<!-- the minimum is 1. The default is 8 if you never call setFrameRate(). -->
<!-- Only the current frame is drawn, so the Blob's plain circle never appears — drawSprite() -->
<!-- is overridden in MyCharacterFrame. The radius/color in super() are just carried along. -->
<!-- Keep poses SIMILAR — change only what should move. Wildly different poses look like -->
<!-- flickering, not animation. -->
<!-- Fast finishers: control the frame by hand instead of auto-advancing — call nextFrame() or -->
<!-- setFrameNumber(n) on a key press to trigger a "jump" or "attack" pose. -->
<!-- Tie-in to Bonus A: a frame can be an ImageSprite, so a sprite sheet animates the same way: -->
<!-- AnimatedSprite.FromSprite(new ImageSprite(this, x, y, "walk0.png")).AddFrameSprite(...) -->
<!-- Show the AnimatedSceneExample (File -> Examples -> Contributed Libraries -> SpriteGame): -->
<!-- its clouds and sun are built with exactly this FromSprite/AddFrameSprite pattern. -->

---

## Rubric — Animate Your Character

*This isn't a test — it's a map of where you are and what to try next. You can always revise and run it again.*

**✅ Check yourself first — I can…**
- [ ] Draw my character in two or more slightly different poses (frames).
- [ ] Build an `AnimatedSprite` with `FromSprite(...).AddFrameSprite(...)`.
- [ ] Set the animation speed with `setFrameRate()`.
- [ ] Move and draw my animated character in `draw()`.

**Where am I?**  *Standard: build a multi-frame animated character with `AnimatedSprite` and control its animation speed.*

| Level | What it looks like |
|---|---|
| **Getting Started** | My character doesn't animate, or doesn't show up. **Next step:** build the `AnimatedSprite` with `FromSprite(...).AddFrameSprite(...)`, create *every* frame at the same `x, y`, and call `player.drawSprite()` in `draw()`. |
| **Got It Working** | My character appears and flips between poses on its own. |
| **Made It Mine** ⭐ | …and the animation is my own — my poses, my character, and a frame rate that looks right for the motion I want. |
| **Went Beyond** | …and I took it further — wired the animation into my Lesson 9 game with `distanceTo()`, animated a second creature, hand-controlled a pose on a key press, or animated image frames. |

⭐ **Made It Mine** is the goal for everyone this lesson.

*"Went Beyond" has no fixed list. The examples are just starting points; going somewhere the lesson did not ask for is the whole idea.*

**✍️ Show your thinking (1–2 sentences):** What part of your character did you make move, and what frame rate looked right for it?
