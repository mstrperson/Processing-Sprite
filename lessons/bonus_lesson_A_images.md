# Bonus Lesson A — Images

> **When to use this lesson:** Drop in any time after Lesson 4. It works well between Lesson 4
> and 5, or between Lesson 7 and 8 when students are starting to think about making their
> world look polished. It can be taught in one period as a standalone enrichment lesson.

## Learning Goals
- Add image files to a Processing sketch using the `data/` folder
- Display an image as a sprite using `ImageSprite`
- Use a `PImage` inside a custom `extends Blob` character so collision detection still works
- Understand the difference between `ImageSprite` (decoration) and image-in-Blob (player)

## New Vocabulary
- **`data/` folder** — a special folder inside your sketch folder where Processing looks for images and sounds
- **`ImageSprite`** — a sprite from the library that displays an image file instead of a shape
- **`PImage`** — Processing's type for a loaded image; think of it as a variable that holds a picture
- **`loadImage("filename.png")`** — the command that reads an image file from the `data/` folder

## Warm-Up  (~5 min)

<!-- Prompt: "Have you ever seen a game where the characters are pictures instead of shapes?
  What games? Do you think it would be hard to make that happen?" -->

## Direct Instruction  (~10 min)

<!--
Key things to demonstrate:

1. The data/ folder:
   - In Processing: Sketch → Show Sketch Folder → create a folder named "data"
   - Drag an image file (PNG or JPG) into that folder
   - Processing will find it automatically when the sketch runs
   - Supported formats: PNG, JPG, GIF (PNG recommended — supports transparency)

2. ImageSprite for decorations:
   - new ImageSprite(this, x, y, "filename.png")          → 100×100 pixels
   - new ImageSprite(this, x, y, "filename.png", 80)      → 80×80 square
   - new ImageSprite(this, x, y, "filename.png", 120, 80) → 120 wide, 80 tall
   - Has all the same methods: move(), setVelocity(), followMouse(), drawSprite()
   - Does NOT have collidesWith() — use it for scenery, not for things that need to collide

3. Image inside an extends Blob character:
   - Store a PImage field: PImage img;
   - Load it in the constructor: img = p.loadImage("hero.png");
   - In drawSprite(): use pushStyle() / imageMode(CENTER) / image() / popStyle()
   - The Blob's radius is still the invisible collision circle
   - This is the right approach when the character needs both a picture AND collisions

4. Transparency:
   - PNG files can have transparent backgrounds (the file needs to be saved that way)
   - Great for character sprites where you want the background to show through
-->

## Guided Activity  (~20 min)

<!-- Step-by-step instructions go here -->
<!--
Suggested flow:
1. Each student finds or draws a small PNG image (a character, object, or decoration)
   - Option: use a free pixel-art sprite from opengameart.org or similar
   - Option: have students draw 32×32 pixel characters in a paint program first
2. Place the image in the sketch's data/ folder
3. Add an ImageSprite decoration first (simpler pattern)
4. Then show how to put the image inside MyCharacter extends Blob (so collision still works)
-->

## Starter Code

**Main sketch tab:**
```java
// Bonus Lesson A — Images
// You need image files in your sketch's data/ folder.
// Sketch → Show Sketch Folder, then drag PNG/JPG files into the data/ folder.

import coxprogramming.processing.sprites.*;

MyImageCharacter player;
ArrayList<ImageSprite> decorations;

void setup() {
  size(800, 600);

  // Player: your character using an image file (see MyImageCharacter tab)
  // Replace "hero.png" with your own file name.
  player = new MyImageCharacter(this, width/2, height/2, "hero.png");
  player.setVelocity(4, 0);

  // Decorations: ImageSprites placed around the scene
  // Replace "tree.png" with your own file name.
  decorations = new ArrayList<ImageSprite>();
  decorations.add(new ImageSprite(this, 150, 420, "tree.png", 60, 100));
  decorations.add(new ImageSprite(this, 400, 430, "tree.png", 60, 100));
  decorations.add(new ImageSprite(this, 650, 415, "tree.png", 60, 100));
}

void draw() {
  background(135, 206, 235);

  // Decorations drawn first (behind player)
  for (ImageSprite d : decorations) {
    d.drawSprite();
  }

  // Player drawn last (in front)
  player.followMouse();
  player.drawSprite();
}
```

**New tab — MyImageCharacter.pde:**
```java
// MyImageCharacter — like MyCharacter, but draws a picture instead of shapes.
// extends Blob means it still has collidesWith() for collision detection.
class MyImageCharacter extends Blob {

  PImage img;

  MyImageCharacter(PApplet p, float x, float y, String fileName) {
    super(p, x, y, 30, color(0));  // radius 30 — the invisible collision circle
    img = p.loadImage(fileName);
  }

  void drawSprite() {
    parent.pushStyle();
    parent.imageMode(CENTER);
    parent.image(img, pos.x, pos.y, 60, 60);  // drawn centered on the sprite's position
    parent.popStyle();
  }
}
```

## Make It Yours  (~10 min)

- Find or draw your own character image (PNG with a transparent background looks best)
- Try a background image: `ImageSprite bg = new ImageSprite(this, width/2, height/2, "background.png", width, height);`
  drawn first in setup, before everything else
- Adjust the display size (the 60, 60 in `image()`) to match your art's proportions
- Give an `ImageSprite` decoration a velocity so it drifts across the scene

## Wrap-Up  (~5 min)

<!-- Exit question: "Why can't we use collidesWith() on an ImageSprite? -->
<!-- What do we do instead if we want an image character with collision detection?" -->

## Teacher Notes

<!-- data/ folder is the #1 setup hurdle — walk through Sketch → Show Sketch Folder together -->
<!-- PNG transparency: a PNG saved without transparency will draw a white or colored rectangle -->
<!-- behind the image. This surprises students. Free tool: remove.bg can strip backgrounds. -->
<!-- The radius in super() is the hitbox — it doesn't need to perfectly match the image size. -->
<!-- A radius that is slightly smaller than the visible image feels fairer in a game. -->
<!-- ImageSprite also has setRotation(angle) and rotate(amount) in radians — great for -->
<!-- spinning decoration effects. Mention if students ask. -->
<!-- Fast finishers: can they animate the character by swapping between two image files? -->
<!-- (Two PImage fields, toggled on a frame counter — a preview of AnimatedSprite ideas) -->
