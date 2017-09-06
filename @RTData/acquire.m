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
        obj.open_port;
        try
            warning('off','MATLAB:callback:PropertyEventError');
            tic %keeps track of real time from start of acquisition
            
            
            fscanf(obj.Hardware.Serial); %get rid of serial content
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
            obj.STLCargoManagement('open');
            while ishandle(TheFig)  %closing the display stops the acquisition
                [time_init]=obj.STLReceive(time_init,Marker,nbSensors,nbControls);
            end
            
            if isempty(acquisition_time)
                Tend=toc;
            else
                Tend=acquisition_time;
            end
            Marker=2; % indicates no graphics
            while true % Purging the cache up to real time figure closing
                       % or acquiring up to prescribed time   
                if obj.iMeasurements>0
                    if obj.Time(obj.iMeasurements)>Tend
                        break;
                    end
                end
                [time_init]=obj.STLReceive(time_init,Marker,nbSensors,nbControls);
            end
            obj.STLCargoManagement('close');
        catch err
            obj.close_port
            save lasterr err
            throw(err)
        end
        obj.stop; %stoping unmonitored control
        obj.close_port;
        obj.acquired=1;
        obj.save;
    else
        fprintf('Data already collected for this object\n')
    end
end



