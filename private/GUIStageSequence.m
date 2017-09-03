function varargout = GUIStageSequence(varargin)
% GUISTAGESEQUENCE MATLAB code for GUIStageSequence.fig
%      GUISTAGESEQUENCE, by itself, creates a new GUISTAGESEQUENCE or raises the existing
%      singleton*.
%
%      H = GUISTAGESEQUENCE returns the handle to a new GUISTAGESEQUENCE or the handle to
%      the existing singleton*.
%
%      GUISTAGESEQUENCE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUISTAGESEQUENCE.M with the given input arguments.
%
%      GUISTAGESEQUENCE('Property','Value',...) creates a new GUISTAGESEQUENCE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUIStageSequence_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUIStageSequence_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUIStageSequence

% Last Modified by GUIDE v2.5 01-Sep-2017 20:20:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIStageSequence_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIStageSequence_OutputFcn, ...
                   'gui_LayoutFcn',  @GUIStageSequence_LayoutFcn, ...
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


% --- Executes just before GUIStageSequence is made visible.
function GUIStageSequence_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUIStageSequence (see VARARGIN)

set(gcf,'CloseRequestFcn',[]);
% Choose default command line output for GUIStageSequence
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

% UIWAIT makes GUIStageSequence wait for user response (see UIRESUME)
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
    dt=handles.output.Hardware.delay;
    
    t=0:dt:Reps*Delay;
    control=t*0;
    for i=1:Reps
        control((t>=Delay*(i-1)) &  (t<Delay*(i-1)+Width))=1;
    end
    plot(t/1000,control);
    xlabel('time (s)')
    ylabel('control')
    
    
    

% --- Outputs from this function are returned to the command line.
function varargout = GUIStageSequence_OutputFcn(hObject, eventdata, handles) 
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

% --- Creates and returns a handle to the GUI figure. 
function h1 = GUIStageSequence_LayoutFcn(policy)
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
    'text', 6, ...
    'edit', 6, ...
    'axes', 2, ...
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
    'lastSavedFile', 'C:\Users\thomas\Documents\MATLAB\Matlab-Arduino-RTData\private\GUIStageSequence.m', ...
    'lastFilename', 'C:\Users\thomas\Documents\MATLAB\Matlab-Arduino-RTData\GuiDesign\StageSequence.fig');
appdata.lastValidTag = 'figure1';
appdata.GUIDELayoutEditor = [];
appdata.initTags = struct(...
    'handle', [], ...
    'tag', 'figure1');

