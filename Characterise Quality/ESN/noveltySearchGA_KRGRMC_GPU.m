%% Novelty Search using metrics
% Author: M. Dale
% Date: 22/03/18

clearvars -except config 
rng(1,'twister');

% type of network to evolve
config.resType = 'RoR_IA'; % can use different hierarchical reservoirs. RoR_IA is default ESN.
config.maxMinorUnits=200; %num of nodes in subreservoirs
config.maxMajorUnits=1; % num of subreservoirs. Default ESN should be 1.

%Evolutionary parameters
config.numTests = 10; %num of runs
config.popSize =200; %large pop better
config.totalGens = 2000; %num of gens
config.numMutate = 0.2; 
config.deme = round(config.popSize*0.2); %sub-species increase diversity
config.recRate = 1; 

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
config.p_min_check =200; % change novelty threshold dynamically after "p_min_check" gens.

% general params
config.genPrint = 10; % gens to display achive and database
config.startTime = datestr(now, 'HH:MM:SS');
figure1 =figure;
config.saveGen = 200;

config.numCores = 4;
config.startClk = tic;
config.cnt_seed =1;
config.startTime = datetime;

%% RUn MicroGA
for tests = 1:config.numTests
    
     clearvars -except config tests storeError figure1 stats_novelty_KQ stats_novelty_MC all_databases total_space_covered...
           
    fprintf('\n Test: %d  ',tests);
    fprintf('Processing genotype......... %s \n',datestr(now, 'HH:MM:SS'))
    tic 
    
    rng(tests,'twister');
    
    config.paramIndx = 1; %record database; start from 1
    
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
    parfor popEval = 1:config.popSize
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
        pop_metrics = [kernel_rank;gen_rank;MC]';
        
        parfor p = 1:config.numCores
            
            scurr = rng;
            temp_seed = scurr.Seed;
            rng(config.cnt_seed+p,'twister');
            
            [winner(p), loser(p)] = selection(config,pop_metrics,archive,gen+p);
            
            %% Infection phase
            [temp_metrics(p,:),dist(p),temp_esnMajor(p),temp_esnMinor(p,:)] = getOffspring(esnMinor(loser(p),:),esnMajor(loser(p)),esnMinor(winner(p),:),esnMajor(winner(p)),config,archive);
        
            rng(temp_seed,'twister');
        end
        
        config.cnt_seed = config.cnt_seed+5;
        
        %if there is no conflicts replace all losers
        U = unique(loser);
        loser_test = U(1<histc(loser,unique(loser)));
            
        if isempty(loser_test)
            %add all losers
            for i = 1:config.numCores
                esnMinor(loser(i),:) = temp_esnMinor(i,:);
                esnMajor(loser(i)) = temp_esnMajor(i);

                % add to search archive
                database = [database; temp_metrics(i,:)];
                
                database_esnMinor = [database_esnMinor; temp_esnMinor(i,:)];
                database_esnMajor = [database_esnMajor temp_esnMajor(i)];
                
                %add to fitness archive
                if  dist(i) > config.p_min || rand < 0.001 %storeError(tests,eval,loser)
                    archive = [archive; temp_metrics(i,:)];
                    archive_esnMinor = [archive_esnMinor; temp_esnMinor(i,:)];
                    archive_esnMajor = [archive_esnMajor temp_esnMajor(i)];
                    cnt_change(gen) = 1;
                    cnt_no_change(gen) = 0;
                else
                    cnt_no_change(gen) = 1;
                    cnt_change(gen) = 0;
                end
                
            end
            
        else
            
            %check list 
            checkedIndvs = ones(1,config.numCores);
            
            %compare offspring
            for j = 1:size(loser_test,2)
                checkLoser(j,:) = loser == loser_test(j);
                
                indvs_num = 1:config.numCores;
                indvs = indvs_num(checkLoser(j,:));
                [wLdist,wL] = max(dist(checkLoser(j,:)));
                
                esnMinor(loser(indvs(wL)),:) = temp_esnMinor(indvs(wL),:);
                esnMajor(loser(indvs(wL))) = temp_esnMajor(indvs(wL));
                
                % add to search archive
                database = [database; temp_metrics(indvs(wL),:)];
                
                database_esnMinor = [database_esnMinor; temp_esnMinor(indvs(wL),:)];
                database_esnMajor = [database_esnMajor temp_esnMajor(indvs(wL))];
                
                %add to fitness archive
                if  dist(indvs(wL)) > config.p_min || rand < 0.001 %storeError(tests,eval,loser)
                    archive = [archive; temp_metrics(indvs(wL),:)];
                    archive_esnMinor = [archive_esnMinor; temp_esnMinor(indvs(wL),:)];
                    archive_esnMajor = [archive_esnMajor temp_esnMajor(indvs(wL))];
                    cnt_change(gen) = 1;
                    cnt_no_change(gen) = 0;
                else
                    cnt_no_change(gen) = 1;
                    cnt_change(gen) = 0;
                end
                
                checkedIndvs(indvs) = zeros;
            end
            
            %check if any haven't been checked
            if sum(checkedIndvs) > 1
                % indv to check
                toCheck = indvs_num(logical(checkedIndvs));
                %run through others
                for i = 1:length(toCheck)
                    esnMinor(loser(toCheck(i)),:) = temp_esnMinor(toCheck(i),:);
                    esnMajor(loser(toCheck(i))) = temp_esnMajor(toCheck(i));
                    
                    % add to search archive
                    database = [database; temp_metrics(toCheck(i),:)];
                    
                    database_esnMinor = [database_esnMinor; temp_esnMinor(toCheck(i),:)];
                    database_esnMajor = [database_esnMajor temp_esnMajor(toCheck(i))];
                    
                    %add to fitness archive
                    if  dist(i) > config.p_min || rand < 0.001 %storeError(tests,eval,loser)
                        archive = [archive; temp_metrics(toCheck(i),:)];
                        archive_esnMinor = [archive_esnMinor; temp_esnMinor(toCheck(i),:)];
                        archive_esnMajor = [archive_esnMajor temp_esnMajor(toCheck(i))];
                        cnt_change(gen) = 1;
                        cnt_no_change(gen) = 0;
                    else
                        cnt_no_change(gen) = 1;
                        cnt_change(gen) = 0;
                    end
                    
                end
                                
            end
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
            fprintf('Gen %d, time taken: %.4f sec(s)\n Winner and Loser: \n',gen,toc/config.genPrint);
            disp(winner);
            disp(loser);
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
            
            save(strcat('noveltySearch_3D_run_GPU_',num2str(tests),'_gens',num2str(config.totalGens),'_',num2str(config.maxMajorUnits),'Nres_',num2str(config.maxMinorUnits),'_nSize.mat'),...
        'all_databases','database_ext','config','stats_novelty_KQ','stats_novelty_MC','total_space_covered','-v7.3');
    
       end
    end
    
    %prune size of archive to essentials, so matlab can save the file
    %archive_esnMinor = rmfield(archive_esnMinor,'outputWeights');
    archive_esnMinor = rmfield(archive_esnMinor,'internalWeights_UnitSR');
    archive_esnMinor = rmfield(archive_esnMinor,'internalWeights');
    
    database_esnMinor = rmfield(database_esnMinor,'internalWeights_UnitSR');
    database_esnMinor = rmfield(database_esnMinor,'internalWeights');
    save(strcat('noveltySearch_3D_run_GPU_',num2str(tests),'_gens',num2str(config.totalGens),'_',num2str(config.maxMajorUnits),'Nres_',num2str(config.maxMinorUnits),'_nSize.mat'),...
        'total_space_covered','all_databases','database_ext','database_esnMajor','database_esnMinor','config','stats_novelty_KQ','stats_novelty_MC','-v7.3');
   
    config.endClk = toc(config.startClk); 
    config.endTime = datetime;
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