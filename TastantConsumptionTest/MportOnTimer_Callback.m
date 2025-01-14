function  MportOnTimer_Callback( ~,~,handles )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
Config = getappdata(0,'Config');
fwrite(handles.Arduino,Config.Pin.Mport);% M port open
start(getappdata(0,'MportWaitTimer'));%wait for mouse poke in
start(getappdata(0,'MportWaitStopTimer'));
end

