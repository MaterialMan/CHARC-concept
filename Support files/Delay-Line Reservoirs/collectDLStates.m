function states = collectDLStates(genotype,inputSequence,config)

% shift input range to be positive - scale between 0 and 1
inputSequence = rescale(inputSequence);

states = zeros(size(inputSequence,1),genotype.nInternalUnits);

% time multiplex input and mask
J =[]; I = [];
hold_str = 1; hold_end = genotype.tau/genotype.time_step;
theta_str =1; theta_end = floor(genotype.theta/genotype.time_step);

for n = 1:size(inputSequence,1)
    
    %input_min = min(inputSequence);
    I(hold_str:hold_end,:) = repmat(inputSequence(n,:),genotype.tau/genotype.time_step,1);%.*genotype.inputScaling;
    
    hold_str = hold_end+1;
    hold_end = hold_end+genotype.tau/genotype.time_step;
    
    for t = 1:genotype.nInternalUnits
        
        %J(theta_str:theta_end,:) = ( (I(theta_str:theta_end,:) - input_min) * genotype.M(t,:)' ) + input_min;
        %J(theta_str:theta_end,:) = I(theta_str:theta_end,:) + I(theta_str:theta_end,:)*genotype.M(t,:)';
        J(theta_str:theta_end,:) = I(theta_str:theta_end,:)*genotype.M(t,:)';
        
        % J(theta_str:theta_end,:) = cross(I(theta_str:theta_end,:),repmat(genotype.M(t,:),floor(genotype.theta/genotype.time_step),1));
        
        theta_str = theta_end+1;
        theta_end = theta_end+floor(genotype.theta/genotype.time_step);
    end
    
end

%% Collect states
switch(genotype.reservoirActivationFunction)
    
    case 'mackey_glass'
        
        sample_n = length(J);	% total no. of samples, excluding the given initial condition
        %index = 1;
        history_length = floor(genotype.tau/genotype.time_step);
        %x_history = zeros(history_length, 1); % here we assume x(t)=0 for -tau <= t < 0
        x_t = J(1);%genotype.x0; % initial condition: x(t=0)=x0
        
        X = zeros(sample_n+1, 1); % vector of all generated x samples
        
        %time = 0;
        %T = zeros(sample_n+1, 1); % vector of time samples
        
        J = [zeros(history_length,1); J];
        
        for n = history_length+1:size(J,1)
            
            X(n) = x_t;
            
            x_t_minus_tau = X(n-history_length) + genotype.gamma*J(n);  % add input sequence
            
            
            x_t = mackeyGlass_rk4(x_t, x_t_minus_tau, genotype.time_step, genotype.eta, genotype.T, genotype.p);
            
            
        end
        
        if isreal(X)
            %remove first delay loop
            X = X(history_length+1:end);
            
            % reshape states
            for k = 1:size(inputSequence,1)
                for i = 1:genotype.nInternalUnits
                    states(k,i) = X(round(k*genotype.tau/genotype.time_step - (genotype.nInternalUnits-i)*floor(genotype.theta/genotype.time_step))-1);%*(1/deltat));
                end
            end
        else
            error('States are complex numbers -- use integers for P, or scale input sequence well above 0')
        end
        
    case 'mackey_glass_dde'
        
        X = zeros(size(J,1), 1);
        history_length = floor(genotype.tau/genotype.time_step);
        x_t = genotype.x0;
        
        for n = history_length+1:size(J,1)
            
            hist = X(n-history_length) + genotype.gamma*J(n);
            
            x_t = mackeyGlass_rk4(x_t, hist, genotype.time_step, genotype.eta, genotype.T, genotype.p);
            
            X(n) = x_t;
            
        end
        
        if isreal(X)
            
            % reshape states
            for k = 1:size(inputSequence,1)
                for i = 1:genotype.nInternalUnits
                    states(k,i) = X(round(k*genotype.tau/genotype.time_step - (genotype.nInternalUnits-i)*floor(genotype.theta/genotype.time_step)));%*(1/deltat));
                end
            end
        else
            error('States are complex numbers -- use integers for P, or scale input sequence well above 0')
        end
        
    case 'mackey_glass_temp'
        
        X = zeros(size(J,1), 1);
        history_length = floor(genotype.tau/genotype.time_step);
        x_t = genotype.x0;
        
        for n = history_length+1:size(J,1)
            
            x_t = mackeyGlass_rk42(x_t, X(n-history_length), genotype.time_step, genotype.eta, genotype.T, genotype.p, genotype.gamma*J(n));
            
            X(n) = x_t;
            
        end
        
        if isreal(X)
            
            % reshape states
            for k = 1:size(inputSequence,1)
                for i = 1:genotype.nInternalUnits
                    states(k,i) = X(round(k*genotype.tau/genotype.time_step - (genotype.nInternalUnits-i)*floor(genotype.theta/genotype.time_step)));%*(1/deltat));
                end
            end
        else
            error('States are complex numbers -- use integers for P, or scale input sequence well above 0')
        end
        
        
    case 'virtualNodes'
        
        x = zeros(size(J));
        for n = genotype.tau+1:length(I)
            x(n,:) = feval(genotype.reservoirActivationFunction,genotype.inputScaling.*J(n-1,:) + genotype.Wscaling.*x(n-genotype.tau,:));
        end
        
        x_s = x(1:genotype.theta:end,:);
        states = reshape(x_s,genotype.nInternalUnits,size(inputSequence,1))';
        
        
    case 'simpleDelay'
        
        for n = 2:length(J)
            for i = 1:genotype.nInternalUnits
                if i == 1
                    states(n,i) = states(n-1,genotype.nInternalUnits);
                else
                    states(n,i) = (1-genotype.time_step)*states(n,i-1) + genotype.time_step*genotype.eta* tanh( states(n-1,i) + genotype.gamma*J(n));
                end
            end
        end
        
        
    case 'virtualNodes2'
        
        J =[];
        for n = 1:size(inputSequence,1)
            J(n,:) = genotype.M*inputSequence(n,:)';
        end
        
        x = zeros(size(J));
        for n = 2:size(J,1)
            for i = 1:genotype.nInternalUnits
                x(n,:) = feval(genotype.reservoirActivationFunction,genotype.inputScaling.*J(n-1,:) + genotype.Wscaling.*x(n-1,:));
            end
        end
        
        %x_s = x(1:genotype.theta:end,:);
        states = x;%reshape(x_s,genotype.nInternalUnits,size(inputSequence,1))';
        
    case 'mackey_glass2'
        
        sample_n = length(J);	% total no. of samples, excluding the given initial condition
        index = 1;
        history_length = floor(genotype.tau/genotype.time_step);
        x_history = zeros(history_length, 1); % here we assume x(t)=0 for -tau <= t < 0
        x_t = genotype.x0;%genotype.x0; % initial condition: x(t=0)=x0
        
        X = zeros(sample_n+1, 1); % vector of all generated x samples
        
        for n = 1:size(J,1)
            
            X(n) = x_t;
            
            if genotype.tau == 0
                x_t_minus_tau = 0.0;
            else
                x_t_minus_tau = x_history(index) + genotype.gamma*J(n);  % add input sequence
            end
            
            x_t_plus_deltat = mackeyGlass_rk4(x_t, x_t_minus_tau, genotype.time_step, genotype.eta, genotype.T, genotype.p);
            
            if (genotype.tau ~= 0)
                x_history(index) = x_t_plus_deltat;
                index = mod(index, history_length)+1;
            end
            
            %time = time + deltat;
            %T(n) = time;
            
            x_t = x_t_plus_deltat;
            
            %              % store state values for nodes
            %              if mod(n,genotype.theta/deltat2) == 0
            %
            %                  states(sample,node_cnt) = X(n);
            %
            %                  % switch to next node
            %                  if node_cnt == genotype.nInternalUnits
            %                      node_cnt = 1; %reset counter
            %                      sample = sample+1;
            %                  else
            %                      node_cnt = node_cnt+1;
            %                  end
            %
            %
            %              end
            
        end
        
        if isreal(X)
            
            % reshape states
            for k = 1:size(inputSequence,1)
                for i = 1:genotype.nInternalUnits
                    states(k,i) = X(round(k*genotype.tau/genotype.time_step - (genotype.nInternalUnits-i)*floor(genotype.theta/genotype.time_step)));%*(1/deltat));
                end
            end
        else
            error('States are complex numbers -- use integers for P, or scale input sequence well above 0')
        end
        
        
    case 'mackey_glass3'
        
        N_steps = round(genotype.tau/genotype.time_step);
        T_start = 1;
        T_end = length(inputSequence);%length(J);
        
        input       = [J; 0];%J(( T_start - 1 ) * N_steps + 1 :   T_end       * N_steps); %+1
        x           = [repmat(genotype.x0,N_steps,1);  zeros(length(J)-N_steps, 1)];
        
        % equations
        A =       -(genotype.time_step/genotype.T)   + .5*         ((genotype.time_step^2)/(genotype.T^2))    + 1 ;
        B = .5*genotype.time_step*(genotype.eta/genotype.T)   - .5*genotype.eta    * ((genotype.time_step^2)/(genotype.T^2))        ;
        C = .5*genotype.time_step*(genotype.eta/genotype.T)                                   ;
        
        for n = 0 : T_end - T_start
            
            hist_start      =  n * N_steps + 1;
            hist_end        = ( n + 1 ) * N_steps;
            
            x_old           = x( hist_start : hist_end );
            I               = genotype.gamma * input( hist_start : hist_end+1 );
            
            x_old(end+1)    = x(hist_end + 1 );
            
            for j = 1 : N_steps
                x(hist_start + N_steps + j) = A * x(hist_start + N_steps + j - 1 )...
                    + B * (x_old(j)+I(j)) / ( 1 + (x_old(j)+I(j))^genotype.p ) ...
                    + C * (x_old(j+1)+I(j+1)) / ( 1 + (x_old(j+1)+I(j+1))^genotype.p );
            end
            
        end
        
        if isreal(x)
            
            % reshape states
            for k = 1:size(inputSequence,1)
                for i = 1:genotype.nInternalUnits
                    states(k,i) = x(round(k*genotype.tau/genotype.time_step - (genotype.nInternalUnits-i)*floor(genotype.theta/genotype.time_step)));%*(1/deltat));
                end
            end
        else
            error('States are complex numbers -- use integers for P, or scale input sequence well above 0')
        end
        
        
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


end
%%

% we need a history function that is a column vector giving the value of y1
% and y2 in the past. Here we make these constant values.
function y = history(t)
y = 1;
end

function dydt = ddefun(t,y,Z,T,eta,p,J)

dydt = -T*y + (eta*(Z+J))/(1 + (Z+J)^p);
end