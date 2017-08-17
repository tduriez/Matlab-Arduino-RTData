function obj=set_arduino_delay(obj,d)
    
    obj.open_port;
    fprintf('Setting Arduino loop delay to %d\n',d)
    fprintf(obj.Hardware.Serial,sprintf('%d',round(d)));
    obj.close_port;
