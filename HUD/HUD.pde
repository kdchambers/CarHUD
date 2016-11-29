// Global variables
IndicatorArrow leftIndicator, rightIndicator;
BrightnessPulse pulse, rPulse, headLightPulse;
GearDisplay gearDisplay;
Speedometer clock, oil, temperature, rpm, speedometer, minuteClock;
RectPlus dialDash, buttonDash;
HazardLight hazardLight;
Button heating, headLights, dimLights, mute, abs, wipers;
RectPlus heatingRect, headLightsRect, dimLightsRect, muteRect, absRect, wipersRect;
Display speedDisplay, rpmDisplay;
float buttonSecXOffset, buttonSecYOffset = 0;

float engineControl = 0;
float speed = 0;
float rpmValue = 0;

void setup()
{
  size(1000, 700);
  smooth();
  buttonSecXOffset = 200;
  
  pulse = new BrightnessPulse(0, 150, 0, 60, 90);
  headLightPulse = new BrightnessPulse(80, 80, 0, 60, 50);
  rPulse = new BrightnessPulse(150, 0, 0, 60, 90);
  
  speedDisplay = new Display(new PVector(width*.6, height*.1), 200, 40, "SPEED: " + speed);
  rpmDisplay = new Display(new PVector(width*.82, height*.1), 200, 40, "RPM: " + rpmValue);
  
  // Buttons
  
  heatingRect = new RectPlus(new PVector(width*.35 + 150 + buttonSecXOffset, height*.25 + buttonSecYOffset), 120, 40, color(#95ADAD), 10);
  heatingRect.setLabel("Heating");
  headLightsRect = new RectPlus(new PVector(width*.35 + 300 + buttonSecXOffset, height*.25 + buttonSecYOffset), 120, 40, color(#C2F00C), 10);
  headLightsRect.setLabel("HeadLights");
  dimLightsRect = new RectPlus(new PVector(width*.35 + 300 + buttonSecXOffset, height*.35 + buttonSecYOffset),120, 40, color(#C2F00C), 10);
  dimLightsRect.setLabel("Dimmers");
  muteRect = new RectPlus(new PVector(width*.35 + buttonSecXOffset, height*.35 + buttonSecYOffset), 120, 40, color(#0212F2), 10);
  muteRect.setLabel("Mute Speakers");
  absRect = new RectPlus(new PVector(width*.35 + buttonSecXOffset, height*.25 + buttonSecYOffset), 120, 40, color(#95ADAD), 10);
  absRect.setLabel("ABS");
  wipersRect = new RectPlus(new PVector(width*.35 + 150 + buttonSecXOffset, height*.35 + buttonSecYOffset), 120, 40, color(#0212F2), 10);
  wipersRect.setLabel("Act. Wipers");
  
  heating = new Button(heatingRect, rPulse);
  headLights = new Button(headLightsRect, headLightPulse);
  dimLights = new Button(dimLightsRect, headLightPulse);
  mute = new Button(muteRect, pulse);
  abs = new Button(absRect, pulse);
  wipers = new Button(wipersRect, rPulse);
  
  // Minute Clock
  minuteClock = new Speedometer(new PVector(width*.37, height*.12), 70, 12, 100, 5);
  minuteClock.setSpeedStart(0);
  minuteClock.setBaseStartAngle((byte)0, 0);
  minuteClock.setRotationRange(true, 0, 360);
  minuteClock.setOuterGaugeColor(color(#9293A1));
  minuteClock.setTextColor(color(#041C0C));
  
  leftIndicator = new IndicatorArrow(new PVector(width*.6, height*.5), 20, 30, 10, 20, false, pulse);
  rightIndicator = new IndicatorArrow(new PVector(width*.83, height*.5), 20, 30, 10, 20, true, pulse);
  
  // hazard light
  hazardLight = new HazardLight(width*.72, height*.55, 60, rPulse);
  
  // Gear console
  gearDisplay = new GearDisplay(width*.25, height*.7, 100, 300, 6);
  gearDisplay.setDisplayColor(color(#000000));
  gearDisplay.setInnerDisplayColor(color(#B4DBDB));
  gearDisplay.setButtonColor(color(#279A9C));
  gearDisplay.incGear();
  
  dialDash = new RectPlus(new PVector(width*.5, height*.7), width*.98, 350, color(#12362B), 30, 2, color(#002117));
  buttonDash = new RectPlus(new PVector(width*.5+buttonSecXOffset, height*.3+buttonSecYOffset), width*.5, 150, color(#12362B), 10, 2, color(#002117));
  
  clock = new Speedometer(new PVector(width*.15, height*.22), 130, 12, 100, 1);
  clock.setBaseStartAngle((byte)0, -360.0/12.0);
  clock.setRotationRange(true, 0, 360);
  clock.setSpeedStart(1);
  clock.setOuterGaugeColor(color(171, 158, 137));
  clock.setTextColor(color(#041C0C));
  clock.setTextSize(12);
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
  
  background(color(200, 200, 250));
  
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
  
  if(heating.containsMouse())
    heating.toggleActive();
  if(headLights.containsMouse())
    headLights.toggleActive();
  if(dimLights.containsMouse())
    dimLights.toggleActive();
  if(mute.containsMouse())
    mute.toggleActive();
  if(abs.containsMouse())
    abs.toggleActive();
  if(wipers.containsMouse())
    wipers.toggleActive();
}

void draw()
{
  if(frameCount%60 == 1)
  {
    dialDash.drawRect();
    buttonDash.drawRect();
    temperature.setNeedlePercentage(random(temperature.getNeedlePercentage() - 5, temperature.getNeedlePercentage() + 5)%95);
    temperature.drawSpeedometer();
    oil.setNeedlePercentage(random(oil.getNeedlePercentage() - 5, oil.getNeedlePercentage() + 5)%95);
    oil.drawSpeedometer();
    gearDisplay.render();
    
    speedDisplay.setDisplayText("Speed: " + round(speed) + " MPH");
    speedDisplay.drawDisplay();
    rpmDisplay.setDisplayText("RPM: " + round(rpmValue*100));
    rpmDisplay.drawDisplay();
    
    minuteClock.setNeedlePercentage(((float)minute()/60.0) * 100.0 + (1.0/15.0)*100.0);
    minuteClock.drawSpeedometer();
  }
  
  clock.drawSpeedometer();
  
  rpm.drawSpeedometer();
  rpmValue = rpm.getSpeed();
  speedometer.drawSpeedometer();
  speed = speedometer.getSpeed();
  
  speedometer.setNeedlePercentage((engineControl * ((float)gearDisplay.getCurrentGear() / (float)gearDisplay.getMaxGear())));
  rpm.setNeedlePercentage(engineControl);
  if(engineControl >= 75 && gearDisplay.currentGear != gearDisplay.getMaxGear())
  {
    engineControl -= 40;
    gearDisplay.incGear();
  }
  
  engineControl += 0.2;
  if(engineControl >= 95)
  {
    engineControl = 0;
    gearDisplay.setGear(1);
  }
  
  heating.render();
  headLights.render();
  dimLights.render();
  mute.render();
  abs.render();
  hazardLight.render();
  wipers.render();
  leftIndicator.render();
  rightIndicator.render();
  
  // Set the time
  float clockPercentage = ((hour()%12.0)/12) * 100 + 3;
  
  clock.setNeedlePercentage(clockPercentage);
}