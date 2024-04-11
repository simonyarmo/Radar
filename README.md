# Radar
I built a functioning radar
This was a personal project of mine. I used a arduino infrared sensor and a servro motor. 
I programmed the motor to complete a 180 degree loop while the infrared sensor was constantly collecting data. 
At each degree turned the program would send the motors angles and the distance captured by the infrared sensor to a processing program.
Here the processing program draws the radar map and outputs the pysical layout. The radar uses the motors angle to produce a sweeping line. 
To produce an output to the map, the program is constantly checking the infrared sensor's distance. If the distance decreases by a drastic amount the program places a dot on the map. Using the radars angle and the infrared's distance to find the exact spot.


**Materials**
For materials I used a bread board, arduino microcontroller, arduino infrared sensor and a servro motor. To put the pieces together I used a old plastic bag container to hold the wiring. I cut a small hole in the top to fit the motor and sensor through. To keep everything in place I used tape to secure it in place. 
