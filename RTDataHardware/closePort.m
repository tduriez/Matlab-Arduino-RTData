function closePort(obj,nomsg)
    if nargin<2
        nomsg=0;
    end
    if isempty(obj.Port)
        if nomsg
            return
        else
            error('Can''t close serial port: no serial port has been configured.');
        end
    end
    if ~isa(obj.Serial,'serial')
        if nomsg
            return
        else
            error('Can''t close serial port: serial object not created.');
        end
    end

    if isvalid(obj.Serial)
        if strcmpi(get(obj.Serial,'Status'),'closed')
            if ~nomsg
                fprintf('Serial port %s already closed\n',obj.Port)
            end
        else
            fclose(obj.Serial);
            if ~nomsg
                fprintf('Serial port %s closed\n',obj.Port)
            end
        end
    end
end