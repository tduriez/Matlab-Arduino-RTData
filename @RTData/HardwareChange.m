function HardwareChange(metaProp,eventData)
%HARDWARECHANGE     Callback of the RTData class. Tracks changes in
%                   hardware configuration and relay them to the hardware.
%
%       See code for details.
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
    
% This function should be replaced when Hardware becomes a class
    
    h=eventData.AffectedObject;
    
    PropertiesToTest={'arduino','delay','Channels','nMeasures'}; % 
    
    for i=1:numel(PropertiesToTest)
        if ischar(h.Hardware.(PropertiesToTest{i}))
            if ~strcmp(h.Hardware.(PropertiesToTest{i}),h.(PropertiesToTest{i}))
            h.set_arduino_parameters(0);
            h.(PropertiesToTest{i})=h.Hardware.(PropertiesToTest{i});
            end
        else
        if h.Hardware.(PropertiesToTest{i})~=h.(PropertiesToTest{i})
            h.set_arduino_parameters(~strcmp(PropertiesToTest{i},'arduino'));
            h.(PropertiesToTest{i})=h.Hardware.(PropertiesToTest{i});
        end
        end
    end
        
end