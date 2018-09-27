function [winner, loser] = selection(config,pop_metrics,archive,seed)


    
% Tournment selection - pick two individuals
equal = 1;
while(equal)
    indv1 = randi([1 config.popSize]);
    indv2 = indv1+randi([1 config.deme]);
    if indv2 > config.popSize
        indv2 = indv2- config.popSize;
    end
    if indv1 ~= indv2
        equal = 0;
    end
end

%calculate distances
%pop_metrics = [kernel_rank;gen_rank;MC]';
error_indv1 = findKNN([archive; pop_metrics],pop_metrics(indv1,:),config.k_neighbours);
error_indv2 = findKNN([archive; pop_metrics],pop_metrics(indv2,:),config.k_neighbours);

% Assess fitness of both and assign winner/loser - highest score
% wins
if error_indv1 > error_indv2
    winner=indv1; loser = indv2;
else
    winner=indv2; loser = indv1;
end


end

%% fitness function
function [avg_dist] = findKNN(metrics,Y,k_neighbours)
[~,D] = knnsearch(metrics,Y,'K',k_neighbours);
avg_dist = mean(D);
end
