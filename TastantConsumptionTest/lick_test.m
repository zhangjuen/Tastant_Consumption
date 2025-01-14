% try
%     fclose(serial_1);
% catch
% end
% clc;clear;
% delete(instrfind);
% serial_1 = serial('COM4');
% set(serial_1,'BaudRate',9600);
% fopen(serial_1);
% setappdata(0,'TestSerial',serial_1);
function lick_test(handles)
serialReadTimer = timer();
x = 1;
set(serialReadTimer,'TimerFcn',{@lick_test_Callback,handles},'ExecutionMode','fixedRate','tag','serialReadTimer');
set(serialReadTimer,'Period',0.1);
start(serialReadTimer);
end