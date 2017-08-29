

int ActionPin=13;
int i = 0;
int j= 0;
int Pins[12];
int Trig = 2;
int TheDelay = 10;
int nMeasures = 100;
int nSensors = 12;
unsigned long InitTime;
int Sensors[12];
int Control;

unsigned long ActTime=0;

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

void sendSensors(int Sensors[], int Control, int nSensors) {
    SerialUSB.print("S ");
    SerialUSB.print(millis());
    SerialUSB.print(" ");
  for (i = 0; i < nSensors; i++) {
    SerialUSB.print(Sensors[i]);
    SerialUSB.print(" ");
  }
  SerialUSB.print("C ");
  SerialUSB.println(Control);
}

int control(unsigned long ActTime) {
  int Control;
  if (millis() < ActTime) {
    digitalWrite(ActionPin,HIGH);
    Control=1;
  }
  else {
    digitalWrite(ActionPin,LOW);
    Control=0;
  }
  return Control;
}


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
  analogReadResolution(12);
  SerialUSB.begin(9600);  
  pinMode(ActionPin, OUTPUT);
}


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
    Control=control(ActTime);

    /* Send Results */
    sendSensors(Sensors, Control, nSensors);

   
    
    /* Enforce loop period */
    delay(TheDelay);

    /* Manage messages from outside */
    if (SerialUSB.available() > 0) {
      int bufferCount;
      char FromSerialBuffer[16];
      char Part1[3];
      char Part2[4];
      char Part3[6];
      bufferCount = ReadLine(FromSerialBuffer);
      if (FromSerialBuffer[0]==78) { // If the first letter is N
        SerialUSB.println("Changing parameters");
        for (i=0;i<2;i++) {
          Part1[i]=FromSerialBuffer[i+2];
        }
        nSensors=atol(Part1); 
        for (i=0;i<3;i++) {
          Part2[i]=FromSerialBuffer[i+5];
        }
        nMeasures=atol(Part2); 
        for (i=0;i<5;i++) {
          Part3[i]=FromSerialBuffer[i+10];
        }
        TheDelay=atol(Part3);    
        SerialUSB.print("New nSensors: ");
        SerialUSB.println(nSensors);
        SerialUSB.print("New nMeasures: ");
        SerialUSB.println(nMeasures);
        SerialUSB.print("New Delay: ");
        SerialUSB.println(TheDelay);
      }
      if (FromSerialBuffer[0]==65) { // 65 is A
        for (i=0;i<5;i++) {
          Part3[i]=FromSerialBuffer[i+2];
        }
        ActTime=millis()+atol(Part3);
      }
    }



  
}
