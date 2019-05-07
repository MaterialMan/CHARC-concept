%% Script to run structured reservoir (graph) tests: Ring topolgy type

% Experiment: Compare ESNs to neuronal graphs with defined structures at different network scales.

% This will provide:
% - a better image of how rigid network structure effects
% performance/quality
% - act as extra substrate to compare framework with and predict
% performances.

% Requirements:
% - match ESN network sizes
% - but also test larger higher graphs

clear
clc

% Move to folder:
cd 'D:\Git\branches\Version_2\Results'

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% Ring topology %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
config.resType = 'Graph';                   % can use different hierarchical reservoirs. RoR_IA is default ESN.
figure1 =figure;
config.maxMajorUnits = 1;                   % num of subreservoirs. Default ESN should be 1.
config.self_loop = 1;                   % give node a loop to self.

config.substrate = 'Ring';            % Define substrate
% Examples: 'Lattice', 'Hypercube',
% 'Torus','L-shape','Bucky','Barbell','Ring'

% substrate params
config.latticeType = 'fullLattice';        % see creatLattice.m for different types.
config.ruleType = config.latticeType;       % used with Torus, 5 neighbours (Von Neumann) or 8 neighbours (Moore's)
% Examples: 'basicLattice','partialLattice','fullLattice','basicCube','partialCube','fullCube',

% node details and connectivity
config.actvFunc = 'tanh';               % decide activation fcn of node.
config.plotStates = 0;                  % plot states in real-time.
config.nearest_neighbour = 0;           % choose radius of nearest neighbour, or set to 0 for direct neighbour.
config.inputEval = 0;                   % add input directly to node, otherwise node takes inputs value.
config.globalParams = 1;                % add global scaling parameters and leakrate
config.num_ensemble = 1;                % number of lattices

%% Evolutionary parameters
config.numTests = 1;                        % num of runs
config.popSize = 200;                       % large pop better
config.totalGens = 2000;                    % num of gens
config.mutRate = 0.2;                       % mutation rate
config.deme_percent = 0.2;                  % speciation percentage
config.deme = round(config.popSize*config.deme_percent);
config.recRate = 1;                       % recombination rate
config.evolveOutputWeights = 0;             % evolve rather than train

% NS parameters
config.k_neighbours = 15;                   % how many neighbours to check
config.p_min = 3;                           % novelty threshold. Start low.
config.p_min_check = 200;                   % change novelty threshold dynamically after "p_min_check" gens.

% general params
config.genPrint = 15;                       % gens to display achive and database
config.startTime = datestr(now, 'HH:MM:SS');

config.saveGen = 200;                        % save at gen = saveGen
config.paramIndx = 1;                       % record database; start from 1

% %% Directed
 config.directedGraph = 1;               % directed graph (i.e. weight for all directions).
% 
% % size = 25
% config.maxMinorUnits = 25;                   % num of nodes in subreservoirs
% config.NGrid = config.maxMinorUnits;    % Number of nodes
% config = getShape(config);
% framework_script_for_ESN_vs_Graph

% % size = 50
config.maxMinorUnits = 50;                   % num of nodes in subreservoirs
config.NGrid = config.maxMinorUnits;    % Number of nodes
config = getShape(config);
framework_script_for_ESN_vs_Graph

% % size = 100
% config.maxMinorUnits = 100;                   % num of nodes in subreservoirs
% config.NGrid = config.maxMinorUnits;    % Number of nodes
% config = getShape(config);
% framework_script_for_ESN_vs_Graph
% 
% % size = 200
% config.maxMinorUnits = 200;                   % num of nodes in subreservoirs
% config.NGrid = config.maxMinorUnits;    % Number of nodes
% config = getShape(config);
% framework_script_for_ESN_vs_Graph
% 
% % size = 400
% config.maxMinorUnits = 400;                   % num of nodes in subreservoirs
% config.NGrid = config.maxMinorUnits;    % Number of nodes
% config = getShape(config);
% framework_script_for_ESN_vs_Graph
% 
% %% Undirected
 config.directedGraph = 0;               % directed graph (i.e. weight for all directions).
% 
% % size = 25
% config.maxMinorUnits = 25;                   % num of nodes in subreservoirs
% config.NGrid = config.maxMinorUnits;    % Number of nodes
% config = getShape(config);
% framework_script_for_ESN_vs_Graph
 
% % size = 50
config.maxMinorUnits = 50;                   % num of nodes in subreservoirs
config.NGrid = config.maxMinorUnits;    % Number of nodes
config = getShape(config);
framework_script_for_ESN_vs_Graph

% % size = 100
% config.maxMinorUnits = 100;                   % num of nodes in subreservoirs
% config.NGrid = config.maxMinorUnits;    % Number of nodes
% config = getShape(config);
% framework_script_for_ESN_vs_Graph
% 
% % size = 200
% config.maxMinorUnits = 200;                   % num of nodes in subreservoirs
% config.NGrid = config.maxMinorUnits;    % Number of nodes
% config = getShape(config);
% framework_script_for_ESN_vs_Graph

% size = 400
% config.maxMinorUnits = 400;                   % num of nodes in subreservoirs
% config.NGrid = config.maxMinorUnits;    % Number of nodes
% config = getShape(config);
% framework_script_for_ESN_vs_Graph