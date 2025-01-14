function WashoffTimer_Callback( ~,~,handles )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% fwrite(handles.serial_1,getappdata(handles.pushbutton_start,'SuckPin_2')+100);%stop the suck_2
%stop the pump
Config = getappdata(0,'Config');
MpumpPin = Config.Pin.MpumpPin;
trialData = getappdata(0,'TrialData');
trialNow = str2double(get(handles.text_trialNow,'string'))+1;% haven't change the number, so add 1
fwrite(handles.Arduino,MpumpPin(trialData(trialNow,2))+100); % M pump pin low
fwrite(handles.Arduino,Config.Pin.WashPin+100);%stop the suck_2
fwrite(handles.Arduino,MpumpPin(trialData(5))+100); % M pump pin low

end

