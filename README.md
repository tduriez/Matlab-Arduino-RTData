# Matlab-Arduino-RTData

Matlab-Arduino-RTdata provides an arduino script (RTData_arduino.ino) and a Matlab toolbox (RTData) in order to achieve data acquisition from the arduino board with real-time display. Some control capabilities have been added and the next versions will focus on this aspect.
 
## Features

The toolbox has been tested and is expected to work only with an Arduino Due board. Support for other boards will come.

### Acquisition (Arduino Due):

- up to 12 analog input at 1kHz (12KS/s) confirmed. Higher rates might be possible.
- Being arduino Due, input voltage is limited to the range 0-3.3V at 12 bits resolution.

### Command (Arduino Due)

- Only analog pin 13 is set for action at the moment.
- A sequence of pulse can be instructed with different pulse width, pulse repetition rate and pulse repetition number.
- The sequence can be cancelled anytime.
- Future versions will expand those capabilities.

### User interface

Though the tool can be used in command line and integrated to other software, the GUI allows to set-up and use the tool without limitations. It includes:
- Fast set-up and repetition of the experiments.
- Autosave.
- Display of past experiments.
- Reuse of past parameters.
- Application of selected post-processing

## How it works

The Matlab toolbox and the arduino board exchange data in ascii through the serial port. Every loop iteration, the following actions are achieved on the arduino:

- Acquire each specified analog input, nMeasures times, and average for each.
- Perform the control action if specified.
- Send to the serial interface the analog input levels and control action.
- Wait a specified number of ms (that's how frequency is set).
- Check if anything is available on the serial interface from matlab (acquisition settings, control action...) 

On the other side, the acquisition function (RTData/acquire) opens a display and performs a loop which reads the serial buffer and updates the Time, Data and Action properties of the RTData object, until the real-time display is closed. A callback is called every time the Time properties is updated, and according to the settings (the refresh frequency in particular), the real time display is updated. The real-time display also counts with uicontrols that allow to send control actions and stop them.

## Installation

1- Download/Clone the repository.

2- Add the Matlab-Arduino-RTData folder to the matlab path.

3- Burn the Arduino-RTData/Arduino-RTdata.ino script on you Arduino Due.


## Quick start

1- Connect the Native Serial Port of the Arduino Due to your computer.

2- Identify to which serial port it corresponds (a universal way is through the Arduino software, Tools/Ports). 

3- Launch the user interface in matlab: RTDataGUI

4- Press SET, and select the serial port where the Native Serial Port of the Arduino is connected, and press Set.

5- Press GO.

6- Close the real-time display when finished with acquisition and press save now to save the experiment.



  



