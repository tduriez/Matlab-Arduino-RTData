#define DEBUG // uncomment this line to get debug messages on Programming Port

#ifdef DEBUG
#define DEBUG_PRINTLN(x)  Serial.println (x)
#define DEBUG_PRINT(x)  Serial.print (x)
#else
#define DEBUG_PRINTLN(x)
#define DEBUG_PRINT(x)
#endif

/* *****************
   *** VARIABLES ***
   ***************** */

int i = 0;
int j = 0;
int SensorPins[12];
int DigiActionPins[4];
int Trig = 2;
int TheDelay = 1000;
int SetDelay = 1000;
int nMeasures = 1;
int nSensors = 12;
int nControls= 4;
unsigned long InitTime;
unsigned long Last_loop, Previous_loop, mDelay;
int Sensors[12];
int Controls[4];
unsigned long ActTime[4];
unsigned long ActTimeOut[4];
int ActParams[12];

/* *****************
   ***  METHODS  ***
   ***************** */

int ReadLine(char str[]) {
  // function for reading a line from the SerialUSB buffer.
  // In: nothing.
  // Out: char object with \0 termination.
  char c;
  int index = 0;
  while (true) {
    if (SerialUSB.available() > 0) {
      c = SerialUSB.read();
      if (c != '\n' & c != 'i') {
        str[index++] = c;
      } else {
        str[index] = '\0'; // null termination character
        break;
      }
    }
  }
  return index;
}

void updateSensors(int Sensors[], int nSensors, int Pins[]) {
  for (i = 0; i < nSensors; i++) {
    Sensors[i] = Sensors[i] + analogRead(Pins[i]);
  }
}

void resetSensors(int Sensors[], int nSensors) {
  for (i = 0; i < nSensors; i++) {
    Sensors[i] = 0;
  }
}

void rescaleSensors(int Sensors[], int nSensors, int nMeasures) {
  for (i = 0; i < nSensors; i++) {
    Sensors[i] = Sensors[i] / nMeasures;
  }
}

void SlowerThanLightWriter(int Sensors[], int Control[], int nSensors) {
  /* 
   *  Control Overwrite
   *  REMOVE AFTER TEST
   */
    Control[0]=1;
    Control[1]=0;
    Control[2]=1;
    Control[3]=0;
  if (millis() % 1000 <500) {
    Control[0]=0;
    Control[1]=1;
    Control[2]=0;
    Control[3]=1;
  } 

  /* 
   *  End of Control Overwrite
   *  REMOVE AFTER TEST
   */
  


   
  
  byte thebuffer[30];
  char str[31];
  int iBit;
  int iChar = 0;
  int jSensors = 0;
  unsigned long thetime;
  int trans[4] = {24, 16, 8, 0};
  thetime = micros();
  for (iBit = 0; iBit < 4; iBit++) {
    thebuffer[iChar] = (thetime >> trans[iBit]) & 0xFF;
    iChar++;
  }
  for (jSensors = 0; jSensors < nSensors; jSensors++) {
    for (iBit = 2; iBit < 4; iBit++) {
      thebuffer[iChar] = (Sensors[jSensors] >> trans[iBit]) & 0xFF;
      iChar++;
    }
  }
  for (iBit = 2; iBit < 4; iBit++) {
    thebuffer[iChar] = 255;
    iChar++;
  }
  thebuffer[4] = thebuffer[4] + 128 * Control[0] + 64 * Control[1] + 32 * Control[2] + 16*Control[3]; // Using bit 16 to 13 of 2bytes from the 12bits first sensor
  SerialUSB.write(thebuffer, iChar);
  SerialUSB.println("");


/* Bebugging STL Cargo. Ruins datarate. 
   Serial.println("STL Cargo:");
   int i_buf;
   for (i_buf=0;i_buf<iChar;i_buf++) {
   Serial.print(thebuffer[i_buf]);
   Serial.print(" ");
   }
   Serial.println(""); */
}

