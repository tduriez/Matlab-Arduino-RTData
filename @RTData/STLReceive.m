function [time_init,timing]=STLReceive(obj,time_init,Marker,nbSensors,nbControls,Tend)
if Marker==2 % If display is closed
    warning('off','MATLAB:callback:error');
else
 %   drawnow limitrate % skip drawings if cannot keep up
end
CargoBitSize=8+nbSensors*2;
nBuffer=get(obj.Hardware.Serial,'BytesAvailable');
nbacquis=floor(nBuffer/CargoBitSize);
if nbacquis==0
    timing=[];
    return;
end
dummy=fread(obj.Hardware.Serial,CargoBitSize*nbacquis,'uint8');
for nba=1:nbacquis
    a=dummy(1+CargoBitSize*(nba-1):CargoBitSize*nba);
    [Control,a]=demultiplexbyte(a,nbControls);
    TheTime=a(1)*2^24+a(2)*2^16+a(3)*2^8+a(4);
    
    if time_init==0
        time_init=TheTime;
        fprintf('Acquisition started\n');
    end
    
    if nargout==2
        if nba==1
            timing=zeros(1,nbacquis);
        end
        timing(nba)=TheTime;
        continue;
    end
    
    Sensors=sum(reshape(a(5:6+2*(nbSensors-1)),[2 nbSensors]).*repmat([2^8; 1],[1 nbSensors]));
    if any(a(end-3:end)~=[255 255 13 10]')
        fprintf('%d ',a');fprintf('\n');
    end
    % Include measurement in the RTDataObject. Also triggers STLPlot
    % if display is open.
    obj.STLStorage((TheTime-time_init)/10^6,Sensors,Control,Marker);
end

if nargin==6
    if (TheTime-time_init)/10^6 > Tend
        time_init=-1;
    end
end


end

function [control,TheBytes]=demultiplexbyte(TheBytes,nbControl)
% 4 controls can be coded on each sensors.
Sensorbyte=[5; 5; 5; 5];
Controlbit=[8; 7; 6; 5];
control=(TheBytes(Sensorbyte)-mod(TheBytes(Sensorbyte),2.^(Controlbit-1)))./2.^(Controlbit-1);
TheBytes(Sensorbyte)=TheBytes(Sensorbyte)-control.*2.^(Controlbit-1);
control=control(1:nbControl);
end