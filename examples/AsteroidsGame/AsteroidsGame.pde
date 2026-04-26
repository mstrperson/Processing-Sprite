/**
 * AsteroidsGame - a complete arcade-style game using SpriteGame.
 *
 * Controls:
 *   Left / Right arrows: rotate
 *   Up arrow: thrust
 *   Space: fire
 *   R: restart after game over
 *
 * This example demonstrates custom Sprite subclasses, screen wrapping,
 * velocity-based movement, collision checks, and managing sprite lists.
 */

import coxprogramming.processing.sprites.*;

Ship ship;
ArrayList<Asteroid> asteroids;
ArrayList<Bullet> bullets;
ArrayList<Spark> sparks;

float[] starX;
float[] starY;
float[] starSize;

boolean turningLeft;
boolean turningRight;
boolean thrusting;
boolean gameOver;

int score;
int lives;
int wave;
int fireCooldown;
int invincibleTimer;
int nextLifeScore;

final int STARTING_LIVES = 3;
final int SHOT_DELAY = 12;
final int MAX_BULLETS = 6;
final int EXTRA_LIFE_SCORE = 10000;

final float LARGE_ASTEROID = 46;
final float SAFE_SPAWN_RADIUS = 150;

void setup() {
  size(900, 700);
  smooth();
  textFont(createFont("Arial", 18));
  createStars();
  newGame();
}

void draw() {
  background(5, 8, 16);
  drawStars();

  if (!gameOver) {
    updateGame();
  }

  drawSprites();
  drawHud();

  if (gameOver) {
    drawGameOver();
  }
}

void newGame() {
  ship = new Ship(this, width / 2, height / 2);
  asteroids = new ArrayList<Asteroid>();
  bullets = new ArrayList<Bullet>();
  sparks = new ArrayList<Spark>();

  score = 0;
  lives = STARTING_LIVES;
  wave = 0;
  fireCooldown = 0;
  nextLifeScore = EXTRA_LIFE_SCORE;
  gameOver = false;
  turningLeft = false;
  turningRight = false;
  thrusting = false;

  startNextWave();
  resetShip();
}

void updateGame() {
  if (turningLeft) {
    ship.turn(-0.085f);
  }
  if (turningRight) {
    ship.turn(0.085f);
  }

  ship.setThrusting(thrusting);
  ship.setInvincible(invincibleTimer > 0);
  ship.update();

  if (fireCooldown > 0) {
    fireCooldown--;
  }
  if (invincibleTimer > 0) {
    invincibleTimer--;
  }

  for (Asteroid asteroid : asteroids) {
    asteroid.update();
  }

  for (int i = bullets.size() - 1; i >= 0; i--) {
    Bullet bullet = bullets.get(i);
    bullet.update();
    if (bullet.dead()) {
      bullets.remove(i);
    }
  }

  for (int i = sparks.size() - 1; i >= 0; i--) {
    Spark spark = sparks.get(i);
    spark.update();
    if (spark.dead()) {
      sparks.remove(i);
    }
  }

  checkBulletHits();
  checkShipHit();

  if (asteroids.isEmpty()) {
    startNextWave();
    invincibleTimer = 90;
  }
}

void drawSprites() {
  for (Asteroid asteroid : asteroids) {
    asteroid.drawSprite();
  }

  for (Bullet bullet : bullets) {
    bullet.drawSprite();
  }

  for (Spark spark : sparks) {
    spark.drawSprite();
  }

  if (!gameOver) {
    ship.drawSprite();
  }
}

void checkBulletHits() {
  for (int i = bullets.size() - 1; i >= 0; i--) {
    Bullet bullet = bullets.get(i);

    for (int j = asteroids.size() - 1; j >= 0; j--) {
      Asteroid asteroid = asteroids.get(j);

      if (asteroid.hits(bullet)) {
        bullets.remove(i);
        asteroids.remove(j);
        score += asteroid.pointValue();
        checkExtraLife();

        addSparks(asteroid.getPosition().x, asteroid.getPosition().y, 18, color(255, 220, 140));
        asteroids.addAll(asteroid.split());
        break;
      }
    }
  }
}

