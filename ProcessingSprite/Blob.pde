/* In order to actually use the Sprite class, we must /extend/ it.
 * We can add to this class /more/ information than is in Sprite
 * but, we do NOT need to replicate the data that is stored in Sprite.
 * x, y, dx, and dy are all defined in the Sprite class and we get
 * all of those for free by using "extends Sprite"
 */
class Blob extends Sprite
{
  // Blobs have a Radius and a color
  protected float radius;
  protected color myColor;
  
  // Create a blob with default velocity.
  Blob(float x, float y, float r, color c)
  {
    // super calls the Sprite(x, y) constructor method.
    super(x, y);
    myColor = c;
    radius = r;
  }
  
  // Create a blob with a particular velocity vector.
  Blob(float x, float y, float r, float dx, float dy, color c)
  {
    super(x, y, dx, dy);
    myColor = c;
    radius = r;
  }
  
  // Check to see if two blobs are touching
  boolean collidesWith(Blob other)
  {
    return (this.distanceTo(other) <= (this.radius+other.radius)/2);    
  }
  
  // This is the method that is /absolutely/ required.
  // this defines how to draw the Blob; it's just a circle...
  void drawSprite()
  {
    fill(myColor);
    ellipse(pos.x, pos.y, 2*radius, 2*radius);
  }
}

// Block is like a blob except it is a rectangle!
public class Block extends Blob
{
  protected float w; // width
  protected float h; // height
  
  Block(float x, float y, float w, float h, color c)
  {
    super(x, y, 0, c);
    
    this.w = abs(w);
    this.h = abs(h);
  }
  
  void drawSprite()
  {
    fill(myColor);
    noStroke();
    rect(pos.x, pos.y, w, h);
  }
}
