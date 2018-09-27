function[statesExt] = collectEnsembleStates(esnMajor,esnMinor,inputSequence,nForgetPoints)


%% Collect states for plain ESN
for i= 1:esnMajor.nInternalUnits
    states{i} = zeros(size(inputSequence,1),esnMinor(i).nInternalUnits);
    x{i} = zeros(size(inputSequence,1),esnMinor(i).nInternalUnits);
end

%equation: x{i}(n) = f(Win*u(n) + W_ii*x{i}(n-1)), 
for i= 1:esnMajor.nInternalUnits
    temp_states = [];
    for n = 2:length(inputSequence(:,1))
        x{i}(n,:) = (esnMajor.connectWeights{i,i}*states{i}(n-1,:)')'; %x{i}(n,:) +
        states{i}(n,:) = feval(esnMajor.reservoirActivationFunction,((esnMinor(i).inputWeights*esnMinor(i).inputScaling)*([esnMinor(i).inputShift inputSequence(n,:)])')+x{i}(n,:)');
    end
end


for i= 1:esnMajor.nInternalUnits
    leakStates = zeros(size(states{i}));
    for n = 2:length(inputSequence(:,1))
        leakStates(n,:) = (1-esnMinor(i).leakRate)*leakStates(n-1,:)+ esnMinor(i).leakRate*states{i}(n,:);
    end
    states{i} = leakStates;
end


statesExt = ones(size(states{1},1),1);
for i= 1:esnMajor.nInternalUnits
    statesExt = [statesExt states{i}];
end

if esnMajor.AddInputStates == 1
    statesExt = [statesExt inputSequence];
end

statesExt = [ones(size(statesExt,1),1)*esnMajor.inputShift statesExt]; % add bias

statesExt = statesExt(nForgetPoints+1:end,:);