function [nSensors,nMeasures,SetDelay,mDelay,mDelay2]=STLCheck(obj)
    sep=[repmat('-',[1 70]) '\n'];
    obj.open_port;

    fprintf(obj.Hardware.Serial,'Q');
    flushinput(obj.Hardware.Serial);
    pause(0.1);
    for i=1:5
        fscanf(obj.Hardware.Serial);
    end
    a=fscanf(obj.Hardware.Serial);
    idx=strfind(a,' ');
    nSensors=str2double(a(1:idx(1)-1));
    nMeasures=str2double(a(idx(1)+1:idx(2)-1));
    SetDelay=str2double(a(idx(2)+1:idx(3)-1));
    mDelay=str2double(a(idx(3)+1:end));
    fprintf(obj.Hardware.Serial,'');
    flushinput(obj.Hardware.Serial);
    pause(0.1);
    nbSensors=obj.Hardware.Channels;
    nbControls=1;
    obj.STLDocking;
    time_init=0;
    Marker=1;
    t=zeros(20,1);
    nbacquis=0;
    while nbacquis<10
        [time_init,TheTime]=STLReceive(obj,time_init,Marker,nbSensors,nbControls);
        if ~isempty(TheTime)
            t(nbacquis+1:nbacquis+length(TheTime))=TheTime;
            nbacquis=nbacquis+length(TheTime);
        end
    end
    t=t(1:nbacquis);
    dt=mean(diff(t));
    mDelay2=round(dt);
    fprintf(sep)
    fprintf('Parameters used:\n')
    fprintf('Sensors:        %d\n',nSensors);
    fprintf('Measures:       %d\n',nMeasures);
    fprintf('Set delay:      %d\n',SetDelay);
    fprintf('Measured delay (intern): %d\n',mDelay);
    fprintf('Measured delay (extern): %d\n',mDelay2);
    obj.close_port;
end