class LineEqn
{
 // Global variables
 float s, c;
 boolean verticalLine = false;
 boolean horizontalLine = false;
 PVector p1, p2;
 
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
  
  boolean toRight(PVector point)
  {
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
      
    
    if((s*point.x + c - point.y) > 0)
      return true;
    else
      return false;
  }
}