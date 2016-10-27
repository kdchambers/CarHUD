class Display
{
  PVector center;
  float rWidth;
  float rHeight;
  String display;
  color rectColor = color(200, 200, 200);
  boolean initialized = false;
  
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
    
    initialized = true;
  }
  
  void drawDisplay()
  {
   fill(rectColor);
   rect(center.x - rWidth / 2, center.y - rHeight / 2, rWidth, rHeight); 
   textAlign(CENTER);
   textSize(10);
   fill(0, 0, 0);
   text(display, center.x, center.y + 5);
  }
}