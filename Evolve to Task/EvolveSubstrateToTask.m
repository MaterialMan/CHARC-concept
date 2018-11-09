%% Evolve Substrate for specific task
% Notes: Added extra flexibility. Can now evolve heirarchical networks and
% graph networks with defined structures.

% Author: M. Dale
% Date: 08/11/18

clear
rng(1,'twister');

%% Setup
% type of network to evolve
config.resType = 'RoR_IA';                   % can use different hierarchical reservoirs. RoR_IA is default ESN.
config.maxMinorUnits = 10;                   % num of nodes in subreservoirs
config.maxMajorUnits = 4;                   % num of subreservoirs. Default ESN should be 1.
config = selectReservoirType(config);       % get correct functions for type of reservoir

%% Network details
config.startFull = 1;                       % start with max network size
config.alt_node_size = 0;                   % allow different network sizes
config.multiActiv = 0;                      % use different activation funcs
config.leakOn = 1;                          % add leak states
config.rand_connect =1;                     % radnomise networks
config.activList = {'tanh';'linearNode'};   % what activations are in use when multiActiv = 1
config.trainingType = 'Ridge';              % blank is psuedoinverse. Other options: Ridge, Bias,RLS
config.AddInputStates = 1;                  % add input to states
config.regParam = 10e-5;                    % training regulariser
config.sparseInputWeights = 0;              % use sparse inputs

%% Graph params
if strcmp(config.resType,'Graph')
    
    config.substrate= 'Lattice';            % Define substrate
    % Examples: 'Lattice', 'Hypercube', 'Torus','L-shape','Bucky','Barbell'
    config.NGrid = config.maxMinorUnits;    % Number of nodes
    config.num_ensemble = 3;                % number of lattices
    
    % substrate params
    config.N_rings = 0;                     % used with Torus
    config.latticeType = 'fullCube';        % see creatLattice.m for different types.
    % Examples: 'basicLattice','partialLattice','fullLattice','basicCube','partialCube','fullCube',
    
    % node details and connectivity
    config.actvFunc = 'tanh';               % decide activation fcn of node.
    config.plotStates = 0;                  % plot states in real-time.
    config.nearest_neighbour = 0;           % choose radius of nearest neighbour, or set to 0 for direct neighbour.
    config.directedGraph = 0;               % directed graph (i.e. weight for all directions).
    config.self_loop = 0;                   % give node a loop to self.
    config.inputEval = 0;                   % add input directly to node, otherwise node takes inputs value.
    config = getShape(config);              % call function to make graph.
    config.plot3d = 0;                      % plot graph in 3D.
    config.globalParams = 1;                % add global scaling parameters and leakrate
end

%% Evolutionary parameters
config.numTests = 1;                        % num of runs
config.popSize = 20;                       % large pop better
config.totalGens = 1000;                    % num of gens
config.mutRate = 0.1;                       % mutation rate
config.deme_percent = 0.2;                  % speciation percentage
config.deme = round(config.popSize*config.deme_percent);
config.recRate = 0.5;                       % recombination rate
config.evolveOutputWeights = 1;             % evolve rather than train

%% Task parameters
config.dataSet = 'poleBalance';                 % Task to evolve for
[config.trainInputSequence,config.trainOutputSequence,config.valInputSequence,config.valOutputSequence,...
    config.testInputSequence,config.testOutputSequence,config.nForgetPoints,config.errType,config.queueType] = selectDataset(config.dataSet);

[config,figure3,figure4] = getDataSetInfo(config);

%% general params
config.genPrint = 10;                       % gens to display achive and database
config.startTime = datestr(now, 'HH:MM:SS');
figure1 =figure;
config.saveGen = 25;                        % save at gen = saveGen
config.parallel = 0;                        % use parallel toolbox
config.multiOffspring = 0;                  % multiple tournament selection and offspring in one cycle
config.numSyncOffspring = config.deme;      % length of cycle/synchronisation step
config.use_metric =[1 1 0];                 %metrics to use = [KR GR LE]