h1 = figure(...
'PaperUnits','inches',...
'Units','characters',...
'Position',[135.8 56.3846153846154 115.428571428571 28],...
'Visible',get(0,'defaultfigureVisible'),...
'Color',get(0,'defaultfigureColor'),...
'CurrentAxesMode','manual',...
'IntegerHandle','off',...
'MenuBar','none',...
'Name','StageSequence',...
'NumberTitle','off',...
'Resize','off',...
'PaperPosition',get(0,'defaultfigurePaperPosition'),...
'PaperSize',[8.5 11],...
'PaperSizeMode',get(0,'defaultfigurePaperSizeMode'),...
'PaperType','usletter',...
'PaperTypeMode',get(0,'defaultfigurePaperTypeMode'),...
'PaperUnitsMode',get(0,'defaultfigurePaperUnitsMode'),...
'ScreenPixelsPerInchMode','manual',...
'HandleVisibility','callback',...
'Tag','figure1',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'axes1';

h2 = axes(...
'Parent',h1,...
'FontUnits',get(0,'defaultaxesFontUnits'),...
'Units','characters',...
'CameraMode',get(0,'defaultaxesCameraMode'),...
'CameraPosition',[0.5 0.5 9.16025403784439],...
'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
'CameraTarget',[0.5 0.5 0.5],...
'CameraTargetMode',get(0,'defaultaxesCameraTargetMode'),...
'CameraViewAngle',6.60861036031192,...
'CameraViewAngleMode',get(0,'defaultaxesCameraViewAngleMode'),...
'Position',[7 2.875 100.142857142857 14.3125],...
'ActivePositionProperty','position',...
'ActivePositionPropertyMode',get(0,'defaultaxesActivePositionPropertyMode'),...
'LooseInset',[8.30142857142857 2.976875 6.06642857142857 2.0296875],...
'LooseInsetMode',get(0,'defaultaxesLooseInsetMode'),...
'DataSpaceMode',get(0,'defaultaxesDataSpaceMode'),...
'PlotBoxAspectRatio',[1 0.37125748502994 0.37125748502994],...
'PlotBoxAspectRatioMode',get(0,'defaultaxesPlotBoxAspectRatioMode'),...
'ColorSpaceMode',get(0,'defaultaxesColorSpaceMode'),...
'ChildContainerMode',get(0,'defaultaxesChildContainerMode'),...
'DecorationContainerMode',get(0,'defaultaxesDecorationContainerMode'),...
'XRulerMode',get(0,'defaultaxesXRulerMode'),...
'XTick',[0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1],...
'XTickMode',get(0,'defaultaxesXTickMode'),...
'XTickLabel',{  '0'; '0.1'; '0.2'; '0.3'; '0.4'; '0.5'; '0.6'; '0.7'; '0.8'; '0.9'; '1' },...
'XTickLabelMode',get(0,'defaultaxesXTickLabelMode'),...
'XBaselineMode',get(0,'defaultaxesXBaselineMode'),...
'YRulerMode',get(0,'defaultaxesYRulerMode'),...
'YTick',[0 0.2 0.4 0.6 0.8 1],...
'YTickMode',get(0,'defaultaxesYTickMode'),...
'YTickLabel',{  '0'; '0.2'; '0.4'; '0.6'; '0.8'; '1' },...
'YTickLabelMode',get(0,'defaultaxesYTickLabelMode'),...
'YBaselineMode',get(0,'defaultaxesYBaselineMode'),...
'ZRulerMode',get(0,'defaultaxesZRulerMode'),...
'ZBaselineMode',get(0,'defaultaxesZBaselineMode'),...
'AmbientLightSourceMode',get(0,'defaultaxesAmbientLightSourceMode'),...
'SortMethod','childorder',...
'SortMethodMode',get(0,'defaultaxesSortMethodMode'),...
'Tag','axes1',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

h3 = get(h2,'title');

set(h3,...
'Parent',h2,...
'Units','data',...
'FontUnits','points',...
'DecorationContainer',[],...
'DecorationContainerMode','auto',...
'Color',[0 0 0],...
'ColorMode','auto',...
'Position',[0.500000545364654 1.01478494623656 0.5],...
'PositionMode','auto',...
'Interpreter','tex',...
'InterpreterMode','auto',...
'Rotation',0,...
'RotationMode','auto',...
'FontName','Helvetica',...
'FontNameMode','auto',...
'FontUnitsMode','auto',...
'FontSize',11,...
'FontSizeMode','auto',...
'FontAngle','normal',...
'FontAngleMode','auto',...
'FontWeight','bold',...
'FontWeightMode','auto',...
'HorizontalAlignment','center',...
'HorizontalAlignmentMode','auto',...
'VerticalAlignment','bottom',...
'VerticalAlignmentMode','auto',...
'EdgeColor','none',...
'EdgeColorMode','auto',...
'LineStyle','-',...
'LineStyleMode','auto',...
'LineWidth',0.5,...
'LineWidthMode','auto',...
'BackgroundColor','none',...
'BackgroundColorMode','auto',...
'Margin',3,...
'MarginMode','auto',...
'Clipping','off',...
'ClippingMode','auto',...
'Layer','middle',...
'LayerMode','auto',...
'FontSmoothing','on',...
'FontSmoothingMode','auto',...
'UnitsMode','auto',...
'IncludeRenderer','on',...
'IsContainer','off',...
'IsContainerMode','auto',...
'HG1EraseMode','auto',...
'BusyAction','queue',...
'Interruptible','on',...
'SelectionHighlight','on',...
'SelectionHighlightMode','auto',...
'HitTest','on',...
'HitTestMode','auto',...
'PickableParts','visible',...
'PickablePartsMode','auto',...
'XLimInclude','on',...
'XLimIncludeMode','auto',...
'YLimInclude','on',...
'YLimIncludeMode','auto',...
'ZLimInclude','on',...
'ZLimIncludeMode','auto',...
'CLimInclude','on',...
'CLimIncludeMode','auto',...
'ALimInclude','on',...
'ALimIncludeMode','auto',...
'Description','Axes Title',...
'DescriptionMode','auto',...
'Visible','on',...
'VisibleMode','auto',...
'Serializable','on',...
'SerializableMode','auto',...
'HandleVisibility','off',...
'HandleVisibilityMode','auto',...
'TransformForPrintFcnImplicitInvoke','on',...
'TransformForPrintFcnImplicitInvokeMode','auto');

h4 = get(h2,'xlabel');

set(h4,...
'Parent',h2,...
'Units','data',...
'FontUnits','points',...
'DecorationContainer',[],...
'DecorationContainerMode','auto',...
'Color',[0.15 0.15 0.15],...
'ColorMode','auto',...
'Position',[0.500000476837158 -0.127240140645308 1.77635683940025e-15],...
'PositionMode','auto',...
'Interpreter','tex',...
'InterpreterMode','auto',...
'Rotation',0,...
'RotationMode','auto',...
'FontName','Helvetica',...
'FontNameMode','auto',...
'FontUnitsMode','auto',...
'FontSize',11,...
'FontSizeMode','auto',...
'FontAngle','normal',...
'FontAngleMode','auto',...
'FontWeight','normal',...
'FontWeightMode','auto',...
'HorizontalAlignment','center',...
'HorizontalAlignmentMode','auto',...
'VerticalAlignment','top',...
'VerticalAlignmentMode','auto',...
'EdgeColor','none',...
'EdgeColorMode','auto',...
'LineStyle','-',...
'LineStyleMode','auto',...
'LineWidth',0.5,...
'LineWidthMode','auto',...
'BackgroundColor','none',...
'BackgroundColorMode','auto',...
'Margin',3,...
'MarginMode','auto',...
'Clipping','off',...
'ClippingMode','auto',...
'Layer','back',...
'LayerMode','auto',...
'FontSmoothing','on',...
'FontSmoothingMode','auto',...
'UnitsMode','auto',...
'IncludeRenderer','on',...
'IsContainer','off',...
'IsContainerMode','auto',...
'HG1EraseMode','auto',...
'BusyAction','queue',...
'Interruptible','on',...
'SelectionHighlight','on',...
'SelectionHighlightMode','auto',...
'HitTest','on',...
'HitTestMode','auto',...
'PickableParts','visible',...
'PickablePartsMode','auto',...
'XLimInclude','on',...
'XLimIncludeMode','auto',...
'YLimInclude','on',...
'YLimIncludeMode','auto',...
'ZLimInclude','on',...
'ZLimIncludeMode','auto',...
'CLimInclude','on',...
'CLimIncludeMode','auto',...
'ALimInclude','on',...
'ALimIncludeMode','auto',...
'Description','AxisRulerBase Label',...
'DescriptionMode','auto',...
'Visible','on',...
'VisibleMode','auto',...
'Serializable','on',...
'SerializableMode','auto',...
'HandleVisibility','off',...
'HandleVisibilityMode','auto',...
'TransformForPrintFcnImplicitInvoke','on',...
'TransformForPrintFcnImplicitInvokeMode','auto');

h5 = get(h2,'ylabel');

set(h5,...
'Parent',h2,...
'Units','data',...
'FontUnits','points',...
'DecorationContainer',[],...
'DecorationContainerMode','auto',...
'Color',[0.15 0.15 0.15],...
'ColorMode','auto',...
'Position',[-0.0565535584173438 0.500000476837158 1.77635683940025e-15],...
'PositionMode','auto',...
'Interpreter','tex',...
'InterpreterMode','auto',...
'Rotation',90,...
'RotationMode','auto',...
'FontName','Helvetica',...
'FontNameMode','auto',...
'FontUnitsMode','auto',...
'FontSize',11,...
'FontSizeMode','auto',...
'FontAngle','normal',...
'FontAngleMode','auto',...
'FontWeight','normal',...
'FontWeightMode','auto',...
'HorizontalAlignment','center',...
'HorizontalAlignmentMode','auto',...
'VerticalAlignment','bottom',...
'VerticalAlignmentMode','auto',...
'EdgeColor','none',...
'EdgeColorMode','auto',...
'LineStyle','-',...
'LineStyleMode','auto',...
'LineWidth',0.5,...
'LineWidthMode','auto',...
'BackgroundColor','none',...
'BackgroundColorMode','auto',...
'Margin',3,...
'MarginMode','auto',...
'Clipping','off',...
'ClippingMode','auto',...
'Layer','back',...
'LayerMode','auto',...
'FontSmoothing','on',...
'FontSmoothingMode','auto',...
'UnitsMode','auto',...
'IncludeRenderer','on',...
'IsContainer','off',...
'IsContainerMode','auto',...
'HG1EraseMode','auto',...
'BusyAction','queue',...
'Interruptible','on',...
'SelectionHighlight','on',...
'SelectionHighlightMode','auto',...
'HitTest','on',...
'HitTestMode','auto',...
'PickableParts','visible',...
'PickablePartsMode','auto',...
'XLimInclude','on',...
'XLimIncludeMode','auto',...
'YLimInclude','on',...
'YLimIncludeMode','auto',...
'ZLimInclude','on',...
'ZLimIncludeMode','auto',...
'CLimInclude','on',...
'CLimIncludeMode','auto',...
'ALimInclude','on',...
'ALimIncludeMode','auto',...
'Description','AxisRulerBase Label',...
'DescriptionMode','auto',...
'Visible','on',...
'VisibleMode','auto',...
'Serializable','on',...
'SerializableMode','auto',...
'HandleVisibility','off',...
'HandleVisibilityMode','auto',...
'TransformForPrintFcnImplicitInvoke','on',...
'TransformForPrintFcnImplicitInvokeMode','auto');

h6 = get(h2,'zlabel');

set(h6,...
'Parent',h2,...
'Units','data',...
'FontUnits','points',...
'DecorationContainer',[],...
'DecorationContainerMode','auto',...
'Color',[0.15 0.15 0.15],...
'ColorMode','auto',...
'Position',[0 0 0],...
'PositionMode','auto',...
'Interpreter','tex',...
'InterpreterMode','auto',...
'Rotation',0,...
'RotationMode','auto',...
'FontName','Helvetica',...
'FontNameMode','auto',...
'FontUnitsMode','auto',...
'FontSize',10,...
'FontSizeMode','auto',...
'FontAngle','normal',...
'FontAngleMode','auto',...
'FontWeight','normal',...
'FontWeightMode','auto',...
'HorizontalAlignment','left',...
'HorizontalAlignmentMode','auto',...
'VerticalAlignment','middle',...
'VerticalAlignmentMode','auto',...
'EdgeColor','none',...
'EdgeColorMode','auto',...
'LineStyle','-',...
'LineStyleMode','auto',...
'LineWidth',0.5,...
'LineWidthMode','auto',...
'BackgroundColor','none',...
'BackgroundColorMode','auto',...
'Margin',3,...
'MarginMode','auto',...
'Clipping','off',...
'ClippingMode','auto',...
'Layer','middle',...
'LayerMode','auto',...
'FontSmoothing','on',...
'FontSmoothingMode','auto',...
'UnitsMode','auto',...
'IncludeRenderer','on',...
'IsContainer','off',...
'IsContainerMode','auto',...
'HG1EraseMode','auto',...
'BusyAction','queue',...
'Interruptible','on',...
'SelectionHighlight','on',...
'SelectionHighlightMode','auto',...
'HitTest','on',...
'HitTestMode','auto',...
'PickableParts','visible',...
'PickablePartsMode','auto',...
'XLimInclude','on',...
'XLimIncludeMode','auto',...
'YLimInclude','on',...
'YLimIncludeMode','auto',...
'ZLimInclude','on',...
'ZLimIncludeMode','auto',...
'CLimInclude','on',...
'CLimIncludeMode','auto',...
'ALimInclude','on',...
'ALimIncludeMode','auto',...
'Description','AxisRulerBase Label',...
'DescriptionMode','auto',...
'Visible','off',...
'VisibleMode','auto',...
'Serializable','on',...
'SerializableMode','auto',...
'HandleVisibility','off',...
'HandleVisibilityMode','auto',...
'TransformForPrintFcnImplicitInvoke','on',...
'TransformForPrintFcnImplicitInvokeMode','auto');

appdata = [];
appdata.lastValidTag = 'PulseWidthEdt';

h7 = uicontrol(...
'Parent',h1,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','characters',...
'String',{  'Edit Text' },...
'Style','edit',...
'Position',[7 18.5625 14.4285714285714 2.5],...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)GUIStageSequence('PulseWidthEdt_Callback',hObject,eventdata,guidata(hObject)),...
'Children',[],...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)GUIStageSequence('PulseWidthEdt_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','PulseWidthEdt',...
'FontSize',10,...
'FontSizeMode',get(0,'defaultuicontrolFontSizeMode'));

appdata = [];
appdata.lastValidTag = 'RepetitionsEdt';

h8 = uicontrol(...
'Parent',h1,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','characters',...
'String',{  'Edit Text' },...
'Style','edit',...
'Position',[28.2857142857143 18.5625 14.4285714285714 2.5],...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)GUIStageSequence('RepetitionsEdt_Callback',hObject,eventdata,guidata(hObject)),...
'Children',[],...
'KeyPressFcn',blanks(0),...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)GUIStageSequence('RepetitionsEdt_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'DeleteFcn',blanks(0),...
'ButtonDownFcn',blanks(0),...
'Tag','RepetitionsEdt',...
'FontSize',10,...
'FontSizeMode',get(0,'defaultuicontrolFontSizeMode'));

