   unsigned long previousMillis=0;
   unsigned long currentMillis = 6;
   unsigned int version_ = 2;
   
   // pin on which to receive the trigger (2 and 3 can be used with interrupts, although this code does not use interrupts)
   int inPin_ = 2;
   // to read out the state of inPin_ faster, use 
   int inPinBit_ = 1 << inPin_;  // bit mask 
   
   
   // pin connected to DIN of TLV5618
   int dataPin = 3;
   // pin connected to SCLK of TLV5618
   int clockPin = 4;
   // pin connected to CS of TLV5618
   int latchPin = 5;

   const int SEQUENCELENGTH = 12;  // this should be good enough for everybody;)
   byte triggerPattern_[SEQUENCELENGTH] = {0,0,0,0,0,0,0,0,0,0,0,0};
   unsigned int triggerDelay_[SEQUENCELENGTH] = {0,0,0,0,0,0,0,0,0,0,0,0};
   int patternLength_ = 0;
   byte repeatPattern_ = 0;
   volatile int triggerNr_; // total # of triggers in this run (0-based)
   volatile int sequenceNr_; // # of trigger in sequence (0-based)
   int skipTriggers_ = 0;  // # of triggers to skip before starting to generate patterns
   byte currentPattern_ = 0;
   const unsigned long timeOut_ = 1000;
   bool blanking_ = false;
   bool blankOnHigh_ = false;
   bool triggerMode_ = false;
   boolean triggerState_ = false;

   int toggleState = 0;    
   int sensorwasLow = 1;

//output pins
   int fluoPin_ = 18;
   int bfPin_ = 19;
