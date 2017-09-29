function obj=stop(obj)
%STOP       method of the RTData class. Stops any actuation in the arduino
%           board.
%
%   RTDataObject.stop immediately sends the 'K' signal to the arduino
%   board. If the arduino is loaded with the original script provided with
%   this toolbox, it corresponds to the command to stop any actuation. The
%   script still continues to send sensors data to the serial port.
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
    
    obj.openPort;
    KillCargo=zeros(1,11);
    KillCargo(1)=2*16;
    fwrite(obj.Hardware.Serial,KillCargo,'uint8');
    
end
    