appdata = [];
appdata.lastValidTag = 'PeriodEdt';

h9 = uicontrol(...
'Parent',h1,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','characters',...
'String',{  'Edit Text' },...
'Style','edit',...
'Position',[49.8571428571429 18.5625 14.4285714285714 2.5],...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)GUIStageSequence('PeriodEdt_Callback',hObject,eventdata,guidata(hObject)),...
'Children',[],...
'KeyPressFcn',blanks(0),...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)GUIStageSequence('PeriodEdt_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'DeleteFcn',blanks(0),...
'ButtonDownFcn',blanks(0),...
'Tag','PeriodEdt',...
'FontSize',10,...
'FontSizeMode',get(0,'defaultuicontrolFontSizeMode'));

appdata = [];
appdata.lastValidTag = 'text2';

h10 = uicontrol(...
'Parent',h1,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','characters',...
'HorizontalAlignment','left',...
'String','Pulse Width (ms)',...
'Style','text',...
'Position',[7.14285714285714 21.1875 17 1.3125],...
'Children',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} ,...
'Tag','text2',...
'FontSize',10,...
'FontSizeMode',get(0,'defaultuicontrolFontSizeMode'));

appdata = [];
appdata.lastValidTag = 'text3';

h11 = uicontrol(...
'Parent',h1,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','characters',...
'HorizontalAlignment','left',...
'String','Repetitions',...
'Style','text',...
'Position',[28.4285714285714 21.1875 12.7142857142857 1.3125],...
'Children',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} ,...
'DeleteFcn',blanks(0),...
'ButtonDownFcn',blanks(0),...
'Tag','text3',...
'FontSize',10,...
'FontSizeMode',get(0,'defaultuicontrolFontSizeMode'));