int SlowerThanLightReader(unsigned long params[]) { /* TODO receive control instructions */
  /* SlowerThanLigthReader gets parameters from the external client.

      The data structure is the following
      Byte 1:       : Bits 5,6,7 and 8 code for number of sensors. -------> params[0]
                    : Bits 1,2,3,4 are reserved for control characters ---> output
      Byte 2:       : nMeasures-1 ([0 255] -> [1 256])             -------> params[1]
      Bytes 3,4,5,6 : loop delay in microseconds (unsigned long, 32bits) -> params[2]
      Bytes 7,8     : Pulse Width (ms) (max 65535)                 -------> params[3]
      Byte 9        : repetitions-1 (max 256)                      -------> params[4]
      Bytes 10,11   : Control delay (ms) (max 65535)               -------> params[5]
  */
  if (SerialUSB.available() > 10) { /* Information comes in packets of 11 */
    int ControlChar;
    byte fromBuffer[11];
    SerialUSB.readBytes(fromBuffer, 11);
    ControlChar = fromBuffer[0] >> 4;
    params[0] = fromBuffer[0] - ControlChar * 16;
    params[1] = fromBuffer[1];
    params[2] = fromBuffer[2] * 16777216 + fromBuffer[3] * 65536 + fromBuffer[4] * 256 + fromBuffer[5];
    params[3] = fromBuffer[6] * 256 + fromBuffer[7];
    params[4] = fromBuffer[8];
    params[5] = fromBuffer[9] * 256 + fromBuffer[10];
    while (SerialUSB.available() > 0) { /* Empty the rest */
      byte test[0];
      SerialUSB.readBytes(test, 1);
    }
    return ControlChar;
  }
  else {
    return 0;
  }
}

void control(int Controls[], unsigned long ActTime[], unsigned long ActTimeOut[], int ActParams[]) {
  Controls[0] = 0;
  Controls[1] = 0;
  Controls[2] = 0;
  Controls[3] = 0;

  /* control line 1*/
  if (millis() > ActTime[0]) {
    Controls[0] = 1;
  }

  if (millis() > ActTimeOut[0]) {
    if (Controls[0] == 1) {
      if (ActParams[1] > 1) {
        ActTime[0] = ActTime[0] + ActParams[2];
        ActTimeOut[0] = ActTime[0] + ActParams[0];
        ActParams[1] = ActParams[1] - 1;
      }
    }
    Controls[0] = 0;
  }

   /* control line 2*/
  if (millis() > ActTime[1]) {
    Controls[1] = 1;
  }

  if (millis() > ActTimeOut[1]) {
    if (Controls[1] == 1) {
      if (ActParams[4] > 1) {
        ActTime[1] = ActTime[1] + ActParams[5];
        ActTimeOut[1] = ActTime[1] + ActParams[3];
        ActParams[4] = ActParams[4] - 1;
      }
    }
    Controls[1] = 0;
  }

    /* control line 3*/
  if (millis() > ActTime[2]) {
    Controls[2] = 1;
  }

  if (millis() > ActTimeOut[2]) {
    if (Controls[2] == 1) {
      if (ActParams[7] > 1) {
        ActTime[2] = ActTime[2] + ActParams[8];
        ActTimeOut[2] = ActTime[2] + ActParams[6];
        ActParams[7] = ActParams[7] - 1;
      }
    }
    Controls[2] = 0;
  }

     /* control line 4*/
  if (millis() > ActTime[3]) {
    Controls[3] = 1;
  }

  if (millis() > ActTimeOut[3]) {
    if (Controls[3] == 1) {
      if (ActParams[10] > 1) {
        ActTime[3] = ActTime[3] + ActParams[11];
        ActTimeOut[3] = ActTime[3] + ActParams[9];
        ActParams[10] = ActParams[10] - 1;
      }
    }
    Controls[3] = 0;
  }


  int iCont;

  for (iCont = 0; iCont < 4; iCont++) {
    if (Controls[iCont] == 1) {
      digitalWrite(DigiActionPins[iCont], HIGH);
    }
    else {
      digitalWrite(DigiActionPins[iCont], LOW);
    }
  }
}

/* *****************
   ***   SETUP   ***
   ***************** */

