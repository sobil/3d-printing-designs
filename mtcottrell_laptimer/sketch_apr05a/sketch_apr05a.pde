/* Autocross Laptimer
 * Simon Pilepich 2010
 * Based on stopwatch by
 * Paul Badger 2008
 * Demonstrates using millis(), pullup resistors, 
 * making two things happen at once, printing fractions
 *
 * Physical setup: momentary switch connected to pin 4, other side connected to ground
 * LED with series resistor between pin 13 and ground
 */
#include <LiquidCrystal.h>

// initialize the library with the numbers of the interface pins
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);

#define ledPin  13                  // LED connected to digital pin 13
#define buttonPin 6                 // button on pin 4
#define readyPin 7                 // button on pin 4

int value = LOW;                    // previous value of the LED
int buttonState;                    // variable to store button state
int lastButtonState;                // variable to store last button state
int readyButtonState;               // variable to store ready button state
int lastReadyButtonState;           // variable to store last ready button state
int blinking;                       // condition for blinking - timer is timing
long interval = 100;                // blink interval - change to suit
long previousMillis = 0;            // variable to store last time LED was updated
long startTime[11] ;                    // start time for stop watch
long elapsedTime[11] ;                  // elapsed time for stop watch
int fractional;                     // variable used to store fractional part of time
int running[11];                           //int to declare ready
int onTrack = 0;                        // variable to determine next vehicle
int waitingForNext;                        // variable to determine next vehicle




void setup()
{
   Serial.begin(9600);
   lcd.begin(16, 2);
   pinMode(ledPin, OUTPUT);         // sets the digital pin as output

   pinMode(buttonPin, INPUT);       // not really necessary, pins default to INPUT anyway
   pinMode(readyPin, INPUT);       // not really necessary, pins default to INPUT anyway
   digitalWrite(buttonPin, HIGH);   // turn on pullup resistors. Wire button so that press shorts pin to ground.
   digitalWrite(readyPin, HIGH);   // turn on pullup resistors. Wire button so that press shorts pin to ground.
   Serial.print("INIT");

}

void loop()
{
  delay(50);  
  readyButtonState = digitalRead(readyPin);
  buttonState = digitalRead(buttonPin);
  if (readyButtonState == LOW && lastReadyButtonState == HIGH){     //read if ready state pressed
    if (onTrack > 9) {                 //check for car limit
      Serial.println("Too Many Cars On Track");
      lcd.setCursor(0, 1);
      lcd.print("Too Many Cars   ");
    }
    else if (running[onTrack] != true && onTrack != 0) {                 //check for double ready
      Serial.println("Allready Waiting for Car");
    }
    else {  
      onTrack = onTrack + 1;
      waitingForNext = true;
      Serial.print("Ready for ");
      Serial.print(onTrack);
      Serial.println("car(s) on track..... GO!");
      lcd.setCursor(0, 1);
      lcd.print("Ready for ");
      lcd.print(onTrack);
      lcd.print(" car");
      if (onTrack > 1) lcd.print("s");

      lastReadyButtonState = readyButtonState;
    } 
  }
  if (buttonState == LOW && lastButtonState == HIGH){     // check if timer trigger pressed
    if (waitingForNext == false) { //Check if ready for Next Car
      if (running[onTrack] == false) {                       //check if any car ready
        Serial.println("Not Ready For Car");
      }
      else {
        
        Serial.println("Car completed run");
        lcd.setCursor(0, 0);
        lcd.print("                ");
        lcd.setCursor(9, 0);
        elapsedTime[1] =   millis() - startTime[1];              // store elapsed time
        blinking = false;                                  // turn off blinking, all done timing
        lastButtonState = buttonState;                     // store buttonState in lastButtonState, to compare next time

        // routine to report elapsed time 
        Serial.print( (int)(elapsedTime[1] / 1000L));         // divide by 1000 to convert to seconds - then cast to an int to print
        lcd.print((int)(elapsedTime[1] / 1000L));
        Serial.print(".");                             // print decimal point
        lcd.print(".");
        // use modulo operator to get fractional part of time 
        fractional = (int)(elapsedTime[1] % 1000L);

       // pad in leading zeros - wouldn't it be nice if 
       // Arduino language had a flag for this? :)
       if (fractional == 0) {
          Serial.print("000");      // add three zero's
          lcd.print("000");
       }
       else if (fractional < 10){    // if fractional < 10 the 0 is ignored giving a wrong time, so add the zeros
          lcd.print("00");
          Serial.print("00");       // add two zeros
       }
       else if (fractional < 100) {
          lcd.print("0");
          Serial.print("0");        // add one zero
       }
       Serial.println(fractional);  // print fractional part of time 
       lcd.print(fractional);
         for (int i=0; i <= 10; i++){
            startTime[i] = startTime[i + 1];
         }
       
       
       
        running[onTrack] = false;
        onTrack = onTrack -1;
        
        Serial.print(onTrack);
        Serial.println("car on Track");
        lcd.setCursor(0, 1);
        lcd.print(onTrack);
        lcd.print(" cars on Track      ");
      }
    }
    else {
      running[onTrack] = true;
      waitingForNext = false;
      Serial.print(onTrack);
      Serial.println("car on Track");
      lcd.setCursor(0, 1);
      lcd.print(onTrack);
      lcd.print(" car on Track   ");
      startTime[onTrack] = millis();                                   // store the start time
      blinking = true;                                     // turn on blinking while timing
      lastButtonState = buttonState;                          // store buttonState in lastButtonState, to compare next time
      lastButtonState = buttonState;                         // store buttonState in lastButtonState, to compare next time
    }
    
  }
  else{
    
    lastReadyButtonState = readyButtonState;               // store readyButtonState in lastReadyButtonState, to compare next time
    lastButtonState = buttonState;                         // store buttonState in lastButtonState, to compare next time
  }

   // blink routine - blink the LED while timing
   // check to see if it's time to blink the LED; that is, the difference
   // between the current time and last time we blinked the LED is larger than
   // the interval at which we want to blink the LED.

   if ( (millis() - previousMillis > interval) ) {

      if (blinking == true){
         previousMillis = millis();                         // remember the last time we blinked the LED

         // if the LED is off turn it on and vice-versa.
         if (value == LOW)
            value = HIGH;
         else
            value = LOW;
         digitalWrite(ledPin, value);
      }
      else{
         digitalWrite(ledPin, LOW);                         // turn off LED when not blinking
      }
   }
   lcd.setCursor(0, 0);
   if ((onTrack > 0 && waitingForNext == false) || onTrack > 1) {
        lcd.setCursor(0, 0);
        elapsedTime[1] =   millis() - startTime[1];              // store elapsed time
        lcd.print((int)(elapsedTime[1] / 1000L));
        lcd.print(".");
        // use modulo operator to get fractional part of time 
        fractional = (int)(elapsedTime[1] % 1000L);
       if (fractional == 0) {
          lcd.print("000");
       }
       else if (fractional < 10){    // if fractional < 10 the 0 is ignored giving a wrong time, so add the zeros
          lcd.print("00");
       }
       else if (fractional < 100) {
          lcd.print("0");
       }
       lcd.print(fractional);
   }
  else {
    lcd.print("000.000");
  }

}
