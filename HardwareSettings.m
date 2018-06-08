function varargout = HardwareSettings(varargin)
% HARDWARESETTINGS MATLAB code for HardwareSettings.fig
%      HARDWARESETTINGS, by itself, creates a new HARDWARESETTINGS or raises the existing
%      singleton*.
%
%      H = HARDWARESETTINGS returns the handle to a new HARDWARESETTINGS or the handle to
%      the existing singleton*.
%
%      HARDWARESETTINGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HARDWARESETTINGS.M with the given input arguments.
%
%      HARDWARESETTINGS('Property','Value',...) creates a new HARDWARESETTINGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HardwareSettings_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HardwareSettings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HardwareSettings

% Last Modified by GUIDE v2.5 08-Jun-2018 08:48:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HardwareSettings_OpeningFcn, ...
                   'gui_OutputFcn',  @HardwareSettings_OutputFcn, ...
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


% --- Executes just before HardwareSettings is made visible.
function HardwareSettings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HardwareSettings (see VARARGIN)

% Choose default command line output for HardwareSettings
handles.output = varargin{1};
set(gcf,'CloseRequestFcn',[]);
getSerials(handles);
set(handles.ArduinoMenu,'String',{'Unscaled','Uno','Due','Mega'});
nums=cell(1,12);
for i=1:12
    nums{i}=num2str(i);
end
set(handles.ChannelsMenu,'String',nums);

daqs=daq.getDevices;
     handles.daqrecognized=0;
     for i=1:length(daqs)
         if strcmp(daqs(i).Model,'DT9816-S')
            handles.daqrecognized=1;
         end
     end

setGUItoValue(handles);
if isempty(handles.output.Hardware.Port)
    state='off';
else
    state='on';
    if strcmpi(handles.output.Hardware.Port,'undefined')
        state='off';
    end
end
    set(handles.SetBttn,'enable',state);
    set(handles.DelayEdt,'enable',state);
    set(handles.MeasuresEdt,'enable',state);
    set(handles.ChannelsMenu,'enable',state);
    
     
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HardwareSettings wait for user response (see UIRESUME)
uiwait(handles.figure1);

function setGUItoValue(handles)
    boards=get(handles.ArduinoMenu,'String');
    idx=strcmpi(handles.output.Hardware.Arduino,boards);
    idx=find(idx);
    set(handles.ArduinoMenu,'Value',idx);
    
    if handles.daqrecognized
        set(handles.dtpop,'enable','on');
        for i=0:6;chnlist{i+1}=sprintf('%d Channels',i);end
        set(handles.dtpop,'string',chnlist);
    else
        set(handles.dtpop,'enable','off');
        set(handles.dtpop,'string','OFF');
    end
    
    if ~isempty(handles.output.Hardware.Port);
        detectedports=get(handles.PortMenu,'String');
        idx=strcmpi(handles.output.Hardware.Port,detectedports);
        idx=find(idx);
    else
        idx=1; % 1 is undefined
    end
    set(handles.PortMenu,'Value',idx);
    
    set(handles.ChannelsMenu,'Value',handles.output.Hardware.Channels);
    
    set(handles.MeasuresEdt,'String',num2str(handles.output.Hardware.nMeasures));
    
    set(handles.DelayEdt,'String',num2str(handles.output.Hardware.Delay));
    
    
function getSerials(handles)
    if ~isempty(instrfindall)
        fclose(instrfindall);
    end
    serialInfo = instrhwinfo('serial');
    set(handles.PortMenu,'String',[{'Undefined'}; serialInfo.AvailableSerialPorts],'Value',1);

% --- Outputs from this function are returned to the command line.
function varargout = HardwareSettings_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gcf,'CloseRequestFcn','closereq');
% Get default command line output from handles structure
varargout{1} = handles.output;
close(gcf)


% --- Executes on selection change in PortMenu.
function PortMenu_Callback(hObject, eventdata, handles)
% hObject    handle to PortMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String'));
handles.output.Hardware.Port=contents{get(hObject,'Value')};
if strcmpi(handles.output.Hardware.Port,'undefined')
    set(handles.DelayEdt,'enable','off');
    set(handles.MeasuresEdt,'enable','off');
    set(handles.ChannelsMenu,'enable','off');
else    
    set(handles.DelayEdt,'enable','on');
    set(handles.MeasuresEdt,'enable','on');
    set(handles.ChannelsMenu,'enable','on');
end
set(handles.SetBttn,'enable','on');



% Hints: contents = cellstr(get(hObject,'String')) returns PortMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PortMenu


% --- Executes during object creation, after setting all properties.
function PortMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PortMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function DelayEdt_Callback(hObject, eventdata, handles)
% hObject    handle to DelayEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output.Hardware.Delay=str2double(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of DelayEdt as text
%        str2double(get(hObject,'String')) returns contents of DelayEdt as a double


% --- Executes during object creation, after setting all properties.
function DelayEdt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DelayEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ArduinoMenu.
function ArduinoMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ArduinoMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String'));
handles.output.Hardware.Arduino=contents{get(hObject,'Value')};
% Hints: contents = cellstr(get(hObject,'String')) returns ArduinoMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ArduinoMenu


% --- Executes during object creation, after setting all properties.
function ArduinoMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ArduinoMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MeasuresEdt_Callback(hObject, eventdata, handles)
% hObject    handle to MeasuresEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output.Hardware.nMeasures=str2double(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of MeasuresEdt as text
%        str2double(get(hObject,'String')) returns contents of MeasuresEdt as a double


% --- Executes during object creation, after setting all properties.
function MeasuresEdt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MeasuresEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ChannelsMenu.
function ChannelsMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ChannelsMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output.Hardware.Channels=get(hObject,'Value');
% Hints: contents = cellstr(get(hObject,'String')) returns ChannelsMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ChannelsMenu


% --- Executes during object creation, after setting all properties.
function ChannelsMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChannelsMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SetBttn.
function SetBttn_Callback(hObject, eventdata, handles)
% hObject    handle to SetBttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.daqrecognized
    if get(handles.dtpop,'Value')>1
        handles.output.Hardware.DT = daq.createSession('dt');
        addAnalogInputChannel(handles.output.Hardware.DT,'DT9816-S(00)',0:(get(handles.dtpop,'Value')-1),'voltage');
        handles.output.Hardware.DT.IsContinuous=1;
    end
end
        

uiresume


% --- Executes on selection change in dtpop.
function dtpop_Callback(hObject, eventdata, handles)
% hObject    handle to dtpop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns dtpop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dtpop


% --- Executes during object creation, after setting all properties.
function dtpop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dtpop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
