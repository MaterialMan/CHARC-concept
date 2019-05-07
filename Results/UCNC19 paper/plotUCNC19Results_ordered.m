clear

dotSize= 5;
maxKR =0; maxGR=0;maxMC=0;

%% Figure 1 to 4: ring vs lattice vs esn (directed)
directedPlot = 1;
% 50
ring50d = load('substrate_Ring_run10_gens2000_Nres_50_directed1_self1.mat','all_databases','total_space_covered');
latt49d = load('substrate_Lattice_run10_gens2000_Nres_49_directed1_self1.mat','all_databases','total_space_covered');
esn50 = load('noveltySearch3D_size50_run10_gens2000.mat','all_databases','total_space_covered');

% single run
% plotBS(figure,{ring50d.all_databases{10,10},latt49d.all_databases{10,10},esn50.all_databases{10,10}},dotSize,maxKR,maxGR,maxMC,directedPlot);
% legend('50-ESN','49-lattice','50-ring','Location','northwest')
%print('behaviourSpace_50size','-dpdf','-bestfit')

% all runs
plotBS(figure,{reshape([ring50d.all_databases{:,10}]',3,21990)',reshape([latt49d.all_databases{:,10}]',3,21990)',reshape([esn50.all_databases{:,10}]',3,21990)'},dotSize,maxKR,maxGR,maxMC,directedPlot);
legend('50-ESN','49-lattice','50-ring','Location','northwest')
print('behaviourSpace_50size_allruns','-dpdf','-bestfit')

% 100
ring100d = load('substrate_Ring_run10_gens2000_Nres_100_directed1_self1.mat','all_databases','total_space_covered');
latt100d = load('substrate_Lattice_run10_gens2000_Nres_100_directed1_self1.mat','all_databases','total_space_covered');
esn100 = load('noveltySearch3D_size100_run10_gens2000.mat','all_databases','total_space_covered');

% all runs
plotBS(figure,{reshape([ring100d.all_databases{:,10}]',3,21990)',reshape([latt100d.all_databases{:,10}]',3,21990)',reshape([esn100.all_databases{:,10}]',3,21990)'},dotSize,maxKR,maxGR,maxMC,directedPlot);
legend('100-ESN','100-lattice','100-ring','Location','northwest')
print('behaviourSpace_100size_allruns','-dpdf','-bestfit')

% 200
ring200d = load('substrate_Ring_run10_gens2000_Nres_200_directed1_self1.mat','all_databases','total_space_covered');
latt196d = load('substrate_Lattice_run10_gens2000_Nres_196_directed1_self1.mat','all_databases','total_space_covered');
esn200 = load('noveltySearch3D_size200_run10_gens2000.mat','all_databases','total_space_covered');

% single run
% plotBS(figure,{ring200d.all_databases{10,10},latt196d.all_databases{10,10},esn200.all_databases{10,10}},dotSize,maxKR,maxGR,maxMC,directedPlot);
% legend('200-ESN','196-lattice','200-ring','Location','northwest')
%print('UCNC19_behaviourSpace_200size','-dpdf','-bestfit')

% all runs
plotBS(figure,{reshape([ring200d.all_databases{:,10}]',3,21990)',reshape([latt196d.all_databases{:,10}]',3,21990)',reshape([esn200.all_databases{:,10}]',3,21990)'},dotSize,maxKR,maxGR,maxMC,directedPlot);
legend('200-ESN','196-lattice','200-ring','Location','northwest')
print('behaviourSpace_200size_allruns','-dpdf','-bestfit')

%% Figure 5 to 8: Directed versus Undirected
directedPlot = 0;
% 25 directed
ring25d = load('substrate_Ring_run10_gens2000_Nres_25_directed1_self1.mat','all_databases','total_space_covered');
latt25d = load('substrate_Lattice_run10_gens2000_Nres_25_directed1_self1.mat','all_databases','total_space_covered');
% 25 undirected
ring25u = load('substrate_Ring_run10_gens2000_Nres_25_directed0_self1.mat','all_databases','total_space_covered');
latt25u = load('substrate_Lattice_run10_gens2000_Nres_25_directed0_self1.mat','all_databases','total_space_covered');

% one run only
% plotBS(figure,{ring25u.all_databases{10,10},ring25d.all_databases{10,10}},dotSize,maxKR,maxGR,maxMC,directedPlot);
% legend('directed','undirected','Location','northwest')
%print('UCNC19_dirVSundir_25ring','-dpdf','-bestfit')

% plotBS(figure,{latt25u.all_databases{10,10},latt25d.all_databases{10,10}},dotSize,maxKR,maxGR,maxMC,directedPlot);
% legend('directed','undirected','Location','northwest')
%print('UCNC19_dirVSundir_25lattice','-dpdf','-bestfit')

% all runs
plotBS(figure,{reshape([ring25u.all_databases{:,10}]',3,21990)',reshape([ring25d.all_databases{:,10}]',3,21990)'},dotSize,maxKR,maxGR,maxMC,directedPlot);
legend('directed','undirected','Location','northwest')
print('dirVSundir_25ring_allruns','-dpdf','-bestfit')

plotBS(figure,{reshape([latt25u.all_databases{:,10}]',3,21990)',reshape([latt25d.all_databases{:,10}]',3,21990)'},dotSize,maxKR,maxGR,maxMC,directedPlot);
legend('directed','undirected','Location','northwest')
print('dirVSundir_25lattice_allruns','-dpdf','-bestfit')

% 100 directed
ring100d = load('substrate_Ring_run10_gens2000_Nres_100_directed1_self1.mat','all_databases','total_space_covered');
latt100d = load('substrate_Lattice_run10_gens2000_Nres_100_directed1_self1.mat','all_databases','total_space_covered');

% 100 undirected
ring100u = load('substrate_Ring_run10_gens2000_Nres_100_directed0_self1.mat','all_databases','total_space_covered');
latt100u = load('substrate_Lattice_run10_gens2000_Nres_100_directed0_self1.mat','all_databases','total_space_covered');

% one run only
% plotBS(figure,{ring100u.all_databases{10,10},ring100d.all_databases{10,10}},dotSize,maxKR,maxGR,maxMC,directedPlot);
% legend('directed','undirected','Location','northwest')
%print('UCNC19_dirVSundir_100ring','-dpdf','-bestfit')

% plotBS(figure,{latt100u.all_databases{10,10},latt100d.all_databases{10,10}},dotSize,maxKR,maxGR,maxMC,directedPlot);
% legend('directed','undirected','Location','northwest')
%print('dirVSundir_100lattice','-dpdf','-bestfit')

% all runs
plotBS(figure,{reshape([ring100u.all_databases{:,10}]',3,21990)',reshape([ring100d.all_databases{:,10}]',3,21990)'},dotSize,maxKR,maxGR,maxMC,directedPlot);
legend('directed','undirected','Location','northwest')
print('dirVSundir_100ring_allruns','-dpdf','-bestfit')

plotBS(figure,{reshape([latt100u.all_databases{:,10}]',3,21990)',reshape([latt100d.all_databases{:,10}]',3,21990)'},dotSize,maxKR,maxGR,maxMC,directedPlot);
legend('directed','undirected','Location','northwest')
print('dirVSundir_100lattice_allruns','-dpdf','-bestfit')


%% Figure 9: Quality vs size (directed) - all sizes/types
figure
ring400d = load('substrate_Ring_run10_gens2000_Nres_400_directed1_self1.mat','all_databases','total_space_covered');
latt400d = load('substrate_Lattice_run10_gens2000_Nres_400_directed1_self1.mat','all_databases','total_space_covered');
ring400u = load('substrate_Ring_run2_gens2000_Nres_400_directed0_self1.mat','all_databases','total_space_covered');
latt400u = load('substrate_Lattice_run10_gens2000_Nres_400_directed0_self1.mat','all_databases','total_space_covered');

esn25 = load('noveltySearch3D_size25_run10_gens2000.mat','all_databases','total_space_covered');
esn100 = load('noveltySearch3D_size100_run10_gens2000.mat','all_databases','total_space_covered');

data = [ring25d.total_space_covered(:,10) latt25d.total_space_covered(:,10)  esn25.total_space_covered(:,10)...
    ring50d.total_space_covered(:,10) latt49d.total_space_covered(:,10)  esn50.total_space_covered(:,10)...
    ring100d.total_space_covered(:,10) latt100d.total_space_covered(:,10)  esn100.total_space_covered(:,10)...
    ring200d.total_space_covered(:,10) latt196d.total_space_covered(:,10)  esn200.total_space_covered(:,10)...
    ring400d.total_space_covered(:,10) latt400d.total_space_covered(:,10)  esn200.total_space_covered(:,10)];

meanBar = [mean(data(:,1:3));mean(data(:,4:6));mean(data(:,7:9));mean(data(:,10:12));mean(data(:,13:15))]';
b = bar(meanBar','FaceColor','flat');
b(1).FaceColor = [0.2 0.2 0.2];
b(2).FaceColor = [0.4 0.4 0.4];
b(3).FaceColor = [0.8 0.8 0.8];
minBar = [min(data(:,1:3));min(data(:,4:6));min(data(:,7:9));min(data(:,10:12));min(data(:,13:15))]';
maxBar = [max(data(:,1:3));max(data(:,4:6));max(data(:,7:9));max(data(:,10:12));max(data(:,13:15))]';

y = meanBar(:);
L = y - minBar(:);
U = maxBar(:) - y;
hold on
er = errorbar([0.775 1 1.225 1.775 2 2.225 2.775 3 3.225 3.775 4 4.225 4.775 5 5.225],y(1:end), L(1:end),U(1:end));
er.LineStyle = 'none';
er.Color = 'k';
hold off

xticklabels({'25','50','100','200','400'})
legend('ring', 'lattice','esn','Location','northwest')
xlabel('size')
ylabel('coverage')
box off
set(gca,'FontSize',12,'FontName','Arial')
set(gcf,'renderer','OpenGL')

print('quality_Size','-dpdf','-bestfit')

%% Figure 10: directed ring vs undirected lattice
% 
figure
latt49u = load('substrate_Lattice_run10_gens2000_Nres_49_directed0_self1.mat','all_databases','total_space_covered');
latt196u = load('substrate_Lattice_run10_gens2000_Nres_196_directed0_self1.mat','all_databases','total_space_covered');

data2 = [ring25d.total_space_covered(:,10) latt25u.total_space_covered(:,10)  ...
    ring50d.total_space_covered(:,10) latt49u.total_space_covered(:,10)  ...
    ring100d.total_space_covered(:,10) latt100u.total_space_covered(:,10)  ...
    ring200d.total_space_covered(:,10) latt196u.total_space_covered(:,10)  ...
    ring400d.total_space_covered(:,10) latt400u.total_space_covered(:,10) ];

meanBar = [mean(data2(:,1:2));mean(data2(:,3:4));mean(data2(:,5:6));mean(data2(:,7:8));mean(data2(:,9:10))]';
b = bar(meanBar','FaceColor','flat');
b(1).FaceColor = [0.2 0.2 0.2];
b(2).FaceColor = [0.4 0.4 0.4];

minBar = [min(data2(:,1:2));min(data2(:,3:4));min(data2(:,5:6));min(data2(:,7:8));min(data2(:,9:10))]';
maxBar = [max(data2(:,1:2));max(data2(:,3:4));max(data2(:,5:6));max(data2(:,7:8));max(data2(:,9:10))]';

y = meanBar(:);
L = y - minBar(:);
U = maxBar(:) - y;
hold on
er = errorbar([0.85 1.15 1.85 2.15 2.85 3.15 3.85 4.15 4.85 5.15],y(1:end), L(1:end),U(1:end));
er.LineStyle = 'none';
er.Color= 'k';
hold off

xticklabels({'25','50','100','200','400'})
legend('ring (directed)', 'lattice (undirected)','Location','northwest')
xlabel('size')
ylabel('coverage')
box off
set(gca,'FontSize',12,'FontName','Arial')
set(gcf,'renderer','OpenGL')
print('quality_dirRingVSundirLattice','-dpdf','-bestfit')

%% calculate no. weights vs coverage

%Get weight info
calculateNumEdges
ring50u = load('substrate_Ring_run10_gens2000_Nres_50_directed0_self1.mat','all_databases','total_space_covered');
ring200u = load('substrate_Ring_run10_gens2000_Nres_200_directed0_self1.mat','all_databases','total_space_covered');

figure
data = [ring25u.total_space_covered(:,10) ring25d.total_space_covered(:,10) latt25u.total_space_covered(:,10) latt25d.total_space_covered(:,10)  esn25.total_space_covered(:,10)...
    ring50u.total_space_covered(:,10) ring50d.total_space_covered(:,10) latt49u.total_space_covered(:,10) latt49d.total_space_covered(:,10)  esn50.total_space_covered(:,10)...
    ring100u.total_space_covered(:,10) ring100d.total_space_covered(:,10) latt100u.total_space_covered(:,10) latt100d.total_space_covered(:,10)  esn100.total_space_covered(:,10)...
   ring200u.total_space_covered(:,10) ring200d.total_space_covered(:,10) latt196u.total_space_covered(:,10) latt196d.total_space_covered(:,10)  esn200.total_space_covered(:,10)];

n = 4; %only to size 200
y = reshape(mean(data),5,4); x =[ring_u(1:n);ring_d(1:n);latt_u(1:n);latt_d(1:n);esn_d(1:n)];

c = {repmat([0 0 0],5,1);
    repmat([0.2 0.2 0.2],5,1);
    repmat([0.4 0.4 0.4],5,1);
    repmat([0.6 0.6 0.6],5,1);
    repmat([0.8 0.8 0.8],4,1)};

meanData2 = [mean(ring400u.total_space_covered(1,10)) mean(ring400d.total_space_covered(:,10)) mean(latt400u.total_space_covered(:,10)) mean(latt400d.total_space_covered(:,10))];
minData2 = [min(ring400u.total_space_covered(1,10)) min(ring400d.total_space_covered(:,10)) min(latt400u.total_space_covered(:,10)) min(latt400d.total_space_covered(:,10))];
maxData2 = [max(ring400u.total_space_covered(1,10)) max(ring400d.total_space_covered(:,10)) max(latt400u.total_space_covered(:,10)) max(latt400d.total_space_covered(:,10))];

y2 = meanData2; x2 =[ring_u(n+1);ring_d(n+1);latt_u(n+1);latt_d(n+1)];

minBar = reshape(min(data),5,4);
maxBar = reshape(max(data),5,4);

yt = [y(:); y2(:)];
L = yt - [minBar(:);minData2(:)];
U = [maxBar(:); maxData2(:)] - yt;
hold on
er = errorbar([x(:);x2(:)],yt(1:end), L(1:end),U(1:end));
er.LineStyle = 'none';
er.Color= [0.5 0.5 0.5];

for i = 1:length(x)
    if i <5
        x_plot = [x(i,:) x2(i)];
        y_plot = [y(i,:) y2(i)];
    else
        x_plot = x(i,:);
        y_plot = y(i,:);
    end
scatter(x_plot,y_plot,[],c{i},'filled')
end
%scatter(x2,y2,[],[0 0 0;0.2 0.2 0.2;0.4 0.4 0.4;0.6 0.6 0.6],'filled')
hold off

x_text = x';
y_text = y';
ylabel('coverage','FontSize',12,'FontName','Arial')
xlabel('no. of weights','FontSize',12,'FontName','Arial')
set(gca,'FontSize',12,'FontName','Arial')
set(gcf,'renderer','OpenGL')
text(x_text(:),y_text(:)+y_text(:)*0.2,repmat({'25','50','100','200'},1,5))
x_text = x2';
y_text = y2';
text(x_text(:),y_text(:)+y_text(:)*0.2,repmat({'400'},1,4))

xline = [1 10e5];
yline = [1 10e5];
line(xline,yline,'Color','k','LineStyle','--')

xline = [1 10e5];
yline = [2200 2200];
line(xline,yline,'Color','k','LineStyle','-')

xlim([20 10e4]);
ylim([20 2750]);
legend('min/max','ring(u)','ring(d)', 'lattice(u)', 'lattice(d)', 'esn(d)','x=y','max coverage','Location','northwest')
set(gca, 'xScale', 'log')
set(gca, 'yScale', 'log')
grid on
%print('weightVsCoverage2','-dpdf','-opengl','-bestfit')

%% material vs 25-node undirected ring and lattice
directedPlot = 1;
mat64 = load('hardware_noveltySearch_2000_SN_B2S164_run_5.mat','all_databases','total_space_covered');
plotBS(figure,{reshape([mat64.all_databases{:,10}]',3,21990/2)',reshape([ring25u.all_databases{1:5,10}]',3,21990/2)',reshape([latt25u.all_databases{1:5,10}]',3,21990/2)'},dotSize,maxKR,maxGR,maxMC,directedPlot);
legend('25-lattice','25-ring','64-CNT','Location','northwest')
print('behaviourSpace_matVSsim25','-dpdf','-bestfit')

plotBS(figure,{reshape([mat64.all_databases{:,10}]',3,21990/2)',reshape([ring50u.all_databases{1:5,10}]',3,21990/2)',reshape([latt49u.all_databases{1:5,10}]',3,21990/2)'},dotSize,maxKR,maxGR,maxMC,directedPlot);
legend('49-lattice','50-ring','64-CNT','Location','northwest')
print('behaviourSpace_matVSsim50','-dpdf','-bestfit')

%% parameters - same size
% clearvars -except dotSize maxKR maxGR maxMC directedPlot
% latt49u = load('Lattice_run1_gens2000_Nres_49_directed0_self1.mat','all_databases','total_space_covered','database_genotype');
% latt49d  = load('Lattice_run1_gens2000_Nres_49_directed1_self1.mat','all_databases','total_space_covered','database_genotype');
% ring50u = load('Ring_run1_gens2000_Nres_50_directed0_self1.mat','all_databases','total_space_covered','database_genotype');
% ring50d  = load('Ring_run1_gens2000_Nres_50_directed1_self1.mat','all_databases','total_space_covered','database_genotype');
% 
% database = {ring50u.all_databases{1,10},ring50d.all_databases{1,10},latt49u.all_databases{1,10},latt49d.all_databases{1,10}};
% genotype = {ring50u.database_genotype,ring50d.database_genotype,latt49u.database_genotype,latt49d.database_genotype};
% parameter = 'Wscaling';
% plotBS(figure,{database{1:2}},dotSize,maxKR,maxGR,maxMC,directedPlot,{genotype{1:2}} ,parameter);
% print(strcat('paramSpace1_50size_',parameter),'-dpdf','-bestfit')
% plotBS(figure,{database{3:4}},dotSize,maxKR,maxGR,maxMC,directedPlot,{genotype{3:4}} ,parameter);
% print(strcat('paramSpace2_50size_',parameter),'-dpdf','-bestfit')
% 
% parameter = 'inputScaling';
% plotBS(figure,{database{1:2}},dotSize,maxKR,maxGR,maxMC,directedPlot,{genotype{1:2}} ,parameter);
% print(strcat('paramSpace1_50size_',parameter),'-dpdf','-bestfit')
% plotBS(figure,{database{3:4}},dotSize,maxKR,maxGR,maxMC,directedPlot,{genotype{3:4}} ,parameter);
% print(strcat('paramSpace2_50size_',parameter),'-dpdf','-bestfit')
% parameters - different size

%% new measures of quality - was wrong before
clearvars -except ring25u ring25d ring50u ring50d ring100u ring100d ring200u ring200d...
    latt25u latt25d latt49u latt49d latt100u latt100d latt196u latt196d...
    esn25 esn50 esn100 esn200

% get number of weights
calculateNumEdges

sc = {ring25u.all_databases{:,10}};
total_space_covered(1,1:10) = measureSearchSpace(sc,repmat(25,1,10));
sc = {ring50u.all_databases{:,10}};
total_space_covered(1,11:20) = measureSearchSpace(sc,repmat(50,1,10));
sc = {ring100u.all_databases{:,10}};
total_space_covered(1,21:30) = measureSearchSpace(sc,repmat(100,1,10));
sc = {ring200u.all_databases{:,10}};
total_space_covered(1,31:40) = measureSearchSpace(sc,repmat(200,1,10));

sc = {ring25d.all_databases{:,10}};
total_space_covered(2,1:10) = measureSearchSpace(sc,repmat(25,1,10));
sc = {ring50d.all_databases{:,10}};
total_space_covered(2,11:20) = measureSearchSpace(sc,repmat(50,1,10));
sc = {ring100d.all_databases{:,10}};
total_space_covered(2,21:30) = measureSearchSpace(sc,repmat(100,1,10));
sc = {ring200d.all_databases{:,10}};
total_space_covered(2,31:40) = measureSearchSpace(sc,repmat(200,1,10));

sc = {latt25u.all_databases{:,10}};
total_space_covered(3,1:10) = measureSearchSpace(sc,repmat(25,1,10));
sc = {latt49u.all_databases{:,10}};
total_space_covered(3,11:20) = measureSearchSpace(sc,repmat(49,1,10));
sc = {latt100u.all_databases{:,10}};
total_space_covered(3,21:30) = measureSearchSpace(sc,repmat(100,1,10));
sc = {latt196u.all_databases{:,10}};
total_space_covered(3,31:40) = measureSearchSpace(sc,repmat(196,1,10));

sc = {latt25d.all_databases{:,10}};
total_space_covered(4,1:10) = measureSearchSpace(sc,repmat(25,1,10));
sc = {latt49d.all_databases{:,10}};
total_space_covered(4,11:20) = measureSearchSpace(sc,repmat(49,1,10));
sc = {latt100d.all_databases{:,10}};
total_space_covered(4,21:30) = measureSearchSpace(sc,repmat(100,1,10));
sc = {latt196d.all_databases{:,10}};
total_space_covered(4,31:40) = measureSearchSpace(sc,repmat(196,1,10));

sc = {esn25.all_databases{:,10}};
total_space_covered(5,1:10) = measureSearchSpace(sc,repmat(25,1,10));
sc = {esn50.all_databases{:,10}};
total_space_covered(5,11:20) = measureSearchSpace(sc,repmat(50,1,10));
sc = {esn100.all_databases{:,10}};
total_space_covered(5,21:30) = measureSearchSpace(sc,repmat(100,1,10));
sc = {esn200.all_databases{:,10}};
total_space_covered(5,31:40) = measureSearchSpace(sc,repmat(200,1,10));

for i = 1:5
    n = 1;
    for j = 0:10:30
        mean_ts(i,n) = mean(total_space_covered(i,j+1:j+10));
        max_ts(i,n) = max(total_space_covered(i,j+1:j+10));
        min_ts(i,n) = min(total_space_covered(i,j+1:j+10));
        n = n+1;
    end
end

figure
n = 4; %only to size 200
yts = mean_ts; x =[ring_u(1:n);ring_d(1:n);latt_u(1:n);latt_d(1:n);esn_d(1:n)];

yt = yts(:);
L = yt - min_ts(:);
U = max_ts(:) - yt;
hold on
er = errorbar(x(:),yt(1:end), L(1:end),U(1:end));
er.LineStyle = 'none';
er.Color= [0.5 0.5 0.5];
% 
% c = {repmat([0 0 0],4,1);
%     repmat([0.2 0.2 0.2],4,1);
%     repmat([0.4 0.4 0.4],4,1);
%     repmat([0.6 0.6 0.6],4,1);
%     repmat([0.8 0.8 0.8],4,1)};

c = {repmat([0 0 0],4,1);
    repmat([0 0 0],4,1);
    repmat([0.65 0.65 0.65],4,1);
    repmat([0.65 0.65 0.65],4,1);
    repmat([0.9 0.9 0.9],4,1)};

typ = {'p','s','p','s','d'};

for i = 1:length(x)  
    x_plot = x(i,:);
    y_plot = yts(i,:);
    scatter(x_plot,y_plot,100,c{i},'filled',typ{i})
    hold on
end
hold off

x_text = x';
y_text = yts';
ylabel('coverage/quality','FontSize',12,'FontName','Arial')
xlabel('max number of weights','FontSize',12,'FontName','Arial')
set(gcf,'renderer','OpenGL')
text(x_text(:)+log(x_text(:)),y_text(:)+log(y_text(:)*1000),repmat({'25','50','100','200'},1,5))

% xline = [1 10e5];
% yline = [1 10e5];
% line(xline,yline,'Color','k','LineStyle','--')

xline = [1 10e5];
yline = [2200 2200];
line(xline,yline,'Color','k','LineStyle','-')

xlim([20 10e4]);
ylim([200 max(max(yts))+500]);
legend('min/max','ring(u)','ring(d)', 'lattice(u)', 'lattice(d)', 'esn(d)','max coverage','Location','northwest')
set(gca, 'xScale', 'log')
set(gca, 'yScale', 'log')
grid on
set(gca,'FontSize',12,'FontName','Arial')

print('weightVsCoverage2','-dpdf','-opengl','-bestfit')

%%
figure
meanBar = mean_ts;
b = bar(meanBar','FaceColor','flat');
b(1).FaceColor = [0 0 0];
b(2).FaceColor = [0.2 0.2 0.2];
b(3).FaceColor = [0.4 0.4 0.4];
b(4).FaceColor = [0.6 0.6 0.6];
b(5).FaceColor = [0.8 0.8 0.8];
minBar = min_ts;
maxBar = max_ts;

y = meanBar(:);
L = y - minBar(:);
U = maxBar(:) - y;
hold on
diste = [0.7 0.85 1 1.15 1.3];
er = errorbar([diste diste+1 diste+2 diste+3],y(1:end), L(1:end),U(1:end));
er.LineStyle = 'none';
er.Color = 'k';
hold off

xticklabels({'25','50','100','200'})
legend('ring(u)','ring(d)','lattice(u)', 'lattice(d)','esn','Location','northwest')
xlabel('size')
ylabel('coverage/quality')
box off
set(gca,'FontSize',12,'FontName','Arial')
set(gcf,'renderer','OpenGL')

print('quality_Size','-dpdf','-bestfit')
%% total coverage across all generations
% tc = {reshape([ring25u.all_databases{:,10}]',3,21990)',reshape([ring50u.all_databases{:,10}]',3,21990)',reshape([ring100u.all_databases{:,10}]',3,21990)',reshape([ring200u.all_databases{:,10}]',3,21990)',...
%     reshape([ring25d.all_databases{:,10}]',3,21990)',reshape([ring50d.all_databases{:,10}]',3,21990)',reshape([ring100d.all_databases{:,10}]',3,21990)',reshape([ring200d.all_databases{:,10}]',3,21990)',...
%     reshape([latt25u.all_databases{:,10}]',3,21990)',reshape([latt49u.all_databases{:,10}]',3,21990)',reshape([latt100u.all_databases{:,10}]',3,21990)',reshape([latt196u.all_databases{:,10}]',3,21990)',...
%     reshape([latt25d.all_databases{:,10}]',3,21990)',reshape([latt49d.all_databases{:,10}]',3,21990)',reshape([latt100d.all_databases{:,10}]',3,21990)',reshape([latt196d.all_databases{:,10}]',3,21990)',...
%     reshape([esn25.all_databases{:,10}]',3,21990)',reshape([esn50.all_databases{:,10}]',3,21990)',reshape([esn100.all_databases{:,10}]',3,21990)',reshape([esn200.all_databases{:,10}]',3,21990)'};
% 
% total_space_covered = measureSearchSpace(tc,repmat([25,50,100,200],1,5),1);
% 
% 
% 
% t = reshape(total_space_covered,5,4);
% 
% % 
% figure
% 
% n = 4; %only to size 200
% y = t; x =[ring_u(1:n);ring_d(1:n);latt_u(1:n);latt_d(1:n);esn_d(1:n)];
% 
% c = {repmat([0 0 0],4,1);
%     repmat([0.2 0.2 0.2],4,1);
%     repmat([0.4 0.4 0.4],4,1);
%     repmat([0.6 0.6 0.6],4,1);
%     repmat([0.8 0.8 0.8],4,1)};
% 
% typ = {'o','s','o','s','d'};
% 
% for i = 1:length(x)  
%     x_plot = x(i,:);
%     y_plot = y(i,:);
%     scatter(x_plot,y_plot,50,c{i},'filled',typ{i})
%     hold on
% end
% %scatter(x2,y2,[],[0 0 0;0.2 0.2 0.2;0.4 0.4 0.4;0.6 0.6 0.6],'filled')
% hold off
% 
% x_text = x';
% y_text = y';
% ylabel('coverage','FontSize',12,'FontName','Arial')
% xlabel('no. of weights','FontSize',12,'FontName','Arial')
% set(gca,'FontSize',12,'FontName','Arial')
% set(gcf,'renderer','OpenGL')
% text(x_text(:),y_text(:)+y_text(:)*0.2,repmat({'25','50','100','200'},1,5))
% 
% xline = [1 10e5];
% yline = [1 10e5];
% line(xline,yline,'Color','k','LineStyle','--')
% % 
% % xline = [1 10e5];
% % yline = [2200 2200];
% % line(xline,yline,'Color','k','LineStyle','-')
% % 
% xlim([20 10e4]);
% ylim([min(min(y)) max(max(y))+50]);
% legend('ring(u)','ring(d)', 'lattice(u)', 'lattice(d)', 'esn(d)','x=y','Location','southeast')
% set(gca, 'xScale', 'log')
% set(gca, 'yScale', 'log')
% grid on