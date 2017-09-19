function varargout = RTDataGUI(varargin)
% RTDATAGUI Calls the user interface for RTData experiments
%
%      RTDATAGUI is a user interface which allows the setting up and use of
%      a microcontroller burned with the Matlab-Arduino-RTData toolbox
%      provided execution code.
%
%      This should result in the ability to acquire up to 12 channels, at
%      up to (at least) 1kHz (each), while also ensuing commands through
%      (for now) one digital output.
%
%      RTDATAGUI doesn't need any arguments.
%      
%      The normal following course of events would be to press the SET
%      button, prescribe the serial port where the micro-controller is
%      plugged in, and then at some point press the GO button. 
%
%      Real-Time Data acquisition should ensue. It can be stopped by
%      closing the real-time display figure.
%
%      Data can be saved either automatically or on button press.
%
% See also: RTData
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


gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RTDataGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @RTDataGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end



% --- Executes just before RTDataGUI is made visible.
function RTDataGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RTDataGUI (see VARARGIN)

% By default, ouput the current RTData object;
handles.output = RTData;
guidata(hObject, handles);
SetGUIToValue(handles);
activate(handles,'Configuration','on')
activate(handles,'Display','off');
activate(handles,'Options','off');
activate(handles,'Control','off');

display_folder(handles);


% Update handles structure
%set(gcf,'closeRequestFcn',[])
set(gcf, 'Position', get(0,'Screensize')); % Maximize figure. 



% UIWAIT makes RTDataGUI wait for user response (see UIRESUME)
 uiwait(handles.figure1);

function show_case(TheAxe,TheData)
    axes(TheAxe);
    plot(TheData.Time,TheData.Data,'*');
    delta=max(TheData.Data(:))-min(TheData.Data(:));
    if max(TheData.Action)>0
        hold on
        plot(TheData.Time,TheData.Action*delta+min(TheData.Data(:)),'k');
        hold off
    end
    set(gca,'xlim',[0 TheData.Time(end)]);
    
        
 
function activate(handles,group,state)
        switch group
            case 'Display'
                list_handles={'NbPointsEdt','GraphFreqEdt','TimeSpanEdt','GoBttn'};
            case 'Options'
                list_handles={'SaveMatCheck','SaveTxtCheck','NameEdt','EditNotesBttn'};
            case 'Configuration'
                list_handles={'SetBttn'};
            case 'Control'
                list_handles={'CtrlTypeMenu','CtrlSettingsBttn'};
        end
        
        for i=1:numel(list_handles)
            set(handles.(list_handles{i}),'Enable',state)
        end
        
function display_folder(handles)
    d=dir('*.mat');
    theString=cell(1,numel(d));
    for i=1:numel(d)
        theString{i}=d(i).name;
    end
    set(handles.MatList,'String',theString,'Value',1);
          
function displayHardware(handles)
    if isfield(handles.output.Hardware,'Port')
        disptxt{1}=sprintf('Port: %s',handles.output.Hardware.Port);
    else
        set(handles.ConfigList,'String','Not configured','Value',1);
        return
    end
    disptxt{2}=sprintf('Board:      %s',handles.output.Hardware.Arduino);
    disptxt{3}=sprintf('Loop delay: %d ms, (%.2f Hz)',handles.output.Hardware.Delay,1000/handles.output.Hardware.Delay);
    disptxt{4}=sprintf('Averaging:  %d points',handles.output.Hardware.nMeasures);
    disptxt{5}=sprintf('Channels:   %d',handles.output.Hardware.Channels);
    set(handles.ConfigList,'String',disptxt);
    
function displayControl(handles)
    if ~isempty(handles.output.Control)
        disptxt{1}=sprintf('Type: %s',handles.output.Control.Type);
    else
        set(handles.ControlList,'String','No control','Value',1);
        return
    end
    switch lower(handles.output.Control.Type)
        case 'stagedsequence'
            disptxt{2}=sprintf('Pulse Width: %d ms',handles.output.Control.PulseWidth);
            disptxt{3}=sprintf('#: %d',handles.output.Control.Repetition);
            disptxt{4}=sprintf('Every: %d ms',handles.output.Control.Delay);
    end
    set(handles.ControlList,'String',disptxt);

    

    
function SetGUIToValue(handles);
    
    set(handles.NbPointsEdt,'String',sprintf('%d',handles.output.nPoints));
    set(handles.GraphFreqEdt,'String',sprintf('%d',handles.output.fRefresh));
    set(handles.TimeSpanEdt,'String',sprintf('%d',handles.output.tFrame));
    set(handles.NameEdt,'String',sprintf('%s',handles.output.Name));
    displayHardware(handles);
    displayControl(handles)
    
function SetValueToGUI(handles);
    NbPointsEdt_Callback(handles.NbPointsEdt,[],handles);
    GraphFreqEdt_Callback(handles.GraphFreqEdt,[],handles);
    TimeSpanEdt_Callback(handles.TimeSpanEdt,[],handles);
    SaveMatCheck_Callback(handles.SaveMatCheck,[],handles);
    SaveTxtCheck_Callback(handles.SaveTxtCheck,[],handles);
    NameEdt_Callback(handles.NameEdt,[],handles);

% --- Outputs from this function are returned to the command line.
function varargout = RTDataGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
set(hObject,'closeRequestFcn','closereq')
close(hObject);
varargout{1} = handles.output;





function GraphFreqEdt_Callback(hObject, eventdata, handles)
% hObject    handle to GraphFreqEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output.fRefresh=str2double(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of GraphFreqEdt as text
%        str2double(get(hObject,'String')) returns contents of GraphFreqEdt as a double


% --- Executes during object creation, after setting all properties.
function GraphFreqEdt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GraphFreqEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function NbPointsEdt_Callback(hObject, eventdata, handles)
% hObject    handle to TimeSpanEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output.nPoints=str2double(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of TimeSpanEdt as text
%        str2double(get(hObject,'String')) returns contents of TimeSpanEdt as a double


% --- Executes during object creation, after setting all properties.
function NbPointsEdt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TimeSpanEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function TimeSpanEdt_Callback(hObject, eventdata, handles)
% hObject    handle to TimeSpanEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output.tFrame=str2double(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of TimeSpanEdt as text
%        str2double(get(hObject,'String')) returns contents of TimeSpanEdt as a double


% --- Executes during object creation, after setting all properties.
function TimeSpanEdt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TimeSpanEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in GoBttn.
function GoBttn_Callback(hObject, eventdata, handles)
% hObject    handle to GoBttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
activate(handles,'Configuration','off');
activate(handles,'Display','off');
activate(handles,'Control','off');
handles.output.acquire;
while ~handles.output.acquired
    pause(0.01)
end
show_case(handles.AxeDisplay,handles.output);
display_folder(handles);


% --- Executes on selection change in MatList.
function MatList_Callback(hObject, eventdata, handles)
% hObject    handle to MatList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String'));
filename=contents{get(hObject,'Value')};
show_RT=load(filename);
show_case(handles.AxeDisplay,show_RT.acquis);
% Hints: contents = cellstr(get(hObject,'String')) returns MatList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from MatList


% --- Executes during object creation, after setting all properties.
function MatList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MatList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in NewBttn.
function NewBttn_Callback(hObject, eventdata, handles)
% hObject    handle to NewBttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Control=handles.output.Control;
Hardware=handles.output.Hardware;
handles.output=RTData;
handles.output.Hardware.Port=Hardware.Port;
list_properties=fieldnames(Hardware);
for k=1:numel(list_properties);
   handles.output.Hardware.(list_properties{k})=Hardware.(list_properties{k});
   %pause(1);
end

handles.output.Control=Control;
guidata(hObject,handles);
SetValueToGUI(handles);

handles.output.check_arduino;
activate(handles,'Display','on');
activate(handles,'Control','on');
activate(handles,'Configuration','on');


% --- Executes on button press in CloseBttn.
function CloseBttn_Callback(hObject, eventdata, handles)
% hObject    handle to CloseBttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume;


function NotesEdt_Callback(hObject, eventdata, handles)
% hObject    handle to NotesEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NotesEdt as text
%        str2double(get(hObject,'String')) returns contents of NotesEdt as a double


% --- Executes during object creation, after setting all properties.
function NotesEdt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NotesEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SaveMatCheck.
function SaveMatCheck_Callback(hObject, eventdata, handles)
% hObject    handle to SaveMatCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value') && get(handles.SaveTxtCheck,'Value')
    handles.output.Save=2;
elseif get(hObject,'Value') && ~get(handles.SaveTxtCheck,'Value')
    handles.output.Save=1;
elseif ~get(hObject,'Value') && get(handles.SaveTxtCheck,'Value')
    handles.output.Save=-2;
else
    handles.output.Save=0;
end
% Hint: get(hObject,'Value') returns toggle state of SaveMatCheck


% --- Executes on button press in SaveTxtCheck.
function SaveTxtCheck_Callback(hObject, eventdata, handles)
% hObject    handle to SaveTxtCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value') && get(handles.SaveMatCheck,'Value')
    handles.output.Save=2;
elseif get(hObject,'Value') && ~get(handles.SaveMatCheck,'Value')
    handles.output.Save=-2;
elseif ~get(hObject,'Value') && get(handles.SaveMatCheck,'Value')
    handles.output.Save=1;
else
    handles.output.Save=0;
end
% Hint: get(hObject,'Value') returns toggle state of SaveTxtCheck



function NameEdt_Callback(hObject, eventdata, handles)
% hObject    handle to NameEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output.Name=get(hObject,'String');
% Hints: get(hObject,'String') returns contents of NameEdt as text
%        str2double(get(hObject,'String')) returns contents of NameEdt as a double


% --- Executes during object creation, after setting all properties.
function NameEdt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NameEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in EditNotesBttn.
function EditNotesBttn_Callback(hObject, eventdata, handles)
% hObject    handle to EditNotesBttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ChangeDirBttn.
function ChangeDirBttn_Callback(hObject, eventdata, handles)
% hObject    handle to ChangeDirBttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cd(uigetdir);
display_folder(handles);


% --- Executes on button press in CheckBttn.
function CheckBttn_Callback(hObject, eventdata, handles)
% hObject    handle to CheckBttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
actual_delay=handles.output.check_arduino;
set(handles.CheckTxt,'String',sprintf('%f ms (%.2f Hz)',actual_delay,1000/actual_delay));


% --- Executes on button press in SetBttn.
function SetBttn_Callback(hObject, eventdata, handles)
% hObject    handle to SetBttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
HardwareSettings(handles.output);
activate(handles,'Display','on')
activate(handles,'Options','on')
activate(handles,'Control','on')
SetGUIToValue(handles);



% --- Executes on button press in ChooseBttn.
function ChooseBttn_Callback(hObject, eventdata, handles)
% hObject    handle to ChooseBttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[TheName,ThePath]=uigetfile('*.m');
handles.PostProcessFcn=fullfile(ThePath,TheName);

[~,fNAME,~] = fileparts(handles.PostProcessFcn);
set(handles.PostText,'String',fNAME);
guidata(hObject,handles);


% --- Executes on button press in SetCurrentBttn.
function SetCurrentBttn_Callback(hObject, eventdata, handles)
% hObject    handle to SetCurrentBttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.MatList,'String'));
filename=contents{get(handles.MatList,'Value')};
show_RT=load(filename);
handles.output=show_RT.acquis;
SetValueToGUI(handles);
guidata(hObject,handles);




% --- Executes on button press in ShowCurrentBttn.
function ShowCurrentBttn_Callback(hObject, eventdata, handles)
% hObject    handle to ShowCurrentBttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
show_case(handles.AxeDisplay,handles.output);


% --- Executes on button press in ApplyBttn.
function ApplyBttn_Callback(hObject, eventdata, handles)
% hObject    handle to ApplyBttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%try
curdir=pwd;
    [ThePath,TheName] = fileparts(handles.PostProcessFcn);
    cd(ThePath)
    feval(TheName,handles.output);
    cd(curdir);
%catch
%end


% --- Executes on button press in SaveBttn.
function SaveBttn_Callback(hObject, eventdata, handles)
% hObject    handle to SaveBttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cstate=handles.output.Save;
handles.output.Save=1;
handles.output.save;
handles.output.Save=cstate;
display_folder(handles);


% --- Executes on selection change in CtrlTypeMenu.
function CtrlTypeMenu_Callback(hObject, eventdata, handles)
% hObject    handle to CtrlTypeMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns CtrlTypeMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from CtrlTypeMenu


% --- Executes during object creation, after setting all properties.
function CtrlTypeMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CtrlTypeMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in CtrlSettingsBttn.
function CtrlSettingsBttn_Callback(hObject, eventdata, handles)
% hObject    handle to CtrlSettingsBttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CtrlTypes=get(handles.CtrlTypeMenu,'String');
CtrlType=CtrlTypes{get(handles.CtrlTypeMenu,'Value')};
switch CtrlType
    case 'None'
        handles.output.Control=[];
    case 'Staged Sequence'
        StageSequence(handles.output);
    case 'Law'
    case 'MLC'
end
displayControl(handles);


% --- Executes on button press in EmptyBttn.
function EmptyBttn_Callback(hObject, eventdata, handles)
% hObject    handle to EmptyBttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RTDataGUI_OpeningFcn(hObject, eventdata, handles);



% --- Executes on selection change in ConfigList.
function ConfigList_Callback(hObject, eventdata, handles)
% hObject    handle to ConfigList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ConfigList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ConfigList


% --- Executes during object creation, after setting all properties.
function ConfigList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ConfigList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ControlList.
function ControlList_Callback(hObject, eventdata, handles)
% hObject    handle to ControlList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ControlList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ControlList


% --- Executes during object creation, after setting all properties.
function ControlList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ControlList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
