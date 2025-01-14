function varargout = TastantLickAnalysis(varargin)
% TASTANTLICKANALYSIS MATLAB code for TastantLickAnalysis.fig
%      TASTANTLICKANALYSIS, by itself, creates a new TASTANTLICKANALYSIS or raises the existing
%      singleton*.
%
%      H = TASTANTLICKANALYSIS returns the handle to a new TASTANTLICKANALYSIS or the handle to
%      the existing singleton*.
%
%      TASTANTLICKANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TASTANTLICKANALYSIS.M with the given input arguments.
%
%      TASTANTLICKANALYSIS('Property','Value',...) creates a new TASTANTLICKANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TastantLickAnalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TastantLickAnalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TastantLickAnalysis

% Last Modified by GUIDE v2.5 25-Sep-2024 12:53:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TastantLickAnalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @TastantLickAnalysis_OutputFcn, ...
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


% --- Executes just before TastantLickAnalysis is made visible.
function TastantLickAnalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TastantLickAnalysis (see VARARGIN)

% Choose default command line output for TastantLickAnalysis
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TastantLickAnalysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TastantLickAnalysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_loadData.
function pushbutton_loadData_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_loadData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pathname = getappdata(0,'A_path');
if ~isempty(pathname)
    str = [pathname '*.mat'];
else
    str = 'F:\post-doc project\mouse behavior data\*.mat';
end
[filename,pathname,index] = uigetfile(str);
if ~index
    return;
end
str = [pathname filename];
matlabData = importdata(str);
s = [pathname,'*.dat'];
[filename,pathname,index] = uigetfile(s);
if ~index
    display('Data not selected!!');
    return;
end
set(handles.edit_LickFile,'string',filename)
str = [pathname filename];
lickData = importdata(str);
setappdata(0,'A_path',pathname);

temp = matlabData.trialPokeInTime>0;
Num = find(temp>0,1,'last');
totalTrialNumber = min(size(lickData,1),Num);
ss = ['totalTrialNumber:',num2str(totalTrialNumber)];
disp(ss)
set(handles.edit_trialRange,'string','[ ]');
setappdata(0,'TrialRange',[1 totalTrialNumber]);
setappdata(0,'matlabData',matlabData);
setappdata(0,'lickData',lickData);
setappdata(0,'TrialNumber',totalTrialNumber);

function edit_LickFile_Callback(hObject, eventdata, handles)
% hObject    handle to edit_LickFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_LickFile as text
%        str2double(get(hObject,'String')) returns contents of edit_LickFile as a double


% --- Executes during object creation, after setting all properties.
function edit_LickFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_LickFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_trialRange_Callback(hObject, eventdata, handles)
% hObject    handle to edit_trialRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_trialRange as text
%        str2double(get(hObject,'String')) returns contents of edit_trialRange as a double


% --- Executes during object creation, after setting all properties.
function edit_trialRange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_trialRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_analysis.
function pushbutton_analysis_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
matlabData = getappdata(0,'matlabData');
lickData = getappdata(0,'lickData');
trialRange = str2num(get(handles.edit_trialRange,'string'));
if isempty(trialRange)
    trialRange = getappdata(0,'TrialRange');
end

% setappdata(0,'TrialNumber',totalTrialNumber);
% inputs = inputdlg({'Taste','Odor','Color'},'',[1 20],{'5','4','2'});
% if isempty(inputs)
%     return;
% else
% end
% 
% Taste = str2num(inputs{1});
% Odor = str2num(inputs{2});
% Co = str2num(inputs{3});
% Color = [0.8 0 0; 0.6 0.6 0.6];

lickData(lickData==-1) = [];%remove preset number
lickData(lickData<0)
% display the out window licks
lickData = abs(lickData);
lickData = lickData-matlabData.trialFirstLickTime;%calibrate to PokeIn time
LickNumber = numel(lickData)
CumuLick = 1:LickNumber;
figure; hold on
plot([lickData matlabData.Config.LickTimeWindow],[CumuLick LickNumber]);
set(gca,'XLim',[0 matlabData.Config.LickTimeWindow]);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
matlabData = getappdata(0,'matlabData');
trialRange = str2num(get(handles.edit_trialRange,'string'));
if isempty(trialRange)
    trialRange = getappdata(0,'TrialRange');
end
    
% setappdata(0,'TrialNumber',totalTrialNumber);
inputs = inputdlg({'Taste','Odor','Color'},'',[1 20],{'5','4','1'});
if isempty(inputs)    
    return;
else    
end

Taste = str2num(inputs{1});
Odor = str2num(inputs{2});
StayInThreshold = 0.5;
% trialRange(1) = 1;% skip first trial

MaxStayInTime = matlabData.Config.MpumpOn+matlabData.Config.MportOff;

% InColor = [0.8 0 0; 0.4 0.9 0.4];
InColor = [0.8 0 0; 0.75 0.75 0.75];

OutColor = [0.75 0.75 0.75];
figure;hold on;
% set(gca,'ylim',[0 4])
for i = 1:numel(Taste)    
    TempTrial = 1;
    index = find(matlabData.TrialData(:,2)==Taste(i)&matlabData.TrialData(:,3)==Odor(i));
    index(index<trialRange(1)) = [];
    index(index>trialRange(2)) = [];
    PokeInTime = abs(matlabData.trialPokeInTime(index,:));
    for j = 1:numel(index)
        PokeInTimeNow = PokeInTime(j,:);
        PokeInTimeNow(PokeInTimeNow==0) = [];
        if ~matlabData.trialStartTime(index(j))% trial not perform
            disp(['trial: ',num2str(index(j)), '  not perform' ])
            continue;
        end
        PokeInTimeNow = PokeInTimeNow-matlabData.trialStartTime(index(j));        
        PokeInTimeNow(PokeInTimeNow>MaxStayInTime) = [];        
        if mod(numel(PokeInTimeNow),2)==1
            PokeInTimeNow = [PokeInTimeNow MaxStayInTime];%animal keep staying in, no out until the end of odor
        end
%         rectangle('Position',[0 index(j)-0.4 MaxStayInTime 0.8 ],'FaceColor','none','EdgeColor',OutColor);
        rectangle('Position',[ index(j)-0.4,0, 0.8, MaxStayInTime  ],'FaceColor','none','EdgeColor',OutColor);

        for k = 1:numel(PokeInTimeNow)/2
%             rectangle('Position',[PokeInTimeNow(k*2-1), index(j)-0.4, PokeInTimeNow(k*2)-PokeInTimeNow(k*2-1), 0.8],'FaceColor',InColor(i,:),'EdgeColor','none');
            rectangle('Position',[index(j)-0.4,PokeInTimeNow(k*2-1), 0.8,  PokeInTimeNow(k*2)-PokeInTimeNow(k*2-1)],'FaceColor',InColor(i,:),'EdgeColor','none');
            
        end
        TempTrial = TempTrial+1;
        
    end
    
end
