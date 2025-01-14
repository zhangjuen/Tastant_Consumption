function varargout = TastantConsumptionTest(varargin)
% TASTANTCONSUMPTIONTEST MATLAB code for TastantConsumptionTest.fig
%      TASTANTCONSUMPTIONTEST, by itself, creates a new TASTANTCONSUMPTIONTEST or raises the existing
%      singleton*.
%
%      H = TASTANTCONSUMPTIONTEST returns the handle to a new TASTANTCONSUMPTIONTEST or the handle to
%      the existing singleton*.
%
%      TASTANTCONSUMPTIONTEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TASTANTCONSUMPTIONTEST.M with the given input arguments.
%
%      TASTANTCONSUMPTIONTEST('Property','Value',...) creates a new TASTANTCONSUMPTIONTEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TastantConsumptionTest_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TastantConsumptionTest_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TastantConsumptionTest

% Last Modified by GUIDE v2.5 26-Sep-2024 10:07:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @TastantConsumptionTest_OpeningFcn, ...
    'gui_OutputFcn',  @TastantConsumptionTest_OutputFcn, ...
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


% --- Executes just before TastantConsumptionTest is made visible.
function TastantConsumptionTest_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TastantConsumptionTest (see VARARGIN)

% Choose default command line output for TastantConsumptionTest
handles.output = hObject;
setappdata(0,'photometryMode',0);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TastantConsumptionTest wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TastantConsumptionTest_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_start.
function pushbutton_start_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;
% Update handles structure
guidata(hObject, handles); 
str = get(handles.pushbutton_start,'String');
%%%% stop
if strcmp(str,'Stop')
    sessionStop( handles );
    return;
end
if ~get(handles.radiobutton_COM_1,'value')
    disp('Please Connect the COM, then wait 2 s.');
    return;
end
%%%%%%%%%start
if strcmp(str,'Start')
    set(handles.pushbutton_start,'String','Stop','BackgroundColor',[1 0 0]);
end
ts = timerfind();
if ~isempty(ts)
    stop(ts);
    delete(ts);
end

% Check config, interval, ratio,...
Config = getappdata(0,'Config');
flushinput(handles.Arduino);
set(handles.text_trialNow,'String',0);
set(handles.edit_totalTrial,'String',Config.TotalTrial);
fwrite(handles.Arduino,0);% all pin off
fwrite(handles.Arduino,Config.Pin.Mport+100);% M port off

set(handles.text_MiddleLickNum,'string',0);

colorStock = getappdata(handles.pushbutton_start,'colorStock');
setappdata(handles.pushbutton_start,'MportLickTimeTic',0);


