class HazardLight
{
  // Global variables
  private float tHeight;
  private float base;
  private BrightnessPulse pulse;
  private boolean active = false;
  private float x, y; // triangle will be centered around this point
  private LineEqn bottom, right, left; // Line equations for checking if point is inside the object
  private PVector tTop, tLeft, tRight;
  
  // Spacing for the middle triangle
  private float outerPaddingLen;
  private float innerPaddingLen;
  
  HazardLight(float tX, float tY, float h, BrightnessPulse bp)
  {
    tHeight = h;
    pulse = bp;
    x = tX;
    y = tY;
    
    if(h <= 0)
    {
      print("Setting default triangle size\n");
      tHeight = 40;
    }
    
    // Calculate base so that triangle is equilatoral
    base = sqrt(pow((h/2),2)+pow(h,2));
    
    // Default spacing
    outerPaddingLen = tHeight*0.20;
    innerPaddingLen = outerPaddingLen;
    
    tTop = new PVector(x, y - tHeight/2);
    tLeft = new PVector(x - base/2, y + tHeight/2);
    tRight = new PVector(x + base/2, y + tHeight/2);
    
    bottom = new LineEqn(tRight, tLeft);
    right = new LineEqn(tTop, tRight);
    left = new LineEqn(tTop, tLeft);
  }
  
  public boolean contains(PVector point)
  { 
    return (bottom.above(point) == false && left.above(point) == false && right.above(point) == false);
  }
  
  public void setActive(boolean val)
  {
    active = val;
  } 
  
  public void toggleActive()
  {
    active = !active;
  }
  
  public boolean isActive()
  {
    return active;
  }
  
  public void render()
  {
    
    fill( (active) ? pulse.getColor() : pulse.getBaseColor() );
    
    triangle(tTop.x, tTop.y, tRight.x, tRight.y, tLeft.x, tLeft.y);
    
    // Calculate points for drawing middle triangle
    PVector middleTriTop, middleTriLeft, middleTriRight;
    middleTriTop = pointOnCirc(tTop, outerPaddingLen, 270);
    middleTriLeft = pointOnCirc(tLeft, outerPaddingLen, 30);
    middleTriRight = pointOnCirc(tRight, outerPaddingLen, 150);
    
    // Calculte points for drawing inner triangle
    PVector innerTriTop, innerTriLeft, innerTriRight;
    innerTriTop = pointOnCirc(middleTriTop, innerPaddingLen, 270);
    innerTriLeft = pointOnCirc(middleTriLeft, innerPaddingLen, 30);
    innerTriRight = pointOnCirc(middleTriRight, innerPaddingLen, 150);
    
    // Draw middle and inner triangles using calculated points
    fill(color(0, 0, 0));
    triangle(middleTriTop.x, middleTriTop.y, middleTriRight.x, middleTriRight.y, middleTriLeft.x, middleTriLeft.y);
    fill( (active) ? pulse.getColor() : pulse.getBaseColor() );
    triangle(innerTriTop.x, innerTriTop.y, innerTriLeft.x, innerTriLeft.y, innerTriRight.x, innerTriRight.y);
  }
  
  private PVector pointOnCirc(PVector center, float radius, float angle)
  {

    while (angle < 0)
      angle += 360;
    angle = angle % 360;

    PVector result;
    float xInc = 1;
    float yInc = 1;
    float theta;

    if (angle >= 270)
    {
      //print("Sector D\n");
      theta = angle - 270;
      theta = 90 - theta;
    } else if (angle >= 180)
    {
      //print("Sector C\n");
      theta = angle - 180;
      xInc = -1;
    } else if (angle >= 90)
    {
      //print("Sector B\n");
      theta = angle - 90;
      theta = 90 - theta;
      xInc = -1;
      yInc = -1;
    } else
    {
      theta = angle;
      yInc = -1;
    }

    yInc *= getYInc(theta, radius);
    xInc *= getXInc(theta, radius);

    result = new PVector(center.x + xInc, center.y + yInc);

    return result;
  }

  private float getYInc(float angle, float radius)
  {
    return sin(radians(angle)) * radius;
  }

  private float getXInc(float angle, float radius)
  {
    return cos(radians(angle)) * radius;
  }
}