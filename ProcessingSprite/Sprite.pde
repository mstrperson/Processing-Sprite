abstract class Sprite
{
  protected Vector2 pos;
  protected Vector2 vel;
  
  
  /// Constructors
  public Sprite(float x, float y)
  {
    pos = new Vector2(x, y);
    vel = new Vector2(0, 0);
  }
  
  public Sprite(float x, float y, float dx, float dy)
  {
    pos = new Vector2(x, y);
    vel = new Vector2(dx, dy);
  }
  
  public Sprite(Vector2 s)
  {
    pos = s;
    vel = new Vector2(0, 0);
  }
  
  /// Behaviors
  public void moveTo(Vector2 newPosition)
  {
    pos = newPosition;
  }
  
  public void moveTo(float x, float y)
  {
    pos.x = x;
    pos.y = y;
  }
  
  public void setVelocity(Vector2 newVelocity)
  {
    vel = newVelocity;
  }
  
  public void setVelocity(float dx, float dy)
  {
    vel.x = dx;
    vel.y = dy;
  }
  
  public void move()
  {
    pos = pos.add(vel);
    if(pos.x > width) pos.x -= width;
    if(pos.x < 0) pos.x += width;
    if(pos.y > height) pos.y -= height;
    if(pos.y < 0) pos.y -= height;
  }
  
  public Vector2 getPosition()
  {
    return pos;
  }
  
  public Vector2 getVelocity()
  {
    return vel;
  }
  
  void keyboardControl()
  {
    switch(keyCode)
    {
      case UP:     vel.y = -5; vel.x = 0;  break;
      case DOWN:   vel.y = 5;  vel.x = 0;  break;
      case LEFT:   vel.y = 0;  vel.x = -5; break;
      case RIGHT:  vel.y = 0;  vel.x = 5;  break;
      default: vel.x = 0; vel.y = 0; break;
    }
    println("keyboard control ", keyCode);
  }
  
  // make this Sprite move at the speed := |<dx, dy>|
  // directly toward your mouse pofloater!
  void followMouse()
  {
    float speed = vel.mag();
    
    Vector2 mLoc = new Vector2(mouseX, mouseY);
    Vector2 mDir = mLoc.subtract(pos);
    
    pos = pos.add(mDir.unitVector().scale(speed));
    
  }
  
  public float distanceTo(Sprite other)
  {
    Vector2 diff = other.pos.subtract(this.pos);
    return diff.mag();
  }
  
  public abstract void drawSprite();
}
