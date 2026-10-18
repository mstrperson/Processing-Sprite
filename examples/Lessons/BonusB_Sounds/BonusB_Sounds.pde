/**
 * Bonus Lesson B - Sounds
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
 *   collectSound  - plays once each time the coin is collected
 *   gameOverSound - plays once when the player touches the hazard
 *   bgMusic       - loops continuously in the background
 *
 * Things to try:
 *   - Change bgMusic.amp(0.4) to adjust the music volume (0.0 to 1.0)
 *   - Add a sound for when the player clicks or presses a key
 *   - Guard rapid sounds: if (!collectSound.isPlaying()) collectSound.play();
 */

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

/**
 * Creates the window, loads all sound files, starts background music,
 * and places the character, the coin, and the hazard.
 * Runs once when the sketch starts.
 */
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

/**
 * Clears the screen and routes to the active game or the game over screen.
 * Called automatically ~60 times per second.
 */
void draw() {
  background(240);

  if (!gameOver) {
    playGame();
  } else {
    showGameOver();
  }
}

/**
 * Moves and draws everything, checks both collisions, and plays a sound
 * at the moment each one happens.  Called from draw() while playing.
 */
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

/**
 * Displays the game over screen with the final score.
 * Called from draw() after the player touches the hazard.
 */
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
