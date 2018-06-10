function STLPlot(h,Time,Data,Control)
%STLPLOT   displays RT graphics
%
%   STLPLOT decides if the real-time display should be updated and acts
%   accordingly. See code for details.
%
% See also: RTData
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


%% Refreshing

    if isempty(h.tFrame)         % if no time frame is specified
        DisplayTime=Time(1:h.iMeasurements);      % draw all data always
        DisplayData=Data(1:h.iMeasurements,:);
        
    else
        if isempty(h.graphics.iFrame)  % determine how much points
            h.graphics.iFrame=round(h.tFrame/h.graphics.dt);
        end
        if isempty(h.nPoints)
            h.graphics.nStep=1;
        else                           % reduce if a maximum number si specified
            h.graphics.nStep=max(1,round(h.graphics.iFrame/h.nPoints));
        end
        
        DisplayTime=Time(max(1,h.iMeasurements-h.graphics.iFrame):h.graphics.nStep:h.iMeasurements);
        DisplayData=[Data(max(1,h.iMeasurements-h.graphics.iFrame):h.graphics.nStep:h.iMeasurements,:)...
                    Control(max(1,h.iMeasurements-h.graphics.iFrame):h.graphics.nStep:h.iMeasurements,:)];
    end
   
try
        for k=1:size(DisplayData,2)
            set(h.graphics.plot_handles(k),'XData',DisplayTime,'YData',DisplayData(:,k));
        end
        
        for i=1:numel(h.graphics.axes_handles)
            set(h.graphics.axes_handles(i),'XLim',[DisplayTime(1) DisplayTime(end)]);
        end
        
        if numel(h.graphics.text_handles)>0
            set(h.graphics.text_handles(1),'String',sprintf('%3.2f s, %d bytes',toc,get(h.Hardware.Serial,'BytesAvailable')));
        end
        drawnow limitrate
catch err
    if strcmp(err.message,'Invalid or deleted object.')
        fprintf('Real-Time Display closed\n');
    else
        fprintf('%s\n',err.message);
        for i=1:length(err.stack)
            disp(err.stack(i));
        end
    end
end
    
end
