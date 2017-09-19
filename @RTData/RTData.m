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
%   openPort      - opens serial port specified in Hardware.Port.
%   closePort     - closes and delete serial port object.
%
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
        Hardware       % Structure containing the hardware config.  
    end
    

%% Protected properties
    properties (SetAccess=private)
        Data=[]        % Where data will be kept
        Action=[]      % Where action will be kept 
        Time=[]        % Where time will be kept
        AcqDate        % Burnt once acquisition is done
        
        
    end
    
%% Hidden, unaccessible magic properties (a.k.a. dirty tweaks)    
    properties (Hidden, SetAccess=private)
        nBuffer=1000*60*10 % Provision for 10 minutes at 1kHz
        iMeasurements=0    % used while acquiring         
        graphics           % Structure with graphic handles and preprocessed info
        acquired=0         % Each RTData object can only be acquired once
lass with listener
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
           obj.Hardware=RTDataHardware;
        end

%% Destructor
    function obj=delete(obj)
        delete(obj.Hardware);
    end
        
%% Display overload
    function disp(obj)
        fprintf('RTData object:\n\n');
        fprintf(' -name: %s\n',obj.Name);
        if obj.acquired
            fprintf(' -Acquired:\n');
            fprintf('   -%d channels\n',size(obj.Data,2));
            fprintf('   -%d acquisitions at %.f Hz (%.2f s)\n',length(obj.Time),1/diff(obj.Time(1:2)),obj.Time(end));
        else
            fprintf(' -Not acquired\n')
            disp(obj.Hardware,'simple')
            fprintf(' -graphics:\n');
            fprintf('   -Refresh: %.1f Hz\n',obj.fRefresh);
            fprintf('   -Points:  %d\n',obj.nPoints);
            fprintf('   -Span:    %.1f s\n',obj.tFrame);
        end
            
            
           
    end
    
    
%% Slower Than Light Technology

            STLDocking(obj);
        obj=STLCargoManagement(obj,mode);
    [t1,t2]=STLReceive(obj,Marker,time_init,nbSensors,nbControls,Tend); 
        obj=STLGrocery(obj,t,s,c,m); %% puts data in the RTData object
            STLCheck(obj,mode)

%% Interface
        % Serial communication
        function obj=openPort(obj)
            obj.Hardware.openPort;
        end
        
        function closePort(obj)
            obj.Hardware.closePort;
        end
        
%% Functionnalities

        AutoPlot(obj,Time,Data,Control)
        obj  = acquire(obj,acquisition_time)     
        obj  = control(obj)
        obj  = stop(obj)
               save(obj)
        obj  = makeLiveInterface(obj,nbfigs,TheFig)
    end    
end