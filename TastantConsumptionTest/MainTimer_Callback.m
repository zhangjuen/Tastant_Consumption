function MainTimer_Callback( ~,~,handles )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
getappdata(handles.pushbutton_start,'MpumpTrigMode');
Config = getappdata(0,'Config'); 
PMtimeNow = toc(getappdata(0,'GlobalTic'));
trialTimeNow = toc(getappdata(0,'trialTic'))-getappdata(handles.pushbutton_start,'MportLickTimeTic');
OutWindowLickAdd = -1;
if trialTimeNow>=Config.trialEnd+Config.MpumpOn% trial restart    
    trialRestart(handles);    
end
%Photometry
if getappdata(0,'photometryMode')
    PMsignalRead(PMtimeNow);
    PM_lickPlot = getappdata(0,'PM_lickPlot');
end%photometry end


trialData = getappdata(0,'TrialData');
trialNow = str2double(get(handles.text_trialNow,'string'));
inputNum = handles.Arduino.BytesAvailable;
if inputNum>0  % should be 'inputNum', not handles.Arduino.BytesAvailable, otherwise, in some case if the exact time has inputs, inputNum will be 0, but BytesAvailable not 0
    Inputs = fread(handles.Arduino,inputNum,'uchar');   
    an_lickPlot = getappdata(0,'an_lickPlot');
    %%%check poke in
    if find(Inputs=='I')%in

        if getappdata(handles.pushbutton_start,'PokeInMark')==0%first poke in
        setappdata(handles.pushbutton_start,'PokeInMark',1);%set mark 1 for m port wait check
        end

%         disp(['Mouse poke in, trial: ',num2str(trialNow)]);
        trialPokeInTime = getappdata(0,'trialPokeInTime');
        index = find(trialPokeInTime(trialNow,:)==0,1);
        trialPokeInTime(trialNow,index) = PMtimeNow;
        setappdata(0,'trialPokeInTime',trialPokeInTime);
                % fwrite(handles.Arduino,11); % tone cue
    end
    if find(Inputs=='i')%%out

%         disp(['Mouse poke out, trial: ',num2str(trialNow)]);
        trialPokeInTime = getappdata(0,'trialPokeInTime');
        index = find(trialPokeInTime(trialNow,:)==0,1);
        trialPokeInTime(trialNow,index) = -PMtimeNow;%negative value, represent out            
        setappdata(0,'trialPokeInTime',trialPokeInTime);
        
    end
    %%%%%%%%%%%%%%% middle lick  
    if find(Inputs=='M')        
        MLickData = getappdata(0,'MLickData');
                % fwrite(handles.Arduino,11); % tone cue
        lickTrigNum = Config.lickTrigNum;
        index = find(MLickData==-1,1);
        if getappdata(handles.pushbutton_start,'MpumpTrigMode') % M Trig On, M lick detect on            
            M_LickMark = getappdata(handles.pushbutton_start,'M_LickMark');
            setappdata(handles.pushbutton_start,'M_LickMark',M_LickMark);            
            if mod(M_LickMark,lickTrigNum)==0                
                fwrite(handles.Arduino,Config.Pin.MpumpPin(trialData(trialNow,2))+200); % M pump  pin Trigger
            end
            setappdata(handles.pushbutton_start,'M_LickMark',M_LickMark+1);
            MLickNum = str2double(get(handles.text_MiddleLickNum,'string'));
            set(handles.text_MiddleLickNum,'string',MLickNum+1);            
            if MLickNum==0
%                 trialTimeNow = 0;% first lick, set timeNow zero
                trialFirstLickTime = getappdata(0,'trialFirstLickTime');
            trialFirstLickTime(trialNow) = PMtimeNow;
            setappdata(0,'trialFirstLickTime',trialFirstLickTime);            
                             
            end   
                    addpoints(an_lickPlot(trialData(trialNow,2)),[NaN,trialTimeNow,trialTimeNow],[NaN,trialNow-0.6,trialNow+0.3]);% MainTimerPeroid the period of this timer
                    if getappdata(0,'photometryMode')
                        addpoints(PM_lickPlot(trialData(trialNow,2)),[NaN,PMtimeNow,PMtimeNow],[NaN,0.1,0.9]);
                    end                            
            MLickData(1,index) = PMtimeNow;% save absolute time
        else % not in time window
            
                    addpoints(an_lickPlot(9),[NaN,trialTimeNow,trialTimeNow],[NaN,trialNow-0.6,trialNow+0.3]);% MainTimerPeroid the period of this timer
                    if getappdata(0,'photometryMode')
                        addpoints(PM_lickPlot(9),[NaN,PMtimeNow,PMtimeNow],[NaN,0.1,0.9]);
                    end
             
            MLickData(1,index) = PMtimeNow*OutWindowLickAdd;% save absolute time
            
        end%
        % save lick Data
        setappdata(0,'MLickData',MLickData);
    end % M lick end
   
       
end % serial avalable end
end % function end



