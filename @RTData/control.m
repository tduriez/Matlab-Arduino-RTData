function obj=control(obj)
%CONTROL    method of the RTData class. Sends control instruction to the
%           arduino.
%
%   RTDataObject.CONTROL  sends the control instructions included in
%       RTDataObject.Control
%
%   The following control methods are implemented:
%       Control:          
%       --------------------------------------
%       []  ----> No effect
%       --------------------------------------
%       .Type = 'StagedSequence'
%       .PulseWidth = PW (int)
%       .Repetition = R  (int)
%       .Delay      = D  (int)
%           ----> R pulses of PW ms every D ms
%       ---------------------------------------
%
%   CONTROL assumes the communication port is already opened.
%
%   See also: RTData
%   Copyright (c) 2017, Thomas Duriez (Distributed under GPLv3)

%% Copyright
%    Copyright (c) 2017, Thomas Duriez (thomas.duriez@gmail.com)
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.


%%%%%%%%%%%  As control happens during acquisition: 
%         %  SERIAL PORT IS ASSUMED OPENED
%    %    %   
%   % %   %  so control does not execute if port is not opened 
%  % ! %  %
% %%%%%%% %
%         %
%%%%%%%%%%%

if ~isfield(obj.Hardware,'Serial')
    fprintf('Serial port is closed\n');
    return
end

if isempty(obj.Control)
    fprintf('No control defined\n');
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
        % Arduino expects a A as leading element of this command
        % instruction
        fprintf('   - Pulse width : %d ms\n',obj.Control.PulseWidth);
        fprintf('   - Repetitions : %d\n',obj.Control.Repetition);
        fprintf('   - Delay       : %d ms\n',obj.Control.Delay);
        ctrlstring=sprintf('A %06d %06d %06d',obj.Control.PulseWidth,obj.Control.Repetition,obj.Control.Delay);
        
end

%% Sending String

fprintf(Settings_sep);
fprintf('Sending: %s\n',ctrlstring);
fprintf(obj.Hardware.Serial,'%si\n',ctrlstring);
fprintf(Settings_sep);
