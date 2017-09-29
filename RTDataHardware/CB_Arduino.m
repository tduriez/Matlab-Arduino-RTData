function CB_Arduino(~,eventData)
    Settings_sep=[repmat('-',[1 72]) '\n'];
    obj=eventData.AffectedObject;
    fprintf(Settings_sep);
    fprintf('Changing Arduino voltage configuration to %s\n',obj.Arduino);
    switch lower(obj.Arduino)
        case 'uno'
            fprintf('Arduino Uno (10 bits, 5V) settings\n')
            obj.Bits=10;
            obj.Volts=5;
        case 'mega'
            fprintf('Arduino Mega (10 bits, 5V) settings\n')
            obj.Bits=10;
            obj.Volts=5;
        case 'due'
            fprintf('Arduino Due (12 bits, 3.3V) settings\n')
            obj.Bits=12;
            obj.Volts=3.3;
        otherwise
            fprintf('Default (No scaling) settings\n')
            obj.Hardware.Bits=0;
            obj.Hardware.Volts=1;
    end
    fprintf(Settings_sep);
end