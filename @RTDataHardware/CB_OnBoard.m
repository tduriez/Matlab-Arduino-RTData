function CB_OnBoard(propChanged,eventData)
%CB_ONBOARD    RTDataHardware callback. Detect parameter change and relay
%              it to the arduino board
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
    fprintf(Settings_sep);
    obj=eventData.AffectedObject;
    switch propChanged.Name
        case 'Delay'
            fprintf('New loop delay: %d us.\n',obj.Delay);
        case 'Channels'
            fprintf('New number of input channels: %d.\n',obj.Channels);
        case 'nMeasures'
            fprintf('New number of averaging measures: %d.\n',obj.nMeasures);
    end
    obj.sendParams;
end