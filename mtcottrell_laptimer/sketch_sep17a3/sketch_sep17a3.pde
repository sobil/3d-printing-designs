/*
 *Autocross Laptimer/Sensor+Sender
 *Sep 2011
 *Simon Pilepich
 *simon.pilepich@gmail.com
 *
 *Arduino 1.0
 *
 *
 */
//Include Libraries
#include <Time.h>
#include <SPI.h>         
#include <Ethernet.h>
#include <Udp.h>
#include <SD.h>
#include <LiquidCrystal.h>
#define BUTTON_ADC_PIN           A0  // A0 is the button ADC input
#define LCD_BACKLIGHT_PIN         3  // D3 controls LCD backlight
#define RIGHT_10BIT_ADC           0  // right
#define UP_10BIT_ADC            145  // up
#define DOWN_10BIT_ADC          329  // down
#define LEFT_10BIT_ADC          505  // left
#define SELECT_10BIT_ADC        741  // right
#define BUTTONHYSTERESIS         10  // hysteresis for valid button sensing window
//return values for ReadButtons()
#define BUTTON_NONE               0  // 
#define BUTTON_RIGHT              1  // 
#define BUTTON_UP                 2  // 
#define BUTTON_DOWN               3  // 
#define BUTTON_LEFT               4  // 
#define BUTTON_SELECT             5  //
#define LCD_BACKLIGHT_OFF()     digitalWrite( LCD_BACKLIGHT_PIN, LOW )
#define LCD_BACKLIGHT_ON()      digitalWrite( LCD_BACKLIGHT_PIN, HIGH )
#define LCD_BACKLIGHT(state)    { if( state ){digitalWrite( LCD_BACKLIGHT_PIN, HIGH );}else{digitalWrite( LCD_BACKLIGHT_PIN, 
#define triggerPin 2
#define ledPin  13                  // LED connected to digital pin 13
#define buttonPin 2                 // button on pin 4

int value = LOW;                    // previous value of the LED
int buttonState;                    // variable to store button state
int lastButtonState;                // variable to store last button state
int blinking;                       // condition for blinking - timer is timing
long interval = 100;                // blink interval - change to suit
long previousMillis = 0;            // variable to store last time LED was updated
              int onTrack = 0;                        // variable to determine next vehicle
              long startTime[11] ;                    // start time for stop watch
              long elapsedTime[11] ;                  // elapsed time for stop watch
              int fractional;                     // variable used to store fractional part of time
              int running[11];                           //int to declare ready
              int waitingForNext;                        // variable to determine next vehicle

//pinMode(ledPin, OUTPUT);         // sets the digital pin as output



//Declare Default Global Variables 
unsigned int ntpPort = 8888;                          // local port to listen for UDP packets
unsigned int framePort = 63333;                       // local port to listen for UDP packets
unsigned int httpPort = 80;                           // local port to listen for UDP packets
byte mac[6];                                          //device MAC
byte ip[4];                                           //device ip
byte gateway[4];                                      //default gateway ip
byte timeServer[4];                                   //timeServer 
byte trackServer[4];                                  //trackServer
int triggerState;                                     //timer trigger stat
LiquidCrystal lcd(8, 9, 4, 5, 6, 7);
char stringSpace[100];
byte buttonJustPressed  = false;         //this will be true after a ReadButtons() call if triggered
byte buttonJustReleased = false;         //this will be true after a ReadButtons() call if triggered
byte buttonWas = BUTTON_NONE;   //used by ReadButtons() for detection of button events
byte buttonReady = BUTTON_NONE;
byte buttonReadyWas = BUTTON_NONE;


/*
 *Setup Function - Initialisation  from SD card
 */
void setup() {
  pinMode(ledPin, OUTPUT);         // sets the digital pin as output
  pinMode(buttonPin, INPUT);       // not really necessary, pins default to INPUT anyway
  digitalWrite(buttonPin, HIGH);   // turn on pullup resistors. Wire button so that press shorts pin to ground.
  pinMode( BUTTON_ADC_PIN, INPUT );         //ensure A0 is an input
  digitalWrite( BUTTON_ADC_PIN, LOW );      //ensure pullup is off on A0
  Serial.begin(9600);                                      //Open Serial
  lcd.begin(16, 2);                                        // set up the LCD's number of columns and rows: 
  if (!SD.begin(4)) {                                      //Open the SD card session
    diagOut(1,"");              
    //return;
  }
  else {
    ipAddr(readini("ip",stringSpace),ip);                              // Get ip
    ipAddr(readini("gateway",stringSpace),gateway);                    // Get gateway
    ipAddr(readini("trackServer",stringSpace),trackServer);           // Get mac
    ipAddr(readini("timeServer",stringSpace),timeServer);            // Get mac
    macAddr(readini("mac",stringSpace),mac);                           // Get mac
  }  
  Ethernet.begin(mac, ip, gateway);                        // start the Ethernet connection:
  Serial.println("Begining main/loop functio");
  menu();
}


