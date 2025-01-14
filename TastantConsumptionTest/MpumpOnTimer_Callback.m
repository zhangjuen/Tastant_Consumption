function [ output_args ] = MpumpOnTimer_Callback( ~,~,handles )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
setappdata(handles.pushbutton_start,'MpumpTrigMode',1);%Lick become effective, animals receive liquid
% start(getappdata(0,'MpumpOffTimer')); % set the time to stop animal get liquid 
% start(getappdata(0,'MportOffTimer')); % set the time to close the door
%%%%do not start the timer now, should start these timer when the mouse
%%%%makes the first lick, that is the real trial start. so at
%%%%MportWaitTimer
disp('M Pump trigger on, tastant becomes available')
end


