function varargout = GUIHardwareSettings(varargin)
% GUIHARDWARESETTINGS MATLAB code for GUIHardwareSettings.fig
%      GUIHARDWARESETTINGS, by itself, creates a new GUIHARDWARESETTINGS or raises the existing
%      singleton*.
%
%      H = GUIHARDWARESETTINGS returns the handle to a new GUIHARDWARESETTINGS or the handle to
%      the existing singleton*.
%
%      GUIHARDWARESETTINGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIHARDWARESETTINGS.M with the given input arguments.
%
%      GUIHARDWARESETTINGS('Property','Value',...) creates a new GUIHARDWARESETTINGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUIHardwareSettings_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUIHardwareSettings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUIHardwareSettings

% Last Modified by GUIDE v2.5 01-Sep-2017 16:18:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIHardwareSettings_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIHardwareSettings_OutputFcn, ...
                   'gui_LayoutFcn',  @GUIHardwareSettings_LayoutFcn, ...
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


% --- Executes just before GUIHardwareSettings is made visible.
function GUIHardwareSettings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUIHardwareSettings (see VARARGIN)

% Choose default command line output for GUIHardwareSettings
handles.output = varargin{1};
set(gcf,'CloseRequestFcn',[]);
getSerials(handles);
set(handles.ArduinoMenu,'String',{'Unscaled','Uno','Due','Mega'});
nums=cell(1,12);
for i=1:12
    nums{i}=num2str(i);
end
set(handles.ChannelsMenu,'String',nums);
setGUItoValue(handles);
if ~isfield(handles.output.Hardware,'Port')
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

% UIWAIT makes GUIHardwareSettings wait for user response (see UIRESUME)
uiwait(handles.figure1);

function setGUItoValue(handles)
    boards=get(handles.ArduinoMenu,'String');
    idx=strcmpi(handles.output.Hardware.Arduino,boards);
    idx=find(idx);
    set(handles.ArduinoMenu,'Value',idx);
    
    if isfield(handles.output.Hardware,'Port');
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
    serialInfo = instrhwinfo('serial');
    set(handles.PortMenu,'String',[{'Undefined'}; serialInfo.AvailableSerialPorts],'Value',1);

% --- Outputs from this function are returned to the command line.
function varargout = GUIHardwareSettings_OutputFcn(hObject, eventdata, handles) 
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
uiresume


% --- Creates and returns a handle to the GUI figure. 
function h1 = GUIHardwareSettings_LayoutFcn(policy)
% policy - create a new figure or use a singleton. 'new' or 'reuse'.

persistent hsingleton;
if strcmpi(policy, 'reuse') & ishandle(hsingleton)
    h1 = hsingleton;
    return;
end

appdata = [];
appdata.GUIDEOptions = struct(...
    'active_h', [], ...
    'taginfo', struct(...
    'figure', 2, ...
    'text', 8, ...
    'popupmenu', 4, ...
    'edit', 3, ...
    'pushbutton', 2), ...
    'override', 0, ...
    'release', [], ...
    'resize', 'none', ...
    'accessibility', 'callback', ...
    'mfile', 1, ...
    'callbacks', 1, ...
    'singleton', 1, ...
    'syscolorfig', 1, ...
    'blocking', 0, ...
    'lastSavedFile', '/home/thomas/00_Git_repos/Matlab-Arduino-RTData/private/GUIHardwareSettings.m', ...
    'lastFilename', '/home/thomas/00_Git_repos/Matlab-Arduino-RTData/GuiDesign/HardwareSettings.fig');
appdata.lastValidTag = 'figure1';
appdata.GUIDELayoutEditor = [];
appdata.initTags = struct(...
    'handle', [], ...
    'tag', 'figure1');

