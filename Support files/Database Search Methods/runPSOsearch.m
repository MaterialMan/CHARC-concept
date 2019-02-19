%% set parameters for tasks
config.leakOn = 1;                          % add leak states
config.AddInputStates = 1;                  % add input to states
config.regParam = 10e-5;                    % training regulariser
config.sparseInputWeights = 0;              % use sparse inputs
config.restricedWeight = 0;                  % restrict weights between [0.2 0.4. 0.6 0.8 1]
config.evolvedOutputStates = 0;             % sub-sample the states to produce output (is evolved)
config.evolveOutputWeights = 0;             % evolve rather than train

config.discrete = 0;               % binary input for discrete systems
config.nbits = 16;                       % if using binary/discrete systems 
config.preprocess = 1;                   % basic preprocessing, e.g. scaling and mean variance


%% get task errors for all in the database - needed for random search
%task_error = assessDBonTasks(config,database_genotype,database);

%% PSO and parameters 
config.swarm_size  = 20;
config.maxStall = 10;
config.maxIter =10;

config.InertiaRange = [0.3, 0.3];
config.SelfAdjustmentWeight = 1.49;
config.SocialAdjustmentWeight = 1.49;
config.MinNeigh = 1;
    
[final_error, final_metrics,output] =  psoOnDatabase(config,database,database_genotype);

%% Equivalent random search
num_rand = config.swarm_size*config.maxIter;
indx = randi([1 length(database)],num_rand,1);
rand_search = task_error.outputs(indx);
best_rand = min(rand_search)