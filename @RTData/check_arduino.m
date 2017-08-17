function freq=check_arduino(obj)
     obj.open_port;
     try
     nTest=10;
     h=waitbar(0,'Checking Arduino data collection frequency:');
     time=zeros(nTest,1);
     f=zeros(nTest,1);
     iAcquis=0;
     while iAcquis<nTest
         msg=fscanf(obj.Hardware.Serial);
         if strfind(msg(1),'D');
             iAcquis=iAcquis+1;
             idx=[strfind(msg,' ') numel(msg+1)];
             time(iAcquis)=str2double(msg(idx(1)+1:idx(2)-1));
             if iAcquis>1
                f(iAcquis)=1000/(time(iAcquis)-time(iAcquis-1));
             end
             waitbar(iAcquis/nTest,h,sprintf('Checking Arduino data collection frequency: %.2f Hz',median(f(2:iAcquis))));
             
         end
     end
     close(h);
     freq=median(f(2:iAcquis));
     fprintf('Measured acquisition frequence: %.2f Hz\n',freq);
     catch
         freq=NaN;
     end
     
     obj.close_port;
     
     