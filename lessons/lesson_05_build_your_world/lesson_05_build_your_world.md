# Lesson 5 - Build Your World

> **Timing:**  One period (~50 min).  It can happily fill a second if students are deep in world-building.  
> **New idea:**  Draw order -- the order of your lines decides what appears in front  
> **Builds on:**  Lesson 4 -- your controllable character.  You keep everything from Lessons 1-4.

## Learning Goals
- Use `Block` to add ground, walls, and platforms to your scene
- Write a second sprite class, like `Cloud`, with the same `extends Blob` pattern as your character
- Explain draw order:  whatever you draw later appears in front
- Design a world with a theme that is yours

## New Vocabulary
- **`Block`** -- a rectangle sprite from the library.  Good for ground, walls, and platforms
- **draw order** -- the sequence you draw things in.  Whatever is drawn later appears in front
- **static sprite** -- a sprite with zero velocity.  It sits in one place, and it is still a real sprite object
- **alpha** -- a fourth number in `color()` or `fill()` that sets transparency.  0 is invisible, 255 is solid

## Warm-Up  (~5 min)

On paper, sketch the world your game takes place in.  What is in the background?  Is there ground?  Sky?  What drifts past?  Three minutes, then show a neighbor.

## How It Works

### Block is a rectangle that stays put

`Block` is the library's rectangle sprite.  It starts with zero velocity, so it sits exactly where you put it.  That makes it good scenery:  ground, walls, a platform, a ceiling.

- **Watch out:**  for a `Block`, `x` and `y` are the **top-left corner**.  For a `Blob` they were the **center**.  This catches everyone once.
- A `Block` is scenery.  Your character passes straight through it, the same as everything else in your world right now.

*A strip of ground along the bottom*
```java
Block ground;

// in setup():
ground = new Block(this, 0, height - 70, width, 70, color(80, 160, 60));
//                       |      |          |      |        |
//                       |      |          |      |        +-- color
//                       |      |          |      +----------- height
//                       |      |          +------------------ width
//                       |      +----------------------------- y of the TOP-LEFT corner
//                       +------------------------------------ x of the TOP-LEFT corner
```

### A second sprite class:  Cloud

In Lesson 2 you wrote `class MyCharacter extends Blob` and gave it a `drawSprite()` full of shapes.  A cloud is the same idea.  Open the `Cloud` tab and look:  a class line, a `super(...)` handshake, and a `drawSprite()` that draws white ellipses around `pos.x` and `pos.y`.

Any decoration you want works the same way -- a `Tree`, a `Star`, a `Fish`, a `Rock`.  New tab, `extends Blob`, draw it.

- To make a new tab, click the small arrow to the right of your tabs and choose **New Tab**.  Name it after the class.
- Use `extends Blob`, the same as your character.  That one word means your cloud already knows how to `move()`.

### One variable for each thing

Each cloud is its own variable, and each one goes through the same three steps your character did.

- Want a third cloud?  Declare `cloud3`, create it, move it, draw it.
- If you find yourself wanting fifty of something, ask your teacher about Bonus Lesson D.

*Declare, create, move and draw*
```java
Cloud cloud1;                              // 1. declare it at the top

cloud1 = new Cloud(this, 150, 90, 0.5);    // 2. create it in setup()

cloud1.move();                             // 3. move and draw it in draw()
cloud1.drawSprite();
```

### Draw order is the whole lesson

Processing draws like paint on a canvas.  Whatever you draw **later** covers whatever you drew earlier.  The order of your lines is the only layering tool you need.

So the order of the calls in `draw()` *is* your layering.

- **Rule of thumb:  background first, player last.**

*Back to front*
```java
void draw() {
  background(135, 206, 235);   // 1. sky - furthest back

  cloud1.move();               // 2. clouds drift behind everything
  cloud1.drawSprite();

  ground.drawSprite();         // 3. ground in front of the sky

  coin.move();                 // 4. things in the world
  coin.drawSprite();

  player.followMouse();        // 5. player last, always in front
  player.drawSprite();
}
```

### background() wipes the slate every frame

Remember from Lesson 1 that `background()` erases everything.  That is why it goes at the **top** of `draw()`.

