function [ output_args ] = MportOffTimer_Callback( ~,~,handles )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
Config = getappdata(0,'Config');
fwrite(handles.Arduino,Config.Pin.Mport+100);% M port close



end

