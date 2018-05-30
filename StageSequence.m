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

% Last Modified by GUIDE v2.5 30-May-2018 15:54:12

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
    handles.output.Control(1).TrigDelay=0 ; %immediate start
end

setfigtovalues(handles);


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes StageSequence wait for user response (see UIRESUME)
uiwait(handles.figure1);

function setfigtovalues(handles)
    for i=1:length(handles.output.Control)
        eval(sprintf('set(handles.PulseWidthEdt%d,''String'',num2str(handles.output.Control(i).PulseWidth));',i));
        eval(sprintf('set(handles.RepetitionsEdt%d,''String'',num2str(handles.output.Control(i).Repetition));',i));
        eval(sprintf('set(handles.TriggerDelay%d,''String'',num2str(handles.output.Control(i).TrigDelay));',i));
        eval(sprintf('set(handles.InterPulseEdt%d,''String'',num2str(handles.output.Control(i).Delay));',i));
    end
    showsequence(handles);
        
function setvaluestofig(handles)
    for i=1:4
        eval(sprintf('Width=str2double(get(handles.PulseWidthEdt%d,''String''));',i));
        eval(sprintf('Delay=str2double(get(handles.InterPulseEdt%d,''String''));',i));
        eval(sprintf('Reps=str2double(get(handles.RepetitionsEdt%d,''String''));',i));
        eval(sprintf('TrigDel=str2double(get(handles.TriggerDelay%d,''String''));',i));
        handles.output.Control(i).PulseWidth=Width;
        handles.output.Control(i).Repetition=Reps;
        handles.output.Control(i).TrigDelay=TrigDel;
        handles.output.Control(i).Delay=Delay;
    end
    showsequence(handles);
        
function showsequence(handles)
    n=get(handles.SelectPop,'Value');
    switch n
        case 1
            imin=1;
            imax=4;
        otherwise
            imin=n-1;
            imax=n-1;
    end
    
    Delay=zeros(1,4);
    Width=zeros(1,4);
    Reps=zeros(1,4);
    TrigDel=zeros(1,4);
    
    for i=1:length(handles.output.Control)
        Delay(i)=handles.output.Control(i).Delay/1000;
        Width(i)=handles.output.Control(i).PulseWidth/1000;
        Reps(i)=handles.output.Control(i).Repetition;
        TrigDel(i)=handles.output.Control(i).TrigDelay/1000;
    end
    
    axes(handles.axes1);
    dt=handles.output.Hardware.Delay/10^6;

    for i=imin:imax
       t=-dt;
       control=0;
       
       for j=1:Reps(i)
           t=[t (j-1)*Delay(i) (j-1)*Delay(i)+Width(i) (j-1)*Delay(i)+Width(i)+dt (j)*Delay(i)-dt];
           control=[control 1 1 0 0];
       end
       
       
       if TrigDel(i)>0
           t=[0 t+TrigDel(i)];
           control=[0 control];
       end
       
       

        
        plot(t/1000,control);
        hold on
    end
    hold off
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


% --- Executes on selection change in SelectPop.
function SelectPop_Callback(hObject, eventdata, handles)
% hObject    handle to SelectPop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
showsequence(handles);
% Hints: contents = cellstr(get(hObject,'String')) returns SelectPop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SelectPop


% --- Executes during object creation, after setting all properties.
function SelectPop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SelectPop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
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


function PulseWidthEdt1_Callback(hObject, eventdata, handles)
% hObject    handle to PulseWidthEdt1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setvaluestofig(handles)
% Hints: get(hObject,'String') returns contents of PulseWidthEdt1 as text
%        str2double(get(hObject,'String')) returns contents of PulseWidthEdt1 as a double


% --- Executes during object creation, after setting all properties.
function PulseWidthEdt1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PulseWidthEdt1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function InterPulseEdt1_Callback(hObject, eventdata, handles)
% hObject    handle to InterPulseEdt1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setvaluestofig(handles)
% Hints: get(hObject,'String') returns contents of InterPulseEdt1 as text
%        str2double(get(hObject,'String')) returns contents of InterPulseEdt1 as a double


% --- Executes during object creation, after setting all properties.
function InterPulseEdt1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to InterPulseEdt1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RepetitionsEdt1_Callback(hObject, eventdata, handles)
% hObject    handle to RepetitionsEdt1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setvaluestofig(handles)
% Hints: get(hObject,'String') returns contents of RepetitionsEdt1 as text
%        str2double(get(hObject,'String')) returns contents of RepetitionsEdt1 as a double


% --- Executes during object creation, after setting all properties.
function RepetitionsEdt1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RepetitionsEdt1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TriggerDelay1_Callback(hObject, eventdata, handles)
% hObject    handle to TriggerDelay1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setvaluestofig(handles)
% Hints: get(hObject,'String') returns contents of TriggerDelay1 as text
%        str2double(get(hObject,'String')) returns contents of TriggerDelay1 as a double


