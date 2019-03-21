
%% Learn the behaviour-performance relationship and test across different reservoirs
clear
rng(1,'twister');

figure1 = figure;

% create dataset to learn from - should hold on reservoirs to be predicted
% and tested on. Replace for desired systems
dataset{1} = load('assessed_dB_forPrediction_25nodes_21990dbSize','pred_dataset');
dataset{2} = load('assessed_dB_forPrediction_50nodes_21990dbSize','pred_dataset');
dataset{3} = load('assessed_dB_forPrediction_100nodes_21990dbSize','pred_dataset');
dataset{4} = load('assessed_dB_forPrediction_200nodes_21990dbSize','pred_dataset');

num_tests = 20;
nn_size = 100;
num_tasks = 4;

%assign threshold for each task
threshold = [0.5 0.7 0.25 0.25];

% dummy output
output_data = [];

% assign number of samples to use for each substrate
samples{1} = 1:21990;
samples{2} = 1:21990;
samples{3} = 1:21990;
samples{4} = 1:21990;

% dataset{5} = dataset{1};
% for i = 2:4
%     dataset{5}.pred_dataset.inputs = [dataset{5}.pred_dataset.inputs; dataset{i}.pred_dataset.inputs];
%     dataset{5}.pred_dataset.outputs = [dataset{5}.pred_dataset.outputs; dataset{i}.pred_dataset.outputs];
% end
% samples{5} = 1:21990*4;

% Predict each task and evaluate on all reservoirs
num_test_substrates = 0;
for task = 1:num_tasks 
    [meanTrainRMSE{task},meanTestRMSE{task}] = learnFNNModel(figure1,dataset,num_tests,nn_size,task,threshold,samples,output_data,0,num_test_substrates);    
end

%% with materials
dataset{5} = load('assessedHardware_dB_forPrediction_run1_2199dbSize','pred_dataset');
dataset{6} = load('assessed_dB_forPrediction_400nodes_2199dbSize_run2','pred_dataset');

% assign number of samples to use for each substrate
samples{5} = 1:2199;
samples{6} = 1:2199;

% Predict each task and evaluate on all reservoirs
num_test_substrates = 2;
for task = 1:num_tasks 
    [meanMatTrainRMSE{task},meanMatTestRMSE{task},~,output_data] = learnFNNModel(figure1,dataset,num_tests,nn_size,task,threshold,samples,output_data,1,num_test_substrates);    
end

%% plot actual vs predicted - do this manually
figure
d = output_data.T3{1,5};
scatter(d(:,1),d(:,2),10,'k');
line([0 1], [0 1],'Color','r');
xlim([max([min(d(:,1)) 0]) min([max(d(:,1)) 1])])
ylim([max([min(d(:,2)) 0]) min([max(d(:,1)) 1])])
xlabel('Predicted')
ylabel('Actual')

%calculate R^2
Bbar = mean(d(:,1));
SStot = sum((d(:,1) - Bbar).^2);
SSreg = sum((d(:,2) - Bbar).^2);
SSres = sum((d(:,1) - d(:,2)).^2);
R2 = 1 - SSres/SStot;
R = corrcoef(d(:,1),d(:,2));
Rsq = R(1,2).^2;
title(strcat('R=',num2str(Rsq)))


%% plot task clusters
% for i = 1:length(dataset)
% error = dataset{1,i}.pred_dataset.outputs;
% data = dataset{1,i}.pred_dataset.inputs;
% 
% [a_error{i},ascend_task_indx] = sort(error);
% 
% range_to_plot = 10;
% 
% T1 = data(ascend_task_indx(1:range_to_plot,1),:);
% T2 = data(ascend_task_indx(1:range_to_plot,2),:);
% T3 = data(ascend_task_indx(1:range_to_plot,3),:);
% T4 = data(ascend_task_indx(1:range_to_plot,4),:);
% 
% figure
% subplot(1,3,1)
% scatter(T1(:,1),T1(:,2),10,[0.75 0.75 0.75],'filled');
% hold on
% scatter(T2(:,1),T2(:,2),10,[0.5 0.5 0.5],'filled');
% scatter(T3(:,1),T3(:,2),10,[0.25 0.25 0.25],'filled');
% scatter(T4(:,1),T4(:,2),10,[0 0 0],'filled');
% xlabel('KR')
% ylabel('GR')
% set(gca,'FontSize',12,'FontName','Arial')
% legend({'T1','T2','T3','T4'},'Location','northwest')
% 
% subplot(1,3,2)
% scatter(T1(:,1),T1(:,3),10,[0.75 0.75 0.75],'filled');
% hold on
% scatter(T2(:,1),T2(:,3),10,[0.5 0.5 0.5],'filled');
% scatter(T3(:,1),T3(:,3),10,[0.25 0.25 0.25],'filled');
% scatter(T4(:,1),T4(:,3),10,[0 0 0],'filled');
% xlabel('KR')
% ylabel('MC')
% set(gca,'FontSize',12,'FontName','Arial')
% 
% subplot(1,3,3)
% scatter(T1(:,2),T1(:,3),10,[0.75 0.75 0.75],'filled');
% hold on
% scatter(T2(:,2),T2(:,3),10,[0.5 0.5 0.5],'filled');
% scatter(T3(:,2),T3(:,3),10,[0.25 0.25 0.25],'filled');
% scatter(T4(:,2),T4(:,3),10,[0 0 0],'filled');
% xlabel('GR')
% ylabel('MC')
% end

