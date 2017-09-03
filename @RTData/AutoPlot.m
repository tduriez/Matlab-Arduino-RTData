function AutoPlot(metaProp,eventData)
%AutoPlot   Callback function of the RTData class. Called every-time new
%           data is available
%
%   AUTOPLOT decides if the real-time display should be updated and acts
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

h=eventData.AffectedObject;

%% determining the refresh period in number of measurements.
if numel(h.Time)>=2 && isempty(h.graphics.nRefresh) % if not already done
    if isempty(h.graphics.dt)
        h.graphics.dt=h.Time(2)-h.Time(1);
    end
    h.graphics.nRefresh=round(1/(h.fRefresh*h.graphics.dt));
end

%% Refreshing
if mod(numel(h.Time),h.graphics.nRefresh)==0
 
    if isempty(h.tFrame)         % if no time frame is specified
        DisplayTime=h.Time;      % draw all data always
        DisplayData=h.Data;
        
    else
        if isempty(h.graphics.iFrame)  % determine how much points
            h.graphics.iFrame=round(h.tFrame/h.graphics.dt);
        end
        if isempty(h.nPoints)
            h.graphics.nStep=1;
        else                           % reduce if a maximum number si specified
            h.graphics.nStep=max(1,round(h.graphics.iFrame/h.nPoints));
        end
        
        DisplayTime=h.Time(max(1,end-h.graphics.iFrame):h.graphics.nStep:end);
        DisplayData=[h.Data(max(1,end-h.graphics.iFrame):h.graphics.nStep:end,:)...
                     h.Action(max(1,end-h.graphics.iFrame):h.graphics.nStep:end,:)];
    end
   
    if ~isempty(h.graphics.plot_handles) % if display is not closed.
        for k=1:numel(h.graphics.plot_handles)
            set(h.graphics.plot_handles(k),'XData',DisplayTime,'YData',DisplayData(:,k));
        end
        
        for i=1:numel(h.graphics.axes_handles)
            set(h.graphics.axes_handles(i),'XLim',[DisplayTime(1) DisplayTime(end)]);
        end
        
        if numel(h.graphics.text_handles)>0
            set(h.graphics.text_handles(1),'String',sprintf('%3.2f s',toc));
        end
    end
    
    
end
end
