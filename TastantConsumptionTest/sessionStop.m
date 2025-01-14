function [ output_args ] = sessionStop( handles )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
Config = getappdata(0,'Config');
    set(handles.pushbutton_start,'String','Start','BackgroundColor',[0.94 0.94 0.94]);
    fwrite(handles.Arduino,0);
    fwrite(handles.Arduino,Config.Pin.Mport+100);% M port off
    setappdata(handles.pushbutton_start,'trialNow',str2double(get(handles.text_trialNow,'string')));
    matlabData.Config = Config;
    matlabData.TrialData = getappdata(0,'TrialData');%save another copy of TrialData, because may change TrialData during the training
    matlabData.statis_data = getappdata(0,'statis_data');
    matlabData.TrialStatisData =getappdata(0,'TrialStatisData');
    matlabData.trialStartTime = getappdata(0,'trialStartTime');
    matlabData.scanRate = getappdata(0,'scanRate');%photometryScanRate
    matlabData.trialFirstLickTime = getappdata(0,'trialFirstLickTime'); 
    matlabData.trialPokeInTime = getappdata(0,'trialPokeInTime');  
    
    DataFolderPath = getappdata(handles.pushbutton_start,'DataFolderPath');
    fileTime = datestr(datetime());
    fileTime(fileTime==':') = '_';
    fileTime(fileTime==' ') = '_';
    str = [DataFolderPath,'\',fileTime, 'matlabData.mat'];
    save(str,'matlabData');
    
    %save last trial lick data, when press stop, but not all trial finish.
    MLickData = getappdata(0,'MLickData');
    lastTrialLickNum = sum(MLickData~=-1);
    if lastTrialLickNum
        dlmwrite(getappdata(0,'LickFileName'),[MLickData],'-append');
    end    
    ts = timerfind;
    if ~isempty(ts)
        if getappdata(0,'photometryMode')%photometry is running
            for i = 1: length(ts)
                if ~strcmp(ts(i).tag,'MainTimer')% don't stop main timer
                    stop(ts(i))
                end
            end
        else
            stop(ts);
        end
    end
    LickFigName = [DataFolderPath,'\',fileTime, 'Lick.emf'];
    f = getappdata(0,'f_lick');
    saveas(f,LickFigName);
    close(f);
    statisFig = [DataFolderPath,'\',fileTime, 'statisFig.emf'];
    f = getappdata(0,'f_statis');
    saveas(f,statisFig);
    fclose('all');
    close(f);
    set(handles.pushbutton_start,'String','Start','BackgroundColor',[0.94 0.94 0.94]);
    disp('Data and figures saved!!!');

end

