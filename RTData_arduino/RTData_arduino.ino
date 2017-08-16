 int i=0;
 int Sensor1, Sensor2;
 int Trig=2;
 int TheDelay=200;
 unsigned long InitTime;

 
 
 int ReadLine(char str[]) {
// function for reading a line from the serial buffer.
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
 
void setup() {
  analogReadResolution(12);
  SerialUSB.begin(9600);
}

int isnum(char str[]){
 
  char * pEnd;
  long int li1;
  li1 = strtol (str,&pEnd,10);
  
  li1=0;
  
  if (strlen(pEnd) == 0) {
    
  li1=1;
  }
  
  return li1;
}


void loop() {
 
    while (Trig == 2) {
        i=0;
        Sensor1=0;
        Sensor2=0;
        while (i<100) {
            Sensor1=Sensor1+analogRead(A0);
            Sensor2=Sensor2+analogRead(A1);
            i++;
        }
        Sensor1=Sensor1/100;
        Sensor2=Sensor2/100;
        SerialUSB.print("D ");
        SerialUSB.print(millis()-InitTime);
        SerialUSB.print(" ");
        SerialUSB.print(Sensor1);
        SerialUSB.print(" ");
        SerialUSB.println(Sensor2);
        
        
        delay(TheDelay-1);
        if (SerialUSB.available()>0) {
            int bufferCount;
	    char Answer[20];
            bufferCount = ReadLine(Answer);
            SerialUSB.println(Answer);
	     if (isnum(Answer)==1) {
              TheDelay=atol(Answer);
              SerialUSB.println("DelayReceived");
              InitTime=millis();
           
          }
          
          
        }
        
        
        
    }
}
