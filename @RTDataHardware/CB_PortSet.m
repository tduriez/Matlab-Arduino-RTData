function CB_PortSet(~,eventData)
    obj=eventData.AffectedObject;
    if isa(obj.Serial,'serial')
        obj.closePort(1);
        delete(obj.Serial);
    end
    obj.createSerial;
end