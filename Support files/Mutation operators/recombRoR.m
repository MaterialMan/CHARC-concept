function loser = recombRoR(winner,loser,config)

%% Infection phase
for i = 1:size(winner.nInternalUnits,2)
    
    %recombine
    if rand < config.recRate
        loser.esnMinor(i) = winner.esnMinor(i);
          
        %update esnMajor weights and major internal units
        loser= changeMajorWeights(loser,i,loser.esnMinor);
    end
    
    %Reorder
    [temp_esnMinor, loser] = reorderESNMinor_ext(loser.esnMinor, loser); 
    loser.esnMinor = temp_esnMinor;
end