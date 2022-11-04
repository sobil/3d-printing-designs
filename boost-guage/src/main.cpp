

#include <U8glib.h>
#include <EEPROM.h>

// U8GLIB_SSD1306_128X64 u8g(U8G_I2C_OPT_NONE);

// average for fuel consumption
const byte AVERAGESIZE = 128;

#define OFFSET 3
#define U2_RXD 17
#define U2_TXD 16


// clear buffer
// add pretty name to buffer
// request value from ecu
// put value
// parse data from ecu
// determine value calulation
//



byte rx[3];
byte mode;
byte count = 0;

void ECU_Stop()
{
  byte txbuf[4] = {0x12, 0x00, 0x00, 0x00};
  Serial2.write(txbuf[0]);
  Serial2.write(txbuf[1]);
  Serial2.write(txbuf[2]);
  Serial2.write(txbuf[3]);
  delay(50);
  Serial2.flush();
}

// read form ecu
// negative means error

int ecu_read(unsigned int addr)
{
  byte txbuf[4] = {0x78, addr >> 8, addr & 0xFF, 0x00};

  ECU_Stop();
  // while (Serial2.read() >= 0);

  Serial2.write(txbuf[0]);
  Serial2.write(txbuf[1]);
  Serial2.write(txbuf[2]);
  Serial2.write(txbuf[3]);

  delay(50);

  Serial2.flush(); // wait to complete tx
  char response[3] = {0};

  int num = Serial2.readBytes(response, 3);
  rx[0] = response[0];
  rx[1] = response[1];
  rx[2] = response[2];

  if (num != 3)
    return -1;
  if (response[0] == (addr >> 8) & 0xff && response[1] == (char)addr & 0xFF)
    return (byte)response[2];
  
}

// read ecu rom id
// for example (hex) 72 32 A5
boolean ECU_GetROMID(byte *buffer)
{
  char readCmd[4] = {0x78, 0x00, 0x00, 0x00};
  char romidCmd[4] = {0x00, 0x46, 0x48, 0x49};
  char romid[3] = {0};

  ECU_Stop();
  while (Serial2.read() >= 0)
    ;

  //  Serial2.write(readCmd[0]);
  //  Serial2.write(readCmd[1]);
  //  Serial2.write(readCmd[2]);
  //  Serial2.write(readCmd[3]);
  ecu_read(0x1337);

  int retries = 0;
  while (retries < 8)
  {

    Serial2.write(romidCmd[0]);
    Serial2.write(romidCmd[1]);
    Serial2.write(romidCmd[2]);
    Serial2.write(romidCmd[3]);

    int nbytes = Serial2.readBytes(romid, 3);

    if ((nbytes == 3) && (romid[0] != 0x00))
      break;
    ++retries;
  }
  // ECU_Stop();

  buffer[0] = romid[0];
  buffer[1] = romid[1];
  buffer[2] = romid[2];

  if (romid[0] == 0x00)
  {
    return false;
  }

  return true;
}

void setup(void){
  // set baudrate and parity
  Serial2.begin(1953, SERIAL_8E1, U2_RXD, U2_TXD);
  Serial.begin(9600, SERIAL_8N1);
}
// pinMode( button_pin, INPUT_PULLUP );

// // mode = EEPROM.read( EEPROM_MODE );

// //if ( !digitalRead( button_pin) )
// {
// //  display rom id
//   u8g.firstPage();
//   do {

//   u8g.setFont(u8g_font_fub11);
//   u8g.setPrintPos(OFFSET, 11);
//    u8g.print("*Online");
//    if (ECU_GetROMID(rx))
//   {
//     u8g.setPrintPos( OFFSET, 25);

//     u8g.print(rx[0], 16);
//     u8g.print(rx[1], 16);
//     u8g.print(rx[2], 16);
//   }

//   } while( u8g.nextPage() );

// delay(2000);
// }

void loop(void)
{
  Serial.println("READING:");
  Serial.print("02::");
  Serial.println(ecu_read(0x1310));
  Serial.print("temp:");
  Serial.println(ecu_read(0x1337));
  Serial.print("a/f trim:");
  Serial.println(ecu_read(0x133e));
  Serial.print("vbatt:");
  Serial.println(ecu_read(0x1335));
  Serial.print("speed*2:");
  Serial.println(ecu_read(0x1336));
  Serial.print("AFM *5/256:");
  Serial.println(ecu_read(0x1307));
  Serial.print("thr *5/256:");
  Serial.println(ecu_read(0x1329));
  Serial.print("switches:");
  Serial.println(ecu_read(0x1344));
  Serial.print("timing retard:");
  Serial.println(ecu_read(0x1328));
  Serial.print("inj pulse *256/1000:");
  Serial.println(ecu_read(0x1306));
  Serial.print("Speed:");
  Serial.println(ecu_read(0x1336));
  Serial.print("RPM:");
  Serial.println(ecu_read(0x1338));
}