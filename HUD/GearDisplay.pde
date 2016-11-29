class GearDisplay
{
  // Global variables
  private float displayHeight = -1;
  private float buttonHeight = -1;
  private float buttonSpacing = -1;
  private float displayWidth = -1;
  private int currentGear = 0;
  private int maxGear = -1;
  private color displayColor = -1;
  private color innerDisplayColor = -1;
  private color buttonColor = -1;
  private float displayHeightMargin = -1;
  private float displayWidthMargin = -1;
  private float x, y; // Display will be centered around this point
  private int textSize = -1;
  float innerDisplayX, innerDisplayY, innerDisplayWidth, innerDisplayHeight = -1;
  float displayX, displayY = -1;
  float buttonTextSize = -1;
  
  GearDisplay(float x, float y, float dHeight, float dWidth, int maxGr)
  {
    // Make sure x and y are appropriate
    if(x < 0 || x > width)
      x = width/2;
    if(y < 0 || y > width)
      y = height/2;
    if(maxGr <= 0)
      maxGr = 6;
      
    this.x = x;
    this.y = y;
    
    displayHeight = dHeight;
    displayWidth = dWidth;
    
    assignDefaults();
  }
  
  private void calcNeededDimensions()
  {
    displayX = x - displayWidth/2;
    displayY = y - displayHeight/2;
    
    innerDisplayX = displayX + displayWidthMargin;
    innerDisplayY = displayY + displayHeightMargin;
    innerDisplayWidth = displayWidth - displayWidthMargin*2;
    innerDisplayHeight = displayHeight - displayHeightMargin*2;
  }
  
  private void assignDefaults()
  {
    
    // Assign defaults as needed
    if(displayColor == -1)
      displayColor = color(100, 100, 150);
    if(innerDisplayColor == -1)
      innerDisplayColor = color(200, 200, 200);
    if(displayHeightMargin == -1)
      displayHeightMargin = displayHeight/10;
    if(displayWidthMargin == -1)
      displayWidthMargin = displayWidth/10;
    if(buttonHeight == -1)
      buttonHeight = displayHeight/2;
    if(buttonSpacing == -1)
      buttonSpacing = displayHeight/10;
    if(textSize == -1)
      textSize = (int)displayHeight/2;
    if(buttonTextSize == -1)
      buttonTextSize = (int) (buttonHeight * 0.75);
    if(maxGear == -1)
      maxGear = 6;
    if(buttonColor == -1)
      buttonColor = color(#A1E2E3);
  }
  
  public void setDisplayColor(color val)
  {
    displayColor = val;
  }
  
  public void setInnerDisplayColor(color val)
  {
    innerDisplayColor = val;    
  }
  
  public void setButtonColor(color val)
  {
    buttonColor = val;
  }
  
  public void setButtonHeight(float h)
  {
    buttonHeight = h;
  }
  
  public void setCurrentGear(int gear)
  {
    currentGear = gear;
  }
  
  public void incGear()
  {
    if(currentGear != maxGear)
      currentGear++;
  }
  
  public void decGear()
  {
    // Let 0 be neutral
    if(currentGear != 0)
      currentGear--;
  }
  
  public boolean upGearClicked()
  {
    if(mouseX < displayX || mouseX > (displayX + displayWidth))
      return false;
    if(mouseY < (y  - (displayHeight/2) - buttonSpacing - buttonHeight) || mouseY > (y - buttonSpacing - (displayHeight/2)))
      return false;
    
    incGear();
    
    return true;
  }
  
  public boolean downGearClicked()
  {
    if(mouseX < displayX || mouseX > (displayX + displayWidth))
      return false;
    if(mouseY > (y + (displayHeight/2) + buttonSpacing + buttonHeight) || mouseY < (y + buttonSpacing + (displayHeight/2)))
      return false;
    
    decGear();
    
    return true;
  }
  
  public void setDisplayHeightMargin(float h)
  {
    displayHeightMargin = h;
  }
  
  public void setDisplayWidthMargin(float w)
  {
    displayWidthMargin = w;
  }
  
  public void render()
  {
    
    calcNeededDimensions();
    
   // Draw display outer rect
   pushMatrix();
   translate(displayX, displayY);
   
   fill(displayColor);
   rect(0, 0, displayWidth, displayHeight);
   
   fill(innerDisplayColor);
   rect(displayWidthMargin, displayHeightMargin, innerDisplayWidth, innerDisplayHeight);
   
   popMatrix();
   
   pushMatrix();
   translate(x, y + textSize/2);
   textAlign(CENTER);
   textSize(textSize);
   fill(color(0, 0 , 0));
   if(currentGear != 0)
     text(currentGear, 0, 0);
   else 
     text("N", 0, 0);
   popMatrix();
   
   // render gearButton rectangles
   
   fill(color(150, 150, 150));
   pushMatrix();
   translate(displayX, displayY - buttonHeight - buttonSpacing);
   fill(buttonColor);
   rect(0, 0, displayWidth, buttonHeight);
   popMatrix();
   
   pushMatrix();
   translate(displayX, displayY + displayHeight + buttonSpacing);
   rect(0, 0, displayWidth, buttonHeight);
   popMatrix();
   
   // Render button labels
   // Set fill colours for labels
   fill(color(0, 0, 0));
   textSize(buttonTextSize);
   
   pushMatrix();
   translate(x, y - buttonSpacing - (buttonHeight*0.2) - (displayHeight/2));
   text("Up", 0, 0);
   popMatrix();
   
   pushMatrix();
   translate(x, y + buttonSpacing  + (displayHeight/2) + (buttonHeight * 0.75));
   text("Down", 0, 0);
   popMatrix();
   
  }
}