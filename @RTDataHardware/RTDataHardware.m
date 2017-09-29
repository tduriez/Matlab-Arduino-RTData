classdef RTDataHardware < matlab.mixin.Copyable
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                            PROPERTIES                                   %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    properties (SetObservable)
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
        function disp(obj,mode)
            if nargin<2
                mode='all';
            end
            disptxt=[];
            if strcmpi(mode,'all')
                disptxt=sprintf('RTData Hardware Object:\n\n');
            end
            if any(strcmpi(mode,{'serial','all','simple'}))
                disptxt=sprintf('%s -Serial configuration:\n',disptxt);
                disptxt=sprintf('%s    -Serial Port: %s\n',disptxt,obj.Port);
                if isa(obj.Serial,'serial')
                    disptxt=sprintf('%s    -Baudrate:    %d\n',disptxt,get(obj.Serial,'BaudRate'));
                    disptxt=sprintf('%s    -Buffer size: %d\n',disptxt,get(obj.Serial,'InputBufferSize'));
                    disptxt=sprintf('%s    -Status:      %s\n',disptxt,get(obj.Serial,'Status'));
                else
                    disptxt=sprintf('%s    -Status:      %s\n',disptxt,'not created');
                end
            end
            if strcmpi(mode,'all')
                disptxt=sprintf('%s\n',disptxt);
            end
            if any(strcmpi(mode,{'arduino','all','simple'}))
                disptxt=sprintf('%s -Arduino configuration:\n',disptxt);
                disptxt=sprintf('%s    -Type:        %s\n',disptxt,obj.Arduino);
                disptxt=sprintf('%s         -Bits:   %d\n',disptxt,obj.Bits);
                disptxt=sprintf('%s         -Volts:  %.1f\n',disptxt,obj.Volts);
                disptxt=sprintf('%s    -Delay:       %d us (%.2f Hz)\n',disptxt,obj.Delay,10^6/obj.Delay);
                disptxt=sprintf('%s    -Channels:    %d\n',disptxt,obj.Channels);
                disptxt=sprintf('%s    -Measures:    %d\n',disptxt,obj.nMeasures);
            end
            fprintf(disptxt);
        end
    end
    
     methods (Static, Hidden)  
        %% Callbacks
        CB_Arduino(prop,eventData)
        CB_OnBoard(propChanged,eventData) 
        CB_PortSet(prop,eventData)
     end
end