// input pins
   int forceswitchPin_ = 20;
   int camexposurePin_ = 21;
   int footswitchPin_ = 22;
   int shutterPin_ = 23;


   // mode controlled by umanager
   int mode1Pin_ = 8;
   int mode2Pin_ = 9;
   int mode4Pin_ = 10;
   int mode8Pin_ = 11;
   int mode16Pin_ = 12;   
   int mode32Pin_ = 13;   
   
   int modeVal = 0;
   int sensorVal = 0; 
   int fluoVal = 0;
   int bfVal = 0;
 
 void setup() {
   // Higher speeds do not appear to be reliable
   Serial.begin(57600);
  
   pinMode(inPin_, INPUT);
   pinMode (dataPin, OUTPUT);
   pinMode (clockPin, OUTPUT);
   pinMode (latchPin, OUTPUT);
   pinMode(mode1Pin_, OUTPUT);
   pinMode(mode2Pin_, OUTPUT);
   pinMode(mode4Pin_, OUTPUT);
   pinMode(mode8Pin_, OUTPUT);
   pinMode(mode16Pin_, OUTPUT);
   pinMode(mode32Pin_, OUTPUT);
   pinMode(fluoPin_, OUTPUT); //FLUO
   pinMode(bfPin_, OUTPUT); //BF 
   
   pinMode(camexposurePin_, INPUT); //CAMERA FRAME EXPOSURE
   pinMode(footswitchPin_, INPUT); //FOOT SWITCH
   pinMode(forceswitchPin_, INPUT); //FORCE SWITCH
   pinMode(shutterPin_, INPUT); //EXTERNAL SHUTTER CONTROL
 
   digitalWrite(latchPin, HIGH);   
 }
 
 void loop() {

   modeVal = 0;
   modeVal += digitalRead(mode1Pin_);
   modeVal += 2*digitalRead(mode2Pin_);
   modeVal += 4*digitalRead(mode4Pin_);
   modeVal += 8*digitalRead(mode8Pin_);
   modeVal += 16*digitalRead(mode16Pin_);
   modeVal += 32*digitalRead(mode32Pin_);
   
   switch (modeVal) {
     case 0: //umanager off -> external control of fluorescence!
        fluoVal = digitalRead(shutterPin_);
        digitalWrite(bfPin_, LOW);
        digitalWrite(fluoPin_, fluoVal);
        break;
     case 1: //Cont BF with umanager 
        digitalWrite(bfPin_, HIGH);
        digitalWrite(fluoPin_, LOW);
        break;
     case 2: //Cont Fluo with umanager
        digitalWrite(bfPin_, LOW);
        digitalWrite(fluoPin_, HIGH);
        break;
     case 3: //pulsed BF with cont Fluo foot
        currentMillis = millis();
        if ((unsigned long)(currentMillis - previousMillis) >= 5) {
          fluoVal = digitalRead(footswitchPin_);
          previousMillis = currentMillis;
        }
        if (fluoVal == HIGH) {
          digitalWrite(bfPin_, LOW);
          digitalWrite(fluoPin_, HIGH);
        }
        else {
          sensorVal = digitalRead(camexposurePin_);
          if (sensorVal == HIGH) {
            if (sensorwasLow == 1) {
              sensorwasLow = 0;
              digitalWrite(fluoPin_, LOW);
              delay(25);
              digitalWrite(bfPin_, HIGH);
              delay(25);
              digitalWrite(bfPin_, LOW);
            }
          }
          else {
            sensorwasLow = 1;
            digitalWrite(bfPin_, LOW);
            digitalWrite(fluoPin_, LOW);
          }            
        } 
        break;
     case 4: //alternating BF / FLUO       10 Hz
        currentMillis = millis();
        if ((unsigned long)(currentMillis - previousMillis) >= 5) {
          fluoVal = digitalRead(footswitchPin_);
          previousMillis = currentMillis;
        }
        fluoVal |= digitalRead(forceswitchPin_);
        sensorVal = digitalRead(camexposurePin_);
        if (sensorVal == HIGH) {
          if (sensorwasLow == 1) {
            sensorwasLow = 0;
            if (toggleState == 0) {
              toggleState = 1;
              digitalWrite(bfPin_, LOW);
              delay(10);
              digitalWrite(fluoPin_, fluoVal);
              delay(80);             
              digitalWrite(fluoPin_, LOW);
            }
            else {
              toggleState = 0;
              digitalWrite(fluoPin_, LOW);
              delay(10);
              digitalWrite(bfPin_, HIGH);
              delay(25);
              digitalWrite(bfPin_, LOW);                
            }              
          }
        }
        else {
          sensorwasLow = 1;
          digitalWrite(bfPin_, LOW);
          digitalWrite(fluoPin_, LOW);
        }            
        break;
        case 5: //alternating BF / FLUO    20 Hz   
        currentMillis = millis();
        if ((unsigned long)(currentMillis - previousMillis) >= 5) {
          fluoVal = digitalRead(footswitchPin_);
          previousMillis = currentMillis;
        }
        fluoVal |= digitalRead(forceswitchPin_);
        sensorVal = digitalRead(camexposurePin_);
        if (sensorVal == HIGH) {
          if (sensorwasLow == 1) {
            sensorwasLow = 0;
            if (toggleState == 0) {
              toggleState = 1;
              digitalWrite(bfPin_, LOW);
              delay(10);
              digitalWrite(fluoPin_, fluoVal);
              delay(31);        
              digitalWrite(fluoPin_, LOW);      
            }
            else {
              toggleState = 0;
              digitalWrite(fluoPin_, LOW);
              delay(10);
              digitalWrite(bfPin_, HIGH);
              delay(25);
              digitalWrite(bfPin_, LOW);                
            }              
          }
        }
        else {
          sensorwasLow = 1;
          digitalWrite(bfPin_, LOW);
          digitalWrite(fluoPin_, LOW);
        }            
        break;
     default:
            digitalWrite(bfPin_, LOW);
            digitalWrite(fluoPin_, LOW);
            break;
   }

   // Trimmed code from Micromanager website
   if (Serial.available() > 0) {
     int inByte = Serial.read();
     switch (inByte) {
       
       // Set digital output
       case 1 :
          if (waitForSerial(timeOut_)) {
            currentPattern_ = Serial.read();
            // Do not set bits 6 and 7 (not sure if this is needed..)
            currentPattern_ = currentPattern_ & B00111111;
            if (!blanking_)
              PORTB = currentPattern_;
            Serial.write( byte(1));
          }
          break;
          
       // Blanks output based on TTL input
       case 20:
         blanking_ = true;
         Serial.write( byte(20));
         break;
         
       // Stops blanking mode
       case 21:
         blanking_ = false;
         Serial.write( byte(21));
         break;
         
       // Sets 'polarity' of input TTL for blanking mode
       case 22: 
         if (waitForSerial(timeOut_)) {
           int mode = Serial.read();
           if (mode==0)
             blankOnHigh_= true;
           else
             blankOnHigh_= false;
         }
         Serial.write( byte(22));
         break;
         
       // Gives identification of the device
       case 30:
         Serial.println("MM-Ard");
         break;
         
       // Returns version string
       case 31:
         Serial.println(version_);
         break;
       }
    }
    
    // In trigger mode, we will blank even if blanking is not on.. CHECK IF THIS CAN BE REMOVED
    if (triggerMode_) {
      boolean tmp = PIND & inPinBit_;
      if (tmp != triggerState_) {
        if (blankOnHigh_ && tmp ) {
          PORTB = 0;
        }
        else if (!blankOnHigh_ && !tmp ) {
          PORTB = 0;
        }
        else { 
          if (triggerNr_ >=0) {
            PORTB = triggerPattern_[sequenceNr_];
            sequenceNr_++;
            if (sequenceNr_ >= patternLength_)
              sequenceNr_ = 0;
          }
          triggerNr_++;
        }
        
        triggerState_ = tmp;       
      }  
    } else if (blanking_) {
      if (blankOnHigh_) {
        if (! (PIND & inPinBit_))
          PORTB = currentPattern_;
        else
          PORTB = 0;
      }  else {
        if (! (PIND & inPinBit_))
          PORTB = 0;
        else  
          PORTB = currentPattern_;
      }
    }
}

 
bool waitForSerial(unsigned long timeOut)
{
    unsigned long startTime = millis();
    while (Serial.available() == 0 && (millis() - startTime < timeOut) ) {}
    if (Serial.available() > 0)
       return true;
    return false;
 }


