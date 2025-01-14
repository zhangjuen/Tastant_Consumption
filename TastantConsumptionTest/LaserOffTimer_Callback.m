function [ output_args ] = LaserOffTimer_Callback( ~,~,handles )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


fwrite(handles.serial_1,getappdata(handles.pushbutton_start,'LaserPin')+100);        



end

