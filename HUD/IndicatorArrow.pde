class IndicatorArrow
{
  // Global variables
  private float orientationAngle = 0; 
  private boolean faceRight; // True = right, False = left
  private float tHeight;
  private float tBase;
  private float tailLen;
  private float tailHeight;
  private PVector center;
  private color colour = color(0, 255, 0);
  private PShape body;
  private boolean active = false;
  private BrightnessPulse pulse;
  private PVector trTip, trLeft, trRight, tlEndLeft, tlEndRight, tlStartRight, tlStartLeft;

  IndicatorArrow(PVector c, float triH, float triW, float tlH, float tlL, boolean dir, BrightnessPulse p)
  {
    center = c;
    tHeight = triH;
    tBase = triW;
    tailLen = tlL;
    tailHeight = tlH;
    faceRight = dir;
    if (!dir)
    {
      orientationAngle = 180;
    }
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

      // Test if triangle part of the arrow has been clicked
      if (faceRight)
        condition1 = (bottom.above(mouseLoc) == true && right.above(mouseLoc) == true && left.above(mouseLoc) == false);
      else
        condition1 = (bottom.above(mouseLoc) == false && right.above(mouseLoc) == false && left.above(mouseLoc) == true);
    }

    // Reuse the variables for the rectangle
    LineEqn right, left, bottom, top;
    top = new LineEqn(new PVector(tlStartRight.x, tlStartRight.y), new PVector(tlStartLeft.x, tlStartLeft.y));
    bottom = new LineEqn(new PVector(tlEndRight.x, tlEndRight.y), new PVector(tlEndLeft.x, tlEndLeft.y));
    right = new LineEqn(new PVector(tlStartRight.x, tlStartRight.y), new PVector(tlEndRight.x, tlEndRight.y));
    left = new LineEqn(new PVector(tlEndLeft.x, tlEndLeft.y), new PVector(tlStartLeft.x, tlStartLeft.y));

    // Test if the rectangle part of the arrow has been clicked
    if (faceRight)
      condition2 = (top.above(mouseLoc) == false && bottom.above(mouseLoc) == true && left.above(mouseLoc) == true && right.above(mouseLoc) == false);
    else
      condition2 = (top.above(mouseLoc) == true && bottom.above(mouseLoc) == false && left.above(mouseLoc) == false && right.above(mouseLoc) == true);

    // If either the triangle or rectangle has been clicked
    if (condition1 || condition2)
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