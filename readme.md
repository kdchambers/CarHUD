Car Heads Up Display

This is a Processing 3.x program that displays a simple HUD for a car with some interactivity. The user will be able to see the speed, rpm, oil level and temperature of the car as well as being able to toggle different buttons such as indicators and various lights. All buttons in the program are responsive and will pulse a colour when activated. 

The program has been build with reusability and modularity in mind, so although the display is pretty basic most of the main componants can be 'configured' to allow for different uses.

The best example of this is the Speedometer class which has the following options that can be specified before the render() method is called: 

+ Whether the module uses the clockwise or anti-clockwise system
+ What the base starting angle is(What angle corresponeds to 0 degrees inside the module)
+ Set start speed value(What is the starting integer on the speedometer)
+ Set the sizes for all the borders(Unlimited amount of borders can be specified)
+ What colours each border will be
+ A gradient can be passed in to colour the notches of the speedometer as well as a solid colour for all
+ Whether each alternate notch will be shortened to look more like a typical speedometer
+ Whether a custom set of strings should be used instead of numbers between a certain range
+ The distance from the notch labels (E.g speed string) and their corresponding notches
+ The beginining and ending angle for the notches 
+ Length and colour of speedometer needle
+ Colour of the inner and outer gauges
+ Size/radius of the speedometer
+ Stroke weight of the notches
+ More

Any values that are not specified by the user of the module are given smart default values so that the modules is both highly customisable yet easy to use.

Different objects work together to achieve a certain effect, for example the brightnessPulse object is used to generate colours for other objects to model a pulsing. Different buttons share simple communications such as the hazard light and the indicator lights. The hazard light turns on both the indicator lights but other than this instance both indicator lights will never be on at the same time. Clicking one will cause the program to check whether the other is active and set it to unactive if needed.





