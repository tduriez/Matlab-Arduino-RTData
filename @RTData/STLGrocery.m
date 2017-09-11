function obj=STLGrocery(obj,time,sensors,control)
    persistent Data Control Time
    
    if nargin==1
        obj.Data=Data(1:obj.iMeasurements,:)/2^obj.Hardware.Bits *obj.Hardware.Volts;
        obj.Time=Time(1:obj.iMeasurements);
        obj.Action=Control(1:obj.iMeasurements,:);
        return
    end
    
    
  
    
    obj.iMeasurements=obj.iMeasurements+1;
    i=obj.iMeasurements;
    if obj.iMeasurements>obj.nBuffer || isempty(Time)
       Time=[Time; (zeros(obj.nBuffer,1))];
       Control=[Control; (zeros(obj.nBuffer,numel(control)))];
       Data=[Data; (zeros(obj.nBuffer,numel(sensors)))];
    end
    
   
    Data(i,:)=sensors;
    Control(i,:)=control;
    Time(i)=time;
    AutoPlot(obj,Time,Data,Control);
   
end