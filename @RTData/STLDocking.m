function STLDocking(obj)
%STLDOCKING     Parse the serial buffer for start of usefull data.
%
% RTDataObject.STLDocking ensures that the next byte read from the serial
% buffer corresponds to the start of a STL sequence.
% 
% Read comments in file for details.
%
%   See also: RTDataGUI
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  STL communication explained  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The goal is to detect one of the end sequence of a STL Cargo.
% A STL Cargo is structured as follows:
%
% Byte:     0 1 2 3 4 5     6 7     8 9     ..... XX XX+1 N-3 N-2 N-1 N 
% Format:   uint32  uint16  uint16  uint16        uint16  x   x   x   x
% Value:    Time    S0      S1      S2            SN      255 255 13  10
%
% S0--SN are sensors values. 
% By detecting that the last four bytes were 255 255 13 and 10, we ensure
% that the next byte corresponds to byte 0 of a new STL sequence.

fprintf('Enforcing security measures to ensure safe Slower Than Light travel of your data\n')
    
    obj.openPort;
    
    % Clean buffers
    flushinput(obj.Hardware.Serial); 
    flushoutput(obj.Hardware.Serial);
    
    % Wait for some data to come from the board
    while get(obj.Hardware.Serial,'BytesAvailable')<150
        pause(0.001)
    end
    
    fprintf('Receiving Data Stream\n')
    % use a lot to avoid potential bullshit at the beginning of the array
    dummy=fread(obj.Hardware.Serial,50,'uint8');  
    for i=51:100
        if all(dummy(i-4:i-1)==[255 255 13 10]') % last four check
            return
        end
        dummy(i)=fread(obj.Hardware.Serial,1,'uint8');
    end
     
end