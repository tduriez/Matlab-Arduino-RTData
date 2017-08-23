function HardwareChange(metaProp,eventData)

    h=eventData.AffectedObject;
    
    
    PropertiesToTest={'arduino','delay','Channels','nMeasures'};
    
    for i=1:numel(PropertiesToTest)
        if h.Hardware.(PropertiesToTest{i})~=h.(PropertiesToTest{i})
            h.set_arduino_parameters(~strcmp(PropertiesToTest{i},'arduino'));
            h.(PropertiesToTest{i})=h.Hardware.(PropertiesToTest{i});
        end
    end
        
end