/*TODO
 *Main Loop
 */
 void loop()
{
timing();
}


/*TODO
 *Timing Program
 */void timing()
{
/*  byte button;
  byte timestamp;

  //get the latest button pressed, also the buttonJustPressed, buttonJustReleased flags
  button = ReadButtons();
  //blank the demo text line if a new button is pressed or released, ready for a new label to be written
  if( buttonJustPressed || buttonJustReleased )
  {
    lcd.setCursor( 4, 1 );
    lcd.print( "            " );
  }
  //show text label for the button pressed
  switch( button )
  {
  case BUTTON_NONE:
    {
      break;
    }
  case BUTTON_RIGHT:
    {
      lcd.setCursor( 4, 1 );
      lcd.print( "RIGHT" );
      break;
    }
  case BUTTON_UP:
    {
      lcd.setCursor( 4, 1 );
      lcd.print( "UP" );
      break;
    }
  case BUTTON_DOWN:
    {
      lcd.setCursor( 4, 1 );
      lcd.print( "DOWN" );
      break;
    }
  case BUTTON_LEFT:
    {
      lcd.setCursor( 4, 1 );
      lcd.print( "LEFT" );
      break;
    }
  case BUTTON_SELECT:
    {
      lcd.setCursor( 4, 1 );
      lcd.print( "SELECT-FLASH" );    

      //SELECT is a special case, it pulses the LCD backlight off and on for demo
      //digitalWrite( LCD_BACKLIGHT_PIN, LOW );
      //delay( 150 );
      //digitalWrite( LCD_BACKLIGHT_PIN, HIGH );   //leave the backlight on at exit
      //delay( 150 );

      /* an example of LCD backlight control via macros with nice labels
       LCD_BACKLIGHT_OFF();
       delay( 150 );
       LCD_BACKLIGHT_ON();   //leave the backlight on at exit
       delay( 150 );
       */

      /*
        // an example of LCD backlight control via a macro with nice label, called with a value
       LCD_BACKLIGHT(false);
       delay( 150 );
       LCD_BACKLIGHT(true);   //leave the backlight on at exit
       delay( 150 );
       */
/*
      break;
    }
  default:
    {
      break;
    }
  }
  // print the number of seconds since reset (two digits only)
  timestamp = ( (millis() / 1000) % 100 );   //"% 100" is the remainder of a divide-by-100, which keeps the value as 0-99 even as the result goes over 100
  lcd.setCursor( 14, 1 );
  if( timestamp <= 9 )
    lcd.print( " " );   //quick trick to right-justify this 2 digit value when it's a single digit
  lcd.print( timestamp, DEC );
  /*  
   //debug/test display of the adc reading for the button input voltage pin.
   lcd.setCursor(12, 0);
   lcd.print( "    " );          //quick hack to blank over default left-justification from lcd.print()
   lcd.setCursor(12, 0);         //note the value will be flickering/faint on the LCD
   lcd.print( analogRead( BUTTON_ADC_PIN ) );
   */
  //clear the buttonJustPressed or buttonJustReleased flags, they've already done their job now.
/*  if( buttonJustPressed )
    buttonJustPressed = false;
  if( buttonJustReleased )
    buttonJustReleased = false;
*/
}
/*
 *Atartup Menu
 */
 
int menu() {
  byte button;
  int menuPos = 0;
  int menuSelected = 2;
  char m_menus[5][12] = {
  "1.Darts    ",
  "2.LoopTime ",
  "3.Set Time ",
  "4.Set Other",
  "5.Diag     "};
  lcd.println ("Select Menu Item");
  lcd.setCursor( 0, 1 );
  lcd.print("<");
  lcd.setCursor( 15, 1 );
  lcd.print(">");
  while (menuSelected != 1) { 
    //Serial.println("Stuck in menu");
    button = ReadButtons();
          delay(100);
    if ( button != BUTTON_NONE) {
      delay(100);
      Serial.println(button);
      
      switch( button ) {
        case BUTTON_NONE: {
          menuSelected = 0;
          break;
        }
        case BUTTON_RIGHT: {
          if (menuPos == 4) {
            menuPos = 0;
          }
          else {
            ++menuPos;
          }
          break;
        }
        case BUTTON_LEFT: {
          if (menuPos == 0) {
            menuPos = 4;
          }
          else {
            --menuPos;
          }
          break;
        }
        case BUTTON_SELECT: {
          menuSelected = 1;
          switch(menuPos) {
            case 0:{
              darts();
              break;
            }
            case 1:{
              while (LoopTime() == 1) {}
              break;
            }
            case 2:{
              darts();
              break;
            }
            case 3:{
              darts();
              break;
            }
            case 4:{
              darts();
              break;
            }
          }
        break;  
        }
      }
      lcd.setCursor( 1, 1 );
      lcd.print (m_menus[menuPos]);
    }
  }
  return menuPos;
}

