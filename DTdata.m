classdef DTdata < matlab.mixin.Copyable
    properties
        time
        data
    end
    
    methods (Static)
        function get_data(src,evnt,datus)
            datus.time=[datus.time ;evnt.TimeStamps];
            datus.data=[datus.data ;evnt.Data];
        end
    end
end
