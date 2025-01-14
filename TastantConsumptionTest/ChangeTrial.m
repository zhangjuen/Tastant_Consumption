%%
[TrialData] = TrialDataGeneration( Config );
Config.TrialData = TrialData;
save('airWater-airBitter', 'Config')