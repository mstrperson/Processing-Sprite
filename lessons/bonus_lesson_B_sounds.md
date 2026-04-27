# Bonus Lesson B — Sounds

> **When to use this lesson:** Drop in any time after Lesson 4. It pairs well with
> Bonus Lesson A (Images) as a two-part "make it real" session, or works on its own.
> Teach it any time students ask "can we add sound?" — which they will.

## Learning Goals
- Install the Processing Sound library
- Load a sound file from the `data/` folder using `SoundFile`
- Play a one-shot sound effect when a game event happens (collision, score, game over)
- Loop background music throughout the sketch

## New Vocabulary
- **library** — review: extra tools we add to Processing
- **`SoundFile`** — a variable that holds a loaded sound; you call `.play()` or `.loop()` on it
- **`.play()`** — plays the sound once from the beginning
- **`.loop()`** — plays the sound continuously, restarting when it reaches the end
- **`.stop()`** — stops the sound

## Warm-Up  (~5 min)

<!-- Prompt: "What sounds do your favorite games use? Background music? -->
<!-- Sound effects? What does each one tell you?" -->

## Direct Instruction  (~10 min)

<!--
Key things to demonstrate:

1. Installing the Sound library (do this BEFORE class if possible):
   - Processing → Sketch → Import Library → Add Library
   - Search "Sound" → select "Sound" by The Processing Foundation → Install
   - Restart Processing after installing

2. Adding sound files:
   - Same data/ folder as images: Sketch → Show Sketch Folder → drag into data/
   - Supported formats: MP3, WAV, OGG, AIFF (MP3 and WAV work most reliably)
   - Royalty-free sources: freesound.org, opengameart.org, zapsplat.com

3. Loading and playing:
   - Declare at top: SoundFile collectSound;
   - In setup(): collectSound = new SoundFile(this, "collect.wav");
   - On event: collectSound.play();    // one-shot
   - Background music: bgMusic.loop(); // in setup(), runs forever

4. Where to trigger sounds:
   - On collision: call sound.play() inside the if (player.collidesWith(...)) block
   - On game over: call sound.play() where gameOver is set to true
   - Background music: call bgMusic.loop() once in setup() — it runs automatically

5. A note on .play() vs. .loop():
   - .play() starts the sound once; calling it again while it's playing restarts it
   - .loop() keeps the sound going forever until you call .stop()
   - For collision effects, .play() is perfect
   - For music, .loop() is what you want
-->

## Guided Activity  (~20 min)

<!-- Step-by-step instructions go here -->
<!--
Suggested flow:
1. Everyone installs the Sound library (or verify it's already installed)
2. Each student finds two sound files:
   - A short sound effect (a "ding", "pop", "coin", or "beep") — WAV recommended
   - An optional background music loop (30-second MP3/WAV loop)
3. Drop files into the data/ folder
4. Add sound declarations, load in setup(), trigger on events
5. Students connect the collect sound to a collision in their existing sketch
-->

## Starter Code

```java
// Bonus Lesson B — Sounds
// Requires: Sketch → Import Library → Add Library → "Sound" (The Processing Foundation)
// Sound files go in your sketch's data/ folder (same place as images).
// Replace "collect.wav", "gameover.wav", and "music.mp3" with your own file names.

import coxprogramming.processing.sprites.*;
import processing.sound.*;

MyCharacter player;
ArrayList<Blob> coins;
int score = 0;
boolean gameOver = false;

SoundFile collectSound;   // plays when a coin is collected
SoundFile gameOverSound;  // plays when the game ends
SoundFile bgMusic;        // loops continuously in the background

void setup() {
  size(800, 600);

  // Load sounds from the data/ folder
  collectSound  = new SoundFile(this, "collect.wav");
  gameOverSound = new SoundFile(this, "gameover.wav");
  bgMusic       = new SoundFile(this, "music.mp3");

  bgMusic.loop();  // start background music immediately

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
  for (int i = coins.size() - 1; i >= 0; i--) {
    Blob c = coins.get(i);
    c.move();
    c.drawSprite();

    if (player.collidesWith(c)) {
      coins.remove(i);
      score = score + 1;
      collectSound.play();  // ← sound on collection
    }
  }

  player.followMouse();
  player.drawSprite();

  if (coins.size() == 0) {
    gameOver = true;
    bgMusic.stop();          // ← stop music
    gameOverSound.play();    // ← sound on game over
  }

  fill(50);
  textSize(24);
  text("Score: " + score, 20, 36);
}

void showGameOver() {
  textAlign(CENTER, CENTER);
  fill(80, 180, 80);
  textSize(52);
  text("You Win!", width/2, height/2 - 20);
  textSize(22);
  fill(50);
  text("Score: " + score, width/2, height/2 + 26);
  textAlign(LEFT, TOP);
}
```

## Make It Yours  (~10 min)

- Connect a sound to a hazard collision (a "hurt" or "crash" sound)
- Add a sound when the player clicks or presses a key
- Change the volume of the background music: `bgMusic.amp(0.3);` (0.0 = silent, 1.0 = full)
- Add a sound that plays when the player reaches a score milestone

## Wrap-Up  (~5 min)

<!-- Pair share: "Where in your game sketch did you add the sound call? -->
<!-- Why did you put it there and not somewhere else?" -->

## Teacher Notes

<!-- Install the Sound library before class to avoid losing 10 minutes to setup -->
<!-- freesound.org has thousands of free sound effects (account required to download) -->
<!-- WAV files are the most reliable format — MP3 works but occasionally has issues on some systems -->
<!-- .play() restarts the sound from the beginning each time — rapid collisions can cause rapid -->
<!-- restarts. For a "softer" effect, guard it: if (!collectSound.isPlaying()) collectSound.play(); -->
<!-- bgMusic.amp(0.3) lowers the music volume so it doesn't overpower effects — worth showing -->
<!-- The Sound library must be imported with: import processing.sound.*; -->
<!-- If students get a null pointer error on a SoundFile, the file isn't found — check data/ folder -->
