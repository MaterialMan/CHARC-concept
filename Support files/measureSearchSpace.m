
function [total_space_covered] = measureSearchSpace(metrics,spaceSize,normalise,plotSpace)

if nargin > 2
    
    for m = 1:length(metrics)
        
        met = metrics{m};
        divSize = spaceSize(m);
        met(:,1:2) = (met(:,1:2)/divSize)*100;
        met(:,3) = (met(:,3)/100)*100;
        
        space = zeros(100,100,100);
        for i = 1:size(met,1)
            tmp = round(met(i,:))+1;
            space(tmp(1),tmp(2),tmp(3)) = 1;
        end
        covered = sum(sum(sum(space)));
        
        total_space_covered(m) = covered/100^3;
    end
else
    for m = 1:length(metrics)
        
        met = metrics{m};
        
        space = zeros(spaceSize(m),spaceSize(m),spaceSize(m));
        for i = 1:size(met,1)
            tmp = round(met(i,:))+1;
            space(tmp(1),tmp(2),tmp(3)) = 1;
        end
        covered = sum(sum(sum(space)));
        
        total_space_covered(m) = covered;
    end
end
