function createSerial(obj)
% CREATESERIAL       RTDataHardware method. Creates and configure serial 
%                    object.
%
%   RTDataHardwareObject.CREATESERIAL Creates and configure serial object.
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

    fprintf('Configuring serial object\n')
    obj.Serial=serial(obj.Port);
    set(obj.Serial,'DataBits',8);
    set(obj.Serial,'BaudRate',230400);
    set(obj.Serial,'StopBits',1);
    set(obj.Serial,'Parity','none');
    set(obj.Serial,'InputBufferSize',512*1024);
    set(obj.Serial,'Timeout',60);
end