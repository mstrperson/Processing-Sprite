# Guiding Principles — Processing Sprite Lessons (6th Grade)

## Who These Lessons Are For

Students in approximately 6th grade (ages 11–12) with little or no prior programming experience.
They are using **Processing** on macOS with the **SpriteGame library** installed.

---

## Core Pedagogical Principles

### 1. Objects First
The very first thing students create is a `Blob` — a live object on screen. Raw shapes,
variables, and loops come later, always in service of making that object (and the student's
own character) do something more interesting. The object is the anchor; everything else
is a tool students reach for when they need it.

### 2. The Character Thread
Starting in Lesson 2, students draw a custom character in a separate tab. Every lesson
from that point forward builds that character: giving it motion, player control, a world
to live in, and finally a game to play. By Lesson 9 the game *is* their character.
Students are more motivated to understand velocity when it is their own creature moving.

### 3. Visual feedback first
Every lesson produces something visible within the first five minutes. Delay abstract
concepts until students have something working that they care about.

### 4. Imitate before you invent
Each lesson provides a complete, working example that students first *run*, then *modify*,
then *personalize*. Creativity happens by changing values — colors, speeds, positions —
not by understanding how the machinery works.

### 5. Use the library as a magic toolbox
The Sprite library contains concepts (inheritance, abstract classes, reflection) that are
years beyond 6th grade. Do not explain them in depth. Frame library objects as "things that
know how to do stuff." Students call methods the way they push buttons on a machine:
`blob.move()`, `blob.drawSprite()`, `player.setVelocity(3, -2)`. The button works; that is enough.

### 6. Gentle framing of `extends`
When students write their own character class (Lesson 2 onward), they use
`class MyCharacter extends Blob`. Explain this in one sentence: *"extends means your
character is built on top of Blob — it already knows how to move and detect collisions;
you just add what it looks like."* Do not use the word "inheritance." Never explain
what `abstract` means. Never explain what `super()` means beyond "that line is the
handshake that connects your character to the library — copy it exactly."

### 7. One new idea per lesson
Introduce at most one genuinely new concept per lesson. Every other element should be
review or a small, safe extension of something already seen.

### 8. Processing's two magic functions
`setup()` and `draw()` are the skeleton every sketch lives in. Establish this mental model
in Lesson 1 and reinforce it every single lesson. Students should be able to predict without
thinking: "one-time setup goes in `setup()`, things that repeat go in `draw()`."

### 9. Vocabulary is a tool, not a test
Introduce words like *variable*, *object*, *method*, *list* when they are useful for
describing something the student can already see on screen. Never define vocabulary in
the abstract before the concrete experience.

### 10. Every lesson ends with a "Make It Yours" section
Students modify at least one creative parameter of their own choosing before the lesson
ends. This transforms exercises into mini-projects and builds ownership.

---

## What This Library Provides (Teacher Reference)

| Class | What students use it for |
|---|---|
| `Blob` | Circle sprite — position, velocity, color, radius, collision detection |
| `Block` | Rectangle sprite |
| `ImageSprite` | Sprite that displays a picture file |
| `AnimatedSprite` | Sprite that cycles through animation frames |
| `.drawSprite()` | Draw the sprite on screen |
| `.move()` | Move by velocity each frame; wraps at screen edges by default |
| `.setVelocity(vx, vy)` | Set horizontal and vertical speed |
| `.followMouse()` | Move toward the mouse cursor each frame (requires velocity > 0) |
| `.keyboardControl()` | Set velocity with arrow keys; call in `keyPressed()` |
| `.collidesWith(blob)` | Returns true when this Blob overlaps another Blob |
| `ArrayList<T>` | A growable list of objects |

**Important:** `collidesWith()` is on `Blob`, not on the base `Sprite`. Students' custom
characters should use `class MyCharacter extends Blob` (not `extends Sprite`) so that
collision detection works automatically against other Blobs in the world.

---

## Lesson Arc at a Glance

| # | Title | New Concept | Character Thread |
|---|---|---|---|
| 1 | Hello, Blob! | `setup()` / `draw()`, objects, RGB color | See a Blob on screen |
| 2 | Draw Your Character | `extends Blob`, separate tab, `drawSprite()` with shapes | Character exists |
| 3 | Bring It to Life | `setVelocity()`, `.move()`, screen wrapping | Character moves |
| 4 | You're in Control | `.followMouse()`, `.keyboardControl()`, event functions | Character is the player |
| 5 | A World of Objects | `ArrayList`, `for` loop, `random()`, custom world sprites | Character has a world |
| 6 | If This, Then That | `if` statements, variables that change, `text()` | Character reacts |
| 7 | Collisions! | `.collidesWith()`, score, removing sprites | Character interacts |
| 8 | Build Your Game World | Draw order, `Block` for terrain, layering, scene design | World takes shape |
| 9 | Build Your Game | Capstone — combine everything into a playable mini-game | The full game |

---

## Lesson Template

Each lesson file follows this structure:

```
## Lesson N — Title

### Learning Goals
(2–4 bullet points: what students will be able to do after this lesson)

### New Vocabulary
(words introduced for the first time, with brief plain-English definitions)

### Warm-Up  (~5 min)
(A quick question or review that activates prior knowledge)

### Direct Instruction  (~10 min)
(Teacher-facing notes: what to demonstrate, what to say, what to draw on the board)

### Guided Activity  (~20 min)
(Step-by-step instructions students follow together with the teacher)

### Starter Code
(Complete, runnable Processing sketch students start from — or build toward)

### Make It Yours  (~10 min)
(Open-ended modifications students make on their own)

### Wrap-Up  (~5 min)
(Exit question or pair-share prompt)

### Teacher Notes
(Anticipated confusions, common mistakes, extension challenges for fast finishers)
```