/*
*Read value from ini config file
 */
char *readini(char *val, char *stringSpace) {
  Serial.print("Looking up value: ");
  Serial.print(val);
  Serial.print(".");
  File configFile = SD.open("cfg.ini");
  char lineStr[80] = {
    ""  };                                                                                // Create a char array for a line buffer
  char *result = NULL;                                                                    // A pointer to the string for strtok
  byte readByte;                                                                          // Byte buffer for character reading
  char delims[] = "=";                                                                    // Set the delimiters (just equals for the ini)
  int linePos = 0;                                                                        // Position register for line string
  while (configFile.available()) {                                                        // while we are not at the end of the file
    readByte = configFile.read();                                                         // grab a byte
    if (readByte != 10 && readByte != 13 && linePos < 81 && readByte != 59) {             // and while for each line(limited to 80 characters and stop at comments)
      lineStr[linePos] = readByte;                                                        // add string to line 
      linePos++;                                                                          // move to the next character slot
      Serial.print(".");  
    }
    else {                                                                                // When we get to the end of the line
      result = strtok( lineStr, delims );                                                 // grab the first 
      if( strcmp (result,val) == 0) {                                                     // if we have the requested value
        configFile.close();                                                               // Close the file
        stringSpace = (strtok( NULL, delims ));                                           // return a pointer to the appropriate string
        Serial.println(stringSpace);
        return stringSpace;
      }
      for (int i=0;i<80;i++) {                                                  
        lineStr[i] = NULL;                                                                // Reset the linebuffer to nothing
      }
      linePos = 0;                                                                        // Reset the linebuffer position
    }
  }
  configFile.close();                                                                     // Close the file If we find nothing.
  Serial.print(".  ");
  return NULL;   
}

/*
 * Rally Timing
 */
void darts() {
Serial.println("SELECTED SOMETHING");

}

/*TODO
 *Diagnostic function
 */
void diagOut(int i, char* msg) {                                                           // Diagnostic output routine **To DfsO**
  switch (i) {
  case 0:
    lcd.println(msg);
    break;
  default:
    Serial.println(i);
  }
}

/*
*Delimit and Modify and IP    
 */
void ipAddr(char *inputString, byte *modIP) {                                                                 
  char delims[] = ".";                                                        //set the delimiters
  char *result = NULL;                                                        //the pointer to the string for strtok
  int a = 0;                                                                  //set the current return string pos
  result = strtok( inputString, delims );                                     //grab the first section of the input string
  modIP[a] = byte(atoi(result));                                              //set the byte into the return string                            
  while (result != NULL) {                                                    //Until we get to the end of the string  && a < 3
    a++;                                                                      //increment the array positino
    result = strtok(NULL, delims );                                           //split the subsequent substrings
    if (result != 0) {
      modIP[a] = byte(atoi(result));                                          //set the byte into the return string
    }                               
  }
}


/*
*Delimit and Modify and MAC    
 */
void macAddr(char *inputString, byte *modMAC) {                          
  char delims[] = "-:";                                                                          //set the delimiters
  char *result = NULL;                                                                           //the pointer to the string for strtok
  int a = 0;                                                                                     //set the current return string pos
  result = strtok( inputString, delims );                                                        //grab the first section of the input string
  modMAC[a] = byte((ascHexToInt(result[0]) * 16)+(ascHexToInt(result[1])));                      //set the byte into the return string                            
  while (result != NULL) {                                                                       //Until we get to the end of the string  && a < 3
    a++;                                                                                         //increment the array positino
    result = strtok(NULL, delims );                                                              //split the subsequent substrings
    if (result != 0) {                                                                           //dont include null asci character (end lines)
      modMAC[a] = byte((ascHexToInt(result[0]) * 16)+(ascHexToInt(result[1])));                  //set the byte into the return string
    }                               
  }
}


