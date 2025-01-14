function MportWaitTimer_Callback( ~,~,handles )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
trialNow = str2double(get(handles.text_trialNow,'string'));
trialFirstLickTime = getappdata(0,'trialFirstLickTime');
if trialFirstLickTime(trialNow) % check firstLick in 
     
    trialStartTime = getappdata(0,'trialStartTime');
    trialStartTime(trialNow) = toc(getappdata(0,'GlobalTic'));
    setappdata(0,'trialStartTime',trialStartTime);
    
    stop(getappdata(0,'MportWaitTimer'));%stop wait check timer
    setappdata(handles.pushbutton_start,'MportLickTimeTic',toc(getappdata(0,'trialTic')));
    start(getappdata(0,'MpumpOffTimer')); % set the time to stop animal get liquid 
    start(getappdata(0,'MportOffTimer')); % set the time to close the door
    trialData = getappdata(0,'TrialData');
    Config = getappdata(0,'Config');
    if Config.OdorDur% include odor
        fwrite(handles.Arduino,Config.Pin.OdorPumpPin(3)+100);%air off, switch to odor
        fwrite(handles.Arduino,Config.Pin.OdorPumpPin(6)+100);
        switch trialData(trialNow,3)
            case 1 % apple, odor A
                fwrite(handles.Arduino,Config.Pin.OdorPumpPin(1));
                fwrite(handles.Arduino,Config.Pin.OdorPumpPin(4));
                
            case 2 % banana, odor B
                fwrite(handles.Arduino,Config.Pin.OdorPumpPin(2));
                fwrite(handles.Arduino,Config.Pin.OdorPumpPin(5));
                
            case 3 %  air
                fwrite(handles.Arduino,Config.Pin.OdorPumpPin(3));
                fwrite(handles.Arduino,Config.Pin.OdorPumpPin(6));                
        end
        start(getappdata(0,'OdorOffTimer'));        

    end
    % start(getappdata(0,'MpumpOnTimer'));
end

