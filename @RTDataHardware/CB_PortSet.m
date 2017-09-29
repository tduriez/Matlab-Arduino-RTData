function CB_PortSet(~,eventData)
%CB_PORTSET    RTDataHardware callback. Detect serial port change and
%              trigger serial port creation.
%
%   Not supposed to be called by user. See file for comments.
%
%   See also: RTDataHardware
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

    obj=eventData.AffectedObject;
    if isa(obj.Serial,'serial')
        obj.closePort(1);
        delete(obj.Serial);
    end
    obj.createSerial;
end