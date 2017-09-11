/* *****************
   *** VARIABLES ***
   ***************** */
int ActionPin=13;
int i = 0;
int j= 0;
int Pins[6];
int Trig = 2;
int TheDelay = 10;
int nMeasures = 100;
int nSensors = 6;
unsigned long InitTime;
int Sensors[12];
int Control;
unsigned long ActTime[1];
unsigned long ActTimeOut[1];
int ActParams[3];

/* *****************
   ***  METHODS  ***
   ***************** */

int ReadLine(char str[]) {
  // function for reading a line from the Serial buffer.
  // In: nothing.
  // Out: char object with \0 termination.
  char c;
  int index = 0;
  while (true) {
    if (Serial.available() > 0) {
      c = Serial.read();
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
    Serial.print("S ");
    Serial.print(millis());
    Serial.print(" ");
  for (i = 0; i < nSensors; i++) {
    Serial.print(Sensors[i]);
    Serial.print(" ");
  }
  Serial.print("C ");
  Serial.println(Control);
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
  Pins[0] = 23;
  Pins[1] = 24;
  Pins[2] = 25;
  Pins[3] = 26;
  Pins[4] = 27;
  Pins[5] = 28;
  
  ActTime[0]=4294967295;
  ActTimeOut[0]=0;
  
  Serial.begin(9600);  
  
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
    sendSensors(Sensors, Control, nSensors);

   
    
    /* Enforce loop period */
    delay(TheDelay);

    /* Manage messages from outside */
    if (Serial.available() > 0) {
      int bufferCount;
      char FromSerialBuffer[23];
      char Part1[7];
      char Part2[7];
      char Part3[7];
      bufferCount = ReadLine(FromSerialBuffer);
      for (i=0;i<6;i++) {
          Part1[i]=FromSerialBuffer[i+2];
        }
        for (i=0;i<6;i++) {
          Part2[i]=FromSerialBuffer[i+9];
        }
        for (i=0;i<6;i++) {
          Part3[i]=FromSerialBuffer[i+16];
        }
      if (FromSerialBuffer[0]==78) { // If the first letter is N
        Serial.println("Changing parameters");
        nSensors=atol(Part1); 
        nMeasures=atol(Part2); 
        TheDelay=atol(Part3);    
      Serial.print("New nSensors: ");
        Serial.println(nSensors);
        Serial.print("New nMeasures: ");
        Serial.println(nMeasures);
        Serial.print("New Delay: ");
        Serial.println(TheDelay); 
      }
      if (FromSerialBuffer[0]==65) { // 65 is A
        Serial.println("New staged control sequence");
        ActParams[0]=atol(Part1);
        ActParams[1]=atol(Part2);
        ActParams[2]=atol(Part3);
      Serial.print("Pulse Width: ");
        Serial.println(ActParams[0]);
        Serial.print("Repetitions: ");
        Serial.println(ActParams[1]);
        Serial.print("Delay: ");
        Serial.println(ActParams[2]); 
        ActTime[0]=millis();
        ActTimeOut[0]=millis()+ActParams[0];
      }
       if (FromSerialBuffer[0]==75) {// 75 is K
        digitalWrite(ActionPin,LOW);
        ActParams[1]=1;
        ActTime[0]=4294967295;
        ActTimeOut[0]=0;
    }
    }



  
}
