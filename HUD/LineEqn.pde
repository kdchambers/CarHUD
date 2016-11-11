class LineEqn
{
 // Global variables
 private float s, c;
 private boolean verticalLine = false;
 private boolean horizontalLine = false;
 private PVector p1, p2;
 
  LineEqn(PVector p1, PVector p2)
  {
    this.p1 = p1;
    this.p2 = p2;
    
    if(p2.x - p1.x == 0)
    {
      verticalLine = true; 
    }
    if(p2.y - p1.y == 0)
    {
      horizontalLine = true; 
    }
    
    s = (p2.y - p1.y) / (p2.x - p1.x);
    c = p1.y - (s*p1.x); 
  }
  
  /*
    Returns true if either of the conditions are met
      1) If the line is not vertical it will return true if the y value
         of the given point is above the lines corresponding y value
      2) If the line is vertical it will return true if the given point
         has a greater x(Is to the right) value than the equation of the line
  */
  public boolean above(PVector point)
  {
    
    float y;
    
    if(verticalLine == true)
    {
      if(point.x > p1.x)
        return true;
      else
        return false;
    }
    
    if(horizontalLine == true)
    {
      if(point.y > p1.y)
        return true;
      else
        return false;
    }
   
   // Calculate corresponding y value filling in X value of given param into the equation
    y = s*point.x + c;
    
    // Generated Y is above(lower y value mean higher position) given y
    if(y > point.y)
    {
      return true;
    }else
    {
      return false;
    }
  }
}