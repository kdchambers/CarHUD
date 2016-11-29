class BrightnessPulse
{
   // Global variables
   int frameLength;
   int currFrame = 0;
   int brightnessInc;
   color colour;
   int r, g, b = 0;
   float nr, ng, nb;
   float rRange, gRange, bRange;
   final int COLORMAX = 255;
   
   BrightnessPulse(int r, int g, int b, int fl, int br)
   {
     this.r = r;
     this.b = b;
     this.g = g;
     brightnessInc = br;
     frameLength = fl;
     
     if(br > 0)
     {
       rRange = (COLORMAX - r) * (br/100.0);
       gRange = (COLORMAX - g) * (br/100.0);
       bRange = (COLORMAX - b) * (br/100.0);
     }else
     {
       rRange = r * (br/100.0);
       gRange = g * (br/100.0);
       bRange = b * (br/100.0);
     }
   }
   
   color getBaseColor()
   {
     return color(r, g, b);
   }
   
   color getColor()
   {
     // Calculate the color maps (Skip if starting colour is zero)
     nr = (r != 0) ? map(currFrame, 0, frameLength, r, r+rRange) : 0;
     ng = (g != 0) ? map(currFrame, 0, frameLength, g, g+gRange) : 0;
     nb = (b != 0) ? map(currFrame, 0, frameLength, b, b+bRange) : 0;

     currFrame++;
     currFrame %= frameLength;
     
     return color(nr, ng, nb);
   }
}