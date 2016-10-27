// Global variables
Speedometer test1, test2, test3, test4;
Display myDisplay;
RectPlus myRect;

void setup()
{
  size(1000, 700);
  test1 = new Speedometer(new PVector((float)width/4, (float)height/4), 100.0, 15, 100.0, 10);
  
  test1.setNotchLen(10);
  test1.setOuterGaugeColor(color(200, 200, 0));
  test1.setInnerGaugeColor(color(0, 200, 0));
  
  test1.drawSpeedometer();
  // PVector c, float w, float h, String d
  myDisplay = new Display(new PVector((float)width/4, (float)height/4+80), 50, 20, new String("1234"));
  myDisplay.drawDisplay();
  
  myRect = new RectPlus(new PVector(width/2, height/2), 300, 20, color(200, 50, 45), 10, 1);
  myRect.drawRect();
}

void draw()
{
  
}