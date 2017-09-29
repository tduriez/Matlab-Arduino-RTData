function obj=STLStorage(obj,time,sensors,control,Marker)
persistent Data Control Time Graph Trigger

if nargin==1
    obj.Data=Data(1:obj.iMeasurements,:)/2^obj.Hardware.Bits *obj.Hardware.Volts;
    obj.Time=Time(1:obj.iMeasurements);
    obj.Action=Control(1:obj.iMeasurements,:);
    clear Data Control Time Graph
    return
end

if nargin==2
    clear Data Control Time Graph
    return
end

if Marker==2
    noplot=1;
else
    noplot=0;
end


obj.iMeasurements=obj.iMeasurements+1;
i=obj.iMeasurements;
if i>obj.BufferSize || isempty(Time)
    fprintf('Making room in STL Storage\n');
    if i>=2
        obj.graphics.dt=Time(2)-Time(1);
    else
        obj.graphics.dt=obj.Hardware.Delay/10^6;
    end
    
    obj.graphics.nRefresh=round(1/(obj.fRefresh*obj.graphics.dt));
    obj.BufferSize=obj.BufferSize+obj.nBuffer;
    Time=[Time; (zeros(obj.nBuffer,1))];
    Graph=mod(1:length(Time),obj.graphics.nRefresh)==0;
    Control=[Control; (zeros(obj.nBuffer,numel(control)))];
    Data=[Data; (zeros(obj.nBuffer,numel(sensors)))];
    Trigger=[Trigger; (zeros(obj.nBuffer,1))];
    if isfield(obj.Control,'Trigger')
        if (length(Time)-1)*obj.graphics.dt>obj.Control.Trigger
            [~,idx]=min(abs((length(Time)-1)*obj.graphics.dt-obj.Control.Trigger));
            Trigger(idx)=1;
        end
    end
end

Data(i,:)=sensors;
Control(i,:)=control;
Time(i)=time;
if Graph(i) && ~noplot
    STLPlot(obj,Time,Data,Control);
end

if Trigger(i)
    obj.control;
end

end