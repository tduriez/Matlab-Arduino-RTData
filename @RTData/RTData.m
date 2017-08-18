classdef RTData < handle
%RTData Matlab class   
    properties 
        nPoints=10000
        tFrame=30
        fRefresh=1
        Notes
        Name='test'
        Save=0
    end
    
    properties (SetObservable)
        Hardware
    end

    properties (SetObservable, SetAccess=private)
        Data=[]
        Time=[]
        AcqDate
        
        
    end
    
    properties (Hidden, SetAccess=private)
        graphics
        acquired=0
        arduino='due'
        delay=200
    end
    
    
        
    
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
           obj.Hardware.delay=200;
           addlistener(obj,'Time','PostSet',@RTData.AutoPlot);
           addlistener(obj,'Hardware','PostSet',@RTData.HardwareChange);
        end
        
        function obj=addmeasure(obj,t,sensors)
            obj.Data(end+1,:)=sensors(:);
            obj.Time(end+1,1)=t;
        end
        
        function obj=open_port(obj)
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
        
        obj=acquire(obj)     
        freq=check_arduino(obj)
        obj=set_arduino_delay(obj,d);
            save(obj);
        
        
    end
    
    
    methods (Static, Hidden)  
        AutoPlot(metaProp,eventData)
        HardwareChange(metaProp,eventData)
    end
    
end