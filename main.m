%% Analysis of Evolutionary Clustering Algorithms

close all; clear; clc;
addpath('datasets')
addpath('mat')
addpath('videos')

%% Specify the data set and the algorithm
dataName = 'hogData'
algorithm = 'Self Tuning PCM'
movieName = []

switch dataName
    case 'Four Gaussians'
        load('fourGaussianData.mat');
        axesLabel = [{'x'}, {'y'}];

        switch algorithm
            case 'PCM'
                graph_structure = 'complete graph';
                edge_weight = 'gaussian';
                sigma = .5;
                K = 4;
                alpha = .8;
                % Run PCM
                [clusters, CS, CT] = EvolutionaryClustering(algorithm, dataSet,...
                    removedIndices, K, alpha, graph_structure, edge_weight, 'sigma', sigma);
                
            case 'PCQ'
                graph_structure = 'complete graph';
                edge_weight = 'gaussian';
                sigma = .5;
                K = 4;
                alpha = .8;
                % Run PCQ
                [clusters, CS, CT] = EvolutionaryClustering(algorithm, dataSet,...
                    removedIndices, K, alpha, graph_structure, edge_weight, 'sigma', sigma);
                 
            case 'Self Tuning'
                neighbor_num = 15;
                cluster_num_choices = [2,3,4,5];
                [clusters, qualityRLS] = SelfTuning(dataSet, neighbor_num, cluster_num_choices);
                
            case 'Self Tuning PCM'
                alpha = 0.9;
                neighbor_num = 15;
                cluster_num_choices = [2,3,4,5];
                [clusters, qualityRLS] = SelfTuningEvolutionary('PCM', dataSet, removedIndices, alpha, neighbor_num, cluster_num_choices);

            case 'Self Tuning PCQ'
                alpha = 0.9;
                neighbor_num = 15;
                cluster_num_choices = [2,3,4,5];
                [clusters, qualityRLS] = SelfTuningEvolutionary('PCQ', dataSet, removedIndices, alpha, neighbor_num, cluster_num_choices);
                
            otherwise
                disp('Algorithm not supported')
                
        end
        
    case 'firework'
        load('fireworkData.mat');
        axesLabel = [{'x'}, {'y'}];

        switch algorithm
            case 'PCM'
                graph_structure = 'complete graph';
                edge_weight = 'gaussian';
                sigma = .5;
                K = 4;
                alpha = .9;
                % Run PCM
                [clusters, CS, CT] = EvolutionaryClustering(algorithm, dataSet,...
                    removedIndices, K, alpha, graph_structure, edge_weight, 'sigma', sigma);
                
            case 'PCQ'
                graph_structure = 'complete graph';
                edge_weight = 'gaussian';
                sigma = .5;
                K = 4;
                alpha = .9;
                % Run PCQ
                [clusters, CS, CT] = EvolutionaryClustering(algorithm, dataSet,...
                    removedIndices, K, alpha, graph_structure, edge_weight, 'sigma', sigma);
                
            case 'Self Tuning'
                neighbor_num = 15;
                cluster_num_choices = [2,3,4,5];
                [clusters, qualityRLS] = SelfTuning(dataSet, neighbor_num, cluster_num_choices);
                
            case 'Self Tuning PCM'
                alpha = 0.5;
                neighbor_num = 15;
                cluster_num_choices = [2,3,4,5];
                [clusters, qualityRLS] = SelfTuningEvolutionary('PCM', dataSet, removedIndices, alpha, neighbor_num, cluster_num_choices);

            case 'Self Tuning PCQ'
                alpha = 0.5;
                neighbor_num = 15;
                cluster_num_choices = [2,3,4,5];
                [clusters, qualityRLS] = SelfTuningEvolutionary('PCQ', dataSet, removedIndices, alpha, neighbor_num, cluster_num_choices);
                
            otherwise
                disp('Algorithm not supported')
                
        end
        
    case 'addingData'
        load('AddingdataSet2.mat');
        axesLabel = [{'x'}, {'y'}];

        switch algorithm
            case 'PCM'
                graph_structure = 'complete graph';
                edge_weight = 'gaussian';
                sigma = .5;
                K = 4;
                alpha = .5;
                % Run PCM
                [clusters, CS, CT] = EvolutionaryClustering(algorithm, dataSet,...
                    removedIndices, K, alpha, graph_structure, edge_weight, 'sigma', sigma);
                
            case 'PCQ'
                graph_structure = 'complete graph';
                edge_weight = 'gaussian';
                sigma = .5;
                K = 4;
                alpha = .5;
                % Run PCQ
                [clusters, CS, CT] = EvolutionaryClustering(algorithm, dataSet,...
                    removedIndices, K, alpha, graph_structure, edge_weight, 'sigma', sigma);
                 
            case 'Self Tuning'
                neighbor_num = 15;
                cluster_num_choices = [2,3,4,5];
                [clusters, qualityRLS] = SelfTuning(dataSet, neighbor_num, cluster_num_choices);
                
            case 'Self Tuning PCM'
                alpha = 0.5;
                neighbor_num = 15;
                cluster_num_choices = [2,3,4,5];
                [clusters, qualityRLS] = SelfTuningEvolutionary('PCM', dataSet, removedIndices, alpha, neighbor_num, cluster_num_choices);

            case 'Self Tuning PCQ'
                alpha = 0.5;
                neighbor_num = 15;
                cluster_num_choices = [2,3,4,5];
                [clusters, qualityRLS] = SelfTuningEvolutionary('PCQ', dataSet, removedIndices, alpha, neighbor_num, cluster_num_choices);
                
            otherwise
                disp('Algorithm not supported')
                
        end        
        
        
    case 'hogData'
        load('hogData.mat');
        axesLabel = [{'Latitude'}, {'Longitude'}];
        
        switch algorithm
            case 'PCM'
                graph_structure = 'complete graph';
                edge_weight = 'gaussian';
                sigma = .001;
                K = 4;
                alpha = .9;
                % Run PCM
                [clusters, CS, CT] = EvolutionaryClustering(algorithm, dataSet,...
                    removedIndices, K, alpha, graph_structure, edge_weight, 'sigma', sigma);
                
            case 'PCQ'
                graph_structure = 'complete graph';
                edge_weight = 'gaussian';
                sigma = .001;
                K = 4;
                alpha = .9;
                % Run PCQ
                [clusters, CS, CT] = EvolutionaryClustering(algorithm, dataSet,...
                    removedIndices, K, alpha, graph_structure, edge_weight, 'sigma', sigma);
                
            case 'Self Tuning'
                neighbor_num = 15;
                cluster_num_choices = [2,3,4,5];
                [clusters, qualityRLS] = SelfTuning(dataSet, neighbor_num, cluster_num_choices);
                
            case 'Self Tuning PCM'
                alpha = 0.9;
                neighbor_num = 15;
                cluster_num_choices = [2,3,4,5];
                [clusters, qualityRLS] = SelfTuningEvolutionary('PCM', dataSet, removedIndices, alpha, neighbor_num, cluster_num_choices);

            case 'Self Tuning PCQ'
                alpha = 0.9;
                neighbor_num = 15;
                cluster_num_choices = [2,3,4,5];
                [clusters, qualityRLS] = SelfTuningEvolutionary('PCQ', dataSet, removedIndices, alpha, neighbor_num, cluster_num_choices);
                
            otherwise
                disp('Algorithm not supported')        
        end
        
    otherwise
        disp('Unknown dataset')
