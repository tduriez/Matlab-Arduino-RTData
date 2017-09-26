classdef RTDataHardware < handle
    
    %% TODO
    
    %delay > Delay

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
        function createSerial(obj)
            fprintf('Configuring serial object\n')
            obj.Serial=serial(obj.Port);
            set(obj.Serial,'DataBits',8);
            set(obj.Serial,'BaudRate',230400);
            set(obj.Serial,'StopBits',1);
            set(obj.Serial,'Parity','none');
            set(obj.Serial,'InputBufferSize',512*1024);
            set(obj.Serial,'Timeout',60);
        end
        
        function openPort(obj)
            if isempty(obj.Port)
                error('Can''t open serial port: no serial port has been configured.');
            end
            if ~isa(obj.Serial,'serial')
                obj.createSerial;
            end
            if strcmpi(get(obj.Serial,'Status'),'closed')
                fopen(obj.Serial);
                fprintf('Serial port %s open\n',obj.Port)
                obj.disp('serial');
                obj.sendParams;
            else
                fprintf('Serial port %s already open\n',obj.Port)
            end  
        end
        
        function closePort(obj,nomsg)
            if nargin<2
                nomsg=0;
            end
            if isempty(obj.Port)
                if nomsg
                    return
                else
                    error('Can''t close serial port: no serial port has been configured.');
                end
            end
            if ~isa(obj.Serial,'serial')
                if nomsg
                    return
                else
                    error('Can''t close serial port: serial object not created.');
                end
            end
            if strcmpi(get(obj.Serial,'Status'),'closed')
                if ~nomsg
                    fprintf('Serial port %s already closed\n',obj.Port)
                end
            else
                fclose(obj.Serial);
                if ~nomsg
                    fprintf('Serial port %s closed\n',obj.Port)
                end
            end
        end
        
        function sendParams(obj,Control)
            if nargin<2
                Control=[];
            end
            STLCargo=zeros(1,11);
            STLCargo(1)=obj.Channels+16;
            STLCargo(2)=uint8(obj.nMeasures);
            STLCargo(6)=mod(obj.Delay,2^8);
            STLCargo(5)=mod(obj.Delay-STLCargo(6),2^16)/2^8;
            STLCargo(4)=mod(obj.Delay-STLCargo(6)-STLCargo(5)*2^8,2^24)/2^16;
            STLCargo(3)=(obj.Delay-STLCargo(6)-STLCargo(5)*2^8-STLCargo(4)*2^16)/2^24;
            if ~isempty(Control)
                switch lower(Control.Type)
                    case 'stagedsequence'
                        STLCargo(8)=mod(Control.PulseWidth,2^8);
                        STLCargo(7)=(Control.PulseWidth-STLCargo(8))/2^8;
                        STLCargo(9)=uint8(Control.Repetition);
                        STLCargo(11)=mod(Control.Delay,2^8);
                        STLCargo(10)=(Control.Delay-STLCargo(11))/2^8;
                end
            end
            Settings_sep=[repmat('-',[1 72]) '\n']; 
            obj.openPort;
            fprintf(Settings_sep);
            fprintf('Arduino internal settings:\n')
            fprintf('\n')
            fprintf('Channels:    %d\n',obj.Channels);
            fprintf('Averaging:   %d\n',obj.nMeasures);
            fprintf('Acq period:  %d\n',obj.Delay);
            fprintf(Settings_sep);
            fprintf('Sending Cargo: ');
            fprintf('%d ',STLCargo);
            fprintf('\n');
            fwrite(obj.Serial,STLCargo,'uint8');
        end
        
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
        function CB_Arduino(~,eventData)
            Settings_sep=[repmat('-',[1 72]) '\n']; 
            obj=eventData.AffectedObject;
            fprintf(Settings_sep);
            fprintf('Changing Arduino voltage configuration to %s\n',obj.Arduino);
            switch lower(obj.Arduino)
                case 'uno'
                    fprintf('Arduino Uno (10 bits, 5V) settings\n')
                    obj.Bits=10;
                    obj.Volts=5;
                case 'mega'
                    fprintf('Arduino Mega (10 bits, 5V) settings\n')
                    obj.Bits=10;
                    obj.Volts=5;
                case 'due'
                    fprintf('Arduino Due (12 bits, 3.3V) settings\n')
                    obj.Bits=12;
                    obj.Volts=3.3;
                otherwise
                    fprintf('Default (No scaling) settings\n')
                    obj.Hardware.Bits=0;
                    obj.Hardware.Volts=1;
            end
            fprintf(Settings_sep);
        end
        
        function CB_OnBoard(~,eventData) 
            obj=eventData.AffectedObject;
            obj.sendParams;
        end
        
        function CB_PortSet(~,eventData)
            obj=eventData.AffectedObject;
            if isa(obj.Serial,'serial');
                obj.closePort(1);
                delete(obj.Serial);
            end
            obj.createSerial;
        end
            
            
        
    end
    
    
    
    end