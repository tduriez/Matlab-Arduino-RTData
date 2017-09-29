function openPort(obj)
    if isempty(obj.Port)
        error('Can''t open serial port: no serial port has been configured.');
    end
    if ~isa(obj.Serial,'serial')
        obj.createSerial;
    else
        if isempty(obj.Serial)
            obj.createSerial;
        end
    end

    if ~isvalid(obj.Serial)
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