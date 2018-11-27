/***************************************************
  This is a library for the Adafruit 1.8" SPI display.

This library works with the Adafruit 1.8" TFT Breakout w/SD card
  ----> http://www.adafruit.com/products/358
The 1.8" TFT shield
  ----> https://www.adafruit.com/product/802
The 1.44" TFT breakout
  ----> https://www.adafruit.com/product/2088
as well as Adafruit raw 1.8" TFT display
  ----> http://www.adafruit.com/products/618

  Check out the links above for our tutorials and wiring diagrams
  These displays use SPI to communicate, 4 or 5 pins are required to
  interface (RST is optional)
  Adafruit invests time and resources providing this open source code,
  please support Adafruit and open-source hardware by purchasing
  products from Adafruit!

  Written by Limor Fried/Ladyada for Adafruit Industries.
  MIT license, all text above must be included in any redistribution
 ****************************************************/
#include <math.h>
#include <Adafruit_GFX.h>    // Core graphics library
#include <Adafruit_ST7735.h> // Hardware-specific library
#include <SPI.h>


// For the breakout, you can use any 2 or 3 pins
// These pins will also work for the 1.8" TFT shield
#define TFT_CS     10
#define TFT_RST    16  // you can also connect this to the Arduino reset
                      // in which case, set this #define pin to 0!
#define TFT_DC     17

// Option 1 (recommended): must use the hardware SPI pins
// (for UNO thats sclk = 13 and sid = 11) and pin 10 must be
// an output. This is much faster - also required if you want
// to use the microSD card (see the image drawing example)
Adafruit_ST7735 tft = Adafruit_ST7735(TFT_CS,  TFT_DC, TFT_RST);

// Option 2: use any pins but a little slower!
#define TFT_SCLK 13   // set these to be whatever pins you like!
#define TFT_MOSI 11   // set these to be whatever pins you like!
//Adafruit_ST7735 tft = Adafruit_ST7735(TFT_CS, TFT_DC, TFT_MOSI, TFT_SCLK, TFT_RST);


 int sw = 0;
 int m0001 = 1;
 int m0010 = 2;
 int m0100 = 3;
 int m1000 = 4;
 int p0001 = 6;
 int p0010 = 5;
 int p0100 = 8;
 int p1000 = 7;
 int swv = 0;
 
 int breakl = 0;
 int incold = 0;

 
 int writee = 0;
 int inc = 0;
 int ledi1 = 0;
 int ledi2 = 0;
 int ledc = 0;
 
 unsigned long previousMillis = 0;

 unsigned long currentMillis = 6;

 unsigned long difff = 6;
 String ledi1s = "0";
 String ledi2s = "0";


void setup(void) {
   pinMode (sw,INPUT_PULLUP);

   pinMode (m0001,INPUT_PULLUP);
   pinMode (m0010,INPUT_PULLUP);
   pinMode (m0100,INPUT_PULLUP);
   pinMode (m1000,INPUT_PULLUP);

   pinMode (p0001,INPUT_PULLUP);
   pinMode (p0010,INPUT_PULLUP);
   pinMode (p0100,INPUT_PULLUP);
   pinMode (p1000,INPUT_PULLUP);
   
// Use this initializer if you're using a 1.8" TFT
  tft.initR(INITR_BLACKTAB);   // initialize a ST7735S chip, black tab
    

   analogWriteResolution(12);
   analogWrite(A21, ledi1);
   analogWrite(A22, ledi2);

  tft.fillScreen(ST7735_BLACK);
  tft2LEDTextTest();


}

void loop() { 
   swv = digitalRead(sw);
   inc = 0;
   breakl = 0;
   inc = inc - !digitalRead(m0001);
   inc = inc + !digitalRead(p0001);
   inc = inc - 10 * !digitalRead(m0010);
   inc = inc + 10 * !digitalRead(p0010);
   inc = inc - 100 * !digitalRead(m0100);
   inc = inc + 100 * !digitalRead(p0100);
   inc = inc - 1000 * !digitalRead(m1000);
   inc = inc + 1000 * !digitalRead(p1000);
   currentMillis = millis();  
   
   if (inc == incold) {
      breakl = 1;
   }

   currentMillis = millis();   
   difff = currentMillis-previousMillis;

   if (difff < 100) {
      breakl = 1;
   }

   if (breakl == 0) {
    
   previousMillis = currentMillis;
   incold = inc;
   if (swv == 0) {
     ledc = ledi1;
   }
   else {
     ledc = ledi2;    
   }

   ledc = ledc + inc;
   
   // Don't overflow
   if (ledc > 4095) {
         ledc = 4095;
   }
   if (ledc < 0) {         
         ledc = 0;
   }
   
   
   if (swv == 0) {
     if (ledc == ledi1) {
     }
     else {
        analogWrite(A21, ledc);
        ledi1 = ledc;
        writee = 1;
     }
   }
   else {
     if (ledc == ledi2) {
     }
     else {
        analogWrite(A22, ledc);
        ledi2 = ledc;
        writee = 1;
     }
   }

    if (writee == 1){
             ledi1s = String(ledi1);
             ledi2s = String(ledi2);
             tft2LEDTextTest();
             writee = 0;
    }
   
   }

}





void tft2LEDTextTest() {

  tft.setTextWrap(false);
  
  tft.fillRect(0,0,127,159,ST7735_BLACK);
  tft.setCursor(0, 0);
  tft.setTextColor(ST7735_GREEN);
  tft.setTextSize(3);
  tft.println(" ");
  tft.println("340 nm");
  tft.println(ledi1s);  
  tft.println(" ");
  tft.setTextColor(ST7735_RED);
  tft.setTextSize(3);
  tft.println("420 nm");
  tft.println(ledi2s);  

}

