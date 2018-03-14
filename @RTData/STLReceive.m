function [time_init,timing]=STLReceive(obj,time_init,Marker,nbSensors,nbControls,Tend)
%STLRECEIVE     receive the STL Data Cargos and pass them to STLStorage
%
% Not meant to be called by user. See file for comments.
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
% A STL Cargo is structured as follows:
%
% Byte:     0 1 2 3 4 5     6 7     8 9     ..... XX XX+1 N-3 N-2 N-1 N 
% Format:   uint32  uint16  uint16  uint16        uint16  x   x   x   x
% Value:    Time    S0      S1      S2            SN      255 255 13  10
%
% S0--SN are sensors values. 
% The control is also coded on the bytes of S0. As of now, the highest bit
% count for analoginput from arduino is due (12bits). That lets 4 bits to
% retrieve 4 digital information from the board. Bit 8 of byte 4 of the STL
% cargo contains the control.

if Marker==2 % If display is closed
    warning('off','MATLAB:callback:error');
else
 %   drawnow limitrate % skip drawings if cannot keep up
end
CargoByteSize=8+nbSensors*2;
nBuffer=get(obj.Hardware.Serial,'BytesAvailable');
nbacquis=floor(nBuffer/CargoByteSize);
if nbacquis==0
    timing=[];
    return;
end
dummy=fread(obj.Hardware.Serial,CargoByteSize*nbacquis,'uint8');
for nba=1:nbacquis
    a=dummy(1+CargoByteSize*(nba-1):CargoByteSize*nba);
    [Control,a]=demultiplexbyte(a,nbControls);
    TheTime=a(1)*2^24+a(2)*2^16+a(3)*2^8+a(4); % (4 bytes -> uint32)
    
    if time_init==0
        time_init=TheTime;
        fprintf('Acquisition started\n');
    end
    
    if nargout==2
        if nba==1
            timing=zeros(1,nbacquis);
        end
        timing(nba)=TheTime;
        continue;
    end
    
    %(2bytes -> uint16)
    Sensors=sum(reshape(a(5:6+2*(nbSensors-1)),[2 nbSensors]).*repmat([2^8; 1],[1 nbSensors]));
    
    if any(a(end-3:end)~=[255 255 13 10]')
        fprintf('%d ',a');fprintf('\n');
    end
    
    % Include measurement in the RTDataObject. Also triggers STLPlot
    % if display is open.
    obj.STLStorage((TheTime-time_init)/10^6,Sensors,Control,Marker);
end

if nargin==6
    if (TheTime-time_init)/10^6 > Tend
        time_init=-1;
    end
end


end

function [control,TheBytes]=demultiplexbyte(TheBytes,nbControl)
% 4 controls can be coded on each sensors.
Sensorbyte=[5; 5; 5; 5];
Controlbit=[8; 7; 6; 5];
control=(TheBytes(Sensorbyte)-mod(TheBytes(Sensorbyte),2.^(Controlbit-1)))./2.^(Controlbit-1);
control(1)=TheBytes(5);
TheBytes(Sensorbyte)=TheBytes(Sensorbyte)-control.*2.^(Controlbit-1);


%keyboard
end