/*
*Quick and dirty ascii hex convertor
 */
int ascHexToInt(char inStr) {
  if (inStr < 58 ) {                                                              //For ascii numbers
    return (inStr - 48);                                                          //Subtract 48 to get int value
  }
  else if (inStr < 71 ){                                                          //For Upper Case
    return (inStr - 55);                                                          //Subtract 48 to get int value
  }
  else {                                                                          //For Upper Case
    return (inStr - 87 );                                                         //Subtract 87 to get int value
  } 
}

/*
*Output to server via HTML
 */
void sendHTML(int anInt) {
  /*
  Serial.print("Connecting to track server - ");
   for (int i = 0;i < 4;i++) {
   Serial.print(int(trackServer[i]));
   Serial.print(".");
   }
   Serial.print(" : ");
   Client client(trackServer, 80);
   if (client.connect()) {
   Serial.println("connected");
   // Make a HTTP request:
   client.println("GET /index.html HTTP/1.0");
   client.println();
   delay(1000);
   while (client.available()) {
   char c = client.read();
   Serial.print(c);
   }
   // if the server's disconnected, stop the client:
   if (!client.connected()) {
   Serial.println();
   Serial.println("disconnecting.");
   client.stop();
   // do nothing forevermore:
   }
   } 
   else {
   // kf you didn't get a connection to the server:
   Serial.println("connection failed");
   return;
   }
   // if there are incoming bytes available 
   // from the server, read them and print them:
   */
}

/*
 * Analog Button Reading
 */
byte ReadButtons() {
  unsigned int buttonVoltage;                                                            //define
  byte button = BUTTON_NONE;                                                             //return no button pressed if the below checks don't write to btn
  buttonVoltage = analogRead( BUTTON_ADC_PIN );                                          //read the button ADC pin voltage
  if( buttonVoltage < ( RIGHT_10BIT_ADC + BUTTONHYSTERESIS ) ) {                         //sense if the voltage falls within valid voltage windows
    button = BUTTON_RIGHT;
  }
  else if(   buttonVoltage >= ( UP_10BIT_ADC - BUTTONHYSTERESIS )
    && buttonVoltage <= ( UP_10BIT_ADC + BUTTONHYSTERESIS ) ) {
    button = BUTTON_UP;
  }
  else if(   buttonVoltage >= ( DOWN_10BIT_ADC - BUTTONHYSTERESIS )
    && buttonVoltage <= ( DOWN_10BIT_ADC + BUTTONHYSTERESIS ) ) {
    button = BUTTON_DOWN;
  }
  else if(   buttonVoltage >= ( LEFT_10BIT_ADC - BUTTONHYSTERESIS )
    && buttonVoltage <= ( LEFT_10BIT_ADC + BUTTONHYSTERESIS ) ) {
    button = BUTTON_LEFT;
  }
  else if(   buttonVoltage >= ( SELECT_10BIT_ADC - BUTTONHYSTERESIS )
    && buttonVoltage <= ( SELECT_10BIT_ADC + BUTTONHYSTERESIS ) ) {
    button = BUTTON_SELECT;
  }                                                                                       //handle button flags for just pressed and just released events                   
  if( ( buttonWas == BUTTON_NONE ) && ( button != BUTTON_NONE ) ) {                       //the button was just pressed, set buttonJustPressed, this can optionally be used to trigger a once-off action for a button press event
    buttonJustPressed  = true;                                                            //it's the duty of the receiver to clear these flags if it wants to detect a new button change event
    buttonJustReleased = false;
  }
  if( ( buttonWas != BUTTON_NONE ) && ( button == BUTTON_NONE ) ) {
    buttonJustPressed  = false;
    buttonJustReleased = true;
  }
  buttonWas = button;                                                                     //save the latest button value, for change event detection next time round
  return( button );
}



int LoopTime()
{
  if (ReadButtons() != buttonReadyWas) {
    buttonReadyWas = ReadButtons();
    buttonReady = ReadButtons();
    //Serial.println("stuck there");
  }
  else {
    //Serial.println("stuck here");
    buttonReady = BUTTON_NONE;
  }
  if (buttonReady == BUTTON_UP){     //read if ready state pressed
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
    } 
  }
  if (buttonReady == BUTTON_SELECT){     // check if timer trigger pressed
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
    }
    
  }
  else{
    //lastReadyButtonState = readyButtonState;               // store readyButtonState in lastReadyButtonState, to compare next time
    //lastButtonState = buttonState;                         // store buttonState in lastButtonState, to compare next time
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
return 1;
}
