#include <FastLED.h>

#define LED_PIN     7
#define NUM_LEDS    33
#define BUTTON_PIN  2
#define BRIGHTNESS  255
#define FRAMES_PER_SECOND  120

CRGB leds[NUM_LEDS];
int mode = 0; // Variable to keep track of the current mode

// For the breathing effect
unsigned long prevMillis = 0;
int breatheDirection = 1;
int currentBrightness = 0;

void setup() {
  FastLED.addLeds<WS2812, LED_PIN, GRB>(leds, NUM_LEDS);
  FastLED.setBrightness(BRIGHTNESS); // Set the brightness here
  FastLED.setMaxPowerInVoltsAndMilliamps(5, 500); // Optional: Limit power usage if powered from Arduino
  
  pinMode(BUTTON_PIN, INPUT_PULLUP);
}
void loop() {
  static int lastButtonState = HIGH; 
  int currentButtonState = digitalRead(BUTTON_PIN);

  if (lastButtonState == HIGH && currentButtonState == LOW) {
    mode = (mode + 1) % 4; // Cycle through 4 modes
    delay(50); // Debounce delay
  }
  lastButtonState = currentButtonState;

  switch(mode) {
    case 0:
      // Mode 0: Stable light
      fill_solid(leds, NUM_LEDS, CRGB(250, 40, 0));
      FastLED.show();
      break;
    case 1:
      // Mode 1: All LEDs off
      fill_solid(leds, NUM_LEDS, CRGB::Black);
      FastLED.show();
      break;
    case 2:
      // Mode 2: Breathing effect
      if(millis() - prevMillis > 15) { // Update every 15 milliseconds
        prevMillis = millis();
        currentBrightness += breatheDirection * 5; // Change the rate if needed
        if(currentBrightness <= 0 || currentBrightness >= 255) {
          breatheDirection *= -1; // Change direction
          currentBrightness += breatheDirection * 5;
        }
        fill_solid(leds, NUM_LEDS, CHSV(20, 255, currentBrightness));
        FastLED.show();
      }
      break;
    case 3:
      // Mode 3: Rainbow effect
      static uint8_t hue = 0;
      fill_rainbow(leds, NUM_LEDS, hue++, 7); // Change '7' to alter the spread of the rainbow
      FastLED.show();
      break;
  }

  FastLED.delay(1000 / FRAMES_PER_SECOND); // Maintain a constant frame rate
}
