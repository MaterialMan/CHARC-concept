function [pop_metrics,dist, esnMajor,esnMinor] = getOffspring(esnMinor,esnMajor,esnMinor_winner,esnMajor_winner,config,archive)
%% Infection phase
for i = 1:size(esnMinor,2)
    %recombine
    if rand < config.recRate
        esnMinor(i) = esnMinor_winner(i);
        
        if config.multiActiv %transfer activation type as well
            actNum = randperm(length(esnMajor.reservoirActivationFunction),length(esnMajor.reservoirActivationFunction)*config.recRate);
            for act = 1:length(actNum)
                esnMajor.reservoirActivationFunction{i,actNum(act)} = esnMajor_winner.reservoirActivationFunction{i,actNum(act)};
            end
        end
        
        %update esnMajor weights and major internal units
        esnMajor= changeMajorWeights(esnMajor,i,esnMinor);
    end
    
    %Reorder
    [esnMinor, esnMajor.connectWeights,esnMajor.interResScaling, esnMajor.nInternalUnits] = reorderESNMinor_ext(esnMinor,esnMajor);
    
    %mutate nodes
    if round(rand) && ~config.multiActiv && config.alt_node_size
        for p = randi([1 10])
            if rand < config.numMutate
                [esnMinor,esnMajor] = mutateLoser_nodes(esnMinor,esnMajor,1,i,config.maxMinorUnits);
            end
        end
    end
    
    %mutate scales and hyperparameters
    if rand < config.numMutate
        [esnMinor,esnMajor] = mutateLoser_hyper_init(esnMinor,esnMajor,1,i);
        
        if config.multiActiv
            actNum = randperm(length(esnMajor.reservoirActivationFunction),length(esnMajor.reservoirActivationFunction)*config.numMutate);
            activPositions = randi(length(config.activList),1,length(esnMajor.reservoirActivationFunction)*config.numMutate);
            for act = 1:length(actNum)
                esnMajor.reservoirActivationFunction{i,act} = config.activList(activPositions(act))';
            end
        end
    end
    
    %mutate weights
    for j = 1:esnMinor(:,i).nInternalUnits
        if rand < config.numMutate
            [esnMinor,esnMajor] = mutateLoser_weights(esnMinor,esnMajor,1,i);
        end
    end
end

%% Evaluate and update fitness
%storeError(tests,gen,:) = storeError(tests,gen-1,:);
[~, pop_metrics(1), pop_metrics(2)] = DeepRes_KQ_GR_LE(esnMajor,esnMinor,config.resType,[1 1 0]);
pop_metrics(3) = DeepResMemoryTest(esnMajor,esnMinor,config.resType);


dist = findKNN([archive; pop_metrics],pop_metrics,config.k_neighbours);
end

%% fitness function
    function [avg_dist] = findKNN(metrics,Y,k_neighbours)
        [~,D] = knnsearch(metrics,Y,'K',k_neighbours);
        avg_dist = mean(D);
    end