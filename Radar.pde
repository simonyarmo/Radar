import processing.serial.*;

Serial myPort;
String val; // Data received from the serial port
int angle = 0; // Angle for the sweep line
HashMap<Integer, Float> detections = new HashMap<Integer, Float>(); // Store detection angles and distances
HashMap<Integer, Integer> detectionTimes = new HashMap<Integer, Integer>(); // Store detection times for fading
int fadeTime = 2000; // Time in milliseconds for a dot to fade
int lastDetectionTime = 0; // Time when the last object was detected
int detectionDelay = 2000; // Delay in milliseconds before reading another data point
int flag =0;

void setup() {
  size(600, 600);
  println(Serial.list()); // Print available serial ports
  myPort = new Serial(this, "/dev/cu.usbserial-10", 9600);
  myPort.bufferUntil('\n');
}

void draw() {
  background(0); // Clear screen for each draw iteration
  drawRadar(); // Draw static parts of the radar
  
  if(angle==180){
    flag =1;
  }
  if(angle ==0){
    flag =0;
}
  if (flag==0){
    angle = (angle + 1);
  }
  if(flag ==1){
    angle = angle-1;
  }
   // Increment angle for the continuous sweep and loop back to 0 after reaching 360
  
  drawSweepLine(angle); // Update the sweep line according to the latest angle
  drawDetections(); // Draw and manage detections
}

void drawRadar() {
  // Radar drawing logic remains unchanged
  pushMatrix();
  translate(width / 2, height / 2); // Move the origin to the center of the window
  stroke(0, 255, 0);
  noFill();
  // Draw concentric circles
  for (int i = 100; i <= 500; i += 100) {
    ellipse(0, 0, i, i);
  }
  // Draw radial lines
  for (int i = 0; i < 360; i += 45) {
    float x = cos(radians(i)) * 250;
    float y = sin(radians(i)) * 250;
    line(0, 0, x, y);
  }
  popMatrix();
}

void drawSweepLine(int ang) {
  pushMatrix();
  translate(width / 2, height / 2);
  rotate(radians(ang - 90)); // Adjusting by 90 degrees to align with 0 degrees at the top
  stroke(255, 0, 0); // Red line for the sweep
  line(0, 0, 250, 0); // Draw line from center outward
  popMatrix();
}

void drawDetections() {
  // Detections drawing logic remains unchanged
  pushMatrix();
  translate(width / 2, height / 2);
  int currentTime = millis();
  detections.entrySet().removeIf(entry -> currentTime - detectionTimes.get(entry.getKey()) > fadeTime); // Remove old detections
  for (Integer ang : detections.keySet()) {
    float dist = detections.get(ang);
    int timeSinceDetected = currentTime - detectionTimes.get(ang);
    float alpha = map(timeSinceDetected, 0, fadeTime, 255, 0); // Fade effect
    fill(255, 0, 0, alpha);
    noStroke();
    float x = cos(radians(ang - 90)) * dist * (250.0 / 200.0); // Assuming 200 is max distance
    float y = sin(radians(ang - 90)) * dist * (250.0 / 200.0);
    ellipse(x, y, 10, 10); // Draw detection dot
     }
  popMatrix();
}

void serialEvent(Serial myPort) {
  val = myPort.readStringUntil('\n');
  if (val != null) {
    val = trim(val); // Update 'val' with the latest complete data received
    String[] parts = val.split(",");
    if (parts.length == 2) {
      // int newAngle = int(parts[0]); // Commented out to stop direct angle updates from serial data
      float newDistance = float(parts[1]);
      
      // You can still process newDistance here if needed
      
      // Logic to add new detections can remain here, but without updating 'angle'
      int currentTime = millis();
      if (newDistance > 0 && currentTime - lastDetectionTime > detectionDelay) {
          detections.put(angle, newDistance); // Use current sweeping angle for detection
          detectionTimes.put(angle, currentTime); // Update detection time
          lastDetectionTime = currentTime; // Reset the last detection time
      }
    }
  }
}
