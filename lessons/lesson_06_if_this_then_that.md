# Lesson 6 — If This, Then That

## Learning Goals
- Use an `if` statement to make the program choose what to do
- Declare and change variables that track information over time (`int score`)
- Display text and numbers on screen with `text()`
- Understand that a program can be in different *states* (playing, game over)

## New Vocabulary
- **`if` statement** — "if this condition is true, do this block of code"
- **`boolean`** — a value that is only ever `true` or `false`
- **variable** — a named container for a value; `int score = 0;` names a box called score that starts at zero
- **`int`** — a variable that holds a whole number
- **`text()`** — a Processing function that draws words or numbers on screen

## Warm-Up  (~5 min)

<!-- Review: "How did you add 12 coins to the world? Which loop did you use?" -->

## Direct Instruction  (~10 min)

<!--
Key things to demonstrate:

Variables declared at the top (global scope):
  int score = 0;
  boolean gameOver = false;
  "These live outside setup() and draw() so all functions can see them"

if statement:
  if (score > 10) {
    background(255, 0, 0);  // turns screen red when score is high
  }
  "The condition in the parentheses is either true or false.
   The code inside the braces runs only when it's true."

Displaying text:
  fill(0);
  textSize(24);
  text("Score: " + score, 20, 36);
  "The + here glues text and a number together into one string"

Boolean state variable:
  if (!gameOver) { ... play ... }  else { ... show game over screen ... }
  "! means NOT — so 'if not gameOver' means 'if the game is still going'"
-->

## Guided Activity  (~20 min)

<!-- Step-by-step instructions go here -->
<!-- Build up from: variable declared → changed in draw → displayed on screen → if used to branch -->

## Starter Code

**Main sketch tab:**
```java
// Lesson 6 — If This, Then That
import coxprogramming.processing.sprites.*;

MyCharacter player;
ArrayList<Blob> coins;
int score = 0;
boolean gameOver = false;

void setup() {
  size(800, 600);
  player = new MyCharacter(this, width/2, height/2);
  player.setVelocity(4, 0);

  coins = new ArrayList<Blob>();
  for (int i = 0; i < 10; i++) {
    coins.add(new Blob(
      this, random(width), random(height),
      random(8, 18), random(-2, 2), random(-2, 2),
      color(255, 220, 50)
    ));
  }
}

void draw() {
  background(240);

  if (!gameOver) {
    playGame();
  } else {
    showGameOver();
  }
}

void playGame() {
  for (Blob c : coins) {
    c.move();
    c.drawSprite();
  }

  player.followMouse();
  player.drawSprite();

  // When score reaches 10, trigger game over
  if (score >= 10) {
    gameOver = true;
  }

  // Display the score
  fill(50);
  textSize(24);
  text("Score: " + score, 20, 36);
}

void showGameOver() {
  fill(80, 180, 80);
  textAlign(CENTER, CENTER);
  textSize(52);
  text("You Win!", width/2, height/2 - 20);
  textSize(22);
  text("Final score: " + score, width/2, height/2 + 26);
  textAlign(LEFT, TOP);  // reset alignment so score display still works
}
```

## Make It Yours  (~10 min)

- Change what triggers game over (a time limit? score > 20?)
- Change what the game over screen looks like (different text, colors, message)
- Add a second variable — maybe a `lives` counter that counts down from 3
- Make the background color change as the score goes up

## Wrap-Up  (~5 min)

<!-- Exit question: "What is the difference between int and boolean? Give an example of each." -->

## Teacher Notes

<!-- score++ is a shorthand for score = score + 1 — fine to introduce if students ask, -->
<!-- but keep score = score + 1 in the starter so the operation is explicit -->
<!-- textAlign(CENTER, CENTER) affects ALL subsequent text() calls — if students use it in -->
<!-- showGameOver(), remind them to reset with textAlign(LEFT, TOP) afterward -->
<!-- Global variables: students sometimes try to declare them inside setup() or draw() — -->
<!-- if they do, the variable disappears when that function ends (scope issue) -->
<!-- Note: coins are drawn but not yet collected — that happens in Lesson 7 -->
