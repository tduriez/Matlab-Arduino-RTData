classdef RTDataHardware < matlab.mixin.Copyable
%RTDataHardware     class for management of the serial port and arduino by
%                   the RTData class
%
%   RTDataHardware properties:
%   Arduino  - (string)   Board type (default: 'due')
%   DT       - (Daq Session) Daq Session for DT board if present
%   Delay    - (integer)  Board loop period
%   Port     - (string)   Name of the serial port
%
%   Serial   - (Serial object) the serial object (private)
%
%   RTDataHardware methods:
%   openPort      - opens serial port.
%   closePort     - closes serial port.
%   sendParams    - sends parameters to arduino
%   createSerial  - creates serial object
%  
%   See also: RTData
%   Copyright (c) 2017-2018, Thomas Duriez (Distributed under GPLv3)

%% Copyright
%    Copyright (c) 2017-2018, Thomas Duriez (thomas.duriez@gmail.com)
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

    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                            PROPERTIES                                   %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    properties (SetObservable, AbortSet)
        Arduino='due'
        Delay=1000
        DT=[];
        Port
        Channels=2
        ControlPorts=4
        nMeasures=1
    end
    
    properties (Hidden,SetAccess=private)
        Bits=12
        Volts=3.3
    end
    
    properties (SetAccess=private)
        Serial
    end

      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                            METHODS                                      %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    methods
        %% Constructor
        function obj=RTDataHardware(ThePort)
            if nargin==1
                if ~isempty(ThePort)
                    obj.Port=ThePort;
                end
            end
            addlistener(obj,'Arduino','PostSet',@RTDataHardware.CB_Arduino);
            addlistener(obj,'Delay','PostSet',@RTDataHardware.CB_OnBoard);
            addlistener(obj,'Channels','PostSet',@RTDataHardware.CB_OnBoard);
            addlistener(obj,'nMeasures','PostSet',@RTDataHardware.CB_OnBoard);
            addlistener(obj,'Port','PostSet',@RTDataHardware.CB_PortSet);
        end
        
        %% Proxys for serial management
        createSerial(obj)
        openPort(obj)
        closePort(obj,nomsg)
        sendParams(obj,Control)
        
        %% Destructor
        function delete(obj)
            obj.closePort(1);
            delete(obj.Serial);
        end
        
        %% Display overload
        disp(obj,mode)
        
    end
    
     methods (Static, Hidden)  
        %% Callbacks
        CB_Arduino(prop,eventData)
        CB_OnBoard(propChanged,eventData) 
        CB_PortSet(prop,eventData)
     end
end