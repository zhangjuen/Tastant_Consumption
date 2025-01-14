function listData = ListDataGeneration(Config)
%%%%trialNum, taste, Delay, Direction,trialInterval, Laser
listData = cell(size(Config.TrialData));
Odor = {'apple','banana','air','none'};
% Taste = {Config.taste1,Config.taste2,'Other_3'};
Taste = {'Acek 2mM','Quinine 0.25mM','Acek 5mM','Cyx100','Water','Acek 20mM','Qui 4mM','Empty'};
for i = 1:Config.TotalTrial
    listData{i,1} = Config.TrialData(i,1);
    listData{i,6} = Config.TrialData(i,6);
    listData{i,5} = Config.TrialData(i,5);
    listData{i,2} = Taste{Config.TrialData(i,2)};
    listData{i,4} = Config.TrialData(i,4);
    listData{i,3} = Odor{Config.TrialData(i,3)};
end

end