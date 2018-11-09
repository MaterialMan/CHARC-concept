function [config,figure3,figure4] = getDataSetInfo(config)

%% overflow for params that can be changed

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

if strcmp(config.resType,'BZ')
    config.plotBZ =0;
    config.fft = 1;
    config.BZfigure1 = figure;
    config.BZfigure2 = figure;
end

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