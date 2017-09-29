function disp(obj,mode)
    if nargin<2
        mode='all';
    end
    disptxt=[];
    if strcmpi(mode,'all')
        disptxt=sprintf('RTData Hardware Object:\n\n');
    end
    if any(strcmpi(mode,{'serial','all','simple'}))
        disptxt=sprintf('%s -Serial configuration:\n',disptxt);
        disptxt=sprintf('%s    -Serial Port: %s\n',disptxt,obj.Port);
        if isa(obj.Serial,'serial')
            disptxt=sprintf('%s    -Baudrate:    %d\n',disptxt,get(obj.Serial,'BaudRate'));
            disptxt=sprintf('%s    -Buffer size: %d\n',disptxt,get(obj.Serial,'InputBufferSize'));
            disptxt=sprintf('%s    -Status:      %s\n',disptxt,get(obj.Serial,'Status'));
        else
            disptxt=sprintf('%s    -Status:      %s\n',disptxt,'not created');
        end
    end
    if strcmpi(mode,'all')
        disptxt=sprintf('%s\n',disptxt);
    end
    if any(strcmpi(mode,{'arduino','all','simple'}))
        disptxt=sprintf('%s -Arduino configuration:\n',disptxt);
        disptxt=sprintf('%s    -Type:        %s\n',disptxt,obj.Arduino);
        disptxt=sprintf('%s         -Bits:   %d\n',disptxt,obj.Bits);
        disptxt=sprintf('%s         -Volts:  %.1f\n',disptxt,obj.Volts);
        disptxt=sprintf('%s    -Delay:       %d us (%.2f Hz)\n',disptxt,obj.Delay,10^6/obj.Delay);
        disptxt=sprintf('%s    -Channels:    %d\n',disptxt,obj.Channels);
        disptxt=sprintf('%s    -Measures:    %d\n',disptxt,obj.nMeasures);
    end
    fprintf(disptxt);
end