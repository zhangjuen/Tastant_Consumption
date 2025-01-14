function [ output_args ] = TrialStartTimer_Callback( ~,~,handles )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
% flushinput(handles.serial_1);
% clc
fwrite(handles.Arduino,100); % reset touch sensor

trialNow = str2double(get(handles.text_trialNow,'string'));
%write data into disk, save lick data of last trial
if trialNow > 0 % to avoid write disk at trial 0
MLickData = getappdata(0,'MLickData');
dlmwrite(getappdata(0,'LickFileName'),[MLickData],'-append');% 
end
set(handles.text_MiddleLickNum,'string',0);
       
trialNow = trialNow+1;
set(handles.text_trialNow,'string',trialNow);


%%%open pre odor valve, give a short pulse odor
trialData = getappdata(0,'TrialData');
Config = getappdata(0,'Config');
if Config.OdorDur% include odor
    
    switch trialData(trialNow,3)
        case 1 % apple, odor A
            fwrite(handles.Arduino,Config.Pin.OdorPumpPin(1));           
        case 2 % banana, odor B
            fwrite(handles.Arduino,Config.Pin.OdorPumpPin(2));            
        case 3 %  air
            fwrite(handles.Arduino,Config.Pin.OdorPumpPin(3));
    end
    fwrite(handles.Arduino,Config.Pin.OdorPumpPin(3));%%%air on, and then switch to odor
    fwrite(handles.Arduino,Config.Pin.OdorPumpPin(6));
end


setappdata(0,'trialTic',tic); % reset trial tic
setappdata(handles.pushbutton_start,'MportLickTimeTic',0);

start(getappdata(0,'MportOnTimer'));
start(getappdata(0,'MpumpOnTimer'));
setappdata(handles.pushbutton_start,'PokeInMark',0);
setappdata(0,'MLickData',ones(1,10000)*-1);% reset the lick data, suppose each trial, lick no more than 100
end

