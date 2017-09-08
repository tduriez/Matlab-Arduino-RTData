function obj=STLGrocery(obj,time,sensors,control)
    obj.iMeasurements=obj.iMeasurements+1;
    i=obj.iMeasurements;
    if obj.iMeasurements>obj.nBuffer || isempty(obj.Time)
        obj.STLCargoManagement('more');
        obj.nBuffer=obj.nBuffer+obj.nBuffer;
    end
    
    obj.Data(i,:)=sensors(:);
    obj.Action(i,:)=control(:);
    obj.Time(i)=time;


    
    %%%%%%%%%%%  obj.Time must be the last one updated 
    %         %  This triggers a callback that needs obj.Data and
    %    %    %  obj.Action with the same size(~,1) as obj.Time.
    %   % %   %   
    %  % ! %  %  WHY ARE YOU READING THIS ANYWAY ?
    % %%%%%%% %
    %         %  You are warned.
    %%%%%%%%%%%  DO NOT CHANGE THE ORDER. Or maybe Action before Data.

end