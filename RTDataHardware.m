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
        function obj=RTDataHardware(ThePort);
            if nargin==1
                if ~isempty(ThePort)
                    obj.Port=ThePort;
                end
            end
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
            if any(strcmpi(mode,{'serial','all'}))
                disptxt=sprintf('%s -Serial configuration:\n',disptxt);
                disptxt=sprintf('%s    -Serial Port: %s\n',disptxt,obj.Port);
                if isa(obj.Serial,'serial')
                    disptxt=sprintf('%s    -Baudrate:    %d\n',disptxt,get(obj.Serial,'BaudRate'));
                    disptxt=sprintf('%s    -Buffer size: %d\n',disptxt,get(obj.Serial,'InputBufferSize'));
                    disptxt=sprintf('%s    -Status:      %s\n',disptxt,get(obj.Serial,'Status'));
                else
                    disptxt=sprintf('%s    -Status:      %s\n',disptxt,'not created');
                end
                    
                disptxt=sprintf('%s\n',disptxt);
            end
            
            disp(disptxt);
        end
            
        
    end
    
    
    
end