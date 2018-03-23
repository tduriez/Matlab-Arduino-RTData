function varargout = StageSequence(varargin)
% STAGESEQUENCE MATLAB code for StageSequence.fig
%      STAGESEQUENCE, by itself, creates a new STAGESEQUENCE or raises the existing
%      singleton*.
%
%      H = STAGESEQUENCE returns the handle to a new STAGESEQUENCE or the handle to
%      the existing singleton*.
%
%      STAGESEQUENCE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STAGESEQUENCE.M with the given input arguments.
%
%      STAGESEQUENCE('Property','Value',...) creates a new STAGESEQUENCE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before StageSequence_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to StageSequence_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help StageSequence

% Last Modified by GUIDE v2.5 23-Mar-2018 15:42:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @StageSequence_OpeningFcn, ...
                   'gui_OutputFcn',  @StageSequence_OutputFcn, ...
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


% --- Executes just before StageSequence is made visible.
function StageSequence_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to StageSequence (see VARARGIN)

set(gcf,'CloseRequestFcn',[]);
% Choose default command line output for StageSequence
handles.output = varargin{1};

%% Setting to default values
reset=0;
if isempty(handles.output.Control)
    reset=1;
else
    if ~strcmpi(handles.output.Control.Type,'stagedsequence')
        reset=1;
    end
end

if reset
    handles.output.Control=struct;
    handles.output.Control(1).Type='StagedSequence';
    handles.output.Control(1).Delay=120*1000; %2 mins
    handles.output.Control(1).PulseWidth=400; %400 us
    handles.output.Control(1).Repetition=1 ; %single pulse
end

setfigtovalues(handles);
showsequence(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes StageSequence wait for user response (see UIRESUME)
uiwait(handles.figure1);

function setfigtovalues(handles)
    nbcontrol=length(handles.output.Control);
    stringpop=cell(1,nbcontrol+1);stringpop{1}='All controls';
    for i=2:length(stringpop)
        stringpop{i}=sprintf('Control %d',i-1);
    end
    set(handles.ControlPop,'String',stringpop);
    
    listtext=cell(1,nbcontrol);
    for i=1:nbcontrol
        listtext{i}=sprintf('%d\t%d\t%d',handles.output.Control.PulseWidth,handles.output.Control.Repetition,handles.output.Control.Delay);
    end
    
    set(handles.ControlList,'String',listtext);
    
    
% function setvaluetofig(handles)
%     handles.output.Control.PulseWidth=str2double(get(handles.PulseWidthEdt,'String'));
%     handles.output.Control.Repetition=str2double(get(handles.RepetitionsEdt,'String'));
%     handles.output.Control.Delay=str2double(get(handles.PeriodEdt,'String'));
    
function showsequence(handles)
    nbcontrol=length(handles.output.Control);
    for i=1:nbcontrol
        Delay(i)=handles.output.Control(i).Delay;
        Width(i)=handles.output.Control(i).PulseWidth;
        Reps(i)=handles.output.Control(i).Repetition;
    end
    axes(handles.axes1);
    dt=handles.output.Hardware.Delay/10^6;
    
    t=0:dt:max(Reps.*Delay);
    control=repmat(t*0,[1 nbcontrol]);
    for i=1:nbcontrol
        for j=1:Reps(i)
        control((t>=Delay(i)*(j-1)) &  (t<Delay(i)*(j-1)+Width(i)),i)=1;
        end
    end
    
    plot(t/1000,control);
    xlabel('time (s)')
    ylabel('control')
    
    
    

% --- Outputs from this function are returned to the command line.
function varargout = StageSequence_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gcf,'CloseRequestFcn','closereq');
% Get default command line output from handles structure
varargout{1} = handles.output;
close(gcf);





% --- Executes on button press in DoneBttn.
function DoneBttn_Callback(hObject, eventdata, handles)
% hObject    handle to DoneBttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume


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


% --- Executes on button press in AddBttn.
function AddBttn_Callback(hObject, eventdata, handles)
% hObject    handle to AddBttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in RemoveBttn.
function RemoveBttn_Callback(hObject, eventdata, handles)
% hObject    handle to RemoveBttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in EditBttn.
function EditBttn_Callback(hObject, eventdata, handles)
% hObject    handle to EditBttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in ControlPop.
function ControlPop_Callback(hObject, eventdata, handles)
% hObject    handle to ControlPop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ControlPop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ControlPop


% --- Executes during object creation, after setting all properties.
function ControlPop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ControlPop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
