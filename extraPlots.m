%% Extra plots for paper
addpath('mat')

PCMalpha9 = load('PCMalpha9.mat');
PCMalpha5 = load('PCMalpha5.mat');
PCMalpha1 = load('PCMalpha1.mat');

PCQalpha9 = load('PCQalpha9.mat');
PCQalpha5 = load('PCQalpha5.mat');
PCQalpha1 = load('PCQalpha1.mat');

hogDataSelfTuning = load('hogDataSelfTuning.mat');

hogDataSelfTuningPCMalpha5 = load('hogDataSelfTuningPCMalpha5.mat');
hogDataSelfTuningPCMalpha2 = load('hogDataSelfTuningPCMalpha2.mat');
hogDataSelfTuningPCMalpha9 = load('hogDataSelfTuningPCMalpha9.mat');

hogDataSelfTuningPCQalpha5 = load('hogDataSelfTuningPCQalpha5.mat');
hogDataSelfTuningPCQalpha2 = load('hogDataSelfTuningPCQalpha2.mat');
hogDataSelfTuningPCQalpha9 = load('hogDataSelfTuningPCQalpha9.mat');
%% PCQ
figure
subplot(1,3,1)
hold on
grid on
plot(1:90,PCQalpha9.alpha*PCQalpha9.CS+(1-PCQalpha9.alpha)*PCQalpha9.CT, 'g', 'LineStyle', '-', 'LineWidth', 3)
plot(1:90,PCQalpha5.alpha*PCQalpha5.CS+(1-PCQalpha5.alpha)*PCQalpha5.CT, 'r',  'LineStyle','-.', 'LineWidth', 3)
plot(1:90,PCQalpha1.alpha*PCQalpha1.CS+(1-PCQalpha1.alpha)*PCQalpha1.CT, 'b', 'LineStyle', '--', 'LineWidth', 3)
title({'Overall Cost PCQ'},'FontSize',14)
xlabel('t')
ylabel('Overall Cost')
l = legend('alpha = 0.9','alpha = 0.5', 'alpha = 0.1');
set(l,'FontSize',14);

subplot(1,3,2)
hold on
grid on
plot(1:90,PCQalpha9.CS, 'g', 'LineStyle','-', 'LineWidth', 3)
plot(1:90,PCQalpha5.CS, 'r', 'LineStyle','-.', 'LineWidth', 3)
plot(1:90,PCQalpha1.CS, 'b', 'LineStyle','--', 'LineWidth', 3)
title({'Snapshot Cost PCQ'},'FontSize',14)
xlabel('t')
ylabel('Snapshot Cost')
l = legend('alpha = 0.9','alpha = 0.5', 'alpha = 0.1');
set(l,'FontSize',14);

subplot(1,3,3)
hold on
grid on
plot(1:90,PCQalpha9.CT, 'g', 'LineStyle','-', 'LineWidth', 3)
plot(1:90,PCQalpha5.CT, 'r', 'LineStyle','-.', 'LineWidth', 3)
plot(1:90,PCQalpha1.CT, 'b', 'LineStyle','--', 'LineWidth', 3)
title({'Temporal Cost PCQ'},'FontSize',14)
xlabel('t')
ylabel('Temporal Cost')
l = legend('alpha = 0.9','alpha = 0.5', 'alpha = 0.1');
set(l,'FontSize',14);

%% PCM
figure
subplot(1,3,1)
hold on
grid on
plot(1:90,PCMalpha9.alpha*PCMalpha9.CS+(1-PCMalpha9.alpha)*PCMalpha9.CT, 'g', 'LineStyle', '-', 'LineWidth', 3)
plot(1:90,PCMalpha5.alpha*PCMalpha5.CS+(1-PCMalpha5.alpha)*PCMalpha5.CT, 'r',  'LineStyle','-.', 'LineWidth', 3)
plot(1:90,PCMalpha1.alpha*PCMalpha1.CS+(1-PCMalpha1.alpha)*PCMalpha1.CT, 'b', 'LineStyle', '--', 'LineWidth', 3)
title({'Overall Cost PCM'},'FontSize',14)
xlabel('t')
ylabel('Overall Cost')
l = legend('alpha = 0.9','alpha = 0.5', 'alpha = 0.1');
set(l,'FontSize',14);

