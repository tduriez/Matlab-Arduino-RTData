function obj=STLStorage(obj,time,sensors,control,Marker)
%STLStorage         keeps the RT Data in persistent variable and manage the
%                   memory allocation for it. This function also triggers
%                   RT plots and control if needed.
%
%   Not supposed to be called by user. Check file for comments
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

% Oddly enough the use of persistent object is by far superior to the use
% of the RTData object properties directly. Hence, the data is stored in
% persistent variables during acquisition and when acquisition is finished
% a last call to STLStorage puts the data inside the RTData object and
% clear persistent variables.

persistent Data Control Time Graph Trigger

if nargin==1
    obj.Data=Data(1:obj.iMeasurements,:)/2^obj.Hardware.Bits *obj.Hardware.Volts;
    obj.Time=Time(1:obj.iMeasurements);
    obj.Action=Control(1:obj.iMeasurements,:);
    clear Data Control Time Graph
    return
end

if nargin==2
    clear Data Control Time Graph
    return
end

if Marker==2
    noplot=1;
else
    noplot=0;
end

obj.iMeasurements=obj.iMeasurements+1;
i=obj.iMeasurements;

if i>obj.BufferSize || isempty(Time)
    fprintf('Making room in STL Storage\n');
    if i>=2
        obj.graphics.dt=Time(2)-Time(1);
    else
        obj.graphics.dt=obj.Hardware.Delay/10^6;
    end
    obj.graphics.nRefresh=round(1/(obj.fRefresh*obj.graphics.dt));
    obj.BufferSize=obj.BufferSize+obj.nBuffer;
    Time=[Time; (zeros(obj.nBuffer,1))];
    Graph=mod(1:length(Time),obj.graphics.nRefresh)==0;
    Control=[Control; (zeros(obj.nBuffer,numel(control)))];
    Data=[Data; (zeros(obj.nBuffer,numel(sensors)))];
    Trigger=[Trigger; (zeros(obj.nBuffer,1))];
    if isfield(obj.Control,'Trigger')
        if (length(Time)-1)*obj.graphics.dt>obj.Control.Trigger
            [~,idx]=min(abs((length(Time)-1)*obj.graphics.dt-obj.Control.Trigger));
            Trigger(idx)=1;
        end
    end
end

Data(i,:)=sensors;
Control(i,:)=control;
Time(i)=time;
if Graph(i) && ~noplot
    STLPlot(obj,Time,Data,Control);
end

if Trigger(i)
    obj.control;
end

end