function obj=acquire(obj)
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
        obj.open_port;
        try
            warning('off','MATLAB:callback:PropertyEventError');
            tic %keeps track of real time from start of acquisition
            TheFig=figure; 
            fscanf(obj.Hardware.Serial); %get rid of serial content
                                         %might contain rubish at arduino
                                         %start
            nbSensors=obj.Hardware.Channels;
            nbControls=1;
            iTest=0;
            
            %% determine nb sensors and controls
            
            
            nbFigs=obj.Hardware.Channels+1;
            
            %% Launch real-time display
            obj.makeLiveInterface(nbFigs,TheFig);
            
            %% Acquire data
            Marker=1; % indicates first acquisition for initial time tracking
            time_init=0;
            SlowerThanLightDocking(obj);
            while ishandle(TheFig)  %closing the display stops the acquisition
                [Marker,time_init]=SlowerThanLightReader(obj,Marker,time_init,nbSensors,nbControls);
            end
            Tend=toc;
            while obj.Time(end)<Tend %% Purging the cache up to real time figure closing
                SlowerThanLightReader(obj,2,time_init,nbSensors,nbControls);
            end
        catch err
            obj.close_port
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

function [nbSensors,nbControl]=SlowerThanLightDocking(obj)
    dummy=fread(obj.Hardware.Serial,50,'uint8');
    for i=51:100
        if all(dummy(i-4:i-1)==[255 255 13 10]')
            return
        end
        dummy(i)=fread(obj.Hardware.Serial,1,'uint8');
    end
end

function [Marker,time_init]=SlowerThanLightReader(obj,Marker,time_init,nbSensors,nbControls)
    if Marker==2 % If display is closed
        warning('off','MATLAB:callback:error');
    else
        drawnow limitrate % skip drawings if cannot keep up
    end
    CargoBitSize=8+nbSensors*2;
    nBuffer=get(obj.Hardware.Serial,'BytesAvailable');
    nbacquis=floor(nBuffer/CargoBitSize);
    if nbacquis==0
        return;
    end
    dummy=fread(obj.Hardware.Serial,CargoBitSize*nbacquis,'uint8');
    Sensors=zeros(1,nbSensors);
    for nba=1:nbacquis
        a=dummy(1+CargoBitSize*(nba-1):CargoBitSize*nba);
        TheTime=a(1)*2^24+a(2)*2^16+a(3)*2^8+a(4);
        for k=1:nbSensors
            Sensors(k)=a(5+2*(k-1))*2^8+a(6+2*(k-1))/2^obj.Hardware.Bits *obj.Hardware.Volts;
        end
        obj.addmeasure(TheTime/10^6,Sensors,0);
    end
end

function [Marker,time_init]=GetDataFromSerial(obj,Marker,time_init,nbSensors,nbControls)
    msg=fscanf(obj.Hardware.Serial);
    if Marker==2 % If display is closed
        warning('off','MATLAB:callback:error');
    else
        drawnow limitrate % skip drawings if cannot keep up
    end
    
    % Structure of msg from serial:
    % 'S 21 12351 CargoBitSize15 123 12516 CargoBitSize131 C 1'
    %   time       sensors             control
    %    ms         level               0/1
    if strfind(msg(1),'S');
        idx=[strfind(msg,' ') numel(msg+1)];
        TheTime=str2double(msg(idx(1)+1:idx(2)-1));
        if Marker==1
            Marker=0;
            time_init=TheTime;
        end
        Sensor=zeros(1,nbSensors);
        Control=zeros(1,nbControls);
        for k=2:nbSensors+1
            Sensor(k-1)=str2double(msg(idx(k)+1:idx(k+1)-1))/2^obj.Hardware.Bits *obj.Hardware.Volts;
        end
        for k=1:nbControls
           Control(k)=str2double(msg(idx(nbSensors+k+2)+1:idx(nbSensors+k+3)-1));
        end
        obj.addmeasure((TheTime-time_init)/1000,Sensor,Control); %time is obtained in ms.
    end
end