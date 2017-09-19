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

% Last Modified by GUIDE v2.5 01-Sep-2017 11:01:53

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
    handles.output.Control.Type='StagedSequence';
    handles.output.Control.Delay=120*1000; %2 mins
    handles.output.Control.PulseWidth=400; %400 us
    handles.output.Control.Repetition=1 ; %single pulse
end

setfigtovalues(handles);
showsequence(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes StageSequence wait for user response (see UIRESUME)
uiwait(handles.figure1);

function setfigtovalues(handles)
    set(handles.PulseWidthEdt,'String',...
        sprintf('%d', handles.output.Control.PulseWidth));
    set(handles.RepetitionsEdt,'String',...
        sprintf('%d', handles.output.Control.Repetition));
    set(handles.PeriodEdt,'String',...
        sprintf('%d', handles.output.Control.Delay));
    
function setvaluetofig(handles)
    handles.output.Control.PulseWidth=str2double(get(handles.PulseWidthEdt,'String'));
    handles.output.Control.Repetition=str2double(get(handles.RepetitionsEdt,'String'));
    handles.output.Control.Delay=str2double(get(handles.PeriodEdt,'String'));
    
function showsequence(handles)
    Delay=handles.output.Control.Delay;
    Width=handles.output.Control.PulseWidth;
    Reps=handles.output.Control.Repetition;
    axes(handles.axes1);
    dt=handles.output.Hardware.Delay;
    
    t=0:dt:Reps*Delay;
    control=t*0;
    for i=1:Reps
        control((t>=Delay*(i-1)) &  (t<Delay*(i-1)+Width))=1;
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



function PulseWidthEdt_Callback(hObject, eventdata, handles)
% hObject    handle to PulseWidthEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setvaluetofig(handles);
showsequence(handles);
% Hints: get(hObject,'String') returns contents of PulseWidthEdt as text
%        str2double(get(hObject,'String')) returns contents of PulseWidthEdt as a double


% --- Executes during object creation, after setting all properties.
function PulseWidthEdt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PulseWidthEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RepetitionsEdt_Callback(hObject, eventdata, handles)
% hObject    handle to RepetitionsEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setvaluetofig(handles);
showsequence(handles);
% Hints: get(hObject,'String') returns contents of RepetitionsEdt as text
%        str2double(get(hObject,'String')) returns contents of RepetitionsEdt as a double


% --- Executes during object creation, after setting all properties.
function RepetitionsEdt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RepetitionsEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PeriodEdt_Callback(hObject, eventdata, handles)
% hObject    handle to PeriodEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setvaluetofig(handles);
showsequence(handles);
% Hints: get(hObject,'String') returns contents of PeriodEdt as text
%        str2double(get(hObject,'String')) returns contents of PeriodEdt as a double


% --- Executes during object creation, after setting all properties.
function PeriodEdt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PeriodEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in DoneBttn.
function DoneBttn_Callback(hObject, eventdata, handles)
% hObject    handle to DoneBttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume