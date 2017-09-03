function obj=makeLiveInterface(obj,nbFigs,TheFig)
%makeLiveInterface      method of the RTData class. Creates the real-time
%                       display.
%
%   RTDataObject.MAKELIVEINTERFACE(NBFIGS,FIGHANDLE) uses the figure of
%   handle FIGHANDLE in order to create the real-time displays. NBFIGS axes
%   are create along with two UIcontrols to start and stop the control
%   action stocked in RTDataObject.Control.
%
%   See also: RTData, RTData/control
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
figure(TheFig);
set(gcf, 'Position', get(0,'Screensize'))
tic
for k=1:nbFigs
    subplot(min(nbFigs,4),ceil(nbFigs/4),k)
    obj.graphics.axes_handles(k)=gca;
    obj.graphics.plot_handles(k)=plot(1,1,'*');
    if k==1
        obj.graphics.text_handles(1)=title(sprintf('%3.2f s',toc));
    end
end

uicontrol(...
'Parent',gcf,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','normalized',...
'ListboxTop',0,...
'String','Start control',...
'Position',[0.025 0.9 0.05 0.05],...
'BackgroundColor',[0.831 0.816 0.784],...
'Callback',@(hObject, eventdata)bttncallback(hObject, eventdata,obj),...
'Children',[],...
'KeyPressFcn',blanks(0),...
'ParentMode','manual',...
'ButtonDownFcn',blanks(0),...
'Tag','pushbutton1',...
'UserData',[]);

uicontrol(...
'Parent',gcf,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','normalized',...
'ListboxTop',0,...
'String','Stop control',...
'Position',[0.025 0.8 0.05 0.05],...
'BackgroundColor',[0.831 0.816 0.784],...
'Callback',@(hObject, eventdata)bttncallback2(hObject, eventdata,obj),...
'Children',[],...
'KeyPressFcn',blanks(0),...
'ParentMode','manual',...
'ButtonDownFcn',blanks(0),...
'Tag','pushbutton2',...
'UserData',[]);

uicontrol(...
'Parent',gcf,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','normalized',...
'String',{  '1','2','3','4' },...
'Style','popupmenu',...
'Value',1,...
'ValueMode',get(0,'defaultuicontrolValueMode'),...
'Position',[0.025 0.65 0.05 0.05],...
'Callback',@(hObject, eventdata)menucallback(hObject, eventdata,obj,nbFigs),...
'Children',[],...
'ButtonDownFcn',blanks(0),...
'DeleteFcn',blanks(0),...
'Tag','ChannelsMenu',...
'KeyPressFcn',blanks(0));

uicontrol(...
'Parent',gcf,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','normalized',...
'String','Number of columns',...
'Style','text',...
'Value',1,...
'ValueMode',get(0,'defaultuicontrolValueMode'),...
'Position',[0.02 0.72 0.075 0.015],...
'Children',[],...
'ButtonDownFcn',blanks(0),...
'DeleteFcn',blanks(0),...
'Tag','Channelstext',...
'KeyPressFcn',blanks(0));



end

function bttncallback(hObject, eventdata,obj)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj.control;
end

function bttncallback2(hObject, eventdata,obj)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj.stop;
end

function menucallback(hObject,eventdata,obj,nbFigs)
nbCol=get(hObject,'Value');
for k=1:nbFigs
    delete(obj.graphics.axes_handles(k));
end

for k=1:nbFigs
    subplot(ceil(nbFigs/nbCol),nbCol,k)
    obj.graphics.axes_handles(k)=gca;
    obj.graphics.plot_handles(k)=plot(1,1,'*');
    if k==1
        obj.graphics.text_handles(1)=title(sprintf('%3.2f s',toc));
    end
end

end

    