h1 = figure(...
'Units','characters',...
'Position',[135.8 65.6971153846154 55.1428571428571 18.6875],...
'Visible',get(0,'defaultfigureVisible'),...
'Color',get(0,'defaultfigureColor'),...
'IntegerHandle','off',...
'MenuBar','none',...
'Name','HardwareSettings',...
'NumberTitle','off',...
'Tag','figure1',...
'Resize','off',...
'PaperPosition',get(0,'defaultfigurePaperPosition'),...
'ScreenPixelsPerInchMode','manual',...
'HandleVisibility','callback',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'PortMenu';

h2 = uicontrol(...
'Parent',h1,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','characters',...
'String',{  'Pop-up Menu' },...
'Style','popupmenu',...
'Value',1,...
'ValueMode',get(0,'defaultuicontrolValueMode'),...
'Position',[4.57142857142857 10.5 16.7142857142857 1.6875],...
'Callback',@(hObject,eventdata)GUIHardwareSettings('PortMenu_Callback',hObject,eventdata,guidata(hObject)),...
'Children',[],...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)GUIHardwareSettings('PortMenu_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','PortMenu');

appdata = [];
appdata.lastValidTag = 'text2';

h3 = uicontrol(...
'Parent',h1,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','characters',...
'HorizontalAlignment','left',...
'String','Port',...
'Style','text',...
'Position',[4.57142857142857 12.375 16.5714285714286 1.25],...
'Children',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} ,...
'Tag','text2',...
'FontSize',12);

appdata = [];
appdata.lastValidTag = 'DelayEdt';

h4 = uicontrol(...
'Parent',h1,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','characters',...
'String',{  'Edit Text' },...
'Style','edit',...
'Position',[4.42857142857143 5.9375 14.4285714285714 2],...
'Callback',@(hObject,eventdata)GUIHardwareSettings('DelayEdt_Callback',hObject,eventdata,guidata(hObject)),...
'Children',[],...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)GUIHardwareSettings('DelayEdt_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','DelayEdt');

appdata = [];
appdata.lastValidTag = 'text3';

h5 = uicontrol(...
'Parent',h1,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','characters',...
'HorizontalAlignment','left',...
'String','Loop Delay',...
'Style','text',...
'Position',[4.57142857142857 8.3125 16.5714285714286 1.25],...
'Children',[],...
'ButtonDownFcn',blanks(0),...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} ,...
'DeleteFcn',blanks(0),...
'Tag','text3',...
'FontSize',12);

appdata = [];
appdata.lastValidTag = 'ArduinoMenu';

h6 = uicontrol(...
'Parent',h1,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','characters',...
'String',{  'Pop-up Menu' },...
'Style','popupmenu',...
'Value',1,...
'ValueMode',get(0,'defaultuicontrolValueMode'),...
'Position',[30.7142857142857 10.5625 16.7142857142857 1.6875],...
'Callback',@(hObject,eventdata)GUIHardwareSettings('ArduinoMenu_Callback',hObject,eventdata,guidata(hObject)),...
'Children',[],...
'ButtonDownFcn',blanks(0),...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)GUIHardwareSettings('ArduinoMenu_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'DeleteFcn',blanks(0),...
'Tag','ArduinoMenu',...
'KeyPressFcn',blanks(0));

appdata = [];
appdata.lastValidTag = 'text4';

h7 = uicontrol(...
'Parent',h1,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','characters',...
'HorizontalAlignment','left',...
'String','Arduino Type',...
'Style','text',...
'Position',[30.7142857142857 12.4375 16.5714285714286 1.25],...
'Children',[],...
'ButtonDownFcn',blanks(0),...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} ,...
'DeleteFcn',blanks(0),...
'Tag','text4',...
'FontSize',12);

appdata = [];
appdata.lastValidTag = 'MeasuresEdt';

h8 = uicontrol(...
'Parent',h1,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','characters',...
'String',{  'Edit Text' },...
'Style','edit',...
'Position',[4.57142857142857 1.125 14.4285714285714 2],...
'Callback',@(hObject,eventdata)GUIHardwareSettings('MeasuresEdt_Callback',hObject,eventdata,guidata(hObject)),...
'Children',[],...
'ButtonDownFcn',blanks(0),...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)GUIHardwareSettings('MeasuresEdt_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'DeleteFcn',blanks(0),...
'Tag','MeasuresEdt',...
'KeyPressFcn',blanks(0));

appdata = [];
appdata.lastValidTag = 'text5';

h9 = uicontrol(...
'Parent',h1,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','characters',...
'HorizontalAlignment','left',...
'String','Measures averaged',...
'Style','text',...
'Position',[4.71428571428571 3.5 22.7142857142857 1.25],...
'Children',[],...
'ButtonDownFcn',blanks(0),...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} ,...
'DeleteFcn',blanks(0),...
'Tag','text5',...
'FontSize',12);

appdata = [];
appdata.lastValidTag = 'ChannelsMenu';

