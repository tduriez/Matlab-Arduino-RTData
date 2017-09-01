function HardwareChange(metaProp,eventData)

    h=eventData.AffectedObject;
    
    
    PropertiesToTest={'arduino','delay','Channels','nMeasures'};
    
    for i=1:numel(PropertiesToTest)
        if ischar(h.Hardware.(PropertiesToTest{i}))
            if ~strcmp(h.Hardware.(PropertiesToTest{i}),h.(PropertiesToTest{i}))
            h.set_arduino_parameters(0);
            h.(PropertiesToTest{i})=h.Hardware.(PropertiesToTest{i});
            end
        else
        if h.Hardware.(PropertiesToTest{i})~=h.(PropertiesToTest{i})
            h.set_arduino_parameters(~strcmp(PropertiesToTest{i},'arduino'));
            h.(PropertiesToTest{i})=h.Hardware.(PropertiesToTest{i});
        end
        end
    end
        
end