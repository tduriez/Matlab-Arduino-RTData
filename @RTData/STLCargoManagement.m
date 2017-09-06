function obj=STLCargoManagement(obj,mode)
    if nargin<2
        mode='Start';
    end
    sep=[repmat('-',[1 72]) '\n'];
    fprintf(sep)
    fprintf('STL Store Service:\n')
    switch mode
        case 'open'
            fprintf('We are making place for your data\n');
            obj.Time=single(zeros(obj.nBuffer,1));
            obj.Data=single(zeros(obj.nBuffer,obj.Hardware.Channels));
            obj.Action=single(zeros(obj.nBuffer,1));
        case 'more'
            fprintf('Looking for more place for your data\n');
            obj.Time=[obj.Time; single(zeros(obj.nBuffer,1))];
            obj.Data=[obj.Data; single(zeros(obj.nBuffer,obj.Hardware.Channels))];
            obj.Action=[obj.Action; single(zeros(obj.nBuffer,1))];
        case 'close'
            fprintf('Closing containers\n');
            obj.Time=obj.Time(1:obj.iMeasurements,:); 
            obj.Data=obj.Data(1:obj.iMeasurements,:); 
            obj.Action=obj.Action(1:obj.iMeasurements,:); 
    end
   
        
       
    