# Lesson 2 — Draw Your Character

## Learning Goals
- Create a custom sprite class in a separate tab using `extends Blob`
- Override `drawSprite()` to draw a character with Processing shapes
- Use `pos.x` and `pos.y` to anchor all shapes to the character's position
- Understand that `extends` means "build on top of something that already exists"

## New Vocabulary
- **class** — a blueprint for making a new kind of object
- **`extends`** — means "my character is built on top of Blob; everything Blob can do, my character can do too"
- **`drawSprite()`** — the method your character fills in to say what it looks like
- **`pos.x` / `pos.y`** — the character's current position; use these to place all shapes relative to the character's center

## Warm-Up  (~5 min)

<!-- Review question from Lesson 1: "What are the two magic functions? What does a Blob need to be created?" -->

## Direct Instruction  (~10 min)

<!--
Key things to demonstrate:
- Creating a new tab in Processing: the arrow at the top-right of the tab bar → "New Tab"
  Name it "MyCharacter" (no .pde extension — Processing adds it)
- Show the shell of the class:
    class MyCharacter extends Blob { ... }
- Explain extends in one sentence: "Your character is built on top of Blob.
  It already knows how to move, wrap around the screen, and detect collisions.
  All you add is what it looks like."
- Walk through the constructor: super(p, x, y, radius, color)
  "super is the handshake line — copy it exactly, just fill in a radius that feels right for
  your character's size. The color here is a backup; you'll draw over it anyway."
- Show pos.x and pos.y: "Think of these as your character's belly-button.
  Every shape you draw is measured from there."
- Demonstrate drawing a simple face: body circle at pos.x, pos.y; eyes offset from there
- Show how changing pos.x offsets to see the offset effect as you move the blob manually
-->

## Guided Activity  (~20 min)

<!-- Step-by-step instructions go here -->
<!--
1. Students create a new tab called "MyCharacter"
2. They copy the shell and fill in a simple character together (teacher leads)
3. Then they branch off and personalize
-->

## Starter Code

**New tab — MyCharacter.pde:**
```java
/** 
 * MyCharacter — this is YOUR character. Change everything!
 */
class MyCharacter extends Blob {

  /** 
   * The constructor: called once when you create the character.
   * "super" connects your character to the Blob it's built on.
   * The radius (30) is the invisible collision circle — make it match your character's size.
   */
  MyCharacter(PApplet p, float x, float y) {
    super(p, x, y, 30, color(100, 180, 255));
  }

  /** 
   * drawSprite: called every frame to draw your character on screen.
   * Use pos.x and pos.y as the center — all other shapes are measured from there.
   */
  void drawSprite() {
    // Body
    fill(100, 180, 255);
    noStroke();
    ellipse(pos.x, pos.y, 60, 60);

    // Eyes
    fill(255);
    ellipse(pos.x - 12, pos.y - 8, 16, 16);
    ellipse(pos.x + 12, pos.y - 8, 16, 16);
    fill(30);
    ellipse(pos.x - 12, pos.y - 8, 8, 8);
    ellipse(pos.x + 12, pos.y - 8, 8, 8);

    // Smile
    stroke(30);
    strokeWeight(2);
    noFill();
    arc(pos.x, pos.y + 5, 24, 18, 0, PI);
  }
}
```

**Main sketch tab:**
```java
// Lesson 2 — Draw Your Character
import coxprogramming.processing.sprites.*;

MyCharacter player;

void setup() {
  size(800, 600);
  player = new MyCharacter(this, width/2, height/2);
}

void draw() {
  background(240);
  player.drawSprite();
}
```

## Make It Yours  (~10 min)

This lesson IS the make-it-yours. Students should spend most of the time personalizing:
- Change the body shape (rect, triangle, or multiple overlapping ellipses)
- Add hair, a hat, wings, antennae, a tail, ears, a beak — anything
- Change all colors using the Color Selector
- Add more features: eyebrows, freckles, a mouth with teeth, a nose
- Change the radius in `super(...)` if the character grows much larger or smaller

## Wrap-Up  (~5 min)

<!-- Pair-share: each student shows a neighbor their character and describes one shape they drew -->

## Teacher Notes

<!-- The super() line: students should not try to understand it in depth. -->
<!-- If a student asks "what does super mean?", say: "It's the handshake that connects your -->
<!-- character to the Blob library — copy it exactly and change the radius to match your art." -->
<!-- Students will want to make elaborate characters — great! But remind them they can keep -->
<!-- adding detail in every future lesson; today's goal is just to get SOMETHING on screen. -->
<!-- Fast finishers: can they make a second character class in another new tab? (a sidekick?) -->
<!-- The radius in super() is the invisible collision circle used later — remind students to -->
<!-- keep it roughly the same size as their character's body. -->