DataFolderPath = getappdata(handles.pushbutton_start,'DataFolderPath');
fileTime = datestr(datetime());
fileTime(fileTime==':') = '_';
fileTime(fileTime==' ') = '_';
LickFileName = [DataFolderPath,'\',fileTime, 'LickData.dat'];
% LickFileFid = fopen(LickFileName,'w');
setappdata(0,'LickFileName',LickFileName);

trialData = getappdata(0,'TrialData');
if Config.TrialInterval(1)-Config.Wash<1
    display('Set larger trial low interval');
    return;
end

%%%%%%%%%%%%%
TrialStartTimer = timer('TimerFcn',{@TrialStartTimer_Callback,handles},'Period',0.1,'StartDelay',trialData(1,5), 'tag','TrialStartTimer','StartFcn',{@TrialStartTimer_StartFcn,handles});
setappdata(0,'TrialStartTimer',TrialStartTimer);
MportOnTimer = timer('TimerFcn',{@MportOnTimer_Callback,handles},'Period',0.1,'StartDelay',Config.DoorOpen,'tag','MportOnTimer');
setappdata(0,'MportOnTimer',MportOnTimer);
MpumpOnTimer = timer('TimerFcn',{@MpumpOnTimer_Callback,handles},'Period',0.1,'StartDelay',Config.MpumpOn,'tag','MpumpOnTimer');
setappdata(0,'MpumpOnTimer',MpumpOnTimer);
MpumpOffTimer = timer('TimerFcn',{@MpumpOffTimer_Callback,handles},'Period',0.1,'StartDelay',Config.LickTimeWindow,'tag','MpumpOffTimer');% M pump off is the duration of pump open window, if 0, define by M port off-Mpump on
setappdata(0,'MpumpOffTimer',MpumpOffTimer);
MportOffTimer = timer('TimerFcn',{@MportOffTimer_Callback,handles},'Period',0.1,'StartDelay',Config.MportOff);
setappdata(0,'MportOffTimer',MportOffTimer);
MportWaitTimer = timer('TimerFcn',{@MportWaitTimer_Callback,handles},'Period',0.02,'ExecutionMode','fixedRate');
setappdata(0,'MportWaitTimer',MportWaitTimer);
MportWaitStopTimer = timer('TimerFcn',{@MportWaitStopTimer_Callback,handles},'Period',0.1,'StartDelay',Config.MportWait);
setappdata(0,'MportWaitStopTimer',MportWaitStopTimer); % if not lick until wait, stop the trial
OdorOffTimer = timer('TimerFcn',{@OdorOffTimer_Callback,handles},'Period',0.1,'StartDelay',Config.OdorDur);
setappdata(0,'OdorOffTimer',OdorOffTimer);
OdorVacuumOffTimer = timer('TimerFcn',{@OdorVacuumOffTimer_Callback,handles},'Period',0.1,'StartDelay',Config.OdorVacuumTime);
setappdata(0,'OdorVacuumOffTimer',OdorVacuumOffTimer);
OdorPulseOffTimer = timer('TimerFcn',{@OdorPulseOffTimer_Callback,handles},'Period',0.1,'StartDelay',0.2);
setappdata(0,'OdorPulseOffTimer',OdorPulseOffTimer);
WashoffTimer = timer('TimerFcn',{@WashoffTimer_Callback,handles},'Period',0.1,'StartDelay',Config.Wash);
setappdata(0,'WashoffTimer',WashoffTimer);
MainTimer = timer();
MainTimerPeroid = 0.02;
set(MainTimer,'TimerFcn',{@MainTimer_Callback,handles},'ExecutionMode','fixedRate','tag','MainTimer');
set(MainTimer,'Period',MainTimerPeroid);
setappdata(0,'MainTimer',MainTimer);

f_lick = figure('position',[100 100 500 700]);hold on;
axes_lick = gca;
colorStock = [0 1 0; 1 0 0; 0 1 0; 1 0 0; 0 0 0; 0 1 0; 1 0 0; 0 0 0; 0.3 0.5 0.9];
an_lickPlot(1) = animatedline(axes_lick,'Color',colorStock(1,:));
an_lickPlot(2) = animatedline(axes_lick,'Color',colorStock(2,:));
an_lickPlot(3) = animatedline(axes_lick,'Color',colorStock(3,:));
an_lickPlot(4) = animatedline(axes_lick,'Color',colorStock(4,:));
an_lickPlot(5) = animatedline(axes_lick,'Color',colorStock(5,:));
an_lickPlot(6) = animatedline(axes_lick,'Color',colorStock(6,:));
an_lickPlot(7) = animatedline(axes_lick,'Color',colorStock(7,:));
an_lickPlot(8) = animatedline(axes_lick,'Color',colorStock(8,:));
an_lickPlot(9) = animatedline(axes_lick,'Color',colorStock(9,:));
set(axes_lick,'xlim',[-0.5 Config.trialEnd]);
setappdata(0,'an_lickPlot',an_lickPlot);
setappdata(0,'f_lick',f_lick);
setappdata(0,'axes_lick',axes_lick);
f_statis = figure('position',[50 100 1000 400]);
axes_statis = gca;
hold on;
setappdata(0,'f_statis',f_statis);
setappdata(0,'axes_statis',axes_statis);
barwidth = 0.2;
set(axes_statis,'xlim',[0 Config.TotalTrial+0.5]);
h_bar(1) = bar(axes_statis,0,0,'FaceColor',colorStock(1,:),'barwidth',barwidth);
h_bar(2) = bar(axes_statis,0,0,'FaceColor',colorStock(2,:),'barwidth',barwidth);
h_bar(3) = bar(axes_statis,0,0,'FaceColor',colorStock(3,:),'barwidth',barwidth);
h_bar(4) = bar(axes_statis,0,0,'FaceColor',colorStock(4,:),'barwidth',barwidth);
h_bar(5) = bar(axes_statis,0,0,'FaceColor',colorStock(5,:),'barwidth',barwidth);
h_bar(6) = bar(axes_statis,0,0,'FaceColor',colorStock(6,:),'barwidth',barwidth);
h_bar(7) = bar(axes_statis,0,0,'FaceColor',colorStock(7,:),'barwidth',barwidth);
h_bar(8) = bar(axes_statis,0,0,'FaceColor',colorStock(8,:),'barwidth',barwidth);
setappdata(0,'h_bar',h_bar);
%

TrialStatisData = zeros(Config.TotalTrial,3);
setappdata(0,'TrialStatisData',TrialStatisData);

if ~getappdata(0,'photometryMode') % no photometry recording, so set the global timer
    setappdata(0,'GlobalTic',tic);%reset global tic
    display('Global timer tic Reset!!!')
end
setappdata(0,'trialFirstLickTime',zeros(Config.TotalTrial,1));
setappdata(0,'trialStartTime',zeros(Config.TotalTrial,1));
setappdata(0,'trialPokeInTime',zeros(Config.TotalTrial,2000));
trialTic = tic;
setappdata(0,'trialTic',trialTic);
setappdata(handles.pushbutton_start,'MportLickTimeTic',tic);
setappdata(handles.pushbutton_start,'M_LickMark',0);
setappdata(handles.pushbutton_start,'PokeInMark',0);
fwrite(handles.Arduino,getappdata(handles.pushbutton_start,'SessionStartSignalPin'));
start(TrialStartTimer);
if strcmp(get(getappdata(0,'MainTimer'),'Running'),'off')
    start(MainTimer);
end

function edit_com1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_com1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_com1 as text
%        str2double(get(hObject,'String')) returns contents of edit_com1 as a double
set(handles.radiobutton_COM_1,'value',1);
radiobutton_COM_1_Callback(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit_com1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_com1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton_COM_1.
function radiobutton_COM_1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_COM_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_COM_1
value = get(handles.radiobutton_COM_1,'value');
if value==1
    com = ['COM',get(handles.edit_com1,'string')];
    try
        delete(instrfind('Port',com));
        handles.Arduino = serial(com);
        set(handles.Arduino,'BaudRate',9600);
    catch
        msgbox('Check Arduino');
        return;
    end
    fopen(handles.Arduino);
    str = [com,':Connected!'];
    disp(str);
else
    com = ['COM',get(handles.edit_com1,'string')];
    fclose(handles.Arduino);
    delete(handles.Arduino);
    str = [com,':Disconnected!'];
    disp(str);
end
handles.output = hObject;
guidata(hObject, handles);

% --- Executes on button press in pushbutton_loadConfig.
function pushbutton_loadConfig_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_loadConfig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ConfigFolderPath = getappdata(handles.pushbutton_start,'ConfigFolderPath');
if isempty(ConfigFolderPath)
    str = '*.mat';
else
    str = [ConfigFolderPath,'*.mat'];
end
[ConfigName,ConfigFolderPath,index] = uigetfile(str,'Select the Config File');
if ~index
    return;
end
setappdata(handles.pushbutton_start,'ConfigFolderPath',ConfigFolderPath);
set(handles.text_configName,'String',ConfigName);
Config = importdata([ConfigFolderPath,ConfigName]);
Config
setappdata(0,'Config',Config);
setappdata(0,'TrialData',Config.TrialData);
listData = ListDataGeneration(Config);
set(handles.uitable_trialList,'data',listData);
set(handles.edit_totalTrial,'string',Config.TotalTrial);

display('Config loaded!');
% setappdata(0,'GlobalTic',tic);%reset global tic
% display('Global timer tic Reset!!!')

% --- Executes on button press in pushbutton_selectFolder.
function pushbutton_selectFolder_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_selectFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DataFolderPath = getappdata(handles.pushbutton_start,'DataFolderPath');


if isempty(DataFolderPath)
    DataFolderPath = 'G:\data';
end


DataFolderPath = uigetdir(DataFolderPath,'Select the folder for data');
if ~DataFolderPath
    return;
end
setappdata(handles.pushbutton_start,'DataFolderPath',DataFolderPath);
set(handles.text_dataFolder,'String',DataFolderPath);



function edit_totalTrial_Callback(hObject, eventdata, handles)
% hObject    handle to edit_totalTrial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_totalTrial as text
%        str2double(get(hObject,'String')) returns contents of edit_totalTrial as a double


% --- Executes during object creation, after setting all properties.
function edit_totalTrial_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_totalTrial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when entered data in editable cell(s) in uitable_trialList.
function uitable_trialList_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable_trialList (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
TrialData = getappdata(0,'TrialData');
inputs = eventdata.NewData;
if inputs=='A'||inputs=='a'
    inputs = 1;
end
if inputs=='B'||inputs=='b'
    inputs = 2;
end
if eventdata.Indices(2)==2
    inputs = str2double(inputs);
end
% class(inputs)
TrialData(eventdata.Indices(1),eventdata.Indices(2)) = inputs;
setappdata(0,'TrialData',TrialData);



function edit_command_Callback(hObject, eventdata, handles)
% hObject    handle to edit_command (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_command as text
%        str2double(get(hObject,'String')) returns contents of edit_command as a double
command = get(handles.edit_command,'string');
set(handles.edit_command,'string',[]);
if strcmp(command,'restart')
    trialRestart(handles);
    return;
end
if strcmp(command,'lick_test')
    try
    stop(timerfind);
    delete(timerfind);
    catch
    end
    lick_test(handles);
    set(handles.text_MiddleLickNum,'string',0);
    return;
end
if strcmp(command,'PP')%prepare, before experiment, wash and odor 
    for pins = [37 28 30 23 25 29 31]
    fwrite(handles.Arduino,pins);
    end
end
command = str2num(command);
fwrite(handles.Arduino,command);
if (command==0)
    fwrite(handles.Arduino,102);%door close
end
display(command);


% --- Executes during object creation, after setting all properties.
function edit_command_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_command (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_sendCommand.
function pushbutton_sendCommand_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_sendCommand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
edit_command_Callback(hObject, eventdata, handles)
