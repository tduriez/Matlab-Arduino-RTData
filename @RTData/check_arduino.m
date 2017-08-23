function period=check_arduino(obj)
     obj.open_port;
     try
     nTest=10000;
     h=waitbar(0,'Checking Arduino data collection:');
     time=zeros(nTest,1);
     dt=zeros(nTest,1);
     iAcquis=0;
     while iAcquis<nTest
         msg=fscanf(obj.Hardware.Serial);
         if strfind(msg(1),'D');
             iAcquis=iAcquis+1;
             idx=[strfind(msg,' ') numel(msg+1)];
             time(iAcquis)=str2double(msg(idx(1)+1:idx(2)-1));
             if iAcquis>1
                dt(iAcquis)=(time(iAcquis)-time(iAcquis-1));
                nTest=min(nTest,round(5000/dt(iAcquis)));
             end
             waitbar(iAcquis/nTest,h,sprintf('Checking Arduino data collection delay: %.2f ms',mean(dt(2:iAcquis))));
             
         end
     end
     close(h);
     period=mean(dt(2:iAcquis));
     fprintf('Measured average period: %d ms (%.2f Hz)\n',round(period),1000/period);
     catch err
         obj.close_port;
         period=NaN;
         throw(err)
     end
     
     obj.close_port;
     
     