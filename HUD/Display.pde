class Display
{
  PVector center;
  float rWidth;
  float rHeight;
  String display;
  color rectColor = color(200, 200, 200);
  boolean initialized = false;
  RectPlus outer;
  
  Display(PVector c, float w, float h, String d)
  {
    if( (c.x + w / 2) > width || (c.x - w / 2) < 0 || (c.y + h / 2) > height || (c.y - h / 2) < 0)
    {
      print("Invalid arguments passed to Display constructor\n");
      return;
    }
    
    center = c;
    rWidth = w;
    rHeight = h;
    display = d;
    
    outer = new RectPlus(center, rWidth, rHeight, color(200, 200, 200), 3, 1);
    
    initialized = true;
  }
  
  void setColor(color c)
  {
    rectColor = c;
  }
  
  boolean containsMouse()
  {
    return outer.containsMouse();
  }
  
  void drawDisplay()
  {
   outer.setColor(rectColor);
   outer.drawRect();
   textAlign(CENTER);
   textSize(rHeight / 2);
   fill(0, 0, 0);
   text(display, center.x, center.y + 5);
  }
}