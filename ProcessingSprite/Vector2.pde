//-----------------------------------------------------------------
// Vector2
// 2-Dimensional Vector with many useful arithmetic operations defined
//-----------------------------------------------------------------
public class Vector2
{
  //***************************
  // Properties
  //***************************
  
  public float x, y;
  
  //***************************
  // Constructor
  //***************************
  
  public Vector2(float x, float y)
  {
    this.x = x;
    this.y = y;
  }
  
  //***************************
  // Arithmetic Operations
  //***************************
  
  // Compute the Vector Sum of this + other.
  public Vector2 add(Vector2 other)
  {
    return new Vector2(this.x + other.x, this.y + other.y);
  }
  
  // Compute the Vector Difference this - other
  public Vector2 subtract(Vector2 other)
  {
    return new Vector2(this.x - other.x, this.y - other.y);
  }
  
  // Compute |this| the Magnitude (length) of this vector.
  public float mag()
  {
    return sqrt(x*x + y*y);
  }
  
  // Compute the Dot Product this*other
  public float dotProduct(Vector2 other)
  {
    return this.x * other.x + this.y * other.y;
  }
  
  // Compute the additive inverse Vector -this.
  public Vector2 inverse()
  {
    return new Vector2(-x, -y);
  }
  
  public Vector2 scale(float m)
  {
    return new Vector2(m * x, m * y);
  }
  
  // Compute a Unit Vector in the same direction as this vector.
  public Vector2 unitVector()
  {
    float m = this.mag();
    return new Vector2(x / m, y / m); 
  }
  
  public Vector2 perpendicular()
  {
    return new Vector2(y, -x);
  }
  
  protected float theta()
  {
    return atan(y / x);
  }
  
  public float angleTo(Vector2 other)
  {
    return other.theta() - this.theta();
  }
  
  public Vector2 rotate(float rads)
  {
    float nx = cos(rads)*x - sin(rads) * y; // new x
    float ny = sin(rads)*x + cos(rads) * y; // new y
    return new Vector2(nx, ny);
  }
}