appdata = [];
appdata.lastValidTag = 'text4';

h12 = uicontrol(...
'Parent',h1,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','characters',...
'HorizontalAlignment','left',...
'String','Period (ms)',...
'Style','text',...
'Position',[50 21.1875 14.4285714285714 1.3125],...
'Children',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} ,...
'DeleteFcn',blanks(0),...
'ButtonDownFcn',blanks(0),...
'Tag','text4',...
'FontSize',10,...
'FontSizeMode',get(0,'defaultuicontrolFontSizeMode'));

appdata = [];
appdata.lastValidTag = 'text5';

h13 = uicontrol(...
'Parent',h1,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','characters',...
'String','Staged Sequence Editor',...
'Style','text',...
'Position',[7 23.5625 100.142857142857 3],...
'Children',[],...
'Tag','text5',...
'FontSize',20,...
'FontWeight','bold',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'DoneBttn';

h14 = uicontrol(...
'Parent',h1,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','characters',...
'String','Done',...
'Style',get(0,'defaultuicontrolStyle'),...
'Position',[85.5714285714286 18.5 21.5714285714286 3.1875],...
'Callback',@(hObject,eventdata)GUIStageSequence('DoneBttn_Callback',hObject,eventdata,guidata(hObject)),...
'Children',[],...
'Tag','DoneBttn',...
'FontSize',10,...
'FontSizeMode',get(0,'defaultuicontrolFontSizeMode'),...
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
    % GUISTAGESEQUENCE
    % create the GUI only if we are not in the process of loading it
    % already
    gui_Create = true;
elseif local_isInvokeActiveXCallback(gui_State, varargin{:})
    % GUISTAGESEQUENCE(ACTIVEX,...)
    vin{1} = gui_State.gui_Name;
    vin{2} = [get(varargin{1}.Peer, 'Tag'), '_', varargin{end}];
    vin{3} = varargin{1};
    vin{4} = varargin{end-1};
    vin{5} = guidata(varargin{1}.Peer);
    feval(vin{:});
    return;
elseif local_isInvokeHGCallback(gui_State, varargin{:})
    % GUISTAGESEQUENCE('CALLBACK',hObject,eventData,handles,...)
    gui_Create = false;
else
    % GUISTAGESEQUENCE(...)
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
    % Singleton setting in the GUI M-file takes priority if different
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
%     if feature('HGUsingMATLABClasses')
%         peers=findobj(findall(allchild(gui_hFigure)),'type','uicontrol','style','text');    
%         for i=1:length(peers)
%             if isappdata(peers(i),'Control')
%                 actxproxy(peers(i));
%             end            
%         end
%     end
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

