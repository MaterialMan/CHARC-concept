function[statesExt] = collectDeepStates_IA(esnMajor,esnMinor,inputSequence,nForgetPoints,leakRateOn)

if nargin < 5
    leakRateOn = 1;
end

%% Collect states for plain ESN
for i= 1:esnMajor.nInternalUnits
    states{i} = zeros(size(inputSequence,1),esnMinor(i).nInternalUnits);
    x{i} = zeros(size(inputSequence,1),esnMinor(i).nInternalUnits);
end

if iscell(esnMajor.reservoirActivationFunction) 
    activ = esnMajor.reservoirActivationFunction;
    A    = cell(1, esnMinor(i).nInternalUnits);
    A(:) = {'tanh'};
    B    = cell(1, esnMinor(i).nInternalUnits);
    B(:) = {'linearNode'};
%     C    = cell(1, esnMinor(i).nInternalUnits);
%     C(:) = {'sigmoid'};
end

%equation: x(n) = f(Win*u(n) + S)
for i= 1:esnMajor.nInternalUnits
    temp_states = [];
    for n = 2:length(inputSequence(:,1))
        for k= 1:esnMajor.nInternalUnits
            x{i}(n,:) = x{i}(n,:) + (esnMajor.connectWeights{i,k}*states{k}(n-1,:)')';
        end
        
        if iscell(esnMajor.reservoirActivationFunction)
            tempstates_tanh = feval('tanh',((esnMinor(i).inputWeights*esnMinor(i).inputScaling)*([esnMinor(i).inputShift inputSequence(n,:)])')+x{i}(n,:)');
            tempstates_lin = feval('linearNode',((esnMinor(i).inputWeights*esnMinor(i).inputScaling)*([esnMinor(i).inputShift inputSequence(n,:)])')+x{i}(n,:)');
      
            index_tanh = cellfun(@strcmp, activ(i,:), A);
            index_lin = cellfun(@strcmp, activ(i,:), B);
            
            states{i}(n,index_tanh) = tempstates_tanh(index_tanh);
            states{i}(n,index_lin) = tempstates_lin(index_lin);
            
        else
            states{i}(n,:) = feval(esnMajor.reservoirActivationFunction,((esnMinor(i).inputWeights*esnMinor(i).inputScaling)*([esnMinor(i).inputShift inputSequence(n,:)])')+x{i}(n,:)'); %n-1
        end
    end
    
end


if leakRateOn
    for i= 1:esnMajor.nInternalUnits
        leakStates = zeros(size(states{i}));
        for n = 2:length(inputSequence(:,1))
            leakStates(n,:) = (1-esnMinor(i).leakRate)*leakStates(n-1,:)+ esnMinor(i).leakRate*states{i}(n,:);
        end
        states{i} = leakStates;
    end
end

statesExt = ones(size(states{1},1),1)*esnMajor.inputShift;
for i= 1:esnMajor.nInternalUnits
    statesExt = [statesExt states{i}];
end

if esnMajor.AddInputStates == 1
    statesExt = [statesExt inputSequence];
end

%statesExt = [ones(size(statesExt,1),1)*esnMajor.inputShift statesExt]; % add bias

statesExt = statesExt(nForgetPoints+1:end,:); % remove washout