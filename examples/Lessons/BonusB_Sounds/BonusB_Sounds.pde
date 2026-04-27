/**
 * Bonus Lesson B — Sounds
 *
 * Requires the Processing Sound library:
 *   Sketch → Import Library → Add Library → search "Sound" → Install
 *   (Restart Processing after installing)
 *
 * ── SETUP ────────────────────────────────────────────────────────────────
 * Add your sound files to the data/ folder inside this sketch's folder.
 * Processing → Sketch → Show Sketch Folder, then drag sound files
 * (MP3 or WAV) into the data/ folder that is already there.
 *
 * Replace "collect.wav", "gameover.wav", and "music.mp3" below with
 * your actual file names.
 * ─────────────────────────────────────────────────────────────────────────
 *
 * Three sounds are used here:
 *   collectSound  — plays once each time a coin is collected
 *   gameOverSound — plays once when all coins are gone
 *   bgMusic       — loops continuously in the background
 *
 * Things to try:
 *   - Change bgMusic.amp(0.4) to adjust the music volume (0.0–1.0)
 *   - Add a sound for when the player clicks or presses a key
 *   - Guard rapid sounds: if (!collectSound.isPlaying()) collectSound.play();
 */

import coxprogramming.processing.sprites.*;
import processing.sound.*;

MyCharacter player;
ArrayList<Blob> coins;
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
  bgMusic.loop();     // start background music — runs until stopped

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
      collectSound.play();  // one-shot sound effect on collection
    }
  }

  player.followMouse();
  player.drawSprite();

  if (coins.size() == 0) {
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
  fill(80, 180, 80);
  textSize(52);
  text("You Win!", width/2, height/2 - 20);
  textSize(22);
  fill(50);
  text("Score: " + score, width/2, height/2 + 26);
  textAlign(LEFT, TOP);
}
