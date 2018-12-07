
function [total_space_covered] = measureSearchSpace(metrics,spaceSize,plotSpace)

space = zeros(spaceSize);
for i = 1:size(metrics,1)
    tmp = round(metrics(i,:))+1;
    space(tmp(1),tmp(2)) = 1;
end
total_space_covered = sum(sum(space));

if nargin > 2
figure
imagesc(flip(space'))
%yticklabels(flip(10:10:spaceSize))
%yticks(2:2:spaceSize/2)
end
