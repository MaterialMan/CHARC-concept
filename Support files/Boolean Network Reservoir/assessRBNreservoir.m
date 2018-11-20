function states = assessRBNreservoir(genotype,inputSequence,config)   

node = genotype.node;                       % nodes in RBN
fHandle = genotype.RBNtype;                 % update routine
datalength = size(inputSequence,1);         % data length

inputSequence = round((sign(inputSequence*genotype.w_in')+1)/2);

% evolve network in specified update mode
[~, states] = feval(fHandle,node,datalength,inputSequence,genotype);
states = states(:,2:end)';      

if config.leakOn      
    leakStates = zeros(size(states));
    for n = 2:size(states,1)
        leakStates(n,:) = (1-genotype.leakRate)*leakStates(n-1,:)+ genotype.leakRate*states(n,:);
    end
    states = leakStates;
end

if config.evolvedOutputStates
    states= states(config.nForgetPoints+1:end,logical(genotype.state_loc));
else
    states= states(config.nForgetPoints+1:end,:);
end

if config.AddInputStates
    states = [ones(size(inputSequence(config.nForgetPoints+1:end,1))) inputSequence(config.nForgetPoints+1:end,:) states];
else
    states = [ones(size(inputSequence(config.nForgetPoints+1:end,1))) states];
end
