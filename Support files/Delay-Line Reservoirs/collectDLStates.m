function states = collectDLStates(genotype,inputSequence,config)


%% Collect states
switch(config.topology)
    
    case 'virtualNodes'
        
        J =[]; I = []; cnt=1;
        for n = 1:size(inputSequence,1)
            for t = 1:genotype.nInternalUnits
                for th = 1:genotype.theta
                    I(cnt,:) = inputSequence(n,:);
                    J(cnt,:) = inputSequence(n,:)*genotype.M(t,:)';
                    cnt = cnt +1;
                end
            end
        end
        
        x = zeros(size(J));
        for n = genotype.tau+1:length(I)
            x(n,:) = feval(genotype.reservoirActivationFunction,genotype.inputScaling.*J(n-1,:) + genotype.Wscaling.*x(n-genotype.tau,:));
        end
        
        x_s = x(1:genotype.theta:end,:);
        states = reshape(x_s,genotype.nInternalUnits,size(inputSequence,1))';
        
        
        case 'virtualNodes2'
        
        J =[]; 
        for n = 1:size(inputSequence,1)
           J(n,:) = genotype.M*inputSequence(n,:)';
        end
        
        x = zeros(size(J));
        for n = 2:size(J,1)
            for j = 1:genotype.nInternalUnits
                x(n,:) = feval(genotype.reservoirActivationFunction,genotype.inputScaling.*J(n-1,:) + genotype.Wscaling.*x(n-1,:));
            end
        end
        
        %x_s = x(1:genotype.theta:end,:);
        states = x;%reshape(x_s,genotype.nInternalUnits,size(inputSequence,1))';
        
%     case 'chainESN' % x_i(t) = f(IS*u(t) + SR*x(t-1,i)
%         
%         states = zeros(size(inputSequence,1),genotype.nInternalUnits);
%         
%         for n = 2:size(inputSequence,1)
%             for i = 1:genotype.nInternalUnits
%                 if i ==1
%                     states(n,1) = feval(genotype.reservoirActivationFunction,(genotype.inputScaling.*genotype.Win)*inputSequence(n,:)');
%                 else
%                     states(n,i) = feval(genotype.reservoirActivationFunction,(genotype.inputScaling.*genotype.Win)*inputSequence(n,:)' + (genotype.Wscaling.*genotype.W)*states(n-1,:));
%                 end
%             end
%         end
%         
%     case 'ELM'  % single layer feed-forward network
%         states = zeros(size(inputSequence,1),genotype.nInternalUnits);
% 
%         for n = 2:size(inputSequence,1)
%             states(n,:) = feval(genotype.reservoirActivationFunction,(genotype.inputScaling.*genotype.Win)*inputSequence(n,:)' + (genotype.Wscaling.*genotype.W)*states(n-1,:));
%         end
end

if config.leakOn
    states = getLeakStates(states,genotype,config);
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
