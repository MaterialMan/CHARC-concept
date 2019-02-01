%% assess all topologies on tasks
clear
figure

% task details
config.taskList = {'NARMA10'};%,'Laser','NonChanEqRodan'};
config.preprocess =1;
config.discrete = 0;

config.resType = 'Graph';                   % can use different hierarchical reservoirs. RoR_IA is default ESN.
% type of network to evolve
config = selectReservoirType(config);       %get correct functions for type of reservoir

% Network details
config.startFull = 1;                       % start with max network size
config.alt_node_size = 0;                   % allow different network sizes
config.multiActiv = 0;                      % use different activation funcs
config.leakOn = 1;                          % add leak states
config.rand_connect = 1;                    % radnomise networks
config.activList = {'tanh'};   % what activations are in use when multiActiv = 1
config.trainingType = 'Ridge';              % blank is psuedoinverse. Other options: Ridge, Bias,RLS
config.AddInputStates = 1;                  % add input to states
config.regParam = 10e-5;                    % training regulariser
config.use_metric =[1 1 0];                 % metrics to use = [KR GR LE]
config.sparseInputWeights = 0;              % use sparse inputs
config.restricedWeight = 0;                 % restrict weights to defined values
config.nsga2 = 0;
config.evolvedOutputStates = 0;             % if evovled outputs are wanted

% dummy variables
config.trainInputSequence= [];
config.trainOutputSequence =[];
config.dataSet =[];

% get addition params for reservoir type
config.task_num_inputs = size(config.trainInputSequence,2);
config.task_num_outputs = size(config.trainOutputSequence,2);

config.maxMajorUnits = 1;                   % num of subreservoirs. Default ESN should be 1.
config.self_loop = 1;                   % give node a loop to self.
% node details and connectivity
config.actvFunc = 'tanh';               % decide activation fcn of node.
config.plotStates = 0;                  % plot states in real-time.
% config.nearest_neighbour = 0;           % choose radius of nearest neighbour, or set to 0 for direct neighbour.
config.inputEval = 0;                   % add input directly to node, otherwise node takes inputs value.
config.globalParams = 1;                % add global scaling parameters and leakrate
config.num_ensemble = 1;                % number of lattices
config.popSize = 20;                       % large pop better
config.evolveOutputWeights = 0;             % evolve rather than train
config.nearest_neighbour = 0;

%% create ring50u
fprintf('\n Starting ring 50 u...');
config.maxMinorUnits = 50;                   % num of nodes in subreservoirs
config.NGrid = config.maxMinorUnits;    % Number of nodes
config.substrate = 'Ring';            % Define substrate

% %% Directed
config.directedGraph = 0;               % directed graph (i.e. weight for all directions).
config.ruleType =[];
config = getShape(config);

% double check right shape
plot(config.G) 
%fprintf('\n Press return if shape is correct.');
%waitforbuttonpress

% create grpahs
genotype = config.createFcn(config);

% intialise metrics
kernel_rank=[]; gen_rank=[];
rank_diff=[]; MC=[];

% Evaluate population and assess novelty
parfor popEval = 1:config.popSize
    [~, kernel_rank(popEval), gen_rank(popEval)] = metricKQGRLE(genotype(popEval),config);
    MC(popEval) = metricMemory(genotype(popEval),config);
    fprintf('\n indv: %d  ',popEval);
end
archive = [kernel_rank;gen_rank; MC]';

ring50u = assessDBonTasks(config,genotype, archive);

%% create ring50d
fprintf('\n Starting ring 50 d...');
% %% Directed
config.directedGraph = 1;               % directed graph (i.e. weight for all directions).
config = getShape(config);

% create grpahs
genotype = config.createFcn(config);

% double check right shape
plot(config.G) 

% intialise metrics
kernel_rank=[]; gen_rank=[];
rank_diff=[]; MC=[];

% Evaluate population and assess novelty
parfor popEval = 1:config.popSize
    [~, kernel_rank(popEval), gen_rank(popEval)] = metricKQGRLE(genotype(popEval),config);
    MC(popEval) = metricMemory(genotype(popEval),config);
    fprintf('\n indv: %d  ',popEval);
end
archive = [kernel_rank;gen_rank; MC]';
ring50d = assessDBonTasks(config,genotype, archive);

%% create latt49u
fprintf('\n Starting lattice 49 u...');
config.maxMinorUnits = 7;                   % num of nodes in subreservoirs
config.NGrid = config.maxMinorUnits;    % Number of nodes
config.substrate = 'Lattice';            % Define substrate

