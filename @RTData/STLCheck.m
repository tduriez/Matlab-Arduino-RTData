function STLCheck(obj)
    sep=repmat('-',[1 70]);
    obj.open_port;
    fprintf(obj.Hardware.Serial,'Q');
    flushinput(obj.Hardware.Serial);
    pause(0.1);
    for i=1:5
        fscanf(obj.Hardware.Serial);
    end
    a=fscanf(obj.Hardware.Serial)
    idx=strfind(a,' ');
    nSensors=str2double(a(1:idx(1)-1));
    nMeasures=str2double(a(idx(1)+1:idx(2)-1));
    SetDelay=str2double(a(idx(2)+1:idx(3)-1));
    mDelay=str2double(a(idx(3)+1:end));
    fprintf(obj.Hardware.Serial,'');
    flushinput(obj.Hardware.Serial);
    fprintf(sep)
    fprintf('Parameters used:\n')
    fprintf('Sensors:        %d\n',nSensors);
    fprintf('Measures:       %d\n',nMeasures);
    fprintf('Set delay:      %d\n',SetDelay);
    fprintf('Measured delay: %d\n',mDelay);
    obj.close_port;
    