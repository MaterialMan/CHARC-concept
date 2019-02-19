function genotype = mutateDL(genotype,config)

% w_in
M = genotype.M(:);
pos =  randi([1 length(M)],round(config.mutRate*length(M)),1);
M(pos) = 2*rand(length(pos),1)-1;
genotype.M = reshape(M,size(genotype.M));

if rand < config.mutRate
    genotype.nInternalUnits= randi([1 config.maxMinorUnits]);
    genotype.theta = genotype.nInternalUnits;
    genotype.M = 2*rand(genotype.nInternalUnits,genotype.nInputUnits)-1;
end


if rand < config.mutRate
    genotype.Wscaling = 2*rand;
end
if rand < config.mutRate%alters network dynamics and memory, SR < 1 in almost all cases
    genotype.inputScaling = 2*rand-1;
end
if rand < config.mutRate%increases nonlinearity
    genotype.inputShift = 2*rand-1;
end
if rand < config.mutRate%adds bias/value shift to input signal
    genotype.leakRate = rand;
end


if config.evolveOutputWeights
    outputWeights = genotype.outputWeights(:);
    pos =  randi([1 length(outputWeights)],round(config.mutRate*length(outputWeights)),1);
    outputWeights(pos) = 2*rand(length(pos),1)-1;
    genotype.outputWeights = reshape(outputWeights,size(genotype.outputWeights));
end

end
