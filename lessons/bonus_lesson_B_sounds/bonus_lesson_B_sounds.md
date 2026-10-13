# Bonus Lesson B — Sounds

> **When to use this lesson:** Drop in any time after Lesson 6. It pairs well with
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
// Bonus Lesson B - Sounds
// Requires: Sketch -> Import Library -> Add Library -> "Sound" (The Processing Foundation)
// Sound files go in your sketch's data/ folder (same place as images).
// Replace "collect.wav", "gameover.wav", and "music.mp3" with your own file names.

import coxprogramming.processing.sprites.*;
import processing.sound.*;

MyCharacter player;
Blob coin;
Blob hazard;
int score = 0;
boolean gameOver = false;

SoundFile collectSound;
SoundFile gameOverSound;
SoundFile bgMusic;

void setup() {
  size(800, 600);

  collectSound  = new SoundFile(this, "collect.wav");
  gameOverSound = new SoundFile(this, "gameover.wav");
  bgMusic       = new SoundFile(this, "music.mp3");

  bgMusic.amp(0.4);   // lower music volume so effects can be heard clearly
  bgMusic.loop();     // start background music - runs until stopped

  player = new MyCharacter(this, width/2, height/2);
  player.setVelocity(4, 0);

  coin = new Blob(this, random(width), random(height),
                  14, random(1, 2.5), random(-1.5, 1.5),
                  color(255, 220, 50));
  hazard = new Blob(this, 80, 80, 22, 3, 2, color(220, 60, 60));
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
  coin.move();
  coin.drawSprite();
  hazard.move();
  hazard.drawSprite();

  player.followMouse();
  player.drawSprite();

  if (player.collidesWith(coin)) {
    score = score + 1;
    coin.moveTo(random(width), random(height));
    collectSound.play();   // one-shot sound effect on collection
  }

  if (player.collidesWith(hazard)) {
    gameOver = true;
    bgMusic.stop();        // stop the music
    gameOverSound.play();  // play the end sound
  }

  fill(50);
  textSize(24);
  text("Score: " + score, 20, 36);
}

void showGameOver() {
  textAlign(CENTER, CENTER);
  fill(220, 60, 60);
  textSize(52);
  text("Game Over", width/2, height/2 - 20);
  textSize(22);
  fill(50);
  text("Score: " + score, width/2, height/2 + 26);
  textAlign(LEFT, BASELINE);
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

---

## Rubric — Bonus: Sounds

*Use this rubric to see where you are and choose what to try next.  You can always revise and run it again.*

**✅ Check yourself first — I can…**
- [ ] Install and import the Sound library.
- [ ] Load a `SoundFile` in `setup()`.
- [ ] Play a one-shot effect on an event with `.play()`.
- [ ] Loop music with `.loop()` and stop it with `.stop()`.

**Where am I?**  *Standard: install the Sound library, load a `SoundFile` from `data/`, play one-shot effects on game events, and loop background music.*

| Level | What it looks like |
|---|---|
| **Getting Started** | No sound plays, or I get a null-pointer error on a `SoundFile`. **Next step:** install the Sound library (Sketch → Import Library → Add Library → "Sound"), and check the file is in `data/` with an *exact* name — a null pointer means the file wasn't found. |
| **Got It Working** | A sound effect plays on a game event (like collecting), triggered from the right spot in the code. |
| **Made It Mine** ⭐ | …and I chose sounds that fit my game and wired them to my events — a collect sound, a hazard/crash sound, or looping background music. |
| **Went Beyond** | …and I layered audio thoughtfully — music looping under one-shot effects with balanced volume (`amp`), milestone sounds, or guarded playback so rapid hits don't stutter. |

⭐ **Made It Mine** is the goal for everyone this lesson.

*"Went Beyond" means taking the project further in a direction you choose.  The examples are starting points.*

**✍️ Show your thinking (1–2 sentences):** Where in your code did you put your sound call, and why there and not somewhere else?
