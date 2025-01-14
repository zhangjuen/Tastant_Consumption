function [TrialData] = TrialDataGeneration( Config )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
% TrialData is important, for caculation and trial control
%%%%trialNum, taste, Odor, temp,trialInterval, temp
TrialData = zeros(Config.TotalTrial,5); % for easily generate random sequence
TrialInterval = round(rand(Config.TotalTrial,1)*(Config.TrialInterval(2)-Config.TrialInterval(1))) + Config.TrialInterval(1);
TrialData(:,1) = 1:Config.TotalTrial;
TrialData(:,2) = 1;%pre-set
TrialData(:,5) = TrialInterval;
TrialData(:,4) = 0;
TrialData(:,6) = 0;
%%%%  taste: number 1~8
%%% example Config.Taste = [0 0 0 1 1]; only bitter and water; channel_1:0, channel_4:1, channel_5:1 
if sum(Config.Taste)==2
    Config.Taste(Config.Taste==1) = 2;% if 1:1, make the random scale to 2:2, to reduce the expetation possibility of next trial
end
tempN = sum(Config.Taste);
    tempM = floor(Config.TotalTrial/tempN);
    [~,RandData] = sort(rand(tempM,tempN),2); 
    TrialTaste(1:tempN*tempM,1) = reshape(RandData',[],1);
    if tempN*tempM<Config.TotalTrial
        for i = 1:Config.TotalTrial-tempN*tempM
            TrialTaste(tempN*tempM+i) = randi([1 tempN],1,1);
        end
    end    
for i = 1:numel(Config.Taste)-1
    TrialData(TrialTaste>sum(Config.Taste(1:i)),2) = i+1;
end
% odor: 1 odorA,apple; 2, odorB banana; 3, odorC, air; 4, N, no odor
tasteOdorPair = [1 2 1 3 3 1 2 ]; 
taste = unique(TrialData(:,2));
for i = 1:numel(taste)
TrialData(TrialData(:,2)==taste(i),3) = tasteOdorPair(taste(i));
end

% TrialData(:,3) = 3;% 

end



