# Lesson 1 — Hello, Blob!

## Learning Goals
- Open Processing and run a sketch
- Understand that `setup()` runs once and `draw()` runs forever
- Create a `Blob` object from the SpriteGame library and display it
- Use color in RGB space to customize the blob's appearance

**developer note:** make sure that we talk about color, the RGB space, and let students know that the "Color Picker" exists in Processing (Tools → Color Selector).

## New Vocabulary
- **sketch** — a Processing program
- **`setup()`** — the function Processing calls once when the sketch starts
- **`draw()`** — the function Processing calls over and over, creating the animation
- **object** — a thing in our program that has its own data and knows how to do things
- **method** — something an object knows how to do, called with a dot: `myBlob.drawSprite()`
- **RGB** — the three numbers (Red, Green, Blue) that describe any color; each ranges from 0 to 255

## Warm-Up  (~5 min)

> Ask students: "Have you ever seen code before? What do you think it looks like?"

Brief discussion — no wrong answers. Goal: surface curiosity and prior knowledge.

## Direct Instruction  (~10 min)

<!-- Teacher notes go here -->
<!--
Key things to demonstrate:
- The Processing IDE: play button, stop button, the two code areas (setup + draw)
- Explain setup/draw with a metaphor: setup = setting up the art table once; draw = drawing a new frame of a flipbook every fraction of a second
- Show the import line — "this tells Processing we want to use the library's tools"
- Walk through the Blob constructor parameters: this, x, y, radius, color
  - "this" means "this sketch" — never change it
  - x and y are where the center of the blob is placed
  - radius is how big the circle is (half its width)
  - color() takes three numbers: how much red, how much green, how much blue
- Open Tools → Color Selector and show how to pick a color and read its RGB values
- Show: changing background(255) to background(0) — white vs. black
-->

## Guided Activity  (~20 min)

<!-- Step-by-step instructions go here -->

## Starter Code

**Main sketch tab:**
```java
// Lesson 1 — Hello, Blob!
import coxprogramming.processing.sprites.*;

Blob myBlob;

void setup() {
  size(800, 600);
  myBlob = new Blob(this, 400, 300, 40, color(255, 80, 80));
}

void draw() {
  background(255);       // white background erases the previous frame
  myBlob.drawSprite();   // draw the blob at its position
}
```

## Make It Yours  (~10 min)

- Change the blob's color using the Color Selector (Tools → Color Selector)
- Change its size (the radius — try 20, then try 80)
- Move it to a different spot on screen
- Change the background color
- Add a second blob with a different color and position

## Wrap-Up  (~5 min)

<!-- Exit question / pair-share prompt goes here -->
<!-- Suggestion: "What are the two magic functions, and when does each one run?" -->

## Teacher Notes

<!-- "this" in the constructor: tell students it means "this sketch" and they should never change it -->
<!-- Forgetting the import line is the most common mistake — sketch won't compile without it -->
<!-- The no-velocity constructor (Blob(this, x, y, radius, color)) is intentional here. -->
<!-- We are not talking about velocity yet — that comes in Lesson 3. -->
<!-- Students will ask "how do I make it move?" — tell them that's coming next time. -->
