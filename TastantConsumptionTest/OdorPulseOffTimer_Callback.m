function [ output_args ] = OdorPulseOffTimer_Callback( ~,~,handles )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%%%turn off the out valve
Config = getappdata(0,'Config');
fwrite(handles.Arduino,Config.Pin.OdorPumpPin(4)+100);
fwrite(handles.Arduino,Config.Pin.OdorPumpPin(5)+100);
fwrite(handles.Arduino,Config.Pin.OdorPumpPin(6)+100);

end

