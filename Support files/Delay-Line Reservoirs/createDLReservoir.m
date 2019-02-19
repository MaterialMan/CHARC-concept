function genotype = createDLReservoir(config)

genotype = [];

for i = 1:config.popSize
    
    genotype(i).trainError = 1;
    genotype(i).valError = 1;
    genotype(i).testError = 1;
    genotype(i).inputShift = 1;
    
    genotype(i).nInternalUnits = config.maxMinorUnits;%randi([1 config.maxMinorUnits]);
    genotype(i).nTotalUnits = genotype(i).nInternalUnits; 
    
    if isempty(config.trainInputSequence)
        genotype(i).nInputUnits = 1;
        genotype(i).nOutputUnits = 1;
    else
        genotype(i).nInputUnits = size(config.trainInputSequence,2);
        genotype(i).nOutputUnits = size(config.trainOutputSequence,2);
    end
    
    
    %inputweights
    if config.sparseInputWeights
        inputWeights = sprand(genotype(i).nInternalUnits,genotype(i).nInputUnits, 0.1); %1/genotype.esnMinor(res,i).nInternalUnits
        inputWeights(inputWeights ~= 0) = ...
            2*inputWeights(inputWeights ~= 0)  - 1;
        genotype(i).M = inputWeights;
    else
        genotype(i).M = 2*rand(genotype(i).nInternalUnits,genotype(i).nInputUnits)-1; %1/genotype.esnMinor(res,i).nInternalUnits
    end
    
    genotype(i).Wscaling = 2*rand;                          %alters network dynamics and memory, SR < 1 in almost all cases
    genotype(i).inputScaling = 2*rand-1;                    %increases nonlinearity
    genotype(i).inputShift = 1;                             %adds bias/value shift to input signal
    genotype(i).leakRate = rand;
    
    
    genotype(i).tau = config.tau;
    genotype(i).theta = genotype(i).tau/genotype(i).nInternalUnits; %round(genotype.tau/genotype(i).nInternalUnits);
    genotype(i).reservoirActivationFunction = 'tanh';
    
    genotype(i).outputWeights = zeros(genotype(i).nInternalUnits+genotype(i).nInputUnits,genotype(i).nOutputUnits);
end