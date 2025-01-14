% clear;
trialData = getappdata(0,'TrialData');
taste = trialData(:,2);
% taste(taste==3) = 1;
taste(taste==2) = 4;
trialData(:,2) = taste;
%  delay = trialData(:,3);
%  delay(delay==2) = 1;
%  trialData(:,3) = delay;
% trialData(:,3) = 1;%delay
% trialData(:,5) = 10;
setappdata(0,'TrialData',trialData);