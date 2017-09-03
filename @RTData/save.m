function save(obj)
%SAVE       method of the RTData class. Saves the current RTData object.
%
%   RTDataObject.SAVE does one of the following depending on the value in
%   RTDataObject.Save. 
%
%   RTDataObject.Save      |    Action
%   ------------------------------------------------------
%           0              |    Nothing
%           1              |  saves DATE-NAME.mat
%           2              |  saves DATE-NAME.mat and
%                          |  DATE-NAME.txt
%          -2              |  saves DATE-NAME.txt
%
%    NAME is RTDataObject.Name, DATE is the result of
%    datestr(now,'yyyymmdd-HHMMSS').
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

    obj.AcqDate=datestr(now,'yyyymmdd-HHMMSS');
    if obj.Save>0
        acquis=obj;
        save(sprintf('%s-%s.mat',obj.AcqDate,obj.Name),'acquis');
    end

    if abs(obj.Save)>1
        fid=fopen(sprintf('%s-%s.txt',obj.AcqDate,obj.Name),'w');
        format=['%.3f ' repmat('%.6f ',[1 size(obj.Data,2)-1]) '%.6f\n'];
        fprintf(fid,format,[obj.Time obj.Data]');
        fclose(fid);
    end