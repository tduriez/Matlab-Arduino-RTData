classdef RTData < handle
%RTData Real-Time Data class.
%
%   Matlab class made for the acquisition and display of analog signals
%   through a serial port in real time.
%
%   RTData properties:
%   Time     - (1xNt) vector, containing time stamps from the hardware.
%   Data     - (NsxNt) matrix, containing the analog signal received.
%   Action   - (NbxNt) matrix, containing the actuation signals.
%
%   nPoints  -  Max number of points to display in one graph.
%   tFrame   -  Time span of the graph in seconds.
%   fRefresh -  Frequency (Hz) of refresh of the graph.
%   Name     -  Experiment name.
%
%   Control  - Control type and parameters.
%   Hardware - Hardware configuration.
%
%   RTData methods:
%   acquire        - starts acquisition.
%   control        - send control instruction contained in Control.
%   stop           - stops any actuation.
%   check_arduino  - returns the actual loop delay of the arduino
%
%   open_port      - opens serial port specified in Hardware.Port.
%   close_port     - closes and delete serial port object.
%   addmeasure     - adds one measurement point.
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




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                            PROPERTIES                                   %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User can edit properties
    properties 
        nPoints=10000  % Max number of points to display in one graph
        tFrame=30      % Time span (s) of the graph in s
        fRefresh=1     % Frequency (Hz) of refresh of the graph
        Notes=''       % Experimental notes (should be a string)
        Name='test'    % Experiment name
        Control        % Control type and parameters
        Save=0         % Save switch (0> no 1>.mat 2>mat+txt -2> txt
    end
    
    
    properties (SetObservable)
        Hardware       % Structure containing the hardware config.         %%TODO Maybe should be own super-serial class
    end

%% Protected properties
    properties (SetObservable, SetAccess=private)
        Data=[]        % Where data will be kept
        Action=[]      % Where action will be kept 
        Time=[]        % Where time will be kept
        AcqDate        % Burnt once acquisition is done
        
        
    end
    
%% Hidden, unaccessible magic properties (a.k.a. dirty tweaks)    
    properties (Hidden, SetAccess=private)
        graphics        % Structure with graphic handles and preprocessed info
        acquired=0      % Each RTData object can only be acquired once
        arduino='due'   % Used to keep track of harware change             %%TODO will disappear once Hardware is a class with listener
        delay=200       % Used to keep track of harware change             %%TODO will disappear once Hardware is a class with listener
        Channels=2      % Used to keep track of harware change             %%TODO will disappear once Hardware is a class with listener
        nMeasures=100   % Used to keep track of harware change             %%TODO will disappear once Hardware is a class with listener
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                            METHODS                                      %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
%% Constructor
    methods
        function obj=RTData()
           obj.graphics.axes_handles=[];
           obj.graphics.plot_handles=[];
           obj.graphics.text_handles=[];
           obj.graphics.iFrame=[];
           obj.graphics.nStep=[];
           obj.graphics.dt=[];
           obj.graphics.nRefresh=[];
           
           obj.Hardware.arduino='due';
           obj.Hardware.Bits=12;
           obj.Hardware.Volts=3.3;
           obj.Hardware.Channels=2;
           obj.Hardware.nMeasures=100;
           obj.Hardware.delay=200;
           addlistener(obj,'Time','PostSet',@RTData.AutoPlot);
           addlistener(obj,'Hardware','PostSet',@RTData.HardwareChange);
        end

%% Other methods
        function obj=addmeasure(obj,t,sensors,control)
            obj.Data(end+1,:)=sensors(:);
            obj.Action(end+1,:)=control(:);
            obj.Time(end+1,1)=t;
            
        end
        
        function obj=open_port(obj)
            if strcmpi(obj.Hardware.Port,'undefined');
                error('No serial port has been set up for communication with hardware');
            end
            obj.Hardware.Serial=serial(obj.Hardware.Port);
            set(obj.Hardware.Serial,'DataBits',8);
            set(obj.Hardware.Serial,'BaudRate',9600);
            set(obj.Hardware.Serial,'StopBits',1);
            set(obj.Hardware.Serial,'Parity','none');
            set(obj.Hardware.Serial,'InputBufferSize',512*1024);
            set(obj.Hardware.Serial,'Timeout',60);     
            % Intialisation
            fopen(obj.Hardware.Serial); %% open the port
            fprintf('Serial port ''%s'' open.\n',obj.Hardware.Port);
        end
        
        function close_port(obj)
            fclose(obj.Hardware.Serial);
            fprintf('Serial port ''%s'' closed.\n',obj.Hardware.Port);
            delete(obj.Hardware.Serial);
            obj.Hardware=rmfield(obj.Hardware,'Serial');
            fprintf('Serial object deleted.\n');
        end
        
        obj  = acquire(obj)     
        obj  = control(obj)
        obj  = stop(obj)
        freq = check_arduino(obj)
        obj  = set_arduino_parameters(obj,ChangeSettings)
               save(obj)
        obj  = makeLiveInterface(obj,nbfigs,TheFig)
    end
    
%% Events callbacks    
    methods (Static, Hidden)  
        AutoPlot(metaProp,eventData)
        HardwareChange(metaProp,eventData)
    end
    
end