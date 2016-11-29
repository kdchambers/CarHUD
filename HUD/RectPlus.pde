class RectPlus
{
 private PVector center;
 private float rWidth;
 private float rHeight;
 private color rColor;
 
 // Optional
 private float radius = 0;
 private float borderSize = 0;
 private color rBorderColor = color(0, 0, 0);
 private String label = "";
 private int fontSize = 17;
 private color strokeColor = color(#000000);
 
 private boolean initialized = false;
 
 public RectPlus(PVector c, float w, float h, color rc)
 {
   if( (c.x + w / 2) > width || (c.x - w / 2) < 0 || (c.y + h / 2) > height || (c.y - h / 2) < 0)
    {
      print("Invalid arguments passed to RectPlus constructor\n");
      return;
    }
    
    center = c;
    rWidth = w;
    rHeight = h;
    rColor = rc;
    
    initialized = true;
 }
 
 public RectPlus(PVector c, float w, float h, color rc, float r)
 {
   if( (c.x + w / 2) > width || (c.x - w / 2) < 0 || (c.y + h / 2) > height || (c.y - h / 2) < 0 || r <= 0)
    {
      print("Invalid arguments passed to RectPlus constructor\n");
      return;
    }
    
    center = c;
    rWidth = w - r * 2;
    rHeight = h - r * 2;
    rColor = rc;
    radius = r;
    
    checkRadius(w, h, r);
    
    initialized = true;
 }
 
 public RectPlus(PVector c, float w, float h, color rc, float r, float bs)
 {
   if( (c.x + w / 2) > width || (c.x - w / 2) < 0 || (c.y + h / 2) > height || (c.y - h / 2) < 0 || r <= 0 || bs <= 0)
    {
      print("Invalid arguments passed to RectPlus constructor\n");
      return;
    }
    
    center = c;
    rWidth = w - r * 2;
    rHeight = h - r * 2;
    rColor = rc;
    radius = r;
    borderSize = bs;
    
    checkRadius(w, h, r);
    
    initialized = true;
 }
 
 public RectPlus(PVector c, float w, float h, color rc, float r, float bs, color bc)
 {
   if( (c.x + w / 2) > width || (c.x - w / 2) < 0 || (c.y + h / 2) > height || (c.y - h / 2) < 0 || r <= 0 || bs <= 0)
    {
      print("Invalid arguments passed to RectPlus constructor\n");
      return;
    }
    
    center = c;
    rWidth = w - r * 2;
    rHeight = h - r * 2;
    rColor = rc;
    radius = r;
    borderSize = bs;
    rBorderColor = bc;
    
    checkRadius(w, h, r);
    
    initialized = true;
 }
 
 void setLabel(String val)
  {
    label = val;
  }
 
 private void checkRadius(float w, float h, float r)
 {
   if(r > (w / 2))
    {
      radius = w / 2;
    }
    
    if(r > (h / 2))
    {
      radius = h / 2;
      print("Radius Modified\n");
      print(radius);
    }
 }
 
 public void setColor(color c)
 {
   rColor = c;
 }
 
public void drawRect()
 {
   
   if(!initialized)
   {
    print("Cannot draw uninitialized RectPlus\n");
    return;
   }
   
   noStroke();
   
   fill(rBorderColor);
   
   // Create border
   if(borderSize > 0)
   {
     float nWidth = rWidth + borderSize * 2;
     float nHeight = rHeight + borderSize * 2;
     float nRadius = radius + borderSize;
     
     rect(center.x - nWidth / 2 - nRadius, center.y - nHeight / 2, nWidth + nRadius * 2, nHeight);
     rect(center.x - nWidth / 2, center.y - nHeight / 2 - nRadius, nWidth, nRadius);
     rect(center.x - nWidth / 2, center.y + nHeight / 2, nWidth, nRadius);
   
     if(radius > 0)
     {
       arc(center.x - nWidth / 2, center.y - nHeight / 2, nRadius*2, nRadius*2, radians(180) , radians(270)); 
       arc(center.x + nWidth / 2, center.y - nHeight / 2, nRadius*2, nRadius*2, radians(270) , radians(360));
       arc(center.x + nWidth / 2, center.y + nHeight / 2, nRadius*2, nRadius*2, radians(0) , radians(90));
       arc(center.x - nWidth / 2, center.y + nHeight / 2, nRadius*2, nRadius*2, radians(90) , radians(180)); 
     }
   }
   
   fill(rColor);
   
   rect(center.x - rWidth / 2 - radius, center.y - rHeight / 2, rWidth + radius * 2, rHeight);
   rect(center.x - rWidth / 2, center.y - rHeight / 2 - radius, rWidth, radius);
   rect(center.x - rWidth / 2, center.y + rHeight / 2, rWidth, radius);
   
   if(radius > 0)
   {
     arc(center.x - rWidth / 2, center.y - rHeight / 2, radius*2, radius*2, radians(180) , radians(270)); 
     arc(center.x + rWidth / 2, center.y - rHeight / 2, radius*2, radius*2, radians(270) , radians(360));
     arc(center.x + rWidth / 2, center.y + rHeight / 2, radius*2, radius*2, radians(0) , radians(90));
     arc(center.x - rWidth / 2, center.y + rHeight / 2, radius*2, radius*2, radians(90) , radians(180)); 
   }
   
   textSize(fontSize);
   fill(strokeColor);
   textAlign(CENTER);
   text(label, center.x, center.y);
 }
 
   boolean containsMouse()
   {
     // Temp varibles
     float tWidth = (rWidth / 2) + 2*radius;
     float tHeight = (rHeight / 2) + 2*radius;
     
     if(mouseX > (center.x+tWidth) || mouseX < (center.x-tWidth) || mouseY > (center.y+tHeight) || mouseY < (center.y-tHeight) )
       return false;
       
     return true;
   }
}