end

%% Display Clusters
colors = [1,0,0;
          0,1,0;
          0,0,1;
          1,1,0;
          1,0,1;
          0,1,1;
          0,0,0
          .5,.5,.5
          .5,.5,0
          0,.5,.5];
      
symbols = [{'o'},{'s'},{'d'},{'v'},{'h'},{'p'},{'>'},{'<'},{'.'},{'*'}];
T = size(dataSet,2);
axisValues = findDataAxis(dataSet);
color_code_clusters(algorithm,dataName,clusters,T,1,colors,symbols,axisValues,axesLabel,movieName);

%% Plot Costs
if strcmp(algorithm,'PCM') || strcmp(algorithm,'PCQ')       
    figure(2)
    subplot(1,3,1)
    plot(alpha*CS+(1-alpha)*CT)
    title({algorithm,'Overall Cost',['alpha = ', num2str(alpha)]})
    xlabel('t')
    ylabel('Overall Cost')
    subplot(1,3,2)
    plot(CS)
    title({algorithm,'Snapshot Cost',['alpha = ', num2str(alpha)]})
    xlabel('t')
    ylabel('Snapshot Cost')
    subplot(1,3,3)
    plot(CT)
    title({algorithm,'Temporal Cost',['alpha = ', num2str(alpha)]})
    xlabel('t')
    ylabel('Temporal Cost')


elseif strcmp(algorithm, 'Self Tuning') || strcmp(algorithm, 'Self Tuning PCM')
    figure(2)
    plot(qualityRLS,'LineWidth',3)
    grid on
    title({algorithm,'Cluster Quality'})
end