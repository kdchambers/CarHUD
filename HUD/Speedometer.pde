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
  private color edgeColor = -1;
  
  // Dimensions and Positioning
  private float notchLen = -1;
  private float notchFromEdge = -1;
  private float needleLen = -1;
  private float speedFromEdge = -1;
  private FloatList borderLenList = new FloatList();
  private float radius;
  private PVector cCenter;
  
  // Rotation variables
  private float notchStartAngle = -1;
  private float notchAngleRange = -1;
  private boolean rotateClockwise = true;
  
  // State and Settings
  private float needlePercentage = 0;
  private boolean alternateNotchLen = true;
  private boolean useCustomStrings = false;
  private int notchWeight = -1;
  private final int DEFAULTSTROKEWEIGHT = 1;
  private int textSize = -1;
  private int numNotches = -1;
  private boolean initialized = false;
  private String[] stringList;
  private int startNotchTextVal = 0;
  private boolean useNotchGradientColors = false;
  private float speedInc = -1;
  private float baseStartAngle = 0;
  private color textColour = -1;
  private int needleWeight = 1;
  private boolean rotateNeedleFully = false;
  
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
    
    stroke(edgeColor);
    
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
    
    strokeWeight(DEFAULTSTROKEWEIGHT);
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
    
    return (startNotchTextVal + speedInc*(numNotches - 1)) * (float)needlePercentage/100.0;
  }
  
  public float getNeedlePercentage()
  {
   return needlePercentage; 
  }
  
  // Sets
  
  public void setEdgeColor(color val)
  {
    edgeColor = val;
  }
  
  public void setNeedleWeight(int val)
  {
    if(val < 1 || val > 5)
      return;
    needleWeight = val;
  }
  
  public void setTextColor(color val)
  {
    textColour = val;
  }
  
  public void setNotchAngleRange(float val)
  {
    if(val < 0)
      return;
      
    notchAngleRange = val;
  }
  
  public void setTextSize(int size)
  {
   if(size < 1 || size > 35)
     return;
     
    textSize = size;
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
  
  public void setRotationRange(boolean isClockwise, float startAngle, float totalAngle)
  {
    rotateClockwise = isClockwise;
    notchStartAngle = startAngle;
    notchAngleRange = totalAngle;
    
    if(totalAngle == 360)
    {
      notchAngleRange -= notchAngleRange / numNotches;
      rotateNeedleFully = true;
    }
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
       //fill(lerpColor(color(0, 255, 0), color(255, 0, 0), i+1.0 / list.size()));
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
  
  public void setNotchGradientColors(color from, color to)
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
    FloatList tempBorderLenList = new FloatList();
    IntList tempBorderColorList = new IntList();
    
    // Deep copy borderLenList and borderColorList
    for(int x = 0; x < borderLenList.size(); x++)
    {
      tempBorderLenList.append(borderLenList.get(x)); 
      tempBorderColorList.append(borderColorList.get(x));
    }
    
    int maxIndex = 0;
    float maxVal = 0;
    
    stroke(edgeColor);
    
    while(tempBorderLenList.size() >= 1)
    {
      for(int x = 0; x < tempBorderLenList.size(); x++)
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
    
    stroke(color(#000000));
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
    if(notchStartAngle == -1)
    { notchStartAngle = (0 + baseStartAngle); }
    if(notchFromEdge == -1)
    { notchFromEdge = 10; }
    if(textSize == -1)
    { textSize = 15; }
    if(notchAngleRange == -1)
      notchAngleRange = 180;
    if(textColour == -1)
      textColour = color(0, 0, 0);
    if(edgeColor == -1)
      edgeColor = color(#000000);
  }
  
  private void drawSpeed(PVector center, float radius, float fromEdge,
                  float angle, int speed)
  {
    PVector location;
    
    location = pointOnCirc(center, radius - fromEdge - notchLen - notchFromEdge, angle);
    fill(textColour);
    textAlign(CENTER);
    text(speed, location.x, location.y+5);
  }
  
  private void drawString(PVector center, float radius, float fromEdge,
                  float angle, String str)
  {
    PVector location;
    
    location = pointOnCirc(center, radius - fromEdge - notchLen - notchFromEdge, angle);
    fill(textColour);
    textAlign(CENTER);
    text(str, location.x, location.y);
  }
  
  private void drawCustomStrings()
  {
    textSize(textSize);
    // Add to endAngle is anti-clockwise and subtract otherwise
    float endAngle = (rotateClockwise) ? (notchStartAngle - notchAngleRange) : (notchStartAngle + notchAngleRange);
    float angle; // Temp value for each string angle
    
    for(int i = 0; i < numNotches; i++)
    {
      angle = lerp(notchStartAngle, endAngle, (float)i/(numNotches - 1));
      drawString(cCenter, radius, speedFromEdge, angle, stringList[i]);
    }
  }
  
  private void drawSpeeds()
  {
    // Starting speed
    int speed = startNotchTextVal;
    float endAngle = (rotateClockwise) ? (notchStartAngle - notchAngleRange) : (notchStartAngle + notchAngleRange);
    float angle;
    textSize(textSize);
    
    for(int i = 0; i < numNotches; i++)
    {
      angle = lerp(notchStartAngle, endAngle, (float)i/(numNotches - 1));
      drawSpeed(cCenter, radius, speedFromEdge, angle, speed);
      speed += speedInc;
    }
  }
  
  private void drawCircleNotches()
  {
    float angle;
    float tempNotchLen = notchLen;
    float endAngle = (rotateClockwise) ? (notchStartAngle - notchAngleRange) : (notchStartAngle + notchAngleRange);
    
    fill(notchesColor);
    strokeWeight(notchWeight);
    
    for(int i = 0; i < numNotches; i++)
    {
      angle = lerp(notchStartAngle, endAngle, (float)i/(numNotches - 1));
      // If alternateNotchLen is true then half the length of every second notch
      tempNotchLen = (i%2 == 1 && alternateNotchLen == true) ? (tempNotchLen /= 2) : (notchLen);
      
      if(useNotchGradientColors == true)
      {
        stroke(lerpColor(notchColorTo, notchColorFrom, ((float)i)/(numNotches - 1)));
      }
      
      drawCircleNotch(cCenter, radius, angle, tempNotchLen, notchFromEdge);
    }
    
    // Set strokeWeight back
    strokeWeight(DEFAULTSTROKEWEIGHT);
  }
  
  private void drawSpeedometerStick()
  {
    float angle;
    float endAngle;
    endAngle = (rotateClockwise) ? (notchStartAngle - notchAngleRange) : (notchStartAngle + notchAngleRange);
    
    angle = lerp(notchStartAngle, endAngle, (float)needlePercentage / 100.0);
    angle %= 360;
    
    PVector needleOuter = pointOnCirc(cCenter, needleLen, angle);
    stroke(needleColor);
    
    strokeWeight(needleWeight);
    line(cCenter.x, cCenter.y, needleOuter.x, needleOuter.y);
    
    // Reset stroke colour and weight
    stroke(color(#000000));
    strokeWeight(1);
  }
  
  private PVector pointOnCirc(PVector center, float radius, float angle)
  {
    
    angle += baseStartAngle;

    while(angle < 0)
      angle += 360;
    angle = angle % 360;
    
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