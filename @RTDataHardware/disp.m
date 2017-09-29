function disp(obj,mode)
%DISP Overload disp fucntion for RTDataHardware objects
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
        mode='all';
    end
    disptxt=[];
    if strcmpi(mode,'all')
        disptxt=sprintf('RTData Hardware Object:\n\n');
    end
    if any(strcmpi(mode,{'serial','all','simple'}))
        disptxt=sprintf('%s -Serial configuration:\n',disptxt);
        disptxt=sprintf('%s    -Serial Port: %s\n',disptxt,obj.Port);
        if isa(obj.Serial,'serial')
            disptxt=sprintf('%s    -Baudrate:    %d\n',disptxt,get(obj.Serial,'BaudRate'));
            disptxt=sprintf('%s    -Buffer size: %d\n',disptxt,get(obj.Serial,'InputBufferSize'));
            disptxt=sprintf('%s    -Status:      %s\n',disptxt,get(obj.Serial,'Status'));
        else
            disptxt=sprintf('%s    -Status:      %s\n',disptxt,'not created');
        end
    end
    if strcmpi(mode,'all')
        disptxt=sprintf('%s\n',disptxt);
    end
    if any(strcmpi(mode,{'arduino','all','simple'}))
        disptxt=sprintf('%s -Arduino configuration:\n',disptxt);
        disptxt=sprintf('%s    -Type:        %s\n',disptxt,obj.Arduino);
        disptxt=sprintf('%s         -Bits:   %d\n',disptxt,obj.Bits);
        disptxt=sprintf('%s         -Volts:  %.1f\n',disptxt,obj.Volts);
        disptxt=sprintf('%s    -Delay:       %d us (%.2f Hz)\n',disptxt,obj.Delay,10^6/obj.Delay);
        disptxt=sprintf('%s    -Channels:    %d\n',disptxt,obj.Channels);
        disptxt=sprintf('%s    -Measures:    %d\n',disptxt,obj.nMeasures);
    end
    fprintf(disptxt);
end