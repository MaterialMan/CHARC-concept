%% Novelty Search using metrics
% Author: M. Dale
% Date: 22/03/18

clearvars -except config 
rng(1,'twister');

% type of network to evolve
config.resType = 'RoR_IA'; % can use different hierarchical reservoirs. RoR_IA is default ESN.
config.maxMinorUnits=50; %num of nodes in subreservoirs
config.maxMajorUnits=1; % num of subreservoirs. Default ESN should be 1.

%Evolutionary parameters
config.numTests = 1; %num of runs
config.popSize =50; %large pop better
config.totalGens = 100; %num of gens
config.numMutate = 0.1; 
config.deme = round(config.popSize*0.2); %sub-species increase diversity
config.recRate = 0.8; 

% Network details
config.startFull = 1; % start with max network size
config.alt_node_size = 0; % allow different network sizes
config.multiActiv = 0; % use different activation funcs
config.leakOn = 1;
config.rand_connect =1; %radnomise networks
config.activList = {'tanh';'linearNode'}; % what activations are in use when multiActiv = 1

% NS parameters
config.k_neighbours = 15; % how many neighbours to check
config.p_min = 3; % novelty threshold. Start low.
config.p_min_check = 25; % change novelty threshold dynamically after "p_min_check" gens.

% general params
config.genPrint = 1; % gens to display achive and database
config.startTime = datestr(now, 'HH:MM:SS');
figure1 =figure;
config.saveGen = 50;
%config.paramIndx = 1; %record database; start from 1
config.startTime = tic;

