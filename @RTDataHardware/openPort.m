function openPort(obj)
%OPENPORT          RTDataHardware method. Opens serial port if possible.
%
%   RTDataHardwareObject.OPENPORT opens the serial port if not already open.
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

    if isempty(obj.Port)
        error('Can''t open serial port: no serial port has been configured.');
    end
    if ~isa(obj.Serial,'serial')
        obj.createSerial;
    else
        if isempty(obj.Serial)
            obj.createSerial;
        end
    end

    if ~isvalid(obj.Serial)
        obj.createSerial;
    end

    if strcmpi(get(obj.Serial,'Status'),'closed')
        fopen(obj.Serial);
        fprintf('Serial port %s open\n',obj.Port)
        obj.disp('serial');
        obj.sendParams;
    else
        fprintf('Serial port %s already open\n',obj.Port)
    end
end