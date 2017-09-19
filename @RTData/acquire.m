function obj=acquire(obj,acquisition_time)
% ACQUIRE    Acquires in real-time. Method of the RTData class.
%
% ACQUIRE opens the serial object and opens a new real-time display. It
% then starts reading the serial port for new measurement points and add
% them to the RTData object until the display is closed. At closing,
% ACQUIRE continues reading until the time stamp delivered through the
% serial port reaches the time of display closure, in case real-time cannot
% be achieved.
%
% Then ACQUIRE marks the RTData object as acquired, so the data cannot be
% overwritten, and save the object if specified.
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
if ~obj.acquired
    if nargin<2
        acquisition_time=[];
    end
    obj.openPort;
    try
        warning('off','MATLAB:callback:PropertyEventError');
        
        
        
        %            fscanf(obj.Hardware.Serial); %get rid of serial content
        %might contain rubish at arduino
        %start
        
        %% determine nb sensors and controls
        nbSensors=obj.Hardware.Channels;
        nbControls=1;
        nbFigs=nbSensors+nbControls;
        
        %% Launch real-time display
        if isempty(acquisition_time)
            TheFig=figure;
            obj.makeLiveInterface(nbFigs,TheFig);
            drawnow;
        else
            try
                close(666)
            catch
            end
            TheFig=666;
            obj.makeTrigger;
        end
        
        
        
        %% Acquire data
        Marker=1; % indicates first acquisition for initial time tracking
        time_init=0;
        obj.STLDocking;
        tic
        while ishandle(TheFig)  %closing the display stops the acquisition
            [time_init]=obj.STLReceive(time_init,Marker,nbSensors,nbControls);
        end
        
        if isempty(acquisition_time)
            Tend=toc;
        else
            Tend=acquisition_time;
        end
        fprintf('No display mode engaged\n');
        Marker=2; % indicates no graphics
        while time_init>=0 % Purging the cache up to real time figure closing
            % or acquiring up to prescribed time
            [time_init]=obj.STLReceive(time_init,Marker,nbSensors,nbControls,Tend);
        end
        obj.STLGrocery;
    catch err
        fprintf('\n%s\n\n',err.message);
        for i=1:length(err.stack)
           disp(err.stack(i)); 
        end
        throw(err);
    end
    obj.stop; %stoping unmonitored control
    obj.acquired=1;
    obj.save;
    obj.closePort;
else
    fprintf('Data already collected for this object\n')
end
end