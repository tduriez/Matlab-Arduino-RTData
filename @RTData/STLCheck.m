function [nSensors,nMeasures,SetDelay,mDelay,mDelay2]=STLCheck(obj,mode)
%STLCHECK     Checks STL communications and the board loop delay
%
% [N1,N2,D1,D2,D3]=RTDataObject.STLCheck
%
% Returns:
%           N1: number of sensors set
%           N2: number of measures for averaging set
%           D1: Delay set in microseconds
%           D2: Delay, as measured on board in microseconds
%           D3: Delay, as measured by information reception in microseconds
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


try
    if nargin<2
        mode='normal';
    end
    sep=[repmat('-',[1 70]) '\n'];
    obj.openPort;
    
    fwrite(obj.Hardware.Serial,repmat(255,[1 11])); %% 
    flushinput(obj.Hardware.Serial);
 %   pause(0.1);
 %   flushinput(obj.Hardware.Serial);
    a=[1 2];
    idx=[];
    while ~((length(idx)==3) && all(a(end-1:end)==[13 10]))
        a=fscanf(obj.Hardware.Serial);
        if strcmpi(mode,'debug')
            fprintf('From Arduino (Query): %s\n',a);
        end
        if numel(a)<2
            a=[1 2];
        end
        idx=strfind(a,' ');
    end
    if strcmpi(mode,'debug')
        fprintf('From Arduino (Query): %s\n',a);
    end
   
nSensors=str2double(a(1:idx(1)-1));
    nMeasures=str2double(a(idx(1)+1:idx(2)-1));
    SetDelay=str2double(a(idx(2)+1:idx(3)-1));
    mDelay=str2double(a(idx(3)+1:end));
    fprintf(obj.Hardware.Serial,'');
    flushinput(obj.Hardware.Serial);
    pause(0.1);
    flushinput(obj.Hardware.Serial);
    nbSensors=nSensors;
    nbControls=1;
    obj.STLDocking;
    time_init=0;
    Marker=1;
    t=zeros(20,1);
    nbacquis=0;
    while nbacquis<10
        [time_init,TheTime]=STLReceive(obj,time_init,Marker,nbSensors,nbControls);
        if ~isempty(TheTime)
            t(nbacquis+1:nbacquis+length(TheTime))=TheTime;
            nbacquis=nbacquis+length(TheTime);
        end
    end
    t=t(1:nbacquis);
    dt=mean(diff(t));
    mDelay2=round(dt);
    fprintf(sep)
    fprintf('Parameters used:\n')
    fprintf('Sensors:        %d\n',nSensors);
    fprintf('Measures:       %d\n',nMeasures);
    fprintf('Set delay:      %d\n',SetDelay);
    fprintf('Measured delay (intern): %d\n',mDelay);
    fprintf('Measured delay (extern): %d\n',mDelay2);
catch err
   save STLCheck_lasterr 
   throw(err)
end
end