void checkShipHit() {
  if (invincibleTimer > 0) {
    return;
  }

  for (Asteroid asteroid : asteroids) {
    if (asteroid.hits(ship)) {
      addSparks(ship.getPosition().x, ship.getPosition().y, 36, color(120, 210, 255));
      lives--;

      if (lives <= 0) {
        gameOver = true;
      } else {
        resetShip();
      }
      return;
    }
  }
}

void checkExtraLife() {
  while (score >= nextLifeScore) {
    lives++;
    nextLifeScore += EXTRA_LIFE_SCORE;
  }
}

void resetShip() {
  ship.reset(width / 2, height / 2);
  bullets.clear();
  fireCooldown = 20;
  invincibleTimer = 150;
}

void startNextWave() {
  wave++;
  asteroids.clear();

  int count = 3 + wave;
  for (int i = 0; i < count; i++) {
    spawnLargeAsteroid();
  }
}

void spawnLargeAsteroid() {
  float x = random(width);
  float y = random(height);

  for (int attempts = 0; attempts < 50; attempts++) {
    x = random(width);
    y = random(height);

    if (dist(x, y, ship.getPosition().x, ship.getPosition().y) > SAFE_SPAWN_RADIUS) {
      break;
    }
  }

  float angle = random(TWO_PI);
  float speed = random(0.8f, 1.8f + wave * 0.08f);
  asteroids.add(
    new Asteroid(
      this,
      x,
      y,
      LARGE_ASTEROID,
      3,
      cos(angle) * speed,
      sin(angle) * speed
    )
  );
}

void tryFire() {
  if (gameOver || fireCooldown > 0 || bullets.size() >= MAX_BULLETS) {
    return;
  }

  bullets.add(ship.fire());
  fireCooldown = SHOT_DELAY;
}

void addSparks(float x, float y, int count, int sparkColor) {
  for (int i = 0; i < count; i++) {
    sparks.add(new Spark(this, x, y, random(1.2f, 4.5f), random(TWO_PI), sparkColor));
  }
}

void createStars() {
  int count = 110;
  starX = new float[count];
  starY = new float[count];
  starSize = new float[count];

  for (int i = 0; i < count; i++) {
    starX[i] = random(width);
    starY[i] = random(height);
    starSize[i] = random(1, 2.6f);
  }
}

void drawStars() {
  noStroke();

  for (int i = 0; i < starX.length; i++) {
    float twinkle = 130 + 90 * sin(frameCount * 0.025f + i);
    fill(twinkle);
    ellipse(starX[i], starY[i], starSize[i], starSize[i]);
  }
}

void drawHud() {
  fill(235);
  textAlign(LEFT, TOP);
  textSize(18);
  text("Score: " + score, 20, 18);
  text("Wave: " + wave, 20, 42);

  for (int i = 0; i < lives; i++) {
    drawShipIcon(24 + i * 24, 86);
  }

  textSize(14);
  fill(180);
  text("Left/Right rotate    Up thrust    Space fire", 20, height - 30);
}

void drawShipIcon(float x, float y) {
  pushMatrix();
  translate(x, y);
  stroke(210, 235, 255);
  strokeWeight(1.5f);
  noFill();
  triangle(0, -8, -6, 7, 6, 7);
  popMatrix();
}

void drawGameOver() {
  noStroke();
  fill(0, 180);
  rect(0, 0, width, height);

  textAlign(CENTER, CENTER);
  fill(255);
  textSize(46);
  text("Game Over", width / 2, height / 2 - 44);

  textSize(20);
  fill(210);
  text("Final score: " + score, width / 2, height / 2 + 4);
  text("Press R to restart", width / 2, height / 2 + 38);
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    if (gameOver) {
      newGame();
    }
    return;
  }

  if (key == ' ') {
    tryFire();
  }

  if (keyCode == LEFT) {
    turningLeft = true;
  } else if (keyCode == RIGHT) {
    turningRight = true;
  } else if (keyCode == UP) {
    thrusting = true;
  }
}

void keyReleased() {
  if (keyCode == LEFT) {
    turningLeft = false;
  } else if (keyCode == RIGHT) {
    turningRight = false;
  } else if (keyCode == UP) {
    thrusting = false;
  }
}
