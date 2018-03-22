function sendParams(obj,Controls)
%SENDPARAMS        RTDataHardware method. Sends parameters to arduino.
%
%   Not supposed to be called by user. See file for comments
%
%   See also: RTDataHardware
%   Copyright (c) 2017-18, Thomas Duriez (Distributed under GPLv3)

%% Copyright
%    Copyright (c) 2017-18, Thomas Duriez (thomas.duriez@gmail.com)
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

%  STL Cargo structure from matlab to arduino
%    
%     The data structure is the following
%     Byte 1:       : Bits 5,6,7 and 8 code for number of sensors. 
%                   : Bits 1,2,3,4 are reserved for control commands 
%     Byte 2:       : nMeasures-1 ([0 255] -> [1 256])             
%     Bytes 3,4,5,6 : loop delay in microseconds (unsigned long, 32bits) 
%     Bytes 7,8     : Pulse Width (ms) (max 65535)                
%     Byte 9        : repetitions-1 (max 256)                      
%     Bytes 10,11   : Control delay (ms) (max 65535)              
   

    if nargin<2
        Controls=[];
    end
    STLCargo=zeros(1,11);
    STLCargo(1)=obj.Channels+16;
    STLCargo(2)=uint8(obj.nMeasures);
    STLCargo(6)=mod(obj.Delay,2^8);
    STLCargo(5)=mod(obj.Delay-STLCargo(6),2^16)/2^8;
    STLCargo(4)=mod(obj.Delay-STLCargo(6)-STLCargo(5)*2^8,2^24)/2^16;
    STLCargo(3)=(obj.Delay-STLCargo(6)-STLCargo(5)*2^8-STLCargo(4)*2^16)/2^24;
    
    
    for i=1:numel(Controls)
        Control=Controls(i);
        STLCargo(1)=obj.Channels+16*i;
        switch lower(Control.Type)
            case 'stagedsequence'
                STLCargo(8)=mod(Control.PulseWidth,2^8);
                STLCargo(7)=(Control.PulseWidth-STLCargo(8))/2^8;
                STLCargo(9)=uint8(Control.Repetition);
                STLCargo(11)=mod(Control.Delay,2^8);
                STLCargo(10)=(Control.Delay-STLCargo(11))/2^8;
        end
    Settings_sep=[repmat('-',[1 72]) '\n'];
    obj.openPort;
    fprintf(Settings_sep);
    fprintf('Sending Cargo to Arduino via STL: ');
    fprintf('%d ',STLCargo);
    fprintf('\n');
    flushinput(obj.Serial);
    flushoutput(obj.Serial);
    fwrite(obj.Serial,STLCargo,'uint8');
    end
end