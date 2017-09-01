function obj=set_arduino_parameters(obj,ChangeSettings)
    
    Settings_sep=[repmat('-',[1 72]) '\n'];


    if ~ChangeSettings
        fprintf(Settings_sep);
        fprintf('Changing Arduino voltage configuration to %s\n',obj.Hardware.arduino);
        switch lower(obj.Hardware.arduino)
            case 'uno'
                fprintf('Arduino Uno (10 bits, 5V) settings\n')
                obj.Hardware.Bits=10;
                obj.Hardware.Volts=5;
            case 'mega'
                fprintf('Arduino Mega (10 bits, 5V) settings\n')
                obj.Hardware.Bits=10;
                obj.Hardware.Volts=5;
            case 'due'
                fprintf('Arduino Due (12 bits, 3.3V) settings\n')
                obj.Hardware.Bits=12;
                obj.Hardware.Volts=3.3;
            otherwise
                fprintf('Default (No scaling) settings\n')
                obj.Hardware.Bits=0;
                obj.Hardware.Volts=1;
        end
        fprintf(Settings_sep);
    end
    
    if ChangeSettings
        obj.open_port;
        fprintf(Settings_sep);
        fprintf('Arduino internal settings:\n')
        fprintf('\n')
        fprintf('Channels:    %d\n',obj.Hardware.Channels);
        fprintf('Averaging:   %d\n',obj.Hardware.nMeasures);
        fprintf('Acq period:  %d\n',obj.Hardware.delay);
        fprintf(Settings_sep);
        fprintf(obj.Hardware.Serial,sprintf('N %06d %06d %06d',obj.Hardware.Channels,obj.Hardware.nMeasures,obj.Hardware.delay));
        obj.close_port;
    end