%% RUn MicroGA
for tests = 1:config.numTests
    
     clearvars -except config tests storeError figure1 stats_novelty_KQ stats_novelty_MC total_space_covered all_databases
           ...
           
    fprintf('\n Test: %d  ',tests);
    fprintf('Processing genotype......... %s \n',datestr(now, 'HH:MM:SS'))
    tic 
    
    rng(tests,'twister');
    
    config.paramIndx=1;
    
    switch(config.resType)
        case 'RoR'
            [esnMajor, esnMinor] =createDeepReservoir_extWeights([],[],config.popSize,config.maxMinorUnits,config.maxMajorUnits,config.startFull,config.multiActiv,config.rand_connect,config.activList);
        case 'RoR_IA'
            [esnMajor, esnMinor] =createDeepReservoir_extWeights([],[],config.popSize,config.maxMinorUnits,config.maxMajorUnits,config.startFull,config.multiActiv,config.rand_connect,config.activList);
        case 'pipeline'
            [esnMajor, esnMinor] =createDeepReservoir_pipeline([],[],config.popSize,config.maxMinorUnits,config.maxMajorUnits,config.startFull,config.multiActiv,config.rand_connect,config.activList);
        case 'pipeline_IA'
            [esnMajor, esnMinor] =createDeepReservoir_pipeline([],[],config.popSize,config.maxMinorUnits,config.maxMajorUnits,config.startFull,config.multiActiv,config.rand_connect,config.activList);
        case 'Ensemble'
            [esnMajor, esnMinor] =createDeepReservoir_ensemble([],[],config.popSize,config.maxMinorUnits,config.maxMajorUnits,config.startFull,config.multiActiv,config.rand_connect,config.activList);
    end

    
    kernel_rank=[]; gen_rank=[];
    rank_diff=[]; MC=[];
    
    %% Evaluate population
    for popEval = 1:config.popSize
        [~, kernel_rank(popEval), gen_rank(popEval)] = DeepRes_KQ_GR_LE(esnMajor(popEval),esnMinor(popEval,:),config.resType,[1 1 0]);
        MC(popEval) = DeepResMemoryTest(esnMajor(popEval),esnMinor(popEval,:),config.resType);  
    end
    
    %% Create NS archive from inital pop
    archive = [kernel_rank;gen_rank; MC]';
    archive_esnMinor = esnMinor;
    archive_esnMajor = esnMajor;
    
    % Add all search points to db
    database = [kernel_rank;gen_rank; MC]';
    database_ext = [kernel_rank;gen_rank;kernel_rank-gen_rank;abs(kernel_rank-gen_rank); MC]';
    database_esnMinor = esnMinor;
    database_esnMajor = esnMajor;
            
    for i = 1:config.popSize
        storeError(tests,1,i) = findKNN(archive,archive(i,:),config.k_neighbours);
    end
    fprintf('Processing took: %.4f sec, Starting GA \n',toc)
    
    cnt_no_change = 1;
    
    for gen = 2:config.totalGens

        rng(gen,'twister');
              
        % Tournment selection - pick two individuals
        equal = 1;
        while(equal)
            indv1 = randi([1 config.popSize]);
            indv2 = indv1+randi([1 config.deme]);
            if indv2 > config.popSize
                indv2 = indv2- config.popSize;
            end
            if indv1 ~= indv2
                equal = 0;
            end
        end
        
        %calculate distances
        pop_metrics = [kernel_rank;gen_rank;MC]';
        error_indv1 = findKNN([archive; pop_metrics],pop_metrics(indv1,:),config.k_neighbours);
        error_indv2 = findKNN([archive; pop_metrics],pop_metrics(indv2,:),config.k_neighbours);
        
                
        % Assess fitness of both and assign winner/loser - highest score
        % wins
        if error_indv1 > error_indv2
            winner=indv1; loser = indv2;
        else
            winner=indv2; loser = indv1;
        end
        
        %% Infection phase
        for i = 1:size(esnMinor,2)
            %recombine
            if rand < config.recRate
                esnMinor(loser,i) = esnMinor(winner,i);
                
                if config.multiActiv %transfer activation type as well
                    actNum = randperm(length(esnMajor(loser).reservoirActivationFunction),length(esnMajor(loser).reservoirActivationFunction)*config.recRate);
                    for act = 1:length(actNum)
                        esnMajor(loser).reservoirActivationFunction{i,actNum(act)} = esnMajor(winner).reservoirActivationFunction{i,actNum(act)};
                    end
                end
                
                %update esnMajor weights and major internal units
                esnMajor(loser)= changeMajorWeights(esnMajor(loser),i,esnMinor(loser,:));
            end
            
            %Reorder
            [esnMinor(loser,:), esnMajor(loser).connectWeights,esnMajor(loser).interResScaling, esnMajor(loser).nInternalUnits] = reorderESNMinor_ext(esnMinor(loser,:),esnMajor(loser));
            
            %mutate nodes
            if round(rand) && ~config.multiActiv  && config.alt_node_size
                for p = randi([1 10])
                    if rand < config.numMutate
                        [esnMinor,esnMajor] = mutateLoser_nodes(esnMinor,esnMajor,loser,i,config.maxMinorUnits);
                    end
                end
            end
            
            %mutate scales and hyperparameters
            if rand < config.numMutate
                [esnMinor,esnMajor] = mutateLoser_hyper_init(esnMinor,esnMajor,loser,i);
                
                if config.multiActiv
                    actNum = randperm(length(esnMajor(loser).reservoirActivationFunction),length(esnMajor(loser).reservoirActivationFunction)*config.numMutate); 
                    activPositions = randi(length(config.activList),1,length(esnMajor(loser).reservoirActivationFunction)*config.numMutate);
                    for act = 1:length(actNum)
                        esnMajor(loser).reservoirActivationFunction{i,act} = config.activList(activPositions(act))';
                    end
                end
            end
            
            %mutate weights
            for j = 1:esnMinor(loser,i).nInternalUnits
                if rand < config.numMutate
                    [esnMinor,esnMajor] = mutateLoser_weights(esnMinor,esnMajor,loser,i);
                end
            end 
        end
        
        %% Evaluate and update fitness
        storeError(tests,gen,:) = storeError(tests,gen-1,:);
        
        [~, kernel_rank(loser), gen_rank(loser)] = DeepRes_KQ_GR_LE(esnMajor(loser),esnMinor(loser,:),config.resType,[1 1 0]);
        MC(loser) = DeepResMemoryTest(esnMajor(loser),esnMinor(loser,:),config.resType);
           
        % Store behaviours   
        pop_metrics = [kernel_rank;gen_rank;MC]'; %abs() used but can be removed
        
        % all metrics for later use
        pop_metrics_ext = [kernel_rank;gen_rank;kernel_rank-gen_rank;abs(kernel_rank-gen_rank);MC]';
        
        dist = findKNN([archive; pop_metrics],pop_metrics(loser,:),config.k_neighbours);
        
        % add to search archive
        database = [database; pop_metrics(loser,:)];
        database_ext = [database_ext; pop_metrics_ext(loser,:)]; % extended database for learning phase
        
        database_esnMinor = [database_esnMinor; esnMinor(loser,:)];
        database_esnMajor = [database_esnMajor esnMajor(loser)];
            
        %add to fitness archive
        if  dist > config.p_min || rand < 0.001 %storeError(tests,eval,loser)
            archive = [archive; pop_metrics(loser,:)];
            archive_esnMinor = [archive_esnMinor; esnMinor(loser,:)];
            archive_esnMajor = [archive_esnMajor esnMajor(loser)];
            cnt_change(gen) = 1;
            cnt_no_change(gen) = 0;
        else
            cnt_no_change(gen) = 1;
            cnt_change(gen) = 0;            
        end
        
        %dynamically adapt p_min -- minimum novelty threshold
        if gen > config.p_min_check+1
            if sum(cnt_no_change(gen-config.p_min_check:gen)) > config.p_min_check-1 %not changing enough
                config.p_min = config.p_min - config.p_min*0.05;%minus 5%
                cnt_no_change(gen-config.p_min_check:gen) = zeros;%reset
            end
            if sum(cnt_change(gen-config.p_min_check:gen)) > 10 %too frequent
                config.p_min = config.p_min + config.p_min*0.1; %plus 20%
                cnt_change(gen-config.p_min_check:gen) = zeros; %reset                
            end
        end
        
        % print info
        if (mod(gen,config.genPrint) == 0)
            fprintf('Gen %d, time taken: %.4f sec(s)\n Winner is %d, Loser is %d \n',gen,toc/config.genPrint,winner,loser);
            fprintf('Length of archive: %d, p_min; %d \n',length(archive), config.p_min);
            tic;
            plotSearch(figure1,archive,database,gen)
        end
    
    
       if mod(gen,config.saveGen) == 0
            %% ------------------------------ Save data -----------------------------------------------------------------------------------
            stats_novelty_KQ(tests,config.paramIndx,:) = [iqr(database(:,1)),mad(database(:,1)),range(database(:,1)),std(database(:,1)),var(database(:,1))];
            stats_novelty_MC(tests,config.paramIndx,:) = [iqr(database(:,2)),mad(database(:,2)),range(database(:,2)),std(database(:,2)),var(database(:,2))];
            
            total_space_covered(tests,config.paramIndx) = measureSearchSpace(database,config.maxMinorUnits*config.maxMajorUnits);
            
            all_databases{tests,config.paramIndx} = database;
            config.paramIndx = config.paramIndx+1;
            
            save(strcat('noveltySearch_3D_run',num2str(tests),'_gens',num2str(config.totalGens),'_',num2str(config.maxMajorUnits),'Nres_',num2str(config.maxMinorUnits),'_nSize.mat'),...
        'all_databases','database_ext','config','stats_novelty_KQ','stats_novelty_MC','total_space_covered','-v7.3');
    
       end
    end
    
    %prune size of archive to essentials, so matlab can save the file
    %archive_esnMinor = rmfield(archive_esnMinor,'outputWeights');
    archive_esnMinor = rmfield(archive_esnMinor,'internalWeights_UnitSR');
    archive_esnMinor = rmfield(archive_esnMinor,'internalWeights');
    
    database_esnMinor = rmfield(database_esnMinor,'internalWeights_UnitSR');
    database_esnMinor = rmfield(database_esnMinor,'internalWeights');
    save(strcat('noveltySearch_3D_run',num2str(tests),'_gens',num2str(config.totalGens),'_',num2str(config.maxMajorUnits),'Nres_',num2str(config.maxMinorUnits),'_nSize.mat'),...
        'total_space_covered','all_databases','database_ext','database_esnMajor','database_esnMinor','config','stats_novelty_KQ','stats_novelty_MC','-v7.3');
    
    config.endTime = toc(config.startTime);
end
 

%% fitness function
function [avg_dist] = findKNN(metrics,Y,k_neighbours)
[~,D] = knnsearch(metrics,Y,'K',k_neighbours);
avg_dist = mean(D);
end

function plotSearch(figureHandle,archive,database, gen)

%figure(figureHandle)
set(0,'CurrentFigure',figureHandle);
subplot(1,2,1)
scatter3(archive(:,1),archive(:,2),archive(:,3),20,1:length(archive),'filled')
title(strcat('Gen:',num2str(gen)))
xlabel('KR')
ylabel('GR')
zlabel('MC')
colormap('copper')
title('Fitness Archive')

subplot(1,2,2)
scatter3(database(:,1),database(:,2),database(:,3),20,1:length(database),'filled')
title(strcat('Gen:',num2str(gen)))
xlabel('KR')
ylabel('GR')
zlabel('MC')
colormap('copper')
title('Database')

drawnow
end