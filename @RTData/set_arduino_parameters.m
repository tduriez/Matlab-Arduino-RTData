function obj=set_arduino_parameters(obj,SendToArduino)
%SET_ARDUINO_PARAMETERS     method of the RTData class. Performs actions 
%                           necessary when hardware configuration is
%                           changed
%
%   This function is called by the RTData class callbacks and should not be
%   called manually. See code for comments.
%
%   See also: RTData
%   Copyright (c) 2017, Thomas Duriez (Distributed under GPLv3)

%% Copyright
%    Copyright (c) 2017, Thomas Duriez (thomas.duriez@gmail.com)
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.



    Settings_sep=[repmat('-',[1 72]) '\n']; % just a display line.

%% Changes in voltage scaling per board
    if ~SendToArduino
        fprintf(Settings_sep);
        fprintf('Changing Arduino voltage configuration to %s\n',obj.Hardware.arduino);
        switch lower(obj.Hardware.arduino)
            case 'uno'
                fprintf('Arduino Uno (10 bits, 5V) settings\n')
                obj.Hardware.Bits=10;
                obj.Hardware.Volts=5;
            case 'mega'
                fprintf('Arduino Mega (10 bits, 5V) settings\n')
                obj.Hardware.Bits=10;
                obj.Hardware.Volts=5;
            case 'due'
                fprintf('Arduino Due (12 bits, 3.3V) settings\n')
                obj.Hardware.Bits=12;
                obj.Hardware.Volts=3.3;
            otherwise
                fprintf('Default (No scaling) settings\n')
                obj.Hardware.Bits=0;
                obj.Hardware.Volts=1;
        end
        fprintf(Settings_sep);
    end
    
%% Changes in the board execution loop for acquisition.
    if SendToArduino
        obj.open_port;
        fprintf(Settings_sep);
        fprintf('Arduino internal settings:\n')
        fprintf('\n')
        fprintf('Channels:    %d\n',obj.Hardware.Channels);
        fprintf('Averaging:   %d\n',obj.Hardware.nMeasures);
        fprintf('Acq period:  %d\n',obj.Hardware.delay);
        fprintf(Settings_sep);
        fprintf(obj.Hardware.Serial,sprintf('N %06d %06d %06d',obj.Hardware.Channels,obj.Hardware.nMeasures,obj.Hardware.delay));
        obj.close_port;
    end