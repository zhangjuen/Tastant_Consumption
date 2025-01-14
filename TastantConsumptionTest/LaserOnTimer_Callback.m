function [ output_args ] = LaserOnTimer_Callback( ~,~,handles )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%stimulation
fwrite(handles.serial_1,getappdata(handles.pushbutton_start,'LaserPin')+200);   
getappdata(handles.pushbutton_start,'LaserPin')+200
% cal-light
% fwrite(handles.serial_1,getappdata(handles.pushbutton_start,'LaserPin'));        


end

