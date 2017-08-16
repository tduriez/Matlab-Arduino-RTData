function save(obj)

    obj.AcqDate=datestr(now,'yyyymmdd-HHMMSS');
    if obj.Save>0
        acquis=obj;
        save(sprintf('%s-%s.mat',obj.AcqDate,obj.Name),'acquis');
    end

    if abs(obj.Save)>1
        fid=fopen(sprintf('%s-%s.txt',obj.AcqDate,obj.Name),'w');
        format=['%.3f ' repmat('%.6f ',[1 size(obj.Data,2)-1]) '%.6f\n'];
        fprintf(fid,format,[obj.Time obj.Data]');
        fclose(fid);
    end