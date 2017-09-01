function obj=control(obj)

%%%%%%%%%%%  As control happens during acquisition: 
%         %  SERIAL PORT IS ASSUMED OPENED
%    %    %   
%   % %   %  so control does not execute if port is not opened 
%  % ! %  %
% %%%%%%% %
%         %
%%%%%%%%%%%

if ~isfield(obj.Hardware,'Serial');
    fprintf('Serial port is closed');
    return
end

if ~ismember(lower(obj.Control.Type),{'stagedsequence'})
    if strcmpi(obj.Control.Type,'none')
        fprintf('Control method is set to ''None''\n');
    else
        fprintf('Unknown control method ''%s''.\n',obj.Control.Type);
    end
    fpritnf('Not doing anything.\n');
    return;
end

Settings_sep=[repmat('-',[1 72]) '\n'];

%% Shaping instruction string to send
fprintf(Settings_sep);
fprintf('Control Type: %s\n',obj.Control.Type);
switch lower(obj.Control.Type)
    case 'stagedsequence'
        fprintf('   - Pulse width : %d ms\n',obj.Control.PulseWidth);
        fprintf('   - Repetitions : %d\n',obj.Control.Repetition);
        fprintf('   - Delay       : %.3f s\n',obj.Control.Delay/1000);
        ctrlstring=sprintf('A %06d %06d %06d',obj.Control.PulseWidth,obj.Control.Repetition,obj.Control.Delay);
end

%% Sending String

fprintf(Settings_sep);
fprintf('Sending: %s\n',ctrlstring);
fprintf(obj.Hardware.Serial,'%si\n',ctrlstring);
fprintf(Settings_sep);
