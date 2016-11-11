// Global variables
IndicatorArrow test, test1;
BrightnessPulse pulse, rPulse;
TrianglePlus tri;
float x = 50;

void setup()
{
  size(1000, 700);
  pulse = new BrightnessPulse(0, 150, 0, 45, 90);
  rPulse = new BrightnessPulse(150, 0, 0, 60, 90);
  test = new IndicatorArrow(new PVector(50, 50), 50, 60, 20, 60, false, pulse);
  test1 = new IndicatorArrow(new PVector(200, 50), 50, 60, 20, 60, true, pulse);
  tri = new TrianglePlus(width/2, height/2, x, rPulse);
  // x^2 = a^2 + b^2
}

void mousePressed()
{
  // Set the indicator to active if clicked
  //print("Mouse Clicked\n");
  test.setActive((test.containsMouse()) ? true : false);
  test1.setActive((test1.containsMouse()) ? true : false);
  tri.setActive(tri.contains(new PVector(mouseX, mouseY)));
}

void draw()
{
  test.render();
  test1.render();
  tri.render();
}