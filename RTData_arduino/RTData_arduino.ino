/* *****************
   *** VARIABLES ***
   ***************** */
int ActionPin=13;
int i = 0;
int j= 0;
int Pins[12];
int Trig = 2;
int TheDelay = 1;
int nMeasures = 1;
int nSensors = 12;
unsigned long InitTime;
unsigned long Last_loop;


int Sensors[12];
int Control;
unsigned long ActTime[1];
unsigned long ActTimeOut[1];
int ActParams[3];

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

void SlowerThanLightWriter(int Sensors[], int Control, int nSensors) {
    byte thebuffer[30];
    char str[31];
    int iBit;
    int iChar=0;
    int jSensors=0;
    unsigned long thetime;
    int trans[4]={24,16,8,0};
    thetime=micros();
    for (iBit=0;iBit<4;iBit++) {
      thebuffer[iChar]=(thetime >> trans[iBit]) & 0xFF;
      iChar++;
      
    }
    for (jSensors=0;jSensors<nSensors;jSensors++) {
      for (iBit=2;iBit<4;iBit++) {
        thebuffer[iChar]=(Sensors[jSensors] >> trans[iBit]) & 0xFF;
        iChar++;
      }
    }
    for (iBit=2;iBit<4;iBit++) {
        thebuffer[iChar]=255;
        iChar++;
    }
    
    SerialUSB.write(thebuffer,iChar);
    SerialUSB.println("");
}

int control(unsigned long ActTime[],unsigned long ActTimeOut[],int ActParams[]) {
  int Control=0;
  if (millis() > ActTime[0]) {
    Control=1;
  }

  if (millis()>ActTimeOut[0]) {
    if (Control==1) {
      if (ActParams[1]>1) {
        ActTime[0]=ActTime[0]+ActParams[2];
        ActTimeOut[0]=ActTime[0]+ActParams[0];
        ActParams[1]=ActParams[1]-1;
      }
    }
    Control=0;
  }
  if (Control==1) {
    digitalWrite(ActionPin,HIGH);
  }
  else {
    digitalWrite(ActionPin,LOW);
  }
  
  return Control;
}

/* *****************
   ***   SETUP   ***
   ***************** */

void setup() {
  Pins[0] = 54;
  Pins[1] = 55;
  Pins[2] = 56;
  Pins[3] = 57;
  Pins[4] = 58;
  Pins[5] = 59;
  Pins[6] = 60;
  Pins[7] = 61;
  Pins[8] = 62;
  Pins[9] = 63;
  Pins[10] = 64;
  Pins[11] = 65;
  ActTime[0]=4294967295;
  ActTimeOut[0]=0;
  analogReadResolution(12);
  SerialUSB.begin(9600);  
  pinMode(ActionPin, OUTPUT);
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
      updateSensors(Sensors, nSensors, Pins);
      j++;
    }

    /* Average measurements */
    rescaleSensors(Sensors, nSensors, nMeasures);

     /* Control */
    Control=control(ActTime,ActTimeOut,ActParams);

    /* Send Results */
    SlowerThanLightWriter(Sensors, Control, nSensors);

   
    
    

    /* Manage messages from outside */
    if (SerialUSB.available() > 0) {
      int bufferCount;
      char FromSerialUSBBuffer[23];
      char Part1[7];
      char Part2[7];
      char Part3[7];
      bufferCount = ReadLine(FromSerialUSBBuffer);
      for (i=0;i<6;i++) {
          Part1[i]=FromSerialUSBBuffer[i+2];
        }
        for (i=0;i<6;i++) {
          Part2[i]=FromSerialUSBBuffer[i+9];
        }
        for (i=0;i<6;i++) {
          Part3[i]=FromSerialUSBBuffer[i+16];
        }
      if (FromSerialUSBBuffer[0]==78) { // If the first letter is N
        SerialUSB.println("Changing parameters");
        nSensors=atol(Part1); 
        nMeasures=atol(Part2); 
        TheDelay=atol(Part3);    
      SerialUSB.print("New nSensors: ");
        SerialUSB.println(nSensors);
        SerialUSB.print("New nMeasures: ");
        SerialUSB.println(nMeasures);
        SerialUSB.print("New Delay: ");
        SerialUSB.println(TheDelay); 
      }
      if (FromSerialUSBBuffer[0]==65) { // 65 is A
        SerialUSB.println("New staged control sequence");
        ActParams[0]=atol(Part1);
        ActParams[1]=atol(Part2);
        ActParams[2]=atol(Part3);
      SerialUSB.print("Pulse Width: ");
        SerialUSB.println(ActParams[0]);
        SerialUSB.print("Repetitions: ");
        SerialUSB.println(ActParams[1]);
        SerialUSB.print("Delay: ");
        SerialUSB.println(ActParams[2]); 
        ActTime[0]=millis();
        ActTimeOut[0]=millis()+ActParams[0];
      }
    }

    /* Enforce loop period */
    while (micros()-Last_loop<TheDelay) {
     delayMicroseconds(1);
    }
     Last_loop=micros();



  
}
