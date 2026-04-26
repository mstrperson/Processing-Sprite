# SpriteGame

**A Processing library for teaching Object-Oriented Programming through game development.**

SpriteGame gives beginner programmers a concrete, visual context for learning the core ideas of OOP — classes, objects, inheritance, encapsulation, and polymorphism — by building sprite-based games in [Processing](https://processing.org).  It is designed around an **Objects First** curriculum philosophy: students encounter and use objects from their very first lesson, and extend the library's own classes to create their own sprites long before they understand every detail of how the machinery works.

---

## Table of Contents

- [Philosophy](#philosophy)
- [Requirements](#requirements)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Class Reference](#class-reference)
- [Writing Your Own Sprite](#writing-your-own-sprite)
- [Included Examples](#included-examples)
- [Building from Source](#building-from-source)
- [Credits](#credits)

---

## Philosophy

### Objects First

The traditional approach to teaching programming starts with variables, then control flow, then functions, and finally — weeks or months later — objects.  By the time students reach OOP the syntax feels abstract and the motivation is unclear.

**Objects First** inverts this.  Students write code that creates and talks to objects on day one.  They observe the behavior before they understand the implementation.  Curiosity about *how* it works is the bridge to reading and writing class definitions themselves.

SpriteGame is designed to support this progression:

| Stage | What the student does | OOP concept encountered |
|---|---|---|
| **1 — Use** | Create `Blob` and `Block` objects, call `move()` and `drawSprite()` | Objects, method calls, constructors |
| **2 — Observe** | See that different objects share behavior but look different | Polymorphism in practice |
| **3 — Extend** | Write `class MySprite extends Sprite` in a `.pde` file | Inheritance, `super()`, overriding |
| **4 — Design** | Add new fields and methods to their subclass | Encapsulation, abstraction |
| **5 — Compose** | Build a `CompoundSprite` from multiple parts | Composition vs. inheritance |

The library intentionally keeps its own source code readable and well-documented so that students who are ready to look under the hood can do so without being overwhelmed.

---

## Requirements

- [Processing 4](https://processing.org/download) (4.0 or later)
- Java 17 (bundled with Processing 4 — no separate install needed)

---

## Installation

1. Download or clone this repository.
2. Copy the `Processing-Sprite` folder into your Processing libraries directory:
   - **Windows:** `Documents\Processing\libraries\`
   - **macOS:** `~/Documents/Processing/libraries/`
   - **Linux:** `~/sketchbook/libraries/`
3. Rename the folder to `SpriteGame` so Processing can find it.
4. Restart Processing.
5. Verify the install: **Sketch → Import Library → SpriteGame** should appear in the menu.

---

## Quick Start

Add the import at the top of your sketch, create some sprites, and call `move()` and `drawSprite()` inside `draw()`:

```java
import coxprogramming.processing.sprites.*;

ArrayList<Blob> blobs;

void setup() {
  fullScreen();
  blobs = new ArrayList<Blob>();

  for (int i = 0; i < 10; i++) {
    blobs.add(new Blob(this,
      random(width), random(height),  // position
      random(10, 30),                 // radius
      random(-5, 5), random(-5, 5),  // velocity
      color(random(255), random(255), random(255))
    ));
  }
}

void draw() {
  background(255);
  for (Blob blob : blobs) {
    blob.move();
    blob.drawSprite();
  }
}
```

Every sprite automatically wraps around the screen edges when `move()` is called — no boundary-checking code required.

---

## Class Reference

### Class Hierarchy

```
Sprite  (abstract)
├── Blob
│   └── Block
├── ImageSprite
└── CompoundSprite

Vector2D   — 2D vector math
Event      — event / listener system
```

---

### `Sprite` *(abstract)*

The base class for everything in the library.  A `Sprite` knows its position (`pos`) and velocity (`vel`) as [`Vector2D`](#vector2d) objects, knows how to move itself, and declares `drawSprite()` as abstract — meaning every concrete subclass **must** decide how it looks.

**Key methods**

| Method | Description |
|---|---|
| `move()` | Advances position by velocity; wraps at screen edges |
| `moveTo(x, y)` | Teleports to a new position |
| `setVelocity(dx, dy)` | Sets the velocity |
| `getPosition()` | Returns current position as `Vector2D` |
| `getVelocity()` | Returns current velocity as `Vector2D` |
| `followMouse()` | Moves toward the mouse at the current speed |
| `keyboardControl()` | Maps arrow keys to velocity; call from `keyPressed()` |
| `distanceTo(Sprite)` | Returns pixel distance to another sprite |
| `drawSprite()` | **Abstract** — subclasses must implement this |

Every constructor requires `this` as the first argument so the sprite can access the sketch's drawing functions and screen dimensions:

```java
Blob b = new Blob(this, 200, 300, 25, color(255, 0, 0));
```

---

### `Blob`

A circular sprite with a radius and a fill color.  The most common building block for quick prototypes.

```java
// Stationary blob
Blob dot = new Blob(this, 100, 200, 30, color(0, 120, 255));

// Moving blob
Blob ball = new Blob(this, 100, 200, 30, 3, -2, color(255, 80, 0));

// Collision detection
if (ball.collidesWith(dot)) {
  // circles are touching
}
```

---

### `Block`

A rectangular sprite.  Extends `Blob` so it has the same collision and movement methods, but `drawSprite()` draws a rectangle instead of a circle.  The position marks the **top-left corner** of the rectangle.

```java
Block wall = new Block(this, 0, 300, width, 20, color(80));
```

---

### `ImageSprite`

A sprite that displays a picture file instead of a drawn shape.  Place the image in your sketch's `data/` folder.  The image is automatically resized to 100 × 100 pixels and centred on the sprite's position.

```java
ImageSprite hero = new ImageSprite(this, 200, 300, "hero.png");
```

---

### `CompoundSprite`

A container that groups multiple sprites so they move together as one unit.  Children can still have their own independent velocity on top of the group velocity — useful for animated characters made of several parts.

```java
Blob body = new Blob(this, 200, 300, 40, color(30, 100, 200));
Blob head = new Blob(this, 200, 250, 20, color(255, 220, 180));

CompoundSprite player = new CompoundSprite(this, 200, 300)
    .addSprite(body)
    .addSprite(head);

// The whole character walks right
player.setVelocity(3, 0);

// In draw():
player.move();
player.drawSprite();
```

`addSprite()` and `removeSprite()` return `this` for builder-style chaining.

---

### `Vector2D`

A 2D vector class used internally by `Sprite` for position and velocity.  Also available directly for students who want to do their own vector math.

```java
Vector2D a = new Vector2D(3, 4);
Vector2D b = Vector2D.FromPolar(5, PI / 4); // from magnitude + angle

float speed   = a.mag();           // length of the vector
Vector2D dir  = a.unitVector();    // same direction, length = 1
Vector2D sum  = a.add(b);
Vector2D diff = a.subtract(b);
Vector2D rot  = a.rotate(PI / 6); // rotate 30 degrees
```

**Static factory methods**

| Method | Description |
|---|---|
| `Vector2D.FromXY(x, y)` | Creates a vector from rectangular coordinates |
| `Vector2D.FromPolar(r, theta)` | Creates a vector from magnitude and angle (radians) |

---

### `Event`

A reflection-based event and listener system for connecting game events to response functions without tight coupling.  Useful once students are comfortable with OOP and want to explore the Observer pattern.

```java
// Declare an event that passes no arguments
Event onCoinCollected = new Event();

// Attach a listener (the method must exist on the object)
onCoinCollected.bind(scoreBoard, "incrementScore");

// Fire the event when something happens
onCoinCollected.trigger();

// Detach when no longer needed
onCoinCollected.unbind(scoreBoard, "incrementScore");
```

---

## Writing Your Own Sprite

The most important feature of SpriteGame is that it is designed to be **extended**.  Students create their own sprite types by writing a class that `extends Sprite` directly in a `.pde` file alongside their sketch.

The only requirement is implementing `drawSprite()`.  Everything else — position, velocity, `move()`, `followMouse()`, `keyboardControl()` — is inherited automatically.

```java
// In MySketch/Asteroid.pde
class Asteroid extends Sprite {

  float radius;
  float rotationAngle;
  float rotationSpeed;

  Asteroid(PApplet p, float x, float y, float r) {
    super(p, x, y, random(-3, 3), random(-3, 3));
    radius        = r;
    rotationAngle = 0;
    rotationSpeed = random(-0.05, 0.05);
  }

  void drawSprite() {
    rotationAngle += rotationSpeed;

    parent.pushMatrix();
    parent.translate(pos.x, pos.y);
    parent.rotate(rotationAngle);
    parent.fill(160, 140, 120);
    parent.stroke(100);
    parent.beginShape();
    for (int i = 0; i < 8; i++) {
      float angle = parent.TWO_PI / 8 * i;
      float r     = radius * parent.random(0.8, 1.2);
      parent.vertex(parent.cos(angle) * r, parent.sin(angle) * r);
    }
    parent.endShape(CLOSE);
    parent.popMatrix();
  }
}
```

A few things to note when writing sprite subclasses in `.pde` files:

- Pass `this` as the first constructor argument so the sprite can reach the sketch's drawing functions through the `parent` field.
- Call all Processing drawing functions as `parent.fill(...)`, `parent.ellipse(...)`, etc., because inside a class that extends `Sprite` (not `PApplet`) they need the explicit reference.
- Processing constants like `CLOSE`, `TWO_PI`, and `CENTER` are available directly in `.pde` inner classes, or as `PApplet.TWO_PI` etc. if needed.

---

## Included Examples

Open any example via **File → Examples → Contributed Libraries → SpriteGame**.

### BasicDemo

Ten randomly colored `Blob` objects bounce around a full-screen window and wrap at the edges.  The simplest possible introduction to the library.

**Concepts:** `Blob`, `ArrayList`, `move()`, `drawSprite()`

---

### SceneExample

A sky-and-ground scene with a drifting sun, animated clouds, and placeholder trees.  `Cloud` and `Sun` are complete working sprites; `Tree` is a commented shell for students to fill in.

**Concepts:** Extending `Sprite`, `drawSprite()` implementation, draw-order layering, the `size` scaling pattern

The `Tree` class is intentionally left incomplete — drawing the tree is the student's assignment.

---

### CalculatorExample

A fully functional four-function calculator where each key is a `Button` sprite wired to a lambda via `onClicked()`.

**Concepts:** Strategy pattern, lambda expressions, `Action` functional interface, builder-style chaining, the Observer pattern

```java
// Each button is told what to do via a lambda.
// The button itself never knows what digitPressed() or opPressed() do.
new Button(this, x, y, 75, 75, "7", grey, white)
    .onClicked(() -> digitPressed("7"));

new Button(this, x, y, 75, 75, "+", orange, white)
    .onClicked(() -> opPressed("+"));
```

---

## Building from Source

The build script uses Processing's own bundled Java 17 compiler and requires no additional tools.

```bash
# From the repository root
bash build.sh
```

Output: `library/SpriteGame.jar`

The script compiles all sources in `src/coxprogramming/processing/sprites/` against Processing's `core.jar` and packages the result.  If you move or upgrade Processing, update the `CORE_JAR` and `JAVAC` paths at the top of `build.sh`.

---

## Credits

- Library design and implementation — **Jason Cox**, Winsor School
- `Event` class — originally by **Stephcraft**, adapted for this library
- Built for [Processing 4](https://processing.org)

---

*SpriteGame is free to use in educational settings.  If you use it in your classroom, the author would love to hear about it.*
