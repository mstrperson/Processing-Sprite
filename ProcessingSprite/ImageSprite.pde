public class ImageSprite extends Sprite
{
  // Encapsulation of the PImage class inside a Sprite
  protected PImage img;
  
  public ImageSprite(float x, float y, String fileName)
  {
    super(x, y);
    img = loadImage(fileName);
  }
  
  public void drawSprite()
  {
    img.resize(100, 100);
    
    image(img, pos.x - 50, pos.y - 50);
  }
}
