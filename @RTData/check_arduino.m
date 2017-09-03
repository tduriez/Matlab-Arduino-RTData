function period=check_arduino(obj)
%CHECK_ARDUINO      method of the RTData class. Returns arduino loop period.
%
%   Period=RTDataObject.CHECK_ARDUINO  returns the time period needed by
%       the arduino controler to realize one loop iteration in milliseconds. 
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

     obj.open_port;
     try
     nTest=10000;
     h=waitbar(0,'Checking Arduino data collection:');
     time=zeros(nTest,1);
     dt=zeros(nTest,1);
     iAcquis=0;
     while iAcquis<nTest
         msg=fscanf(obj.Hardware.Serial);
         if strfind(msg(1),'S');
             iAcquis=iAcquis+1;
             idx=[strfind(msg,' ') numel(msg+1)];
             time(iAcquis)=str2double(msg(idx(1)+1:idx(2)-1));
             if iAcquis>1
                dt(iAcquis)=(time(iAcquis)-time(iAcquis-1));
                nTest=min(nTest,round(5000/dt(iAcquis)));
             end
             waitbar(iAcquis/nTest,h,sprintf('Checking Arduino data collection delay: %.2f ms',mean(dt(2:iAcquis))));
             
         end
     end
     close(h);
     period=mean(dt(2:iAcquis));
     fprintf('Measured average period: %d ms (%.2f Hz)\n',round(period),1000/period);
     catch err
         obj.close_port;
         period=NaN;
         throw(err)
     end
     
     obj.close_port;
     
     