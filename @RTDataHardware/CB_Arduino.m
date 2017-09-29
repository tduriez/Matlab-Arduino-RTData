function CB_Arduino(~,eventData)
%CB_ARDUINO    RTDataHardware callback. Detect arduino config change and
%              trigger calibration change
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

    Settings_sep=[repmat('-',[1 72]) '\n'];
    obj=eventData.AffectedObject;
    fprintf(Settings_sep);
    fprintf('Changing Arduino voltage configuration to %s\n',obj.Arduino);
    switch lower(obj.Arduino)
        case 'uno'
            fprintf('Arduino Uno (10 bits, 5V) settings\n')
            obj.Bits=10;
            obj.Volts=5;
        case 'mega'
            fprintf('Arduino Mega (10 bits, 5V) settings\n')
            obj.Bits=10;
            obj.Volts=5;
        case 'due'
            fprintf('Arduino Due (12 bits, 3.3V) settings\n')
            obj.Bits=12;
            obj.Volts=3.3;
        otherwise
            fprintf('Default (No scaling) settings\n')
            obj.Hardware.Bits=0;
            obj.Hardware.Volts=1;
    end
    fprintf(Settings_sep);
end