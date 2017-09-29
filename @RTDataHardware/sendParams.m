function sendParams(obj,Control)
    if nargin<2
        Control=[];
    end
    STLCargo=zeros(1,11);
    STLCargo(1)=obj.Channels+16;
    STLCargo(2)=uint8(obj.nMeasures);
    STLCargo(6)=mod(obj.Delay,2^8);
    STLCargo(5)=mod(obj.Delay-STLCargo(6),2^16)/2^8;
    STLCargo(4)=mod(obj.Delay-STLCargo(6)-STLCargo(5)*2^8,2^24)/2^16;
    STLCargo(3)=(obj.Delay-STLCargo(6)-STLCargo(5)*2^8-STLCargo(4)*2^16)/2^24;
    if ~isempty(Control)
        switch lower(Control.Type)
            case 'stagedsequence'
                STLCargo(8)=mod(Control.PulseWidth,2^8);
                STLCargo(7)=(Control.PulseWidth-STLCargo(8))/2^8;
                STLCargo(9)=uint8(Control.Repetition);
                STLCargo(11)=mod(Control.Delay,2^8);
                STLCargo(10)=(Control.Delay-STLCargo(11))/2^8;
        end
    end
    Settings_sep=[repmat('-',[1 72]) '\n'];
    obj.openPort;
    fprintf(Settings_sep);
    fprintf('Sending Cargo to Arduino via STL: ');
    fprintf('%d ',STLCargo);
    fprintf('\n');
    flushinput(obj.Serial);
    flushoutput(obj.Serial);
    fwrite(obj.Serial,STLCargo,'uint8');
end