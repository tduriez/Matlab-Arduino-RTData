function HardwareChange(metaProp,eventData)

    h=eventData.AffectedObject;
    if ~strcmp(h.Hardware.arduino,h.arduino)
        fprintf('Changing Arduino configuration to %s\n',h.Hardware.arduino);
        switch h.Hardware.arduino
            case 'uno'
                h.Hardware.Bits=10;
                h.Hardware.Volts=5;
            case 'mega'
                h.Hardware.Bits=10;
                h.Hardware.Volts=5;
            case 'due'
                h.Hardware.Bits=12;
                h.Hardware.Volts=3.3;
            otherwise
                h.Hardware.Bits=0;
                h.Hardware.Volts=1;
        end
        h.arduino=h.Hardware.arduino
    end
    
    if h.Hardware.delay~=h.delay
        
        
        h.set_arduino_delay(h.Hardware.delay);
        h.delay=h.Hardware.delay;
        
    end
                
        
        
        
end