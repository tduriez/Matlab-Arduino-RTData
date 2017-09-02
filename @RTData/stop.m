function obj=stop(obj)
    if ~isfield(obj.Hardware,'Port')
        error('No Port is configured, can''t stop anything. Consider cut board power.')
    end
    was_closed=0;
    if ~isfield(obj.Hardware,'Serial')
        obj.open_port;
        was_closed=1;
    end
    fprintf(obj.Hardware.Serial,'K');
    pause(1)
    if was_closed
        obj.close_port;
    end
end
    