PVector cCenter;
float radius;
float speed = 0;

void setup()
{
  cCenter = new PVector(width/2, height/2);
  radius = 200;
  size(500, 500);
}

void drawSpeed(PVector center, float radius, float fromEdge,
                float angle, int speed)
{
  PVector location;
  
  location = pointOnCirc(center, radius - fromEdge, angle);
  textAlign(CENTER);
  text(speed, location.x, location.y);
}

void drawSpeeds(PVector center, float radius, int speedInc, float fromEdge,
                int notches, float sAngle, float eAngle)
{
  float totalAngle = eAngle - sAngle;
  float intervalAngle = totalAngle / (notches - 1);
  
  int speed = 0;
  print("NOTCHES: " + notches + "\n\n\n\n\n\n");
  for(int i = 0; i < notches; i++)
  {
    float angle = eAngle - (i * intervalAngle);
    drawSpeed(center, radius, fromEdge, angle, speed);
    speed += speedInc;
    //sAngle += intervalAngle;
  }
}

void drawSpeedometer(PVector center, float radius, int numNotches, float nlPercentage)
{
  float nLen = 20;
  float nFromEdge = 10;
  float nStart = -60;
  float nEnd = 240;
  float nlLen = 130;
  
  fill(200, 255, 150);
  ellipse(center.x, center.y, radius*2, radius*2);
  fill(0);
  ellipse(center.x, center.y, 10, 10);
  
  drawCircleNotches(center, radius, nStart, nEnd, nLen, nFromEdge, numNotches);
  drawSpeedometerStick(center, nlLen, nlPercentage, nStart, nEnd);
  //drawSpeed(center, radius, nFromEdge + nLen + 20, 145, 60);
  drawSpeeds( center, radius, 5, nFromEdge + nLen + 20,
                numNotches, nStart, nEnd);
}

void drawCircleNotches(PVector cCenter, float radius, float sAngle, float eAngle,
                       float len, float fromEdge, float num)
{
  float totalAngle = eAngle - sAngle;
  float intervalAngle = totalAngle / (num - 1);
  
  for(int i = 0; i < num; i++)
  {
    drawCircleNotch(cCenter, radius, sAngle, (len/2)*(i%2+1), fromEdge);
    sAngle += intervalAngle;
  }
}

void draw()
{
  background(200, 200, 200);
  drawSpeedometer(cCenter, radius, 31, speed);
  speed += 0.1;
  if(speed >= 100)
    speed = 0;
}

void drawSpeedometerStick(PVector cCenter, float len, float percentage, 
                          float sAngle, float eAngle)
{
    
  if(percentage < 0)
  {
    print("Negative value passed for speedometer needle percentage\n");
    return;
  }
  
  float totalAngle = eAngle - sAngle;
  float angle;
  if(percentage == 0.0)
  {
    angle = eAngle;
  }else
  {
  angle = eAngle - totalAngle * (percentage / 100);
  }
  
  PVector needleOuter = pointOnCirc(cCenter, len, angle);
  
  line(cCenter.x, cCenter.y, needleOuter.x, needleOuter.y);
}

PVector pointOnCirc(PVector center, float radius, float angle)
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
  //print("yInc: " + yInc + "\n");
  xInc *= getXInc(theta, radius);
  //print("xInc: " + xInc + "\n");
  
  result = new PVector(center.x + xInc, center.y + yInc);
  //print("Result: " + result.x + ", " + result.y + "\n");
  
  return result;
}

void drawCircleNotch(PVector center, float radius, float angle, 
float len, float fromEdge)
{
  // Calculate end points of the notch
  PVector inner = pointOnCirc(center, radius - len - fromEdge, angle);
  PVector outer = pointOnCirc(center, radius - fromEdge, angle);
                
  //print("Inner.x: " + inner.x + "\n");
  //print("Inner.y: " + inner.y + "\n");
  //print("Outer.x: " + outer.x + "\n");
  //print("Outer.y: " + outer.y + "\n");
  
  line(inner.x, inner.y, outer.x, outer.y);
}

float getYInc(float angle, float radius)
{
  //print("Angle: " + angle + "\n"); 
  //print("Radius: " + radius + "\n");
  return sin(radians(angle)) * radius;  
}

float getXInc(float angle, float radius)
{
  //print("Angle: " + angle + "\n"); 
  //print("Radius: " + radius + "\n");
  return cos(radians(angle)) * radius;
}