% --- Executes during object creation, after setting all properties.
function TriggerDelay1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TriggerDelay1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TriggerDelay4_Callback(hObject, eventdata, handles)
% hObject    handle to TriggerDelay4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setvaluestofig(handles)
% Hints: get(hObject,'String') returns contents of TriggerDelay4 as text
%        str2double(get(hObject,'String')) returns contents of TriggerDelay4 as a double


% --- Executes during object creation, after setting all properties.
function TriggerDelay4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TriggerDelay4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RepetitionsEdt4_Callback(hObject, eventdata, handles)
% hObject    handle to RepetitionsEdt4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setvaluestofig(handles)
% Hints: get(hObject,'String') returns contents of RepetitionsEdt4 as text
%        str2double(get(hObject,'String')) returns contents of RepetitionsEdt4 as a double


% --- Executes during object creation, after setting all properties.
function RepetitionsEdt4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RepetitionsEdt4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function InterPulseEdt4_Callback(hObject, eventdata, handles)
% hObject    handle to InterPulseEdt4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setvaluestofig(handles)
% Hints: get(hObject,'String') returns contents of InterPulseEdt4 as text
%        str2double(get(hObject,'String')) returns contents of InterPulseEdt4 as a double


% --- Executes during object creation, after setting all properties.
function InterPulseEdt4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to InterPulseEdt4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PulseWidthEdt4_Callback(hObject, eventdata, handles)
% hObject    handle to PulseWidthEdt4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setvaluestofig(handles)
% Hints: getsetvaluestofig(handles)(hObject,'String') returns contents of PulseWidthEdt4 as text
%        str2double(get(hObject,'String')) returns contents of PulseWidthEdt4 as a double


% --- Executes during object creation, after setting all properties.
function PulseWidthEdt4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PulseWidthEdt4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TriggerDelay3_Callback(hObject, eventdata, handles)
% hObject    handle to TriggerDelay3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setvaluestofig(handles)
% Hints: get(hObject,'String') returns contents of TriggerDelay3 as text
%        str2double(get(hObject,'String')) returns contents of TriggerDelay3 as a double


% --- Executes during object creation, after setting all properties.
function TriggerDelay3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TriggerDelay3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RepetitionsEdt3_Callback(hObject, eventdata, handles)
% hObject    handle to RepetitionsEdt3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setvaluestofig(handles)
% Hints: get(hObject,'String') returns contents of RepetitionsEdt3 as text
%        str2double(get(hObject,'String')) returns contents of RepetitionsEdt3 as a double


% --- Executes during object creation, after setting all properties.
function RepetitionsEdt3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RepetitionsEdt3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function InterPulseEdt3_Callback(hObject, eventdata, handles)
% hObject    handle to InterPulseEdt3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setvaluestofig(handles)
% Hints: get(hObject,'String') returns contents of InterPulseEdt3 as text
%        str2double(get(hObject,'String')) returns contents of InterPulseEdt3 as a double


% --- Executes during object creation, after setting all properties.
function InterPulseEdt3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to InterPulseEdt3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PulseWidthEdt3_Callback(hObject, eventdata, handles)
% hObject    handle to PulseWidthEdt3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setvaluestofig(handles)
% Hints: get(hObject,'String') returns contents of PulseWidthEdt3 as text
%        str2double(get(hObject,'String')) returns contents of PulseWidthEdt3 as a double


% --- Executes during object creation, after setting all properties.
function PulseWidthEdt3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PulseWidthEdt3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TriggerDelay2_Callback(hObject, eventdata, handles)
% hObject    handle to TriggerDelay2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setvaluestofig(handles)
% Hints: get(hObject,'String') returns contents of TriggerDelay2 as text
%        str2double(get(hObject,'String')) returns contents of TriggerDelay2 as a double


% --- Executes during object creation, after setting all properties.
function TriggerDelay2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TriggerDelay2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RepetitionsEdt2_Callback(hObject, eventdata, handles)
% hObject    handle to RepetitionsEdt2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setvaluestofig(handles)
% Hints: get(hObject,'String') returns contents of RepetitionsEdt2 as text
%        str2double(get(hObject,'String')) returns contents of RepetitionsEdt2 as a double


% --- Executes during object creation, after setting all properties.
function RepetitionsEdt2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RepetitionsEdt2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function InterPulseEdt2_Callback(hObject, eventdata, handles)
% hObject    handle to InterPulseEdt2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setvaluestofig(handles)
% Hints: get(hObject,'String') returns contents of InterPulseEdt2 as text
%        str2double(get(hObject,'String')) returns contents of InterPulseEdt2 as a double


% --- Executes during object creation, after setting all properties.
function InterPulseEdt2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to InterPulseEdt2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PulseWidthEdt2_Callback(hObject, eventdata, handles)
% hObject    handle to PulseWidthEdt2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setvaluestofig(handles)
% Hints: get(hObject,'String') returns contents of PulseWidthEdt2 as text
%        str2double(get(hObject,'String')) returns contents of PulseWidthEdt2 as a double


% --- Executes during object creation, after setting all properties.
function PulseWidthEdt2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PulseWidthEdt2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
