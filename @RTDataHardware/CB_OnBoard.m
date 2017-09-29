function CB_OnBoard(propChanged,eventData)
    Settings_sep=[repmat('-',[1 72]) '\n'];
    fprintf(Settings_sep);
    obj=eventData.AffectedObject;
    switch propChanged.Name
        case 'Delay'
            fprintf('New loop delay: %d us.\n',obj.Delay);
        case 'Channels'
            fprintf('New number of input channels: %d.\n',obj.Channels);
        case 'nMeasures'
            fprintf('New number of averaging measures: %d.\n',obj.nMeasures);
    end
    obj.sendParams;
end