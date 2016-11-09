class Button
{
  private boolean active;
  private RectPlus body;
  private BrightnessPulse cp;
  private color colour;
  private color defaultColor = color(200, 30, 30);
  
  Button(RectPlus b, BrightnessPulse c)
  {
    body = b;
    cp = c;
  }
  
  void render()
  {
    if(active)
      colour = cp.getColor();
    else 
      colour = defaultColor;
    body.setColor(colour);
    body.drawRect();
  }
  
  void mousePressed()
  {
    print("Called!\n");
    // Decide whether it is active and change color pattern
    if(body.containsMouse())
      active = true;
    else
      active = false;
  }
  
  boolean containsMouse()
  {
   return body.containsMouse(); 
  }
  
  void setActive(boolean val)
  {
   active = val; 
  }
}