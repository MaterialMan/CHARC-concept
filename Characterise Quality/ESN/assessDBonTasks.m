% import database - by hand
clearvars -except database_ext genotype config

% define tasks
config.taskList = {'NARMA10','NARMA30','Laser','NonChanEqRodan'};

for set = 1:length(config.taskList)
    fprintf('\nStarted Task: %s\n',config.taskList{set})
    
    [trainInputSequence,trainOutputSequence,valInputSequence,valOutputSequence,...
        testInputSequence,testOutputSequence,nForgetPoints,errType,queueType] = selectDataset_Rodan(config.taskList{set});
    
    parfor res = 1:length(genotype)
        genotype(res) = testReservoir(genotype(res),config);
        test_error(res,set) = genotype(res).testError;
        %fprintf('Task: %s, Current error: %.4f, Best error found: %.4f\n',config.taskList{set},test_error(res,set),min(test_error(1:res ,set)))
        fprintf('Task: %s, Current error: %.4f\n',config.taskList{set},test_error(res,set))
    end
    
    fprintf('\nCompleted: %s\n',config.taskList{set})
end

pred_dataset.inputs = database_ext;
pred_dataset.outputs = test_error;

%save output
 save(strcat('assessed_dB_forPrediction_',num2str(config.maxMinorUnits),'nodes_',num2str(length(database_ext)),'dbSize.mat'),...
                'pred_dataset','config','test_error','taskList','-v7.3');
       