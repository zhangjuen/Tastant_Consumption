function [ output_args ] = lick_test_Callback( ~,~,handles )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% serial_1 = getappdata(0,'TestSerial');
serial_1=handles.Arduino;
inputNum = serial_1.BytesAvailable;

% display(555)

if inputNum>0  % should be 'inputNum', not handles.serial_1.BytesAvailable, otherwise, in some case if the exact time has inputs, inputNum will be 0, but BytesAvailable not 0
        Inputs = fread(serial_1,inputNum,'uchar'); 
%         display(char(Inputs)');
        lickTrigNum = 2;
        N = numel(find(Inputs=='M'));
        if N
            MLickNum = str2double(get(handles.text_MiddleLickNum,'string'))+N;
                    fwrite(serial_1, 11);  
            if mod(MLickNum,lickTrigNum) == 0
                fwrite(serial_1,230);
            end
            set(handles.text_MiddleLickNum,'string',MLickNum);
        end
        
%         fwrite(serial_1,223);


% [ ArduinoTime ] = ArduinoTimeExtract( Inputs ,'T','t');
% % [ ArduinoTimeM ] = ArduinoTimeExtract( Inputs ,'M','m')
% if isempty(getappdata(0,'ArduinoS'))
%     setappdata(0,'ArduinoS',ArduinoTime);
% 
% else
%     ArduinoTimeStart = getappdata(0,'ArduinoS');
%     Del = (ArduinoTime-ArduinoTimeStart)/1000-toc(getappdata(0,'MatlabTic'))
% end
% 
% end

end