%% RUn MicroGA
for test = 1:config.numTests
    
    clearvars -except config test storeError figure1 figure3 figure4
    
    fprintf('\n Test: %d  ',test);
    fprintf('Processing genotype......... %s \n',datestr(now, 'HH:MM:SS'))
    tic
    
    rng(test,'twister');
    
    genotype = config.createFcn(config);
    
    %Assess Genotype
    if config.parallel
        parfor popEval = 1:config.popSize
            genotype(popEval) = config.testFcn(genotype(popEval),config);
            fprintf('\n i = %d, error = %.4f\n',popEval,genotype(popEval).testError);
        end
    else
        for popEval = 1:config.popSize
            genotype(popEval) = config.testFcn(genotype(popEval),config);
            fprintf('\n i = %d, error = %.4f\n',popEval,genotype(popEval).testError);
        end
    end
    
    [best_error,best] = min([genotype.valError]);
    fprintf('\n Starting loop... Best error = %.4f\n',best_error);
    
    storeError(test,1,:) = [genotype.valError];
    
    for gen = 2:config.totalGens
        
        rng(gen,'twister');
        
        cmpError = reshape(storeError(test,gen-1,:),1,size(storeError,3));
        
        % Num of ofspring to evolve
        if config.multiOffspring
            %scurr = rng;
            %temp_seed = scurr.Seed;
            parfor p = 1:config.numSyncOffspring
                %rng(temp_seed+p,'twister');
                
                % Tournment selection - pick two individuals
                equal = 1;
                while(equal)
                    indv_1 = randi([1 config.popSize]);
                    indv_2 = indv_1+randi([1 config.deme]);
                    if indv_2 > config.popSize
                        indv_2 = indv_2- config.popSize;
                    end
                    if indv_1 ~= indv_2
                        equal = 0;
                    end
                end
                
                % Assess fitness of both and assign winner/loser - highest score
                % wins
                if cmpError(indv_1) < cmpError(indv_2)
                    w=indv_1; l(p) = indv_2;
                else
                    w=indv_2; l(p) = indv_1;
                end
                
                %% Infection phase
                parLoser{p} = config.recFcn(genotype(w),genotype(l(p)),config);
                parLoser{p} = config.mutFcn(parLoser{p},config);
                
                %% Evaluate and update fitness
                parLoser{p} = config.testFcn(parLoser{p},config);
            end
            
            [U,ia,ic]  = unique(l);                                  % find unique losers
            genotype(l(ia)) = [parLoser{ia}];                        % replace losers (does not replace replicates) 
            
            %update errors
            storeError(test,gen,:) =  storeError(test,gen-1,:);
            storeError(test,gen,l(ia)) = [genotype(l(ia)).valError];
            
            % print info
            if (mod(gen,config.genPrint) == 0)
                [best,best_indv] = min(storeError(test,gen,:));
                fprintf('Gen %d, time taken: %.4f sec(s)\n Best Error: %.4f \n',gen,toc/config.genPrint,best);
                tic;
                
                if strcmp(config.resType,'Graph')
                    plotGridNeuron(figure1,genotype,storeError,test,best_indv,l(1),config)
                end
                
                if strcmp(config.dataSet,'autoencoder')
                    plotAEWeights(figure3,figure4,config.testInputSequence,genotype(best_indv),config)
                end
            end
            
        else
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
            
            % Assess fitness of both and assign winner/loser - highest score
            % wins
            if cmpError(indv1) < cmpError(indv2)
                winner=indv1; loser = indv2;
            else
                winner=indv2; loser = indv1;
            end
            
            genotype(loser) = config.recFcn(genotype(winner),genotype(loser),config);
            genotype(loser) = config.mutFcn(genotype(loser),config);
            
            %% Evaluate and update fitness
            genotype(loser) = config.testFcn(genotype(loser),config);
            
            %update errors
            storeError(test,gen,:) =  storeError(test,gen-1,:);
            storeError(test,gen,loser) = genotype(loser).valError;
            
            % print info
            if (mod(gen,config.genPrint) == 0)
                [best,best_indv] = min(storeError(test,gen,:));
                fprintf('Gen %d, time taken: %.4f sec(s)\n  Winner: %.4f, Loser: %.4f, Best Error: %.4f \n',gen,toc/config.genPrint,genotype(winner).valError,genotype(loser).valError,best);
                tic;
                if strcmp(config.resType,'Graph')
                    plotGridNeuron(figure1,genotype,storeError,test,best_indv,loser,config)
                end
                
                if strcmp(config.dataSet,'autoencoder')
                    plotAEWeights(figure3,figure4,config.testInputSequence,genotype(best_indv),config)
                end
            end
        end
        
        if mod(gen,config.saveGen) == 0
            %% ------------------------------ Save data -----------------------------------------------------------------------------------
            if strcmp(config.resType,'Graph')
                save(strcat('Task_',config.dataSet,'_substrate_',config.substrate,'_run',num2str(test),'_gens',num2str(config.totalGens),'_Nres_',num2str(config.N),'_directed',num2str(config.directedGraph),'_self',num2str(config.self_loop),'_nSize.mat'),...
                    'genotype','config','storeError','-v7.3');
            else
                save(strcat('Task_',config.dataSet,'_substrate_',config.resType,'_run',num2str(test),'_gens',num2str(config.totalGens),'_',num2str(config.maxMajorUnits),'Nres_',num2str(config.maxMinorUnits),'_nSize.mat'),...
                    'genotype','config','storeError','-v7.3');
            end
        end
    end
    
    %get metric details
    parfor popEval = 1:config.popSize
        [~, kernel_rank(test,popEval), gen_rank(test,popEval)] = metricKQGRLE(genotype(popEval),config);
        MC(test,popEval) = metricMemory(genotype(popEval),config);
    end
    
end

function plotGridNeuron(figure1,genotype,storeError,test,best_indv,loser,config)

set(0,'currentFigure',figure1)
subplot(2,2,[1 2])
imagesc(reshape(storeError(test,:,:),size(storeError,2),size(storeError,3)))
set(gca,'YDir','normal')
colormap(bluewhitered)
colorbar
ylabel('Generations')
xlabel('Individual')


subplot(2,2,3)
if config.plot3d
    p = plot(genotype(best_indv).G,'NodeLabel',{},'Layout','force3');
else
    p = plot(genotype(best_indv).G,'NodeLabel',{},'Layout','force');
end
p.NodeColor = 'black';
p.MarkerSize = 1;
if ~config.directedGraph
    p.EdgeCData = genotype(best_indv).G.Edges.Weight;
end
highlight(p,logical(genotype(best_indv).input_loc),'NodeColor','g','MarkerSize',3)
colormap(bluewhitered)
xlabel('Best weights')

subplot(2,2,4)
if config.plot3d
    p = plot(genotype(loser).G,'NodeLabel',{},'Layout','force3');
else
    p = plot(genotype(loser).G,'NodeLabel',{},'Layout','force');
end
if ~config.directedGraph
    p.EdgeCData = genotype(loser).G.Edges.Weight;
end
p.NodeColor = 'black';
p.MarkerSize = 1;
highlight(p,logical(genotype(loser).input_loc),'NodeColor','g','MarkerSize',3)
colormap(bluewhitered)
xlabel('Loser weights')

pause(0.01)
drawnow
end