Everything after it is layered onto a clean canvas, in the order you wrote it.  Call `background()` halfway through `draw()` and you erase everything you already drew that frame.

### Transparency and speed make things look far away

`fill()` and `color()` take an optional fourth number:  transparency, called **alpha**.  `0` is completely invisible, `255` is completely solid.  Semi-transparent decorations look soft and distant.

Speed does the same work.  A world feels deep when the far-away things move slowly and the close things move fast.  Ground sits still.  Clouds drift.  The coin darts.  Your player goes wherever you send it.

*A faint cloud -- change the fill() lines inside your Cloud tab*
```java
fill(250, 250, 255, 180);   // white, slightly see-through
```

## Direct Instruction  (~10 min)

<!--
Block, and the corner-versus-center trap:
  `new Block(this, x, y, width, height, color)`.
  **`x, y` is the top-left corner**, not the center.  This is genuinely confusing after four lessons of `Blob`, where it was the center.  Say it, write it on the board, and expect to say it again individually.
  `Block` starts with zero velocity.  It inherits `setVelocity()` and `move()`, so it can move.  Its inherited collision check uses a circle of radius 0 at its top-left corner, so it is scenery only.  Solid platforms take collision and movement logic well past this course.
  A ground strip is the canonical example:  `new Block(this, 0, height-70, width, 70, color(80, 160, 60))`.  Walk through why each number is what it is.

Draw order - demonstrate, then state the rule:
  On the projector:  draw a big block, then draw a blob on top.  Fine.  Now **reverse the two lines** and re-run.  The blob vanishes.
  That five-second demo teaches the whole concept.  Then state the rule:  **background first, player last.**

Reconnect background() to Lesson 1:
  `background()` in `draw()` erases everything before re-drawing.  It goes at the top.
  The order of calls **after** `background()` determines what ends up on top.  Students have been drawing in some order since Lesson 1 without a name for it; today it gets the name.

The Cloud tab is Lesson 2 again:
  Open the `Cloud` tab on the projector beside a student's `MyCharacter` tab.  Same class line, same `super(...)` handshake, same `drawSprite()` drawing around `pos.x` and `pos.y`.  Name the match out loud:  everything in this tab is something they have already written.
  `Cloud` uses `extends Blob` so it can move today and collide later.  Steer any motivated student who writes `extends Sprite` back to `extends Blob`.
  Push students who want richer scenery toward their own sprite class in a tab.  A pile of raw `ellipse()` and `rect()` calls in the main tab works, and it makes `draw()` unreadable right before the two lessons where they most need to read it.

One variable per thing - and where lists went:
  Each cloud is its own variable:  `cloud1`, `cloud2`.  Two or three of something is easy to manage this way, and it uses only what students already know from Lessons 1-4.
  A student who wants fifty stars has a real reason for a list.  That is Bonus Lesson D.  Point that student there, and keep the room on named variables.

The alpha channel:
  `fill(r, g, b, alpha)` -- alpha 0 is invisible, 255 is fully opaque.  For the `Cloud`, the change goes on the `fill()` lines inside its `drawSprite()`.
  Semi-transparent decorations look genuinely good and cost one number.  Show `fill(250, 250, 255, 180)` next to `fill(250, 250, 255)` on the projector.
-->

## Guided Activity  (~20 min)

<!--
1. Start with the paper sketch warm-up.  Three minutes of drawing before any code.  It genuinely improves what they build.
2. Everyone adds the ground `Block` together.  Expect the top-left-corner confusion here -- several students will put it off-screen.
3. Everyone changes the background color to something themed.  Immediate visible payoff.
4. **Deliberately break it as a class:**  move `ground.drawSprite()` to the last line of `draw()`.  Everyone runs and walks their player under the ground.  Move it back.  Nobody forgets draw order after doing it with their own hands.
5. Make the `Cloud` tab together.  Declare, create, move, and draw `cloud1` as a class.  Students add `cloud2` on their own.
6. Add the coin.  Tell the room plainly that touching it does nothing yet, and that next lesson it will.
7. Release for world-building.  This is the bulk of the period and it should be.
8. Last five minutes:  quick share-out.  Each student shows their world and names one draw-order decision.
-->