h10 = uicontrol(...
'Parent',h1,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','characters',...
'String',{  'Pop-up Menu' },...
'Style','popupmenu',...
'Value',1,...
'ValueMode',get(0,'defaultuicontrolValueMode'),...
'Position',[30.7142857142857 6.25 16.7142857142857 1.6875],...
'Callback',@(hObject,eventdata)GUIHardwareSettings('ChannelsMenu_Callback',hObject,eventdata,guidata(hObject)),...
'Children',[],...
'ButtonDownFcn',blanks(0),...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)GUIHardwareSettings('ChannelsMenu_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'DeleteFcn',blanks(0),...
'Tag','ChannelsMenu',...
'KeyPressFcn',blanks(0));

appdata = [];
appdata.lastValidTag = 'text6';

h11 = uicontrol(...
'Parent',h1,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','characters',...
'HorizontalAlignment','left',...
'String','Channels',...
'Style','text',...
'Position',[30.7142857142857 8.125 16.5714285714286 1.25],...
'Children',[],...
'ButtonDownFcn',blanks(0),...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} ,...
'DeleteFcn',blanks(0),...
'Tag','text6',...
'FontSize',12);

appdata = [];
appdata.lastValidTag = 'text7';

h12 = uicontrol(...
'Parent',h1,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','characters',...
'String','Hardware Settings',...
'Style','text',...
'Position',[3.57142857142857 15.4375 46.4285714285714 2.5625],...
'Children',[],...
'Tag','text7',...
'FontSize',20,...
'FontWeight','bold',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'SetBttn';

h13 = uicontrol(...
'Parent',h1,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','characters',...
'String','Set',...
'Style',get(0,'defaultuicontrolStyle'),...
'Position',[33.8571428571429 1 18 2.9375],...
'Callback',@(hObject,eventdata)GUIHardwareSettings('SetBttn_Callback',hObject,eventdata,guidata(hObject)),...
'Children',[],...
'Tag','SetBttn',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );


hsingleton = h1;


% --- Set application data first then calling the CreateFcn. 
function local_CreateFcn(hObject, eventdata, createfcn, appdata)

if ~isempty(appdata)
   names = fieldnames(appdata);
   for i=1:length(names)
       name = char(names(i));
       setappdata(hObject, name, getfield(appdata,name));
   end
end

if ~isempty(createfcn)
   if isa(createfcn,'function_handle')
       createfcn(hObject, eventdata);
   else
       eval(createfcn);
   end
end


% --- Handles default GUIDE GUI creation and callback dispatch
function varargout = gui_mainfcn(gui_State, varargin)

gui_StateFields =  {'gui_Name'
    'gui_Singleton'
    'gui_OpeningFcn'
    'gui_OutputFcn'
    'gui_LayoutFcn'
    'gui_Callback'};
gui_Mfile = '';
for i=1:length(gui_StateFields)
    if ~isfield(gui_State, gui_StateFields{i})
        error(message('MATLAB:guide:StateFieldNotFound', gui_StateFields{ i }, gui_Mfile));
    elseif isequal(gui_StateFields{i}, 'gui_Name')
        gui_Mfile = [gui_State.(gui_StateFields{i}), '.m'];
    end
end

numargin = length(varargin);

if numargin == 0
    % GUIHARDWARESETTINGS
    % create the GUI only if we are not in the process of loading it
    % already
    gui_Create = true;
elseif local_isInvokeActiveXCallback(gui_State, varargin{:})
    % GUIHARDWARESETTINGS(ACTIVEX,...)
    vin{1} = gui_State.gui_Name;
    vin{2} = [get(varargin{1}.Peer, 'Tag'), '_', varargin{end}];
    vin{3} = varargin{1};
    vin{4} = varargin{end-1};
    vin{5} = guidata(varargin{1}.Peer);
    feval(vin{:});
    return;
elseif local_isInvokeHGCallback(gui_State, varargin{:})
    % GUIHARDWARESETTINGS('CALLBACK',hObject,eventData,handles,...)
    gui_Create = false;
else
    % GUIHARDWARESETTINGS(...)
    % create the GUI and hand varargin to the openingfcn
    gui_Create = true;
end

if ~gui_Create
    % In design time, we need to mark all components possibly created in
    % the coming callback evaluation as non-serializable. This way, they
    % will not be brought into GUIDE and not be saved in the figure file
    % when running/saving the GUI from GUIDE.
    designEval = false;
    if (numargin>1 && ishghandle(varargin{2}))
        fig = varargin{2};
        while ~isempty(fig) && ~ishghandle(fig,'figure')
            fig = get(fig,'parent');
        end
        
        designEval = isappdata(0,'CreatingGUIDEFigure') || (isscalar(fig)&&isprop(fig,'GUIDEFigure'));
    end
        
    if designEval
        beforeChildren = findall(fig);
    end
    
    % evaluate the callback now
    varargin{1} = gui_State.gui_Callback;
    if nargout
        [varargout{1:nargout}] = feval(varargin{:});
    else       
        feval(varargin{:});
    end
    
    % Set serializable of objects created in the above callback to off in
    % design time. Need to check whether figure handle is still valid in
    % case the figure is deleted during the callback dispatching.
    if designEval && ishghandle(fig)
        set(setdiff(findall(fig),beforeChildren), 'Serializable','off');
    end
else
    if gui_State.gui_Singleton
        gui_SingletonOpt = 'reuse';
    else
        gui_SingletonOpt = 'new';
    end

    % Check user passing 'visible' P/V pair first so that its value can be
    % used by oepnfig to prevent flickering
    gui_Visible = 'auto';
    gui_VisibleInput = '';
    for index=1:2:length(varargin)
        if length(varargin) == index || ~ischar(varargin{index})
            break;
        end

        % Recognize 'visible' P/V pair
        len1 = min(length('visible'),length(varargin{index}));
        len2 = min(length('off'),length(varargin{index+1}));
        if ischar(varargin{index+1}) && strncmpi(varargin{index},'visible',len1) && len2 > 1
            if strncmpi(varargin{index+1},'off',len2)
                gui_Visible = 'invisible';
                gui_VisibleInput = 'off';
            elseif strncmpi(varargin{index+1},'on',len2)
                gui_Visible = 'visible';
                gui_VisibleInput = 'on';
            end
        end
    end
    
    % Open fig file with stored settings.  Note: This executes all component
    % specific CreateFunctions with an empty HANDLES structure.

    
    % Do feval on layout code in m-file if it exists
    gui_Exported = ~isempty(gui_State.gui_LayoutFcn);
    % this application data is used to indicate the running mode of a GUIDE
    % GUI to distinguish it from the design mode of the GUI in GUIDE. it is
    % only used by actxproxy at this time.   
    setappdata(0,genvarname(['OpenGuiWhenRunning_', gui_State.gui_Name]),1);
    if gui_Exported
        gui_hFigure = feval(gui_State.gui_LayoutFcn, gui_SingletonOpt);

        % make figure invisible here so that the visibility of figure is
        % consistent in OpeningFcn in the exported GUI case
        if isempty(gui_VisibleInput)
            gui_VisibleInput = get(gui_hFigure,'Visible');
        end
        set(gui_hFigure,'Visible','off')

        % openfig (called by local_openfig below) does this for guis without
        % the LayoutFcn. Be sure to do it here so guis show up on screen.
        movegui(gui_hFigure,'onscreen');
    else
        gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt, gui_Visible);
        % If the figure has InGUIInitialization it was not completely created
        % on the last pass.  Delete this handle and try again.
        if isappdata(gui_hFigure, 'InGUIInitialization')
            delete(gui_hFigure);
            gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt, gui_Visible);
        end
    end
    if isappdata(0, genvarname(['OpenGuiWhenRunning_', gui_State.gui_Name]))
        rmappdata(0,genvarname(['OpenGuiWhenRunning_', gui_State.gui_Name]));
    end

    % Set flag to indicate starting GUI initialization
    setappdata(gui_hFigure,'InGUIInitialization',1);

    % Fetch GUIDE Application options
    gui_Options = getappdata(gui_hFigure,'GUIDEOptions');
    % Singleton setting in the GUI MATLAB code file takes priority if different
    gui_Options.singleton = gui_State.gui_Singleton;

    if ~isappdata(gui_hFigure,'GUIOnScreen')
        % Adjust background color
        if gui_Options.syscolorfig
            set(gui_hFigure,'Color', get(0,'DefaultUicontrolBackgroundColor'));
        end

        % Generate HANDLES structure and store with GUIDATA. If there is
        % user set GUI data already, keep that also.
        data = guidata(gui_hFigure);
        handles = guihandles(gui_hFigure);
        if ~isempty(handles)
            if isempty(data)
                data = handles;
            else
                names = fieldnames(handles);
                for k=1:length(names)
                    data.(char(names(k)))=handles.(char(names(k)));
                end
            end
        end
        guidata(gui_hFigure, data);
    end

    % Apply input P/V pairs other than 'visible'
    for index=1:2:length(varargin)
        if length(varargin) == index || ~ischar(varargin{index})
            break;
        end

        len1 = min(length('visible'),length(varargin{index}));
        if ~strncmpi(varargin{index},'visible',len1)
            try set(gui_hFigure, varargin{index}, varargin{index+1}), catch break, end
        end
    end

    % If handle visibility is set to 'callback', turn it on until finished
    % with OpeningFcn
    gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
    if strcmp(gui_HandleVisibility, 'callback')
        set(gui_hFigure,'HandleVisibility', 'on');
    end

    feval(gui_State.gui_OpeningFcn, gui_hFigure, [], guidata(gui_hFigure), varargin{:});

    if isscalar(gui_hFigure) && ishghandle(gui_hFigure)
        % Handle the default callbacks of predefined toolbar tools in this
        % GUI, if any
        guidemfile('restoreToolbarToolPredefinedCallback',gui_hFigure); 
        
        % Update handle visibility
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);

        % Call openfig again to pick up the saved visibility or apply the
        % one passed in from the P/V pairs
        if ~gui_Exported
            gui_hFigure = local_openfig(gui_State.gui_Name, 'reuse',gui_Visible);
        elseif ~isempty(gui_VisibleInput)
            set(gui_hFigure,'Visible',gui_VisibleInput);
        end
        if strcmpi(get(gui_hFigure, 'Visible'), 'on')
            figure(gui_hFigure);
            
            if gui_Options.singleton
                setappdata(gui_hFigure,'GUIOnScreen', 1);
            end
        end

        % Done with GUI initialization
        if isappdata(gui_hFigure,'InGUIInitialization')
            rmappdata(gui_hFigure,'InGUIInitialization');
        end

        % If handle visibility is set to 'callback', turn it on until
        % finished with OutputFcn
        gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
        if strcmp(gui_HandleVisibility, 'callback')
            set(gui_hFigure,'HandleVisibility', 'on');
        end
        gui_Handles = guidata(gui_hFigure);
    else
        gui_Handles = [];
    end

    if nargout
        [varargout{1:nargout}] = feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    else
        feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    end

    if isscalar(gui_hFigure) && ishghandle(gui_hFigure)
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);
    end
