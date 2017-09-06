function STLDocking(obj)
    dummy=fread(obj.Hardware.Serial,50,'uint8');
    for i=51:100
        if all(dummy(i-4:i-1)==[255 255 13 10]')
            return
        end
        dummy(i)=fread(obj.Hardware.Serial,1,'uint8');
    end
end