function genotype =createDeepReservoir_ensemble(config)

%% Reservoir Parameters
for res = 1:config.popSize
    % Assign neuron/model type (options: 'plain' and 'leaky', so far... 'feedback', 'multinetwork', 'LeakyBias')
    genotype(res).inputShift = 1;
    
    if config.startFull
        config.minMajorUnits = config.maxMajorUnits; %maxMinorUnits = 100;
        config.minMinorUnits = config.maxMinorUnits;
    else
        config.minMajorUnits = 1;
        config.minMinorUnits = 2;
    end
    
    genotype(res).nInternalUnits = randi([config.minMajorUnits config.maxMajorUnits]);
    
    if isempty(config.trainInputSequence)
        genotype(res).nInputUnits = 1;
        genotype(res).nOutputUnits = 1;
    else
        genotype(res).nInputUnits = size(config.trainInputSequence,2);
        genotype(res).nOutputUnits = size(config.trainOutputSequence,2);
    end
    
    % rand number of inner ESN's
    for i = 1:  genotype(res).nInternalUnits
        
        %define num of units
        genotype.esnMinor(i).nInternalUnits = randi([config.minMinorUnits config.maxMinorUnits]);
        %store(i) = genotype.esnMinor(i).nInternalUnits;
        
        % Scaling
        genotype.esnMinor(i).spectralRadius = 2*rand; %alters network dynamics and memory, SR < 1 in almost all cases
        genotype.esnMinor(i).inputScaling = 2*rand-1; %increases nonlinearity
        genotype.esnMinor(i).inputShift = 1; %adds bias/value shift to input signal
        genotype.esnMinor(i).leakRate = rand;
        
        %weights
        %genotype.esnMinor(res,i).inputWeights = (2.0 * rand(genotype.esnMinor(res,i).nInternalUnits,  genotype(res).nInputUnits+1)- 1.0);%*esn.inputScaling;
        genotype.esnMinor(i).inputWeights = 2*sprand(genotype.esnMinor(res,i).nInternalUnits,  genotype(res).nInputUnits+1, 0.8)-1; %1/genotype.esnMinor(res,i).nInternalUnits
        
        %initialise new reservoir
        %genotype.esnMinor(res,i).connectRatio = round(rand*10)*10;
        genotype.esnMinor(i).connectivity = 10/genotype.esnMinor(res,i).nInternalUnits; %max([10/genotype.esnMinor(res,i).nInternalUnits rand]);%min([10/genotype.esnMinor(res,i).nInternalUnits 1]);
        genotype.esnMinor(i).internalWeights_UnitSR = generate_internal_weights(genotype.esnMinor(i).nInternalUnits, ...
            genotype.esnMinor(i).connectivity);
        %genotype.esnMinor(res,i).rho = genotype.esnMinor(i).internalWeights_UnitSR;%/max(abs(eigs(genotype.esnMinor(res,i).internalWeights_UnitSR)));
        genotype.esnMinor(i).internalWeights = genotype.esnMinor(i).spectralRadius * genotype.esnMinor(i).internalWeights_UnitSR;
        genotype.esnMinor(i).outputWeights = zeros( genotype(res).nOutputUnits, genotype.esnMinor(i).nInternalUnits +  genotype(res).nInputUnits);
        
        if config.multiActiv
            activPositions = randi(length(config.ActivList),1,genotype(res).esnMinor(i).nInternalUnits);
            for act = 1:length(activPositions)
                genotype(res).reservoirActivationFunction{i,act} = config.ActivList{activPositions(act)};
            end
        else
            genotype(res).reservoirActivationFunction = 'tanh';
            
        end
    end
    
    %% connectivity to other reservoirs
    for i= 1: genotype(res).nInternalUnits
        for j= 1: genotype(res).nInternalUnits
            
            genotype(res).InnerConnectivity = 1;
            val = (2*rand-1);%/10;
            genotype(res).interResScaling{i,j} = val;
            
            if i==j %new
                genotype(res).connectWeights{i,j} = genotype.esnMinor(i).internalWeights;
                genotype(res).interResScaling{i,j} = 1;
            else
                genotype(res).connectWeights{i,j} =  0;
                genotype(res).connectWeights{j,i} = 0;
            end
        end
    end
    
end