## Build It Step by Step

1. Sketch your world on paper first.  Three minutes.
2. Open your Lesson 4 sketch.  Keep your `MyCharacter` tab exactly as it is.
3. Declare `Block ground;` at the top of your sketch.  In `setup()`, create it:  `ground = new Block(this, 0, height - 70, width, 70, color(80, 160, 60));`
4. In `draw()`, right after `background()`, add `ground.drawSprite();`.  Run it.  You should have a strip of green along the bottom.
5. Change `background(240)` to a color that fits your world -- sky blue, deep space black, ocean teal, lava red.
6. **Experiment with draw order:**  move `ground.drawSprite()` to the very last line of `draw()` and run.  Walk your player down to the ground.  It disappears underneath.  Move the line back and say out loud what happened.
7. Make a new tab called `Cloud` and paste in the `Cloud` code from the starter below.
8. Declare `Cloud cloud1;` and `Cloud cloud2;` at the top.  Create them in `setup()`.  In `draw()`, move and draw them **right after** `background()`, before the ground.
9. Add a coin:  declare `Blob coin;`, create it in `setup()` with the line from the starter, and move and draw it **after** the ground and **before** the player.  Nothing happens when you touch it yet.  That is Lesson 6.
10. Add a second `Block` as scenery:  a platform, a wall, a ceiling.  Choose where it belongs.
11. Restyle everything so it belongs together.  A gold coin in a space world looks wrong -- make it a star, or a gem.  Play it.  Does it look like a place?  Keep going until it does.

## Starter Code

**Main sketch tab:**
```java
// Lesson 5 - Build Your World
import coxprogramming.processing.sprites.*;

MyCharacter player;
Cloud cloud1;
Cloud cloud2;
Block ground;
Blob coin;

void setup() {
  size(800, 600);

  // Ground strip along the bottom.  x, y is the TOP-LEFT corner.
  ground = new Block(this, 0, height - 70, width, 70, color(80, 160, 60));

  // Two clouds, each drifting at its own speed (Cloud is in its own tab)
  cloud1 = new Cloud(this, 150, 90, 0.5);
  cloud2 = new Cloud(this, 520, 60, 0.8);

  // A coin drifting through the world.  You collect it in Lesson 6.
  coin = new Blob(this, random(width), random(100, height - 150),
                  14, random(1, 2.5), random(-1.5, 1.5),
                  color(255, 220, 50));

  player = new MyCharacter(this, width/2, height/2);
  player.setVelocity(4, 0);
}

void draw() {
  background(135, 206, 235);   // 1. sky - furthest back

  cloud1.move();               // 2. clouds drift behind everything
  cloud1.drawSprite();
  cloud2.move();
  cloud2.drawSprite();

  ground.drawSprite();         // 3. ground in front of the sky

  coin.move();                 // 4. things in the world
  coin.drawSprite();

  player.followMouse();        // 5. player last, so it is always in front
  player.drawSprite();
}
```

**New tab - Cloud.pde:**
```java
// Cloud - a second sprite class.  Redesign it to fit your world!
class Cloud extends Blob {

  Cloud(PApplet p, float x, float y, float speed) {
    super(p, x, y, 40, color(255));  // radius 40 used for collision if ever needed
    setVelocity(speed, 0);           // drift slowly to the right; no vertical movement
  }

  void drawSprite() {
    noStroke();

    // Bottom puffs - the wide base of the cloud
    fill(250, 250, 255);
    ellipse(pos.x,      pos.y,      72, 46);
    ellipse(pos.x - 31, pos.y + 13, 50, 33);
    ellipse(pos.x + 33, pos.y + 13, 55, 33);

    // Top puffs - slightly greyer for a sense of depth
    fill(235, 238, 248);
    ellipse(pos.x - 13, pos.y - 17, 54, 38);
    ellipse(pos.x + 17, pos.y - 11, 46, 33);
  }
}
```

## Make It Yours

