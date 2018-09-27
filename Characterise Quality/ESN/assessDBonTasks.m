% import database - by hand
clearvars -except database_ext database_esnMinor database_esnMajor config

% define tasks
taskList = {'NARMA10','NARMA30','Laser','NonChanEqRodan'};

for set = 1:length(taskList)
    fprintf('\nStarted Task: %s\n',taskList{set})
    
    [trainInputSequence{set},trainOutputSequence{set},valInputSequence{set},valOutputSequence{set},...
        testInputSequence{set},testOutputSequence{set},nForgetPoints{set},errType{set},queueType{set}] = selectDataset_Rodan(taskList{set});
    
    parfor res = 1:length(database_esnMinor)
        test_error(res,set) = assessESNonTask(database_esnMinor(res,:),database_esnMajor(res),...
            trainInputSequence{set},trainOutputSequence{set},valInputSequence{set},valOutputSequence{set},testInputSequence{set},testOutputSequence{set},...
            nForgetPoints{set},config.leakOn,errType{set},config.resType);
        fprintf('Task: %s, Current error: %.4f, Res num: %.4f\n',taskList{set},test_error(res,set),res)%min(test_error(1:res ,set)))
    end
    
    fprintf('\nCompleted: %s\n',taskList{set})
end

pred_dataset.inputs = database_ext;
pred_dataset.outputs = test_error;

%save output
 save(strcat('assessed_dB_forPrediction_',num2str(config.maxMinorUnits),'nodes_',num2str(length(database_ext)),'dbSize.mat'),...
                'pred_dataset','config','test_error','taskList','-v7.3');
       