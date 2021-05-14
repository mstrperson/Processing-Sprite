ArrayList<Blob> blobs;

void setup()
{
  fullScreen();
  blobs = new ArrayList<Blob>();
  
  for(int i = 0; i < 10; i++)
  {
    blobs.add(new Blob(random(width), random(height), random(-5, 5), random(-5, 5), random(10, 30), color(random(255), random(255), random(255))));
  }
}

void draw()
{
  background(255);
  for(Blob blob : blobs)
  {
    blob.move();
    blob.drawSprite();
  }
}
