class Speedometer
{

  private PVector cCenter;
  private float radius;
  private color outerGaugeColor = color(200, 200, 200);
  private color innerGaugeColor = color(0, 0, 0);
  private color needleColor = color(0, 0, 0);
  private color notchesColor = color(0, 0, 0);
  private float notchLen = 20;
  private float notchFromEdge = 10;
  private float notchStart = -60;
  private float notchEnd = 240;
  private float needleLen = 20;
  private float needlePercentage = 0;
  private int numNotches = 0;
  private boolean initialized = false;
  private float speedInc = 0;
  
  private float speedFromEdge = notchLen + notchFromEdge + 15;
  
  // Public Interface 
  
  public void drawSpeedometer()
  {
    
    if(!initialized)
    {
     print("Cannot draw initialized speedometer\n");
     return;
    }
    
    needleLen = radius - notchFromEdge - needleLen - (radius / 10);
    
    fill(outerGaugeColor);
    ellipse(cCenter.x, cCenter.y, radius*2, radius*2);
    fill(innerGaugeColor);
    ellipse(cCenter.x, cCenter.y, 10, 10);
    
    drawCircleNotches();
    drawSpeedometerStick();
    drawSpeeds();
  }
  
  Speedometer(PVector center, float r, int notches, float nlPercentage, float spInc)
  {
    if(center.x < 0 || center.y < 0 || radius < 0 || radius > width || nlPercentage > 100 || nlPercentage < 0 || spInc < 1)
    {
     print("Invalid parameters passed to Speedometer constructor");
     return;
    }
    
    cCenter = center;
    radius = r;
    numNotches = notches;
    needlePercentage = nlPercentage;
    speedInc = spInc;
    
    initialized = true;
  }
  
  public boolean setNumNotches(int n)
  {
    if(n <= 0 || n > (radius / 2))
    {
      print("Invalid numNotches passed to speedometer\n");
      return false;
    }
    
    return true;
  }
  
  public void setNotchRange(float start, float end)
  {
    notchStart = start;
    notchEnd = end;
  }
  
  public boolean setNeedlePercentage(float percentage)
  {
    if(percentage > 100 || percentage < 0)
    {
      print("Invalid needlePercentage passed to Speedometer\n");
      return false;
    }
    
    needlePercentage = percentage;
    return true;
    
  }
  
  public boolean setNeedleLen(float len)
  {
    if(len < 5 || len > (radius * 0.75))
    {
      print("Invalid NeedleLen passed to Speedometer\n");
      return false;
    }
    
    needleLen = len;
    return true;
  }
  
  public void setNotchEnd(float e)
  {
    notchEnd = e;
  }
  
  public void setNotchStart(float s)
  {
    notchStart = s;
  }
  
  public boolean setNotchFromEdge(float gap)
  {
    if(gap < 0 || gap > (radius / 2) - notchLen)
    {
      print("Invalid notchFromEdge value passed to Speedometer\n");
      return false;
    }
    
    notchFromEdge = gap;
    
    return true;
  }
  
  public boolean setNotchLen(float len)
  {
    if(len < 4 || len > (radius / 2))
    {
      print("Invalid notchLen passed to Speedometer\n");
      return false;
    }
    
    notchLen = len;
    speedFromEdge = notchLen + notchFromEdge + 15;
    
    return true;
  }
  
  public void setNotchesColor(color c)
  {
    notchesColor = c;
  }
  
  public void setNeedleColor(color c)
  {
    needleColor = c;
  }
  
  public void setOuterGaugeColor(color c)
  {
   outerGaugeColor = c; 
  }
  
  public void setInnerGaugeColor(color c)
  {
   innerGaugeColor = c; 
  }
  
  public boolean setRadius(float r)
  {
    if(r < 1 || r > width)
      return false;
    else 
    {
      radius = r;
      return true;
    }
  }
  
  // Private functions
  
  private void drawSpeed(PVector center, float radius, float fromEdge,
                  float angle, int speed)
  {
    PVector location;
    
    location = pointOnCirc(center, radius - fromEdge, angle);
    textAlign(CENTER);
    text(speed, location.x, location.y);
  }
  
  private void drawSpeeds()
  {
    float totalAngle = notchEnd - notchStart;
    print(notchEnd + " - " + notchStart);
    print(totalAngle + "\n");
    
    float intervalAngle = totalAngle / (numNotches - 1);
    
    int speed = 0;
    for(int i = 0; i < numNotches; i++)
    {
      float angle = notchEnd - (i * intervalAngle);
      drawSpeed(cCenter, radius, speedFromEdge, angle, speed);
      speed += speedInc;
    }
  }
  
  private void drawCircleNotches()
  {
    float totalAngle = notchEnd - notchStart;
    float intervalAngle = totalAngle / (numNotches - 1);
    float angle = notchStart;
    
    fill(notchesColor);
    
    for(int i = 0; i < numNotches; i++)
    {
      drawCircleNotch(cCenter, radius, angle, (notchLen/2)*(i%2+1), notchFromEdge);
      angle += intervalAngle;
    }
  }
  
  private void drawSpeedometerStick()
  {
    float totalAngle = notchEnd - notchStart;
    float angle;
    if(needlePercentage == 0.0)
    {
      angle = notchEnd;
    }else
    {
    angle = notchEnd - totalAngle * (needlePercentage / 100);
    }
    
    PVector needleOuter = pointOnCirc(cCenter, needleLen, angle);
    fill(needleColor);
    
    line(cCenter.x, cCenter.y, needleOuter.x, needleOuter.y);
  }
  
  private PVector pointOnCirc(PVector center, float radius, float angle)
  {
    angle = angle % 360;
    while(angle < 0)
      angle += 360;
    
    PVector result;
    float xInc = 1;
    float yInc = 1;
    float theta;
    
    if(angle >= 270)
    {
      //print("Sector D\n");
      theta = angle - 270;
      theta = 90 - theta;
    }else if(angle >= 180)
    {
      //print("Sector C\n");
      theta = angle - 180;
      xInc = -1;
    }else if(angle >= 90)
    {
      //print("Sector B\n");
      theta = angle - 90;
      theta = 90 - theta;
      xInc = -1;
      yInc = -1;
    }else
    {
      theta = angle;
      yInc = -1;
    }
    
    yInc *= getYInc(theta, radius);
    xInc *= getXInc(theta, radius);
    
    result = new PVector(center.x + xInc, center.y + yInc);
    
    return result;
  }
  
  private void drawCircleNotch(PVector center, float radius, float angle, 
  float len, float fromEdge)
  {
    // Calculate end points of the notch
    PVector inner = pointOnCirc(center, radius - len - fromEdge, angle);
    PVector outer = pointOnCirc(center, radius - fromEdge, angle);
    
    line(inner.x, inner.y, outer.x, outer.y);
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