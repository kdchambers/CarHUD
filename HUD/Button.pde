class Button
{
  private boolean active;
  private RectPlus body;
  private BrightnessPulse cp;
  private color colour;
  private color defaultColor = color(200, 30, 30);
  private String label = "";
  
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
  
  boolean containsMouse()
  {
   return body.containsMouse(); 
  }
  
  void setActive(boolean val)
  {
   active = val; 
  }
  
  void toggleActive()
  {
    active = !active;
  }
}