subplot(1,3,2)
hold on
grid on
plot(1:90,PCMalpha9.CS, 'g', 'LineStyle','-', 'LineWidth', 3)
plot(1:90,PCMalpha5.CS, 'r', 'LineStyle','-.', 'LineWidth', 3)
plot(1:90,PCMalpha1.CS, 'b', 'LineStyle','--', 'LineWidth', 3)
title({'Snapshot Cost PCM'},'FontSize',14)
xlabel('t')
ylabel('Snapshot Cost')
l = legend('alpha = 0.9','alpha = 0.5', 'alpha = 0.1');
set(l,'FontSize',14);

subplot(1,3,3)
hold on
grid on
plot(1:90,PCMalpha9.CT, 'g', 'LineStyle','-', 'LineWidth', 3)
plot(1:90,PCMalpha5.CT, 'r', 'LineStyle','-.', 'LineWidth', 3)
plot(1:90,PCMalpha1.CT, 'b', 'LineStyle','--', 'LineWidth', 3)
title({'Temporal Cost PCM'},'FontSize',14)
xlabel('t')
ylabel('Temporal Cost')
l = legend('alpha = 0.9','alpha = 0.5', 'alpha = 0.1');
set(l,'FontSize',14);

%% Cluster Quality
figure
plot(hogDataSelfTuning.qualityRLS, 'g', 'LineStyle','-.', 'LineWidth', 2)
grid on
hold on
plot(hogDataSelfTuningPCQalpha5.qualityRLS, 'r', 'LineStyle','-', 'LineWidth', 2)
plot(hogDataSelfTuningPCMalpha5.qualityRLS, 'b', 'LineStyle','--', 'LineWidth', 2)
title({hogDataSelfTuning.algorithm,'Cluster Quality'},'FontSize',14)
xlabel('time')
ylabel('Cluster Quality')
l = legend('Independent Self Tuning','PCM Self Tuning', 'PCQ Self Tuning');
set(l,'FontSize',14);

%% Number of Clusters over time
T = size(hogDataSelfTuning.clusters,2);
for t = 1:T
    numClustersST(t) = size(hogDataSelfTuning.clusters{t},2);
    
    numClustersPCQalpha5(t) = size(hogDataSelfTuningPCQalpha5.clusters{t},2);
    numClustersPCQalpha2(t) = size(hogDataSelfTuningPCQalpha2.clusters{t},2);
    numClustersPCQalpha9(t) = size(hogDataSelfTuningPCQalpha9.clusters{t},2);
    
    numClustersPCMalpha5(t) = size(hogDataSelfTuningPCMalpha5.clusters{t},2);
    numClustersPCMalpha2(t) = size(hogDataSelfTuningPCMalpha2.clusters{t},2);
    numClustersPCMalpha9(t) = size(hogDataSelfTuningPCMalpha9.clusters{t},2);
end

numClusterChangeST = 100*(size(find(diff(numClustersST) ~= 0),2))/T
avgClusterChangeST = sum(abs(diff(numClustersST)))/(size(find(diff(numClustersST) ~= 0),2))

numClusterChangePCQ9 = 100*(size(find(diff(numClustersPCQalpha9) ~= 0),2))/T
numClusterChangePCQ5 = 100*(size(find(diff(numClustersPCQalpha5) ~= 0),2))/T
numClusterChangePCQ2 = 100*(size(find(diff(numClustersPCQalpha2) ~= 0),2))/T

avgClusterChangePCQ9 = sum(abs(diff(numClustersPCQalpha9)))/(size(find(diff(numClustersPCQalpha9) ~= 0),2))
avgClusterChangePCQ5 = sum(abs(diff(numClustersPCQalpha5)))/(size(find(diff(numClustersPCQalpha5) ~= 0),2))
avgClusterChangePCQ2 = sum(abs(diff(numClustersPCQalpha2)))/(size(find(diff(numClustersPCQalpha2) ~= 0),2))

numClusterChangePCM9 = 100*(size(find(diff(numClustersPCMalpha9) ~= 0),2))/T
numClusterChangePCM5 = 100*(size(find(diff(numClustersPCMalpha5) ~= 0),2))/T
numClusterChangePCM2 = 100*(size(find(diff(numClustersPCMalpha2) ~= 0),2))/T

avgClusterChangePCM9 = sum(abs(diff(numClustersPCMalpha9)))/(size(find(diff(numClustersPCMalpha9) ~= 0),2))
avgClusterChangePCM5 = sum(abs(diff(numClustersPCMalpha5)))/(size(find(diff(numClustersPCMalpha5) ~= 0),2))
avgClusterChangePCM2 = sum(abs(diff(numClustersPCMalpha2)))/(size(find(diff(numClustersPCMalpha2) ~= 0),2))
