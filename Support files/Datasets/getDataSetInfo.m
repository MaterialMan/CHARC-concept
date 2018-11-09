function [config,figure3,figure4] = getDataSetInfo(config)

figure3= 0; figure4 = 0;
config.task_num_inputs = size(config.trainInputSequence,2);
config.task_num_outputs = size(config.trainOutputSequence,2);

if strcmp(config.dataSet,'autoencoder')
    config.leakOn = 0;                          % add leak states
    config.AddInputStates = 0; 
    figure3= figure; figure4 = figure;
    config.sparseInputWeights = 1;
end
  
if strcmp(config.dataSet,'poleBalance')
    config.time_steps = 1000;
    config.simpleTask = 3;
    config.pole_tests = 1;
    config.velocity = 1;
    config.runSim = 0;
    config.testFcn = @poleBalance;
    config.evolveOutputWeights = 1;
end
