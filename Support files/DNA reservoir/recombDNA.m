function l = recombDNA(w,l,config)

if rand < config.recRate
    l.inputScaling = w.inputScaling;
end

Winner= w.H(:);
Loser = l.H(:);
pos = randi([1 length(Loser)],round(config.recRate*length(Loser)),1);
Loser(pos) = Winner(pos);
l.H = reshape(Loser,size(l.H));

Winner= w.V(:);
Loser = l.V(:);
pos = randi([1 length(Loser)],round(config.recRate*length(Loser)),1);
Loser(pos) = Winner(pos);
l.V = reshape(Loser,size(l.V));

Winner= w.P0(:);
Loser = l.P0(:);
pos = randi([1 length(Loser)],round(config.recRate*length(Loser)),1);
Loser(pos) = Winner(pos);
l.P0 = reshape(Loser,size(l.P0));

Winner= w.S0(:);
Loser = l.S0(:);
pos = randi([1 length(Loser)],round(config.recRate*length(Loser)),1);
Loser(pos) = Winner(pos);
l.S0 = reshape(Loser,size(l.S0));

Winner= w.GateCon(:);
Loser = l.GateCon(:);
pos = randi([1 length(Loser)],round(config.recRate*length(Loser)),1);
Loser(pos) = Winner(pos);
l.GateCon = reshape(Loser,size(l.GateCon));


Winner= w.w_in(:);
Loser = l.w_in(:);
pos = randi([1 length(Loser)],round(config.recRate*length(Loser)),1);
Loser(pos) = Winner(pos);
l.w_in = reshape(Loser,size(l.w_in));

% Winner= w.input_loc;
% Loser = l.input_loc;
% pos = randi([1 length(Loser)],round(config.recRate*length(Loser)),1);
% Loser(pos) = Winner(pos);
% l.input_loc = Loser;

if config.evolvedOutputStates
    Winner= w.state_loc;
    Loser = l.state_loc;
    pos = randi([1 length(Loser)],round(config.recRate*length(Loser)),1);
    Loser(pos) = Winner(pos);
    l.state_loc = Loser;
end