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