end

function gui_hFigure = local_openfig(name, singleton, visible)

% openfig with three arguments was new from R13. Try to call that first, if
% failed, try the old openfig.
if nargin('openfig') == 2
    % OPENFIG did not accept 3rd input argument until R13,
    % toggle default figure visible to prevent the figure
    % from showing up too soon.
    gui_OldDefaultVisible = get(0,'defaultFigureVisible');
    set(0,'defaultFigureVisible','off');
    gui_hFigure = matlab.hg.internal.openfigLegacy(name, singleton);
    set(0,'defaultFigureVisible',gui_OldDefaultVisible);
else
    % Call version of openfig that accepts 'auto' option"
    gui_hFigure = matlab.hg.internal.openfigLegacy(name, singleton, visible);  
%     %workaround for CreateFcn not called to create ActiveX
%         peers=findobj(findall(allchild(gui_hFigure)),'type','uicontrol','style','text');    
%         for i=1:length(peers)
%             if isappdata(peers(i),'Control')
%                 actxproxy(peers(i));
%             end            
%         end
end

function result = local_isInvokeActiveXCallback(gui_State, varargin)

try
    result = ispc && iscom(varargin{1}) ...
             && isequal(varargin{1},gcbo);
catch
    result = false;
end

function result = local_isInvokeHGCallback(gui_State, varargin)

try
    fhandle = functions(gui_State.gui_Callback);
    result = ~isempty(findstr(gui_State.gui_Name,fhandle.file)) || ...
             (ischar(varargin{1}) ...
             && isequal(ishghandle(varargin{2}), 1) ...
             && (~isempty(strfind(varargin{1},[get(varargin{2}, 'Tag'), '_'])) || ...
                ~isempty(strfind(varargin{1}, '_CreateFcn'))) );
catch
    result = false;
end


