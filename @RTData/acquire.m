function obj=acquire(obj)
    if ~obj.acquired
        obj.open_port;
        try
            time_init=0;
            tic
            iAcquis=0;
            TheFig=figure;
            msg=fscanf(obj.Hardware.Serial);
            nbSensors=[];
            iTest=0;
            while isempty(nbSensors);
                msg=fscanf(obj.Hardware.Serial);
                if strfind(msg(1),'S');
                    idx = strfind(msg,' ');
                    idx2 = strfind(msg,' C');
                    idx3 = idx(idx>idx2); 
                    idx=idx(idx<idx2);
                    nbSensors=numel(idx)-1;
                    nbControls=numel(idx3);
                end
                iTest=iTest+1;
                if iTest>30;
                    error('Couldn''t find Data line from Arduino');
                end
            end
            nbFigs=nbSensors+nbControls;
            obj.makeLiveInterface(nbFigs,TheFig);
            

            Marker=1;
            time_init=0;
            while ishandle(TheFig)
                [Marker,time_init]=GetDataFromSerial(obj,Marker,time_init,nbSensors,nbControls);
            end
            Tend=toc;
            while obj.Time(end)<Tend %% Purging the cache up to real time figure closing
                GetDataFromSerial(obj,2,time_init,nbSensors,nbControls);
            end
        catch err
            obj.close_port
            save lasterr err
            throw(err)
        end
        obj.stop;
        obj.close_port;
        obj.acquired=1;
        obj.save;
        
        
    else
        fprintf('Data already collected for this object\n')
    end
end

function [Marker,time_init]=GetDataFromSerial(obj,Marker,time_init,nbSensors,nbControls)
    msg=fscanf(obj.Hardware.Serial);
    if Marker==2
        warning('off','MATLAB:callback:error');
    else
        drawnow limitrate
    end
   
    if strfind(msg(1),'S');
        idx=[strfind(msg,' ') numel(msg+1)];
        TheTime=str2double(msg(idx(1)+1:idx(2)-1));
        if Marker==1
            Marker=0;
            time_init=TheTime;
        end
        Sensor=zeros(1,nbSensors);
        Control=zeros(1,nbControls);
        for k=2:nbSensors+1
            Sensor(k-1)=str2double(msg(idx(k)+1:idx(k+1)-1))/2^obj.Hardware.Bits *obj.Hardware.Volts;
        end
        for k=1:nbControls
           Control(k)=str2double(msg(idx(nbSensors+k+2)+1:idx(nbSensors+k+3)-1));
        end
        obj.addmeasure((TheTime-time_init)/1000,Sensor,Control);
    end
end