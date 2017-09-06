function obj=STLGrocery(obj,time,sensors,control)
    obj.iMeasurements=obj.iMeasurements+1;
    
    if obj.iMeasurements>obj.nBuffer || isempty(obj.Time)
        obj.STLCargoManagement('more');
    end
    obj.Data(obj.iMeasurements,:)=single(sensors(:));
    obj.Action(obj.iMeasurements,:)=single(control(:));
    obj.Time(obj.iMeasurements)=single(time);
    
    %%%%%%%%%%%  obj.Time must be the last one updated 
    %         %  This triggers a callback that needs obj.Data and
    %    %    %  obj.Action with the same size(~,1) as obj.Time.
    %   % %   %   
    %  % ! %  %  WHY ARE YOU READING THIS ANYWAY ?
    % %%%%%%% %
    %         %  You are warned.
    %%%%%%%%%%%  DO NOT CHANGE THE ORDER. Or maybe Action before Data.

end