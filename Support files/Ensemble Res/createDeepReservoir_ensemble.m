function[esnMajor, esnMinor]=createDeepReservoir_ensemble(trainInputSequence,trainOutputSequence,numRes,maxMinorUnits,maxMajorUnits,startFull,mutateActiv)

if nargin < 6
    startFull = 0;
end
if nargin < 7
    mutateActiv = 0;
end
    
%% Reservoir Parameters
for res = 1:numRes
    % Assign neuron/model type (options: 'plain' and 'leaky', so far... 'feedback', 'multinetwork', 'LeakyBias')
    %esnMajor(res).type = ''; %blank is standard sigmoid, subSample is only use a number of neuron states
    esnMajor(res).trainingType = 'Ridge'; %blank is psuedoinverse. Other options: Ridge, Bias,RLS
    %esnMajor(res).multiOut = ''; %default = normal network, '1' = 3rd network, '2' = 2nd & 3rd network, '3' = all networks
    esnMajor(res).AddInputStates = 1;
    esnMajor(res).regParam = 10e-5;
    esnMajor(res).range = 2;
    esnMajor(res).inputShift = 1;
    
    if startFull
        minMajorUnits = maxMajorUnits; %maxMinorUnits = 100;
        minMinorUnits = maxMinorUnits;
    else
        minMajorUnits = 1;
        minMinorUnits = 2;
    end
    
    esnMajor(res).nInternalUnits = randi([minMajorUnits maxMajorUnits]);
    
    %assign different activations, if necessary
    for n = 1:esnMajor(res).nInternalUnits
        if mutateActiv
            activList = {'ReLU';'tanh';'softplus';'logistic'};%;'linearNode'
            tempActiv = char(activList(randi([1 length(activList)])));
            esnMajor(res).reservoirActivationFunction{n} = tempActiv;
        else
            esnMajor(res).reservoirActivationFunction = 'tanh';
            break
        end     
    end
    
    
    esnMajor(res).nInputUnits = size(trainInputSequence,2);
    esnMajor(res).nOutputUnits = size(trainOutputSequence,2);
    
    % rand number of inner ESN's
    for i = 1: esnMajor(res).nInternalUnits
        
        %define num of units
        esnMinor(res,i).nInternalUnits = randi([minMinorUnits maxMinorUnits]);
        %store(i) = esnMinor(res,i).nInternalUnits;
        
        % Scaling
        esnMinor(res,i).spectralRadius = 2*rand; %alters network dynamics and memory, SR < 1 in almost all cases
        esnMinor(res,i).inputScaling = 2*rand-1; %increases nonlinearity
        esnMinor(res,i).inputShift = 1; %adds bias/value shift to input signal
        esnMinor(res,i).leakRate = rand;
        
        %weights
        %esnMinor(res,i).inputWeights = (2.0 * rand(esnMinor(res,i).nInternalUnits, esnMajor(res).nInputUnits+1)- 1.0);%*esn.inputScaling;
        esnMinor(res,i).inputWeights = 2*sprand(esnMinor(res,i).nInternalUnits, esnMajor(res).nInputUnits+1, 0.8)-1; %1/esnMinor(res,i).nInternalUnits
        
        %initialise new reservoir
        %esnMinor(res,i).connectRatio = round(rand*10)*10;
        esnMinor(res,i).connectivity = 10/esnMinor(res,i).nInternalUnits; %max([10/esnMinor(res,i).nInternalUnits rand]);%min([10/esnMinor(res,i).nInternalUnits 1]);
        esnMinor(res,i).internalWeights_UnitSR = generate_internal_weights(esnMinor(res,i).nInternalUnits, ...
            esnMinor(res,i).connectivity);
        %esnMinor(res,i).rho = esnMinor(res,i).internalWeights_UnitSR;%/max(abs(eigs(esnMinor(res,i).internalWeights_UnitSR)));
        esnMinor(res,i).internalWeights = esnMinor(res,i).spectralRadius * esnMinor(res,i).internalWeights_UnitSR;
        esnMinor(res,i).outputWeights = zeros(esnMajor(res).nOutputUnits, esnMinor(res,i).nInternalUnits + esnMajor(res).nInputUnits);
            
    end
    
    %% connectivity to other reservoirs
    for i= 1:esnMajor(res).nInternalUnits
        for j= 1:esnMajor(res).nInternalUnits
            if i==j %new
                esnMajor(res).connectWeights{i,j} = esnMinor(res,i).internalWeights;
            else
                esnMajor(res).connectWeights{i,j} =  0;
                esnMajor(res).connectWeights{j,i} = 0;
            end
        end        
    end

end 