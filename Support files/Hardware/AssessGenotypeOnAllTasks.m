

function testError = AssessGenotypeOnAllTasks(genotype,config, read_session, switch_session,taskList,tests)

rng(1,'twister');
%taskList = {'NARMA10','NARMA20','Laser','NonChanEqRodan','Sunspot','IPIX_plus5','JapVowels'};
%taskList = {'NARMA10','Laser','IPIX_plus5','JapVowels'};


if nargin == 1 
    taskList = {'NARMA10','NARMA30','Laser','NonChanEqRodan'};
    config.popSize = size(genotype,1);
    config.leakOn = 1;
    config.num_electrodes =64;
    config.voltage_range =7;
    config.input_range = 16;
    config.reg_param = 10e-5;
    config.metrics_used = [1 1 0];
    tests = 1;
    config.material = 'B2S464';
    %setup
    [read_session,switch_session] = createDaqSessions(0:config.num_electrodes-1,0:(config.num_electrodes/2)-1);
end

config.hardware_scaling = 1;
config.showNeuronStates = 0;

%define tasks
for set = 1:length(taskList)
    [trainInputSequence{set},trainOutputSequence{set},valInputSequence{set},valOutputSequence{set},...
        testInputSequence{set},testOutputSequence{set},nForgetPoints{set},errType{set},queueType{set}] = selectDataset_Rodan(taskList{set},config.hardware_scaling);%deepSelectData(dataSet, [] ,[]); %NonChanEq has extra input
end

metrics =[]; kernel_rank =[];gen_rank=[];MC=[]; mapping=[];

%asses genotype
for test= 1:size(genotype,1)
    
    release(read_session); release(switch_session);
    testGenotype = reshape(genotype(test,:,:),size(genotype,2),size(genotype,3));
    
    fprintf('\nTest %d:\n',test)
    
     [kernel_rank(test),gen_rank(test),~,MC(test),mapping(test,:)] =getMetrics(switch_session,read_session,testGenotype...
            ,config.num_electrodes/2,config.num_electrodes,config.reg_param,config.leakOn,config.metrics_used);
      fprintf('Metrics: KR %d, GR %d, MC %.3f\n',kernel_rank(test),gen_rank(test),MC(test))
        fprintf('Mapping: outputs %d, controls %d, weights %.3f\n',mapping(test,1),mapping(test,2),mapping(test,3))
     
        metrics = [kernel_rank; gen_rank; MC];
      
    for taskSet = 1:length(taskList)
        
        trainInput= trainInputSequence{taskSet};
        trainOutput= trainOutputSequence{taskSet};
        valInput= valInputSequence{taskSet};
        valOutput = valOutputSequence{taskSet};
        testInput= testInputSequence{taskSet};
        testOutput= testOutputSequence{taskSet};
        
        switch(taskList{taskSet})
            case 'JapVowels'
                %weights
                queueType = 'Weighted';
                numInputs = size(trainInput,2);
                inputWeights = (2*rand(config.num_electrodes/2, numInputs)-1)/12;
                weightedTrainSequence = trainInput*inputWeights';
                weightedValSequence = valInput*inputWeights';
                weightedTestSequence = testInput*inputWeights';
                
            case 'IPIX_plus5'
                %weights
                queueType = 'Weighted';
                numInputs = size(trainInput,2);
                inputWeights = (2*rand(config.num_electrodes/2, numInputs)-1)/12;
                weightedTrainSequence = trainInput*inputWeights';
                weightedValSequence = valInput*inputWeights';
                weightedTestSequence = testInput*inputWeights';
                
            otherwise
                queueType = 'simple';
                weightedTrainSequence = [];
                weightedValSequence = [];
                weightedTestSequence = [];
        end
        
        % training data
        [statesExt,inputLoc,queue] = collectStatesHardware('train',switch_session, read_session, testGenotype, ...
            trainInput,nForgetPoints{taskSet},(config.num_electrodes/2),queueType,...
            weightedTrainSequence(),[],[],config.leakOn);
        
        % val data
        statesExtval = collectStatesHardware('val',switch_session, read_session, testGenotype, ...
            valInput,nForgetPoints{taskSet},(config.num_electrodes/2),queueType,...
            weightedValSequence(),inputLoc,queue,config.leakOn);
        
        % Find best reg parameter
        regTrainError = [];
        regValError =[];regWeights=[];
        regParam = [10e-1 10e-3 10e-5 10e-7 10e-9];
        
        for j = 1:length(regParam)
            
            %Train: tanspose is inversed compared to equation
            outputWeights = trainOutput(nForgetPoints{taskSet}+1:end,:)'*statesExt*inv(statesExt'*statesExt + regParam(j)*eye(size(statesExt'*statesExt)));
            
            % Calculate trained output Y
            outputSequence = statesExt*outputWeights';
            regTrainError(j,:)  = calculateError(outputSequence,trainOutput,nForgetPoints{taskSet},errType{taskSet});
            
            % Calculate trained output Y
            outputValSequence = statesExtval*outputWeights';
            regValError(j,:)  = calculateError(outputValSequence,valOutput,nForgetPoints{taskSet},errType{taskSet});
            regWeights(j,:,:) =outputWeights;
        end
        
        [~, regIndx]= min(sum(regValError,2));
        trainError(test,taskSet) = regTrainError(regIndx,:);
        valError(test,taskSet) = regValError(regIndx,:);
        testWeights =reshape(regWeights(regIndx,:,:),size(regWeights,2),size(regWeights,3));
        
        %% Evaluate on test data
        testStates = collectStatesHardware('test',switch_session, read_session, testGenotype, ...
            testInput,nForgetPoints{taskSet},(config.num_electrodes/2),queueType,...
            weightedTestSequence,inputLoc,queue,config.leakOn);
        
        if config.showNeuronStates
            imagesc(testStates)
            colormap('gray')
            drawnow
        end
        
        testSequence = testStates*testWeights';
        testError(test,taskSet) = calculateError(testSequence,testOutput,nForgetPoints{taskSet},errType{taskSet});
        
        fprintf('Task: %s,  error = %.4f\n',taskList{taskSet},testError(test,taskSet))
        
    end
    save(strcat('assessedGenoHardware_',num2str(size(genotype,1)),'_plusMetrics_SN_',config.material,'_run_',num2str(tests),'.mat'),'config','metrics','testError','genotype','mapping')
end

%save(strcat('assessedGenoHardware_',num2str(popSize),'.mat'),'Metrics','testError','genotype')

