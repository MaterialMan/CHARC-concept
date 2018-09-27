
function [total_space_covered] = measureSearchSpace(metrics,spaceSize,plotSpace)

if size(metrics,2) == 3
    space = zeros(spaceSize,spaceSize,spaceSize);
    
    for i = 1:size(metrics,1)
        tmp = round(metrics(i,:))+1;
        space(tmp(1),tmp(2),tmp(3)) = 1;
    end
    total_space_covered = sum(sum(sum(space)));
else
    space = zeros(spaceSize);
    
    for i = 1:size(metrics,1)
        tmp = round(metrics(i,:))+1;
        space(tmp(1),tmp(2)) = 1;
    end
    total_space_covered = sum(sum(space));
end


if nargin > 2
    figure
    imagesc(flip(space'))
    %yticklabels(flip(10:10:spaceSize))
    %yticks(2:2:spaceSize/2)
end