- Replace the sky-blue background with **your** theme.  Space?  Underwater?  Lava?  A cave?  A candy world?
- Redesign the `Cloud` tab completely -- a star, a bubble, a bird, a fish.  Rename the class if you like.
- Write a brand-new decoration class in its own tab -- a `Tree`, a `Star`, a `Rock`.  Same `extends Blob` pattern as Lesson 2.
- Add more `Block`s to draw platforms, walls, or a border around your scene.
- Change your coin to match the theme -- a gem, a fish, a star, a heart, an asteroid.
- Give background decorations a much slower speed than the coin.  That difference alone reads as depth.

**Finished early?**  Build a real parallax effect:  three clouds at three different speeds, the slowest one faintest and drawn first, the fastest one solid and drawn last.  It is the oldest trick in 2D games and it still works.

## Wrap-Up  (~5 min)

<!--
Exit question:  Name one draw-order decision you made in your world, and what it changed.
Looking for:  Anything specific and deliberate:  "I drew the clouds before the ground so they look like they are behind the hill," or "I moved the player last so it is always visible."  You want intent.  Correctness can come later.
-->

## Teacher Notes

<!--
Common mistakes:
  - **`Block` x, y as center instead of top-left.**  The block lands half off-screen.  The most common problem in this lesson.
  - **Drawing the player before the ground**, burying the character.
  - **Calling `background()` somewhere other than the top of `draw()`**, erasing everything drawn that frame.
  - **Creating a cloud inside `draw()`** -- `cloud1 = new Cloud(...)` runs every frame, so the cloud is rebuilt at its starting spot sixty times a second and appears frozen.  Creation goes in `setup()`.
  - Forgetting `.drawSprite()` on the ground or a cloud -- the object exists, nothing appears.
  - Pasting the `Cloud` class into the main tab below `draw()`.  Processing accepts it, and the class gets buried where students lose it.  New tab every time.
  - Decorations moving at the same speed as the coin, so the depth effect disappears.

Notes:
  - There is very little new code today.  It is a design lesson wearing a programming lesson's clothes.  Let it be that.
  - This lesson replaces the old Lesson 5 (A World of Objects) and the old Lesson 8 (Build Your Game World).  The lists and loops from the old Lesson 5 moved to Bonus Lesson D.  The world-building moved up front, so Lessons 6 and 7 happen in a world students already care about.
  - The coin is there on purpose.  Touching it does nothing yet, and that is the hook for Lesson 6:  open next class by asking what *should* happen.
  - The paper sketch earns its three minutes.  Students who plan on paper build noticeably better scenes.
  - The course arc leaves one flex meeting in the eleven.  If the room is deep in world-building, this is a good place to spend it.
  - Fast finishers:  their own decoration class in a tab, or the three-layer parallax challenge.
-->

---

## Rubric - Build Your World

*Use this rubric to see where you are and choose what to try next.  You can always revise and run it again.*

**✅ Check yourself first -- I can…**
- [ ] Create terrain with `Block` (remember:  `x, y` is the top-left corner).
- [ ] Use a second sprite class from its own tab.
- [ ] Order my `draw()` calls so the right things appear in front.
- [ ] Make a draw-order decision on purpose and explain it.

**Where am I?**  *Standard:  Use `Block` for terrain and a second sprite class for decoration, and control draw order to layer a themed world.*

| Level | What it looks like |
|---|---|
| **Getting Started** | My world pieces overlap wrong, the ground hides my player, or my `Cloud` tab will not run.  **Next step:**  things drawn **later** appear on top -- background first, player last.  `Block`'s `x, y` is the **top-left corner**.  And check that your class line says `extends Blob`. |
| **Got It Working** | My scene has a background, ground made with `Block`, and at least one decoration sprite, layered in a sensible order. |
| **Made It Mine** ⭐ | …and I designed a world with a clear theme (themed colors, more than one block, a decoration and a coin that belong there) that feels like a real **place**. |
| **Went Beyond** | …and I wrote my own decoration class in a new tab, used transparency and different speeds for depth, or arranged platforms and borders to develop my scene. |

⭐ **Made It Mine** is the goal for everyone this lesson.

*"Went Beyond" means taking the project further in a direction you choose.  The examples are starting points.*

**✍️ Show your thinking:**  In one or two sentences:  name one draw-order decision you made, and what it changed.
