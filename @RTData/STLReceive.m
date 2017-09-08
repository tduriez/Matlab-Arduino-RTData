function [time_init,TheTime]=STLReceive(obj,time_init,Marker,nbSensors,nbControls)
    if Marker==2 % If display is closed
         warning('off','MATLAB:callback:error');
    else
         drawnow limitrate % skip drawings if cannot keep up
    end
    CargoBitSize=8+nbSensors*2;
    nBuffer=get(obj.Hardware.Serial,'BytesAvailable');
    nbacquis=floor(nBuffer/CargoBitSize);
    if nbacquis==0
        return;
    end
    dummy=fread(obj.Hardware.Serial,CargoBitSize*nbacquis,'uint8');
    Sensors=zeros(1,nbSensors);
    for nba=1:nbacquis
        a=dummy(1+CargoBitSize*(nba-1):CargoBitSize*nba);
        [Control,a]=demultiplexbyte(a,nbControls);
        TheTime=a(1)*2^24+a(2)*2^16+a(3)*2^8+a(4);
        if time_init==0
            time_init=TheTime;
            fprintf('Acquisition started\n');
        end
        for k=1:nbSensors
            Sensors(k)=(a(5+2*(k-1))*2^8+a(6+2*(k-1)))/2^obj.Hardware.Bits *obj.Hardware.Volts;
        end
        if any(a(end-3:end)~=[255 255 13 10]')
            fprintf('%d ',a');fprintf('\n');
        end
        % Include measurement in the RTDataObject. Also triggers AutoPlot
        % if display is open.
        obj.STLGrocery((TheTime-time_init)/10^6,Sensors,Control);
    end
end

function [control,TheBytes]=demultiplexbyte(TheBytes,nbControl)
    % 4 controls con be coded on each sensors. 
    Sensorbyte=[5; 5; 5; 5];
    Controlbit=[8; 7; 6; 5];   
    control=(TheBytes(Sensorbyte)-mod(TheBytes(Sensorbyte),2.^(Controlbit-1)))./2.^(Controlbit-1);
    TheBytes(Sensorbyte)=TheBytes(Sensorbyte)-control.*2.^(Controlbit-1);
    control=control(1:nbControl);
end