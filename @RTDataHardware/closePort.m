function closePort(obj,nomsg)
%CLOSEPORT          RTDataHardware method. Closes serial port if possible.
%
%   RTDataHardwareObject.CLOSEPORT closes the serial port.
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


    if nargin<2
        nomsg=0;
    end
    if isempty(obj.Port)
        if nomsg
            return
        else
            error('Can''t close serial port: no serial port has been configured.');
        end
    end
    if ~isa(obj.Serial,'serial')
        if nomsg
            return
        else
            error('Can''t close serial port: serial object not created.');
        end
    end

    if isvalid(obj.Serial)
        if strcmpi(get(obj.Serial,'Status'),'closed')
            if ~nomsg
                fprintf('Serial port %s already closed\n',obj.Port)
            end
        else
            fclose(obj.Serial);
            if ~nomsg
                fprintf('Serial port %s closed\n',obj.Port)
            end
        end
    end
end