void setup() {
  mDelay = TheDelay;
  SensorPins[0] = 54;
  SensorPins[1] = 55;
  SensorPins[2] = 56;
  SensorPins[3] = 57;
  SensorPins[4] = 58;
  SensorPins[5] = 59;
  SensorPins[6] = 60;
  SensorPins[7] = 61;
  SensorPins[8] = 62;
  SensorPins[9] = 63;
  SensorPins[10] = 64;
  SensorPins[11] = 65;
  DigiActionPins[0]=13;
  DigiActionPins[1]=12;
  DigiActionPins[2]=11;
  DigiActionPins[3]=10;
  ActTime[0] = 4294967295;
  ActTimeOut[0] = 0;
  analogReadResolution(12);
  SerialUSB.begin(9600);  //speed of this one doesn't mean anything
  Serial.begin(9600);
  pinMode(DigiActionPins[0], OUTPUT);
  pinMode(DigiActionPins[1], OUTPUT);
  pinMode(DigiActionPins[2], OUTPUT);
  pinMode(DigiActionPins[3], OUTPUT);
  while (SerialUSB.available() > 0) {
    byte test[0];
    SerialUSB.readBytes(test, 1);
  }
}

/* *****************
   ***   LOOP    ***
   ***************** */

void loop() {
  /* Preparing for measurement */
  j = 0;
  resetSensors(Sensors, nSensors);

  /* Summing measurements*/
  while (j < nMeasures) {
    updateSensors(Sensors, nSensors, SensorPins);
    j++;
  }

  /* Average measurements */
  rescaleSensors(Sensors, nSensors, nMeasures);

  /* Control */
  control(Controls, ActTime, ActTimeOut, ActParams);

  /* Send Results */
  SlowerThanLightWriter(Sensors, Controls, nSensors);

  /* Manage messages from outside */
  if (SerialUSB.available() > 0) {
    DEBUG_PRINTLN("Got something on the port");
    unsigned long Parameters[6];
    int mode;
    mode = SlowerThanLightReader(Parameters);
    if (mode == 15) { // Query mode
      DEBUG_PRINTLN("It's Query mode !");

#ifdef DEBUG
      int N = 0;
#endif
      while (SerialUSB.available() < 1) {
#ifdef DEBUG
        N++;
#endif
        SerialUSB.print(nSensors);
        SerialUSB.print(" ");
        SerialUSB.print(nMeasures);
        SerialUSB.print(" ");
        SerialUSB.print(TheDelay);
        SerialUSB.print(" ");
        SerialUSB.println(mDelay);
        delay(10);
      }
      DEBUG_PRINT("Info sent ");
      DEBUG_PRINT(N);
      DEBUG_PRINT(" times.");
      while (SerialUSB.available() > 0) {
        char junk[1];
        SerialUSB.readBytes(junk, 1);
      }
      DEBUG_PRINTLN("Back to normal mode");
    }
    if (mode == 1) { // Config mode
      DEBUG_PRINTLN("It's Config mode !");
      nSensors       = Parameters[0];
      nMeasures      = Parameters[1];
      TheDelay       = Parameters[2];
      if (Parameters[3] > 0) {
        ActParams[0] = Parameters[3];
        ActParams[1] = Parameters[4];
        ActParams[2] = Parameters[5];
        ActTime[0] = millis();
        ActTimeOut[0] = millis() + ActParams[0];
      }
      DEBUG_PRINT("n sensors: ");
      DEBUG_PRINTLN(nSensors);
      DEBUG_PRINT("nMeasures: ");
      DEBUG_PRINTLN(nMeasures);
      DEBUG_PRINT("delay: ");
      DEBUG_PRINTLN(TheDelay);
      DEBUG_PRINT("Pulse Width: ");
      DEBUG_PRINTLN(ActParams[0]);
      DEBUG_PRINT("Reps: ");
      DEBUG_PRINTLN(ActParams[1]);
      DEBUG_PRINT("Control Delay: ");
      DEBUG_PRINTLN(ActParams[2]);
      DEBUG_PRINT("Control Char: ");
      DEBUG_PRINTLN(mode);
    }
    if (mode == 2) { // Kill Mode
      ActTime[0] = 4294967295;
      ActTimeOut[0] = 0;
      DEBUG_PRINTLN("Actuation killed!!!");
    }

    DEBUG_PRINTLN("Back to sensing");
  }



  /* Enforce loop period */
  while (micros() - Last_loop < TheDelay) {
    delayMicroseconds(1);
  }
  Previous_loop = Last_loop;
  Last_loop = micros();
  mDelay = Last_loop - Previous_loop;
}
