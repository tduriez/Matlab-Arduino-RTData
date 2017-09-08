classdef RTDataHardware < handle
    
    %% TODO
    %arduino > Arduino
    %delay > Delay
    
   properties (SetObservable)
      arduino='due'
      delay=1000
      Port
      Channels=2
      nMeasures=1
   end
   
   properties (Hidden,SetAccess=private)
      Bits=12
      Volts=3.3
   end
   
   properties (SetAccess=private)
      Serial
   end
   
   methods
       function obj=RTDataHardware(ThePort);
           obj.Port=ThePort;
       end
       
       function openPort(obj)
           
       end
       
       function closePort(obj)
       
       end
       
       function delete(obj)
           
       end
       
   end
   
   
   
end