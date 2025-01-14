function [ output_args ] = MpumpOffTimer_Callback( ~,~,handles )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
setappdata(handles.pushbutton_start,'MpumpTrigMode',0);%Lick become not effective, animals receive no liquid


end

