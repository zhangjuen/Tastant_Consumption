function TrialStartTimer_StartFcn( ~,~,handles )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
Config = getappdata(0,'Config');
if Config.Wash > 0
    fwrite(handles.Arduino,Config.Pin.WashPin);    
    % open the taste pump
    MpumpPin = Config.Pin.MpumpPin;
    trialData = getappdata(0,'TrialData');
    trialNow = str2double(get(handles.text_trialNow,'string'))+1;% haven't change the number, so add 1
    % fwrite(handles.Arduino,MpumpPin(trialData(trialNow,2))); % M pump on pin high
    fwrite(handles.Arduino,MpumpPin(5)); % M pump on pin high, only water wash
    
    start(getappdata(0,'WashoffTimer'));
end

if Config.OdorVacuumTime>0
    fwrite(handles.Arduino,Config.Pin.OdorVacuumPin);
    start(getappdata(0,'OdorVacuumOffTimer'));

end



end

