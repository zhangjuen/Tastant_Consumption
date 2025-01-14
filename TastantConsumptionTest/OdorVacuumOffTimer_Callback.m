function [ output_args ] = OdorVacuumOffTimer_Callback( ~,~,handles )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
Config = getappdata(0,'Config');
fwrite(handles.Arduino,Config.Pin.OdorVacuumPin+100);


end

