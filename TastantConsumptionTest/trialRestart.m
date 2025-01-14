function trialRestart( handles )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
Config = getappdata(0,'Config');
fwrite(handles.Arduino,0);% all pin off
ts = timerfind;
for i = 1: length(ts)
    if ~strcmp(ts(i).tag,'MainTimer')% don't stop main timer
        stop(ts(i))
    end
end

fwrite(handles.Arduino,Config.Pin.OdorPumpPin(3)+100);%air off, 
fwrite(handles.Arduino,Config.Pin.OdorPumpPin(6)+100);
fwrite(handles.Arduino,Config.Pin.Mport+100);% M port off
trialData = getappdata(0,'TrialData');
trialNow = str2double(get(handles.text_trialNow,'string'));


setappdata(handles.pushbutton_start,'M_LickMark',0);
setappdata(handles.pushbutton_start,'PokeInMark',0);
setappdata(handles.pushbutton_start,'MpumpTrigMode',0);


TrialStatisData =getappdata(0,'TrialStatisData');

TrialStatisData(trialNow,1) = str2double(get(handles.text_MiddleLickNum,'string'));
h_bar = getappdata(0,'h_bar');
XData = [h_bar(trialData(trialNow,2)).XData trialNow];
YData = [h_bar(trialData(trialNow,2)).YData TrialStatisData(trialNow,1)];
h_bar(trialData(trialNow,2)).XData = XData;
h_bar(trialData(trialNow,2)).YData = YData;
setappdata(0,'TrialStatisData',TrialStatisData);

if trialNow<str2double(get(handles.edit_totalTrial,'String'))
    % start nex trial, reset start delay
    TrialStartTimer = getappdata(0,'TrialStartTimer');
    TrialStartTimer.StartDelay = trialData(trialNow+1,5);
    start(TrialStartTimer);
else%session finished
    fwrite(handles.Arduino,Config.Pin.Mport+100);
    MLickData = getappdata(0,'MLickData');
    dlmwrite(getappdata(0,'LickFileName'),[MLickData],'-append');
    setappdata(0,'MLickData',ones(1,10000)*-1);% reset the lick data, suppose each trial, lick no more than 100
    disp('Training Completed! Well Done!!!');
    sessionStop( handles );
end

end

