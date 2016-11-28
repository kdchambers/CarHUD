class Speedometer
{
 
  // Coloring
  private color outerGaugeColor = color(200, 200, 200);
  private color innerGaugeColor = color(0, 0, 0);
  private color needleColor = color(0, 0, 0);
  private color notchesColor = color(0, 0, 0);
  private color notchColorFrom = color(0, 0, 255);
  private color notchColorTo = color(255, 0, 0);
  private IntList borderColorList = new IntList();
  
  private float notchLen = -1;
  private float notchFromEdge = -1;
  private float notchStartAngle = -1;
  private float notchEndAngle = -1;
  private float needleLen = -1;
  private float speedFromEdge = -1;
  private FloatList borderLenList = new FloatList();
  private int notchWeight = -1;
  private final int DEFAULTSTROKEWEIGHT = 1;
  private PVector cCenter;
  private float radius;
  private float needlePercentage = 0;
  private int numNotches = -1;
  private boolean initialized = false;
  private String[] stringList;
  private int startNotchTextVal = 0;
  private boolean useNotchGradientColors = false;
  private boolean alternateNotchLen = true;
  private boolean useCustomStrings = false;
  private float speedInc = -1;
  private float baseStartAngle = 0;
  private boolean rotateClockwise = true;
  private float needleAngleRange;
  private float notchIntervalAngle;

  // Public Interface 

  public void drawSpeedometer()
  {
    
    if(!initialized)
    {
     print("Cannot draw initialized speedometer\n");
     return;
    }
    
    // Ensure default strokeWeight
    strokeWeight(DEFAULTSTROKEWEIGHT);
    
    assignDefaults();
    
    if(borderLenList.size() > 0)
    {
     drawBorders(); 
    }
    
    fill(outerGaugeColor);
    ellipse(cCenter.x, cCenter.y, radius*2, radius*2);
    fill(innerGaugeColor);
    ellipse(cCenter.x, cCenter.y, radius*0.1, radius*0.1);
    
    drawCircleNotches();
    drawSpeedometerStick();
    if(useCustomStrings)
    {
      drawCustomStrings();
    }else
    {
      drawSpeeds();
    }
  }
  
  Speedometer(PVector center, float r, int notches, float nlPercentage, float spInc)
  {
    
    if(center.x < 0 || center.y < 0 || r < 0 || r > width || nlPercentage > 100 || nlPercentage < 0 || spInc < 1)
    {
     print("Invalid parameters passed to Speedometer constructor\n");
     return;
    }
    
    radius = r;
    cCenter = center;
    needlePercentage = nlPercentage;
    speedInc = spInc;

    if(setNumNotches(notches) == false) return;

    initialized = true;
  }
  
  
  Speedometer(PVector center, float r, int notches, float nlPercentage, String[] customList)
  {
    
    if(center.x < 0 || center.y < 0 || r < 0 || r > width || nlPercentage > 100 || nlPercentage < 0)
    {
     print("Invalid parameters passed to Speedometer constructor\n");
     return;
    }
    
    radius = r;
    cCenter = center;
    needlePercentage = nlPercentage;
    stringList = customList;

    if(setNumNotches(notches) == false) return;
    setCustomStrings(customList);
    
    useCustomStrings = true;
    initialized = true;
  }
  
  // Gets
  
  public float getSpeed()
  {
    if(useCustomStrings == true)
    {
      return -1;
    }
    
    return (speedInc*numNotches) / needlePercentage;
  }
  
  public float getNeedlePercentage()
  {
   return needlePercentage; 
  }
  
  // Sets
  
  public void rotateClockwise(boolean val)
  {
    rotateClockwise = val; 
  }
  
  public void setBaseStartAngle(byte reference, float offset)
  {
    float angle = 0;
    switch(reference)
    {
      case 0: // North
        angle = 90;
        break;
      case 1: // West
        angle = 180;
        break;
      case 2: // South
        angle = 270;
        break;
      case 3: // East
        angle = 360;
        break;
      default:
        print("Invalid reference value passed to setBaseAngle\n");
    }
    
    baseStartAngle = offset + angle;
    while(baseStartAngle < 0)
      baseStartAngle += 360;
      
    baseStartAngle %= 360;
  }
  
  public boolean setSpeedStart(int start)
  {
    if(start < 0)
    {
      print("Invalid parameter passed for startNotchTextVal\n");
      return false;
    }
    
    startNotchTextVal = start;
    return true;
  }
  
  public boolean setNotchWeight(int weight)
  {
    if(weight > 5)
    {
       print("NotchWeight must be between 1 and 5\n");
       return false;
    }
    
    notchWeight = weight;
    
    return true;
  }
  
  public boolean setBorderLenList(FloatList list)
  {
    
      for(int i = 0; i < list.size(); i++)
      {
       if(list.get(i) <= 0)
       {
         print("A borderLen value supplied was negitive or zero. Assignment failed\n");
         return false;
       }
       
       borderColorList.append(lerpColor(color(0, 0, 255), color(255, 0, 0), ((float)i + 1) / (float)list.size()));
       fill(lerpColor(color(0, 255, 0), color(255, 0, 0), i+1.0 / list.size()));
      }
    
      borderLenList = list;

      return true;
  }
  
  public boolean setBorderLenList(FloatList list, IntList cList)
  {
      if(cList.size() < list.size())
      {
       print("BorderColorList does not contain enough elements for each border\n");
       return false;
      }
    
      for(int i = 0; i < list.size(); i++)
      {
       if(list.get(i) <= 0)
       {
         print("A borderLen value supplied was negitive or zero. Assignment failed\n");
         return false;
       }
       
       borderLenList = list;
       borderColorList = cList;
      }
      
      return true;
  }
  
  public void setNotchGradientColors(color to, color from)
  {
    notchColorFrom = from;
    notchColorTo = to;
  
    useNotchGradientColors = true;
  }
  
  public void setAlternateNotchLen(boolean val)
  {
    alternateNotchLen = val;
  }
  
  public void setCustomStrings(String[] strings)
  {
    numNotches = strings.length;
    stringList = strings;
  }
  
   public boolean setSpeedFromEdge(float dist)
  {
    if(dist < 0 || dist > (radius/2 - notchLen - notchFromEdge))
    {
      print("Invalid speedFromEdge value passed\n");
      return false;
    }
    
    speedFromEdge = dist;
    return true;
  }
  
  public boolean setNumNotches(int n)
  {
    if(n <= 0 || n > (radius / 2))
    {
      print("Invalid numNotches passed to speedometer\n");
      return false;
    }
    
    numNotches = n;
    
    return true;
  }
  
  public void setNotchRange(float start, float end)
  {
    
    notchStartAngle = start;
    notchEndAngle = end;
    needleAngleRange = end - start;
    
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
    
    return true;
  }
  
  public void setNotchesColor(color c)
  {
    notchesColor = c;
    useNotchGradientColors = false;
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
  
  private void drawBorders()
  {
    FloatList tempBorderLenList = borderLenList;
    IntList tempBorderColorList = borderColorList;
    int maxIndex = 0;
    float maxVal = 0;
    
    while(borderLenList.size() >= 1)
    {
      for(int x = 0; x < borderLenList.size(); x++)
      {
        if(tempBorderLenList.get(x) > maxVal)
        {
           maxVal = tempBorderLenList.get(x);
           maxIndex = x;
        }
      }
      
      fill(tempBorderColorList.get(maxIndex));
      ellipse(cCenter.x, cCenter.y, radius*2+tempBorderLenList.get(maxIndex)*2, radius*2+tempBorderLenList.get(maxIndex)*2);
      
      tempBorderLenList.remove(maxIndex);
      tempBorderColorList.remove(maxIndex);
      
      maxIndex = 0;
      maxVal = 0;
    }
  }
  
  private void assignDefaults()
  {
    if(notchLen == -1)
    {  notchLen = radius*0.1; }
    if(needleLen == -1)
    {  needleLen = (radius - notchFromEdge - needleLen) * 0.75; }
    if(speedFromEdge == -1)
    {  speedFromEdge = (radius - (notchLen + notchFromEdge))*0.20; }
    if(notchWeight == -1)
    { notchWeight = 1; }
    if(notchEndAngle == -1)
    { notchEndAngle = (360 + baseStartAngle); }
    if(notchStartAngle == -1)
    { notchStartAngle = (0 + baseStartAngle); }
    if(notchFromEdge == -1)
    { notchFromEdge = 10; }
    
    needleAngleRange = notchEndAngle - notchStartAngle;
    
    float tempNumNotches = numNotches;
    if(needleAngleRange == 360)
      tempNumNotches++;
      
    notchIntervalAngle = needleAngleRange / (tempNumNotches-1);
  }
  
  private void drawSpeed(PVector center, float radius, float fromEdge,
                  float angle, int speed)
  {
    PVector location;
    
    location = pointOnCirc(center, radius - fromEdge - notchLen - notchFromEdge, angle);
    textAlign(CENTER);
    text(speed, location.x, location.y+5);
  }
  
  private void drawString(PVector center, float radius, float fromEdge,
                  float angle, String str)
  {
    PVector location;
    
    location = pointOnCirc(center, radius - fromEdge - notchLen - notchFromEdge, angle);
    textAlign(CENTER);
    text(str, location.x, location.y);
  }
  
  private void drawCustomStrings()
  {
    
    for(int i = 0; i < numNotches; i++)
    {
      float angle = notchStartAngle + (i * notchIntervalAngle);
      drawString(cCenter, radius, speedFromEdge, angle, stringList[i]);
    }
  }
  
  private void drawSpeeds()
  {

    float intervalAngle = needleAngleRange / (numNotches - 1);
    int speed = startNotchTextVal;
    
    for(int i = 0; i < numNotches; i++)
    {
      float angle = notchStartAngle + (i * intervalAngle);
      drawSpeed(cCenter, radius, speedFromEdge, angle, speed);
      speed += speedInc;
    }
  }
  
  private void drawCircleNotches()
  {
    float angle = notchStartAngle;
    float tempNotchLen = notchLen;
    
    fill(notchesColor);
    strokeWeight(notchWeight);
    
    for(int i = 0; i < numNotches; i++)
    {
      if(i%2 == 1 && alternateNotchLen == true)
      {
        tempNotchLen /= 2;
      }else
      {
        tempNotchLen = notchLen;
      }
      
      if(useNotchGradientColors == true)
      {
        stroke(lerpColor(notchColorTo, notchColorFrom, ((float)i+1.0)/numNotches));
      }
      drawCircleNotch(cCenter, radius, angle, tempNotchLen, notchFromEdge);
      angle += notchIntervalAngle;
    }
    
    // Set strokeWeight back
    strokeWeight(DEFAULTSTROKEWEIGHT);
  }
  
  private void drawSpeedometerStick()
  {
    float angle;
    
    if(rotateClockwise)
    {
      angle = lerp(0, needleAngleRange, needlePercentage / 100);
      angle += notchStartAngle;
    }else
    {
      angle = lerp(0, needleAngleRange, needlePercentage / 100);
      angle -= notchStartAngle;
    }
    angle %= 360;
    
    PVector needleOuter = pointOnCirc(cCenter, needleLen, angle);
    stroke(needleColor);
    
    line(cCenter.x, cCenter.y, needleOuter.x, needleOuter.y);
  }
  
  private PVector pointOnCirc(PVector center, float radius, float angle)
  {
    
    angle += baseStartAngle;

    while(angle < 0)
      angle += 360;
    angle = angle % 360;
    
    print(baseStartAngle + "\n");
    print(angle + "\n");
    
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