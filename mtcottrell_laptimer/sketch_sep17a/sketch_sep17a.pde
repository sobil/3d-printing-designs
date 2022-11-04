/*
 *Autocross Laptimer/Sensor+Sender
 *Sep 2011
 *Simon Pilepich
 *simon.pilepich@gmail.com
 */
//Include Libraries
#include <Time.h>
#include <SPI.h>         
#include <Ethernet.h>
#include <Udp.h>
#include <SD.h>
#include <LiquidCrystal.h>

//Declare Default Global Variables 
unsigned int ntpPort = 8888;                          // local port to listen for UDP packets
unsigned int framePort = 63333;                       // local port to listen for UDP packets
unsigned int httpPort = 80;                           // local port to listen for UDP packets
byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };  //default MAC
byte ip[] = { 192,168,1,2 };                          //default ip
byte timeServer[] = { 192, 43, 244, 18 };             //time.nist.gov NTP server
const int NTP_PACKET_SIZE= 48;                        // NTP time stamp is in the first 48 bytes of the message
byte packetBuffer[ NTP_PACKET_SIZE];                  //buffer to hold incoming and outgoing packets 
String configFileName="config.ini";                   //config file name to draw from sd card
File configFile;                                      //config file to draw from sd card
int triggerState;                                     //timer trigger state
long interval = 100;                                  // blink interval - change to suit
long previousMillis = 0;                              // variable to store last time LED was updated
long startTime;                                       // start time for stop watch
long elapsedTime;                                     // elapsed time for stop watch


/*TODO
 *Start Program
 */
void setup() {
  Serial.begin(9600);
  
  //Print out a description
  diagOut("Autocross Laptimer/Sensor+Sender V0.1");
  diagOut("*Sep 2011");
  diagOut("*Simon Pilepich");
  diagOut("*simon.pilepich@gmail.com");
  
  
  //Open the SD card session and call function to open then read settings from the config file if possible
  if (!SD.begin(4)) {
    diagOut("SD initialisation failed!");
    return;
  }
  else {
    configFile = SD.open(configFileName.toCharArray());
    if (configFile) {
      toByteArray()
    }
    else {
      diagOut("Cannot Read File");
    }
    configFile.close();
  }
  
  //Start Ethernet after reading config file
  Ethernet.begin(mac,ip);
  Udp.begin(ntpPort);
  
  
}

/*TODO
 *Main Program
 */
void loop() {
}

/*
*Read value from ini config file
*/
String readini(String val) {
  String aString = "";                                                                                   // temporary string space   
  int aByte;                                                                                             // temporary byte/int space
  while (configFile.available()) {                          
    aByte = configFile.read();                                                                           // run through file, 1 char at a time
    if (aByte == 10 || aByte == 13) {                                                                    // break for eval at each line break
      if (aString.length() != 0 && aString.charAt(0) != ';' && aString.charAt(0) != '[') {               // ignore null lines, comments and headings
        if (aString.substring(0,aString.indexOf('=')) == val) {                                          // compare current line with lookup 
          return aString.substring(aString.indexOf('=') + 1,aString.length());                           // return value
        }
      }
      aString = "";                                                                                      //reset the temp string 
    }
    else {
      aString = aString + byte(aByte);
    }
  }
  // close the file:

}

Stri






/*
*Output time Values
*/

/*TODO
 *Send time signal out on serial port
 */
int serialsendframe() {
}

/*TODO
 *Send time signal out as multicast ethernet frame
 */
int mnetsendframe() {
}

/*TODO
 *Send time signal out as html post
 */
int htmlpostframe() {
}

/*TODO
*Send time signal out to display
*/
int lcddisplayframe() {
}

/*TODO
*Send time signal out to display
*/
int logtosdcard() {
}


void diagOut(String diagMSG) {
  Serial.println(diagMSG);
}

