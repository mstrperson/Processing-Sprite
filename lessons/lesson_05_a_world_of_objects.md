# Lesson 5 — A World of Objects

## Learning Goals
- Store many objects in an `ArrayList` and loop over them with `for`
- Understand the difference between a *counting* `for` loop and a *for-each* `for` loop
- Use `random()` to populate a world with variety
- Optionally: create a second custom sprite class (e.g., a `Cloud`) in a new tab

## New Vocabulary
- **`ArrayList`** — a list that can hold many objects of the same type; it grows as you add more
- **`for` loop** — two flavors: one for *counting* (create 10 things), one for *visiting each item* (move/draw all things)
- **`random(a, b)`** — review: picks a random float between `a` and `b`

## Warm-Up  (~5 min)

<!-- Review: "How do you make your character move toward the mouse? Where does that call go?" -->

## Direct Instruction  (~10 min)

<!--
Key things to demonstrate:

ArrayList:
  - "A list is like a bag — you can keep stuffing things in"
  - Declare: ArrayList<Blob> coins;
  - Create: coins = new ArrayList<Blob>();
  - Add: coins.add(new Blob(...));

Two for loops — make this distinction explicit:
  - Counting loop (used in setup to CREATE things):
      for (int i = 0; i < 10; i++) { coins.add(new Blob(...)); }
      "i counts from 0 to 9 — we use it to repeat the add 10 times"
  - For-each loop (used in draw to VISIT each thing):
      for (Blob c : coins) { c.move(); c.drawSprite(); }
      "for each coin c in the list, move it and draw it"
  Both use the word 'for', but they feel different — one counts, one visits.
  Students often try to mix them up.

Custom sprite tab (optional, for motivated students):
  - Show a simple Cloud class (see SceneExample/Cloud.pde in the examples folder)
  - "It's just like MyCharacter but draws cloud shapes instead"
  - Students who want a richer world can write their own environment sprites
-->

## Starter Code

**Main sketch tab:**
```java
// Lesson 5 — A World of Objects
import coxprogramming.processing.sprites.*;

MyCharacter player;
ArrayList<Blob> coins;

void setup() {
  size(800, 600);

  player = new MyCharacter(this, width/2, height/2);
  player.setVelocity(4, 0);

  coins = new ArrayList<Blob>();

  // Counting loop: add 12 coins at random positions
  for (int i = 0; i < 12; i++) {
    coins.add(new Blob(
      this,
      random(width),             // random x
      random(height),            // random y
      random(8, 20),             // random radius
      random(-2, 2),             // random horizontal speed
      random(-2, 2),             // random vertical speed
      color(255, 220, 50)        // gold
    ));
  }
}

void draw() {
  background(240);

  // For-each loop: visit every coin — move it and draw it
  for (Blob c : coins) {
    c.move();
    c.drawSprite();
  }

  player.followMouse();
  player.drawSprite();  // draw player last so it appears on top
}
```

**Optional new tab — Cloud.pde:**
```java
// A simple cloud sprite — draws itself as a cluster of white circles.
// Feel free to redesign this completely!
class Cloud extends Blob {

  Cloud(PApplet p, float x, float y, float speed) {
    super(p, x, y, 40, color(255));  // radius 40, white
    setVelocity(speed, 0);           // drift horizontally
  }

  void drawSprite() {
    noStroke();
    fill(250, 250, 255);
    ellipse(pos.x,      pos.y,      70, 45);
    ellipse(pos.x - 30, pos.y + 12, 50, 32);
    ellipse(pos.x + 32, pos.y + 12, 55, 32);
    fill(235, 238, 248);
    ellipse(pos.x - 12, pos.y - 16, 52, 38);
    ellipse(pos.x + 16, pos.y - 10, 44, 32);
  }
}
```

## Make It Yours  (~10 min)

- Change the number of coins, their speed, their size
- Add a second ArrayList of a different color/type of blob (enemies? stars? bubbles?)
- If you wrote a Cloud class, add an ArrayList of clouds drifting across the scene
- Add a `mousePressed()` function that spawns a new coin wherever you click

## Wrap-Up  (~5 min)

<!-- Exit question: "What is the difference between the counting for loop and the for-each loop?  -->
<!-- When would you use each one?" -->

## Teacher Notes

<!-- **developer note:** make sure to note the difference between the "for" loop and the -->
<!-- "for-each" loop. Even though they use the same keyword in Java, and both are count-controlled -->
<!-- in a broad sense, they feel different — one counts, one visits. Students mix them up often. -->

<!-- coins.drawSprite() is the most common mistake — you can't call a method on the whole list, -->
<!-- only on individual items inside it -->
<!-- Draw order matters: draw coins BEFORE the player so the player appears on top -->
<!-- Cloud class uses extends Blob (not extends Sprite) so it gets collidesWith() later — -->
<!-- if students want clouds to be interactive obstacles in Lesson 7, this matters -->
