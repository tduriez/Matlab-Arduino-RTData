function obj=acquire(obj)
    if ~obj.acquired
        obj.open_port;
        try
            time_init=0;
            tic
            iAcquis=0;
            TheFig=figure;
            msg=fscanf(obj.Hardware.Serial);
            if strfind(msg(1),'D');
                nbFig=numel(strfind(msg,' '))-1;
            end
            for k=1:nbFig
                subplot(nbFig,1,k)
                obj.graphics.axes_handles(k)=gca;
                obj.graphics.plot_handles(k)=plot(1,1,'*');
                if k==1
                    obj.graphics.text_handles(1)=title(sprintf('%3.2f s',toc));
                end
            end



            while ishandle(TheFig)
                msg=fscanf(obj.Hardware.Serial);
                drawnow limitrate
                if strfind(msg(1),'D');
                    iAcquis=iAcquis+1;
                    idx=[strfind(msg,' ') numel(msg+1)];
                    TheTime=str2double(msg(idx(1)+1:idx(2)-1));
                    if iAcquis==1
                        time_init=TheTime;
                        Sensor=zeros(1,numel(idx)-2);
                    end

                    for k=2:numel(idx)-1
                        Sensor(k-1)=str2double(msg(idx(k)+1:idx(k+1)-1))/obj.Hardware.Bits *obj.Hardware.Volts;
                    end

                    obj.addmeasure((TheTime-time_init)/1000,Sensor);
                end
            end
            Tend=toc;
            while obj.Time(end)<Tend
                % warning('off','MATLAB:callback:error')
                msg=fscanf(obj.Hardware.Serial);
                if strfind(msg(1),'D');
                    idx=[strfind(msg,' ') numel(msg+1)];
                    TheTime=str2double(msg(idx(1)+1:idx(2)-1));
                    for k=2:numel(idx)-1
                        Sensor(k-1)=str2double(msg(idx(k)+1:idx(k+1)-1))/obj.Hardware.Bits *obj.Hardware.Volts;
                    end
                    obj.addmeasure((TheTime-time_init)/1000,Sensor);
                else
                    break
                end
            end
        catch err
            obj.close_port
            save lasterr err
            throw(err)
        end
        obj.close_port
        obj.acquired=1;
        obj.save;
        
        
    else
        fprintf('Data already collected for this object\n')
    end
end