function varargout = RTDataGUI(varargin)
% RTDATAGUI MATLAB code for RTDataGUI.fig
%      RTDATAGUI, by itself, creates a new RTDATAGUI or raises the existing
%      singleton*.
%
%      H = RTDATAGUI returns the handle to a new RTDATAGUI or the handle to
%      the existing singleton*.
%
%      RTDATAGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RTDATAGUI.M with the given input arguments.
%
%      RTDATAGUI('Property','Value',...) creates a new RTDATAGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RTDataGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RTDataGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RTDataGUI

% Last Modified by GUIDE v2.5 30-Aug-2017 16:01:50

% Begin initialization code - DO NOT EDIT
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
% End initialization code - DO NOT EDIT


% --- Executes just before RTDataGUI is made visible.
function RTDataGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RTDataGUI (see VARARGIN)

% By default, ouput the current RTData object;
handles.output = RTData;

SetGUIToValue(handles);

activate(handles,'Acquisition','off');
activate(handles,'Options','off');

display_folder(handles);

search_serial(handles);



% Update handles structure
set(gcf,'closeRequestFcn',[])
set(gcf, 'Position', get(0,'Screensize')); % Maximize figure. 

guidata(hObject, handles);

% UIWAIT makes RTDataGUI wait for user response (see UIRESUME)
 uiwait(handles.figure1);

function show_case(TheAxe,TheData)
    axes(TheAxe);
    plot(TheData.Time,TheData.Data,'*');
        
 
function activate(handles,group,state)
        switch group
            case 'Acquisition'
                list_handles={'NbPointsEdt','GraphFreqEdt','TimeSpanEdt','GoBttn'};
            case 'Options'
                list_handles={'SaveMatCheck','SaveTxtCheck','NameEdt','EditNotesBttn'};
            case 'Configuration'
                list_handles={'SerialPop','ArduinoPop','LoopDelayEdt'};
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
          
function search_serial(handles)
    serialInfo = instrhwinfo('serial');
    set(handles.SerialPop,'String',serialInfo.AvailableSerialPorts,'Value',1);
    
function SetGUIToValue(handles);
    set(handles.LoopDelayEdt,'String',sprintf('%d',handles.output.Hardware.delay))
    set(handles.NbPointsEdt,'String',sprintf('%d',handles.output.nPoints));
    set(handles.GraphFreqEdt,'String',sprintf('%d',handles.output.fRefresh));
    set(handles.TimeSpanEdt,'String',sprintf('%d',handles.output.tFrame));
    set(handles.NameEdt,'String',sprintf('%s',handles.output.Name));
    
function SetValueToGUI(handles);
    SerialPop_Callback(handles.SerialPop,[],handles);
    ArduinoPop_Callback(handles.ArduinoPop,[],handles);
    LoopDelayEdt_Callback(handles.LoopDelayEdt,[],handles);21
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


% --- Executes on selection change in SerialPop.
function SerialPop_Callback(hObject, eventdata, handles)
% hObject    handle to SerialPop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
listSerial=cellstr(get(hObject,'String'));
handles.output.Hardware.Port=listSerial{get(hObject,'Value')};


% Hints: contents = cellstr(get(hObject,'String')) returns SerialPop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SerialPop


% --- Executes during object creation, after setting all properties.
function SerialPop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SerialPop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NbPointsEdt_Callback(hObject, eventdata, handles)
% hObject    handle to NbPointsEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output.nPoints=str2double(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of NbPointsEdt as text
%        str2double(get(hObject,'String')) returns contents of NbPointsEdt as a double


% --- Executes during object creation, after setting all properties.
function NbPointsEdt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NbPointsEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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


% --- Executes on selection change in ArduinoPop.
function ArduinoPop_Callback(hObject, eventdata, handles)
% hObject    handle to ArduinoPop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String'));
handles.output.Hardware.arduino = contents{get(hObject,'Value')};
        

% Hints: contents = cellstr(get(hObject,'String')) returns ArduinoPop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ArduinoPop


% --- Executes during object creation, after setting all properties.
function ArduinoPop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ArduinoPop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function LoopDelayEdt_Callback(hObject, eventdata, handles)
% hObject    handle to LoopDelayEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output.Hardware.delay=str2double(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of LoopDelayEdt as text
%        str2double(get(hObject,'String')) returns contents of LoopDelayEdt as a double


% --- Executes during object creation, after setting all properties.
function LoopDelayEdt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LoopDelayEdt (see GCBO)
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
handles.output.acquire;
activate(handles,'Acquisition','off');
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
handles.output=RTData;
guidata(hObject,handles)
SetValueToGUI(handles);
activate(handles,'Acquisition','on');

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
freq=handles.output.check_arduino;
set(handles.CheckTxt,'String',sprintf('%f',freq));
% --- Executes on button press in SetBttn.
function SetBttn_Callback(hObject, eventdata, handles)
% hObject    handle to SetBttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
activate(handles,'Acquisition','on')
activate(handles,'Options','on')
listSerial=cellstr(get(handles.SerialPop,'String'));
handles.output.Hardware.Port=listSerial{get(handles.SerialPop,'Value')};


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


% --- Executes on button press in EmptyBttn.
function EmptyBttn_Callback(hObject, eventdata, handles)
% hObject    handle to EmptyBttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RTDataGUI_OpeningFcn(hObject, eventdata, handles);