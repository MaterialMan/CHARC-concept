
function [covered,stats] = measureSearchSpace(metrics)

metrics = round(metrics);
metrics_cmp = metrics;

covered = 0; rep_behaviour =[];
for i = 1:size(metrics,1)
   if sum(sum(metrics(i,:) == metrics_cmp,2) == size(metrics,2)) < 2
       covered = covered +1;
   else
        rep_behaviour = [rep_behaviour; metrics(i,:)];
   end
end

num_orig_rep_behaviour = unique(rep_behaviour,'rows');

covered = covered + size(num_orig_rep_behaviour,1);

%% collect additional stats
for i = 1:size(metrics,2)
    stats(:,i) = [iqr(metrics(:,i)),mad(metrics(:,i)),range(metrics(:,i)),std(metrics(:,i)),var(metrics(:,i))];
end

% if nargin > 2
%     
%     for m = 1:length(metrics)
%         
%         met = metrics{m};
%         divSize = spaceSize(m);
%         met(:,1:2) = (met(:,1:2)/divSize)*100;
%         met(:,3) = (met(:,3)/100)*100;
%         
%         space = zeros(100,100,100);
%         for i = 1:size(met,1)
%             tmp = round(met(i,:))+1;
%             space(tmp(1),tmp(2),tmp(3)) = 1;
%         end
%         covered = sum(sum(sum(space)));
%         
%         %total_space_covered(m) = covered/100^3;
%     end
% else
%     for m = 1:length(metrics)
%         
%         met = metrics{m};
%         
%         space = zeros(100,100,spaceSize(m));
%         space_cnt = zeros(101,101,spaceSize(m)+1);
%         for i = 1:size(met,1)
%             tmp(1:2) = round(met(i,1:2)*100)+1;
%             tmp(3) = round(met(i,3))+1;
%             space(tmp(1),tmp(2),tmp(3)) = 1;
%             space_cnt(tmp(1),tmp(2),tmp(3)) = space_cnt(tmp(1),tmp(2),tmp(3))+1;
%         end
%         covered = sum(sum(sum(space)));
%         
%         %total_space_covered(m) = covered;
%                 
%     end
% end
% 
% 
% 
% 
