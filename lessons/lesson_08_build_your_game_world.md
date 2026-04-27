# Lesson 8 — Build Your Game World

## Learning Goals
- Use `Block` to add ground, walls, sky, and other terrain to the scene
- Understand that draw order determines layering — later draws appear on top
- Combine static sprites (no velocity) with moving ones for a living background
- Design the visual world that the game will take place in

## New Vocabulary
- **`Block`** — a rectangle sprite from the library, great for terrain and platforms
- **draw order** — the sequence sprites are drawn in; things drawn later appear in front
- **static sprite** — a sprite with no velocity; it sits in one place but is still a proper sprite object

## Warm-Up  (~5 min)

<!-- Sketch time: "On paper, sketch the world your game will take place in. -->
<!-- What's the background? Ground? Sky? Any decorations?" (~3 min, then share briefly) -->

## Direct Instruction  (~10 min)

<!--
Key things to demonstrate:

Block constructor: new Block(this, x, y, width, height, color)
  - x, y is the top-left corner (unlike Blob where it's the center)
  - Block is always stationary — there is no velocity parameter
  - A ground strip: new Block(this, 0, height-80, width, 80, color(80, 160, 60))

Draw order:
  - Show a concrete example on projector: draw a big block, then draw a blob on top
  - Then reverse the order — the blob disappears behind the block
  - Rule of thumb: background first, player last

Remind students: background() in draw() erases everything before re-drawing.
The order of calls AFTER background() determines what's on top.

Environment sprites: students can write simple Tab-based sprite classes
for decoration (Star, Tree, Rock) — same extends Blob pattern as Lesson 2
-->

## Guided Activity  (~20 min)

<!-- Step-by-step: students add a ground block, a sky gradient or color, and at least -->
<!-- one decorative element, then share with a neighbor -->

## Starter Code

**Main sketch tab (replaces previous lesson's draw, keeps MyCharacter and game logic):**
```java
// Lesson 8 — Build Your Game World
import coxprogramming.processing.sprites.*;

MyCharacter player;
ArrayList<Blob> coins;
Block ground;
ArrayList<Blob> decorations;  // clouds, stars, trees — whatever fits your theme
int score = 0;
boolean gameOver = false;

void setup() {
  size(800, 600);

  // Ground strip along the bottom
  ground = new Block(this, 0, height - 70, width, 70, color(80, 160, 60));

  // Background decorations (slow-moving clouds, drifting stars, etc.)
  decorations = new ArrayList<Blob>();
  for (int i = 0; i < 5; i++) {
    decorations.add(new Blob(
      this, random(width), random(height * 0.7),
      random(20, 50), random(0.2, 0.8), 0,
      color(255, 255, 255, 180)  // semi-transparent white blobs as clouds
    ));
  }

  // Player
  player = new MyCharacter(this, width/2, height - 120);
  player.setVelocity(4, 0);

  // Coins
  coins = new ArrayList<Blob>();
  for (int i = 0; i < 10; i++) {
    coins.add(new Blob(
      this, random(width), random(100, height - 100),
      random(8, 16), random(-2, 2), random(-1, 1),
      color(255, 220, 50)
    ));
  }
}

void draw() {
  background(135, 206, 235);  // sky blue — change to match your theme

  // 1. Background decorations (drawn first = appear behind everything)
  for (Blob d : decorations) {
    d.move();
    d.drawSprite();
  }

  // 2. Ground (drawn after sky, before player)
  ground.drawSprite();

  if (!gameOver) {
    playGame();
  } else {
    showGameOver();
  }
}

void playGame() {
  for (int i = coins.size() - 1; i >= 0; i--) {
    Blob c = coins.get(i);
    c.move();
    c.drawSprite();
    if (player.collidesWith(c)) {
      coins.remove(i);
      score = score + 1;
    }
  }

  // 3. Player (drawn last = appears in front of everything)
  player.followMouse();
  player.drawSprite();

  if (coins.size() == 0) {
    gameOver = true;
  }

  fill(50);
  textSize(24);
  text("Score: " + score, 20, 36);
}

void showGameOver() {
  fill(80, 180, 80);
  textAlign(CENTER, CENTER);
  textSize(52);
  text("You Win!", width/2, height/2);
  textAlign(LEFT, TOP);
}
```

## Make It Yours  (~Remaining time)

This lesson is mostly creative work — students should spend most of it designing their world:
- Replace the sky-blue background with your theme color (space? underwater? lava?)
- Write a new decoration sprite class in a tab (Tree, Star, Fish, Rock — whatever fits)
- Add multiple ground/wall Blocks to create platforms or borders
- Change coin colors and sizes to match the theme (gems? fish? stars? hearts?)

## Wrap-Up  (~5 min)

<!-- Share-out: each student shows their world and names one draw-order decision they made -->

## Teacher Notes

<!-- Block x,y is the TOP-LEFT corner, not the center — common confusion after working with Blob -->
<!-- The color() function supports a fourth argument for transparency (alpha): color(r, g, b, alpha) -->
<!-- where alpha 0 = invisible and 255 = fully opaque. Semi-transparent decorations look nice. -->
<!-- Students who want more complex shapes should be encouraged to write a new extends Blob class -->
<!-- rather than piling up raw shapes in the main tab -->
<!-- This lesson can expand to two periods if students are deeply engaged in world-building -->
