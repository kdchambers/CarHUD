class IndicatorArrow
{
  // Global variables
  float orientationAngle; 
  float tHeight;
  float tBase;
  float tailLen;
  float tailHeight;
  PVector center;
  color colour = color(0, 255, 0);;
  PShape body;
  boolean active = false;
  BrightnessPulse pulse;
  PVector trTip, trLeft, trRight, tlEndLeft, tlEndRight, tlStartRight, tlStartLeft;
  
 IndicatorArrow(PVector centeration, float triH, float triW, float tlH, float tlL, float angle, BrightnessPulse p)
 {
   
   print("Constructing IndicatorArrow\n");
   center = centeration;
   tHeight = triH;
   tBase = triW;
   tailLen = tlL;
   tailHeight = tlH;
   orientationAngle = angle;
   pulse = p;
 }
 
 public void render()
 {
  
  
  // Calculate the two base points
  trLeft = pointOnCirc(center, tBase/2, 90+orientationAngle);
  trRight = pointOnCirc(center, tBase/2, 270+orientationAngle);
  
  // Calculate the triangle tip point
  trTip = pointOnCirc(center, tHeight, orientationAngle);
  
  // Calculate the points on the triangle base that align with the tail lines
  tlStartRight = pointOnCirc(center, tailHeight/2, 270+orientationAngle);
  tlStartLeft = pointOnCirc(center, tailHeight/2, 90+orientationAngle);
  
  // Calulate the tail end points
  tlEndLeft = pointOnCirc(tlStartLeft, tailLen, 180+orientationAngle);
  tlEndRight = pointOnCirc(tlStartRight, tailLen, 180+orientationAngle);
 
  // Use pShape
  body = createShape(PShape.PATH);
  
  body.beginShape();
  body.fill((active) ? pulse.getColor() : pulse.getBaseColor());
  body.vertex(trTip.x, trTip.y);
  body.vertex(trRight.x, trRight.y);
  body.vertex(tlStartRight.x, tlStartRight.y);
  body.vertex(tlEndRight.x, tlEndRight.y);
  body.vertex(tlEndLeft.x, tlEndLeft.y);
  body.vertex(tlStartLeft.x, tlStartLeft.y);
  body.vertex(trLeft.x, trLeft.y);
  //body.vertex(trTip.x, trTip.y);
  body.endShape(CLOSE);
  
  // Draw
  // shape(body, center.x, center.y);
  shape(body);
 }
 
 public boolean containsMouse()
 {
   // Following isn't working so different implementation required
   //return body.contains(mouseX, mouseY);
   
   PVector mouseLoc = new PVector(mouseX, mouseY);
   boolean condition1, condition2;
   
   { // Shorten life span of temp variables
     LineEqn right, left, bottom;
     right = new LineEqn(new PVector(trTip.x, trTip.y), new PVector(trRight.x, trRight.y));
     left = new LineEqn(new PVector(trTip.x, trTip.y), new PVector(trLeft.x, trLeft.y));
     bottom = new LineEqn(new PVector(trRight.x, trRight.y), new PVector(trLeft.x, trLeft.y));
     
     condition1 = (bottom.toRight(mouseLoc) == true && right.toRight(mouseLoc) == true && left.toRight(mouseLoc) == false);
   }

   // Reuse the variables for the rectangle
   LineEqn right, left, bottom, top;
   top = new LineEqn(new PVector(tlStartRight.x, tlStartRight.y), new PVector(tlStartLeft.x, tlStartLeft.y));
   bottom = new LineEqn(new PVector(tlEndRight.x, tlEndRight.y), new PVector(tlEndLeft.x, tlEndLeft.y));
   right = new LineEqn(new PVector(tlStartRight.x, tlStartRight.y), new PVector(tlEndRight.x, tlEndRight.y));
   left = new LineEqn(new PVector(tlEndLeft.x, tlEndLeft.y), new PVector(tlStartLeft.x, tlStartLeft.y));
   
   condition2 = (top.toRight(mouseLoc) == false && bottom.toRight(mouseLoc) == true && left.toRight(mouseLoc) == true && right.toRight(mouseLoc) == false);
   
   if(condition1 || condition2)
     return true;
   else
     return false;
 }

 public void setActive(boolean val)
 {
   active = val;
 }
 
 public void toggleActive()
 {
  active = !active; 
 }
 
 private PVector pointOnCirc(PVector center, float radius, float angle)
  {

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
 
 private float getYInc(float angle, float radius)
  {
    return sin(radians(angle)) * radius;  
  }
  
  private float getXInc(float angle, float radius)
  {
    return cos(radians(angle)) * radius;
  }
}