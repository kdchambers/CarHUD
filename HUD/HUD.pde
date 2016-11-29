// Global variables
IndicatorArrow leftIndicator, rightIndicator;
BrightnessPulse pulse, rPulse;
GearDisplay gearDisplay;
Speedometer clock, oil, temperature, rpm, speedometer;
RectPlus dialDash;
HazardLight hazardLight;

void setup()
{
  size(1000, 700);
  smooth();
  
  pulse = new BrightnessPulse(0, 150, 0, 60, 90);
  rPulse = new BrightnessPulse(150, 0, 0, 60, 90);
  
  leftIndicator = new IndicatorArrow(new PVector(width*.6, height*.5), 20, 30, 10, 20, false, pulse);
  rightIndicator = new IndicatorArrow(new PVector(width*.83, height*.5), 20, 30, 10, 20, true, pulse);
  
  // hazard light
  hazardLight = new HazardLight(width*.72, height*.55, 60, rPulse);
  
  // Gear console
  gearDisplay = new GearDisplay(width*.25, height*.7, 100, 300, 6);
  
  dialDash = new RectPlus(new PVector(width*.5, height*.7), width*.98, 350, color(#12362B), 30, 2, color(#002117));
  
  clock = new Speedometer(new PVector(width*.75, height*.75), 100, 12, 100, 1);
  clock.setBaseStartAngle((byte)0, -360.0/12.0);
  clock.setRotationRange(true, 0, 360);
  clock.setSpeedStart(1);
  clock.setOuterGaugeColor(color(171, 158, 137));
  clock.setTextColor(color(0, 50, 0));
  FloatList clockBorderLens = new FloatList();
  IntList clockBorderColours = new IntList();
  
  // Setup border
  clockBorderLens.append(15);
  clockBorderColours.append(color(92, 73, 41));
  
  clock.setBorderLenList(clockBorderLens, clockBorderColours);
  
  String[] tempuratureList = {"C", "H"};
  String[] oilList = {"L", "H"};
  
  temperature = new Speedometer(new PVector(width*.93, height*.58), 50, 2, 50, tempuratureList);
  temperature.setBaseStartAngle((byte)3, 0);
  temperature.setRotationRange(false, 0, 120);
  temperature.setAlternateNotchLen(false);
  temperature.setNotchWeight(2);
  temperature.setNotchGradientColors(color(255, 0, 0), color(0, 0, 255));
  
  FloatList temperatureBorderLens = new FloatList();
  IntList temperatureBorderColours = new IntList();
  
  temperatureBorderLens.append(5);
  temperatureBorderColours.append(color(#8C0E0E));
  
  temperature.setBorderLenList(temperatureBorderLens, temperatureBorderColours);
  
  speedometer = new Speedometer(new PVector(width*.85, height*.75), 130, 15, 10, 10);
  speedometer.setBaseStartAngle((byte)1, 45);
  speedometer.setRotationRange(true, 0, 270);
  speedometer.setNotchGradientColors(color(#FF0303), color(#540101));
  speedometer.setOuterGaugeColor(color(#000000));
  speedometer.setInnerGaugeColor(color(#00FFB3));
  speedometer.setTextColor(color(#8924AB));
  speedometer.setNeedleColor(color(#FFF700));
  speedometer.setEdgeColor(color(#EDEDED));
  
  FloatList speedometerBorderLens = new FloatList();
  IntList speedometerBorderColours = new IntList();
  
  speedometerBorderLens.append(5);
  speedometerBorderColours.append(color(#8C0E0E));
  
  speedometer.setBorderLenList(speedometerBorderLens, speedometerBorderColours);
  
  rpm = new Speedometer(new PVector(width*.60 - 10, height*.75), 130, 15, 10, 5);
  rpm.setBaseStartAngle((byte)1, 45);
  rpm.setRotationRange(true, 0, 225);
  rpm.setNotchGradientColors(color(#FF0303), color(#540101));
  rpm.setOuterGaugeColor(color(#000000));
  rpm.setInnerGaugeColor(color(#00FFB3));
  rpm.setTextColor(color(#8924AB));
  rpm.setNeedleColor(color(#FFF700));
  rpm.setEdgeColor(color(#EDEDED));
  
  FloatList rpmBorderLens = new FloatList();
  IntList rpmBorderColours = new IntList();
  
  rpmBorderLens.append(5);
  rpmBorderColours.append(color(#8C0E0E));
  
  rpm.setBorderLenList(rpmBorderLens, rpmBorderColours);
  
  oil = new Speedometer(new PVector(width*.5, height*.58), 50, 2, 50, oilList);
  oil.setBaseStartAngle((byte)0, 30);
  oil.setRotationRange(true, 70, 140);
  oil.setAlternateNotchLen(false);
  oil.setNotchWeight(2);
  
  FloatList oilBorderLens = new FloatList();
  IntList oilBorderColours = new IntList();
  
  oilBorderLens.append(5);
  oilBorderColours.append(color(#8C0E0E));
  
  oil.setBorderLenList(oilBorderLens, oilBorderColours);
  
  background(color(255, 255, 255));
  
}

void mousePressed()
{
  // Set the indicator to active if clicked(HazardLight blocks this functionality when active)
  if(leftIndicator.containsMouse() == true)
  {
    if(hazardLight.isActive() == false)
    {
      leftIndicator.toggleActive();
      rightIndicator.setActive(false);
    }
  }
  
  if(rightIndicator.containsMouse() == true)
  {
    if(hazardLight.isActive() == false)
    {
      rightIndicator.toggleActive();
      leftIndicator.setActive(false);
    }
  }
  
  
  if(hazardLight.contains(new PVector(mouseX, mouseY)))
  {
    if(hazardLight.isActive() == true)
    {
      hazardLight.setActive(false);
      leftIndicator.setActive(false);
      rightIndicator.setActive(false);
    }else
    {
      hazardLight.setActive(true);
      leftIndicator.setActive(true);
      rightIndicator.setActive(true);
    }
  }
  
  gearDisplay.upGearClicked();
  gearDisplay.downGearClicked();
}

void draw()
{
  
  if(frameCount%60 == 1)
  {
    dialDash.drawRect();
    temperature.drawSpeedometer();
    oil.drawSpeedometer();
    rpm.drawSpeedometer();
    speedometer.drawSpeedometer();
    gearDisplay.render();
  }
  
  hazardLight.render();
  leftIndicator.render();
  rightIndicator.render();
  // Set the time
  float clockPercentage = (hour()*100.0)/12.0 + (((float)minute()/60.0)*100)/12; 
  //clock.setNeedlePercentage(clockPercentage);
}