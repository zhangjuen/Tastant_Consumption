function [ output_args ] = MportWaitStopTimer_Callback( ~,~,handles )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
if getappdata(handles.pushbutton_start,'M_LickMark')<2 %if still no M lick, until wait time out
    %  stop MwaitStopTimer
        stop(getappdata(0,'MportWaitTimer')); % stop check lick or not

    trialRestart(handles);
%     stop(getappdata(0,'MportWaitTimer')); % stop check lick or not
    % stop the trial, start a new trial, or end the test
    
end


end

