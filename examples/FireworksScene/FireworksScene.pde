/**
 * FireworksScene - a night city skyline with twinkling stars and fireworks.
 *
 * Stars are Blobs that twinkle. Buildings are Blocks with lit windows.
 * Rockets rise until gravity stops them, then burst into a ring of Sparks
 * that fall and fade. Spent sparks are removed from the list.
 */

import coxprogramming.processing.sprites.*;

/** Gravity added to every falling thing's y velocity each frame. */
float GRAVITY = 0.06f;

ArrayList<Star> stars;
ArrayList<Building> buildings;
ArrayList<Rocket> rockets;
ArrayList<Spark> sparks;

void setup() {
  fullScreen();
  Sprite.screenBehavior = ScreenBehavior.NoWalls;

  stars = new ArrayList<Star>();
  for (int i = 0; i < width * height / 3600; i++) {
    stars.add(new Star(this, random(width), random(height * 0.75f)));
  }

  buildings = new ArrayList<Building>();
  float x = 0;
  while (x < width) {
    float w = random(35, 80);
    float h = random(height * 0.08f, height * 0.28f);
    buildings.add(new Building(this, x, height - h, w, h));
    x += w + random(-8, 6);
  }

  rockets = new ArrayList<Rocket>();
  sparks = new ArrayList<Spark>();
}

void draw() {
  drawSky();

  for (Star s : stars) {
    s.drawSprite();
  }

  // Launch a new rocket now and then. Clicking launches one too.
  if (random(1) < 0.03f) {
    rockets.add(new Rocket(this, random(width * 0.15f, width * 0.85f),
                                 random(height * 0.2f, height * 0.5f)));
  }

  for (int i = rockets.size() - 1; i >= 0; i--) {
    Rocket r = rockets.get(i);
    r.move();
    r.drawSprite();
    if (r.readyToBurst()) {
      r.burst(sparks);
      rockets.remove(i);
    }
  }

  // ADD blending makes overlapping sparks add their light together, so
  // the middle of a burst glows brighter instead of covering itself up.
  blendMode(ADD);
  for (int i = sparks.size() - 1; i >= 0; i--) {
    Spark s = sparks.get(i);
    s.move();
    s.drawSprite();
    if (s.isDead()) {
      sparks.remove(i);
    }
  }
  blendMode(BLEND);

  for (Building b : buildings) {
    b.drawSprite();
  }
}

void mousePressed() {
  rockets.add(new Rocket(this, mouseX, mouseY));
}

/** Paints a dark blue gradient from the top of the sky down to the horizon. */
void drawSky() {
  for (int y = 0; y < height; y += 4) {
    float t = y / (float) height;
    noStroke();
    fill(lerpColor(color(5, 5, 25), color(40, 30, 80), t));
    rect(0, y, width, 4);
  }
}