% substrate params
config.latticeType = 'fullLattice';        % see creatLattice.m for different types.
config.ruleType = config.latticeType;       % used with Torus, 5 neighbours (Von Neumann) or 8 neighbours (Moore's)

% %% undirected
config.directedGraph = 0;               % directed graph (i.e. weight for all directions).
config = getShape(config);

% create grpahs
genotype = config.createFcn(config);

% double check right shape
plot(config.G) 
%fprintf('\n Press return if shape is correct.');
%waitforbuttonpress

% intialise metrics
kernel_rank=[]; gen_rank=[];
rank_diff=[]; MC=[];

% Evaluate population and assess novelty
parfor popEval = 1:config.popSize
    [~, kernel_rank(popEval), gen_rank(popEval)] = metricKQGRLE(genotype(popEval),config);
    MC(popEval) = metricMemory(genotype(popEval),config);
    fprintf('\n indv: %d  ',popEval);
end
archive = [kernel_rank;gen_rank; MC]';

latt49u = assessDBonTasks(config,genotype, archive);
%% create latt49d
fprintf('\n Starting lattice 49 d...');

% %% Directed
config.directedGraph = 1;               % directed graph (i.e. weight for all directions).
config = getShape(config);

% create grpahs
genotype = config.createFcn(config);

% double check right shape
plot(config.G) 

% intialise metrics
kernel_rank=[]; gen_rank=[];
rank_diff=[]; MC=[];

% Evaluate population and assess novelty
parfor popEval = 1:config.popSize
    [~, kernel_rank(popEval), gen_rank(popEval)] = metricKQGRLE(genotype(popEval),config);
    MC(popEval) = metricMemory(genotype(popEval),config);
    fprintf('\n indv: %d  ',popEval);
end
archive = [kernel_rank;gen_rank; MC]';
latt49d = assessDBonTasks(config,genotype, archive);

%% esn 50

config.resType = 'RoR_IA';
config.maxMinorUnits = 50;                   % num of nodes in subreservoirs
config.NGrid = config.maxMinorUnits;    % Number of nodes
config = selectReservoirType(config);       %get correct functions for type of reservoir

genotype = config.createFcn(config);
% intialise metrics
kernel_rank=[]; gen_rank=[];
rank_diff=[]; MC=[];

% Evaluate population and assess novelty
parfor popEval = 1:config.popSize
    [~, kernel_rank(popEval), gen_rank(popEval)] = metricKQGRLE(genotype(popEval),config);
    MC(popEval) = metricMemory(genotype(popEval),config);
    fprintf('\n indv: %d  ',popEval);
end
archive = [kernel_rank;gen_rank; MC]';
esn50 = assessDBonTasks(config,genotype, archive);

%% plot findings

% plot performance
n10 = [ring50u.outputs(:,1) ring50d.outputs(:,1) latt49u.outputs(:,1) latt49d.outputs(:,1) esn50.outputs(:,1)];
%laser = [ring50u.outputs(:,2) ring50d.outputs(:,2) latt49u.outputs(:,2) latt49d.outputs(:,2)];
%nonchan =[ring50u.outputs(:,3) ring50d.outputs(:,3) latt49u.outputs(:,3) latt49d.outputs(:,3)];

figure
boxplot(n10,'Notch','on')
ylim([0 2])

medianN10 = median(n10);
minN10 = min(n10);
stdN10 = std(n10);

figure
for i = 1:4
shortVer{i} = n10(n10(:,i) < 1,i);
boxplot(shortVer{i},i)
hold on
end
hold off

short_data = [shortVer{1}' shortVer{2}' shortVer{3}' shortVer{4}'];
g = [ones(length(shortVer{1}'),1)' ones(length(shortVer{2}'),1)'*2 ones(length(shortVer{3}'),1)'*3 ones(length(shortVer{4}'),1)'*4];
boxplot(short_data,g,'Notch','on')


% tab = [minN10;medianN10;stdN10]
% 
[h(1),p(1)] = ranksum(n10(:,1),n10(:,2)); % dir vs undir (ring)
[h(2),p(2)] = ranksum(n10(:,1),n10(:,3)); % ring and lattice (un)
[h(3),p(3)] = ranksum(n10(:,2),n10(:,4)); % ring and lattice (dir)

p
h
xticklabels({'ring(u)','ring(d)','lattice(u)','lattice(d)'})
ylabel('NMSE')
set(gca,'FontSize',12,'FontName','Arial')

print('benchmarkTask','-dpdf','-bestfit')

% figure
% boxplot(laser,'Notch','on')
% ylim([0 2])
% 
% figure
% boxplot(nonchan,'Notch','on')
% ylim([0 2])