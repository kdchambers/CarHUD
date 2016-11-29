// Global variables
IndicatorArrow test, test1;
BrightnessPulse pulse, rPulse;
TrianglePlus tri;
GearDisplay gearDisplay;
Speedometer speedometer, oil, temperature, rpm;
float x = 50;

void setup()
{
  size(1000, 700);
  pulse = new BrightnessPulse(0, 150, 0, 45, 90);
  rPulse = new BrightnessPulse(150, 0, 0, 60, 90);
  test = new IndicatorArrow(new PVector(50, 50), 50, 60, 20, 60, false, pulse);
  test1 = new IndicatorArrow(new PVector(200, 50), 50, 60, 20, 60, true, pulse);
  tri = new TrianglePlus(width/2, height/2, x, rPulse);
  gearDisplay = new GearDisplay(500, 200, 50, 100, 5);
  
  speedometer = new Speedometer(new PVector(width*.75, height*.75), 150, 12, 100, 1);
  speedometer.setBaseStartAngle((byte)0, -360.0/12.0);
  speedometer.setRotationRange(true, 0, 360);
  speedometer.setSpeedStart(1);
  
  String[] tempuratureList = {"C", "H"};
  String[] oilList = {"L", "H"};
  
  temperature = new Speedometer(new PVector(width*.75 - 200, height*.75 - 200), 50, 2, 50, tempuratureList);
  temperature.setBaseStartAngle((byte)0, 0);
  temperature.setRotationRange(true, 70, 140);
  temperature.setAlternateNotchLen(false);
  temperature.setNotchWeight(2);
  temperature.setNotchGradientColors(color(255, 0, 0), color(0, 0, 255));
  
  rpm = new Speedometer(new PVector(width*.25, height*.75), 130, 15, 10, 5);
  rpm.setBaseStartAngle((byte)1, 45);
  rpm.setRotationRange(true, 0, 225);
  
  oil = new Speedometer(new PVector(width*.3, height*.4), 50, 2, 50, oilList);
  oil.setBaseStartAngle((byte)0, 0);
  oil.setRotationRange(true, 70, 140);
  oil.setAlternateNotchLen(false);
  oil.setNotchWeight(2);
  
  background(color(255, 255, 255));
  
}

void mousePressed()
{
  // Set the indicator to active if clicked
  test.setActive((test.containsMouse()) ? true : false);
  test1.setActive((test1.containsMouse()) ? true : false);
  tri.setActive(tri.contains(new PVector(mouseX, mouseY)));
  
  if(gearDisplay.upGearClicked())
    print("Upper clicked\n");
    
  if(gearDisplay.downGearClicked())
    print("Down clicked\n");
}

void draw()
{
  test.render();
  test1.render();
  tri.render();
  gearDisplay.render();
  speedometer.drawSpeedometer();
  temperature.drawSpeedometer();
  rpm.drawSpeedometer();
  oil.drawSpeedometer();
}