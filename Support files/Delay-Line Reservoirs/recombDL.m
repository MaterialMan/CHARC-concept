function l = recombDL(w,l,config)

% recombine
% Winner= w.M(:);
% Loser = l.M(:);
% pos = randi([1 length(Loser)],round(config.recRate*length(Loser)),1);
% Loser(pos) = Winner(pos);
% l.M = reshape(Loser,size(l.M));


temp_winner = [w.Wscaling w.inputScaling w.inputShift w.leakRate];
temp_loser = [l.Wscaling l.inputScaling l.inputShift l.leakRate];
pos = randi([1 length(temp_loser)],round(config.recRate*length(temp_loser)),1);
temp_loser(pos) = temp_winner(pos);

l.Wscaling = temp_loser(1);                          %alters network dynamics and memory, SR < 1 in almost all cases
l.inputScaling = temp_loser(2);                    %increases nonlinearity
l.inputShift = temp_loser(3);                             %adds bias/value shift to input signal
l.leakRate = temp_loser(4);


if config.evolveOutputWeights
    Winner= w.outputWeights(:);
    Loser = l.outputWeights(:);
    pos = randi([1 length(Loser)],round(config.recRate*length(Loser)),1);
    Loser(pos) = Winner(pos);
    l.outputWeights = reshape(Loser,size(l.outputWeights));
end

end
