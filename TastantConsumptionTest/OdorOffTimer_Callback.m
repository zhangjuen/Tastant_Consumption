function [ output_args ] = OdorOffTimer_Callback( ~,~,handles )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
Config = getappdata(0,'Config');
fwrite(handles.Arduino,Config.Pin.OdorPumpPin(1)+100);
fwrite(handles.Arduino,Config.Pin.OdorPumpPin(4)+100);
fwrite(handles.Arduino,Config.Pin.OdorPumpPin(2)+100);
fwrite(handles.Arduino,Config.Pin.OdorPumpPin(5)+100);

%switch to air
fwrite(handles.Arduino,Config.Pin.OdorPumpPin(3));
fwrite(handles.Arduino,Config.Pin.OdorPumpPin(6));



end

