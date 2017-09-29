classdef RTDataHardware < matlab.mixin.Copyable
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                            PROPERTIES                                   %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    properties (SetObservable, AbortSet)
        Arduino='due'
        Delay=1000
        Port
        Channels=2
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