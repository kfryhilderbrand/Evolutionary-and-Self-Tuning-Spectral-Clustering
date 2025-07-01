function [clusters, qualityRLS] = SelfTuning(dataSet, neighbor_num, CLUSTER_NUM_CHOICES)

if ~(exist('evrot','file') == 3)
    mex evrot.cpp;
end

if ~(exist('scale_dist','file') == 3)
    mex scale_dist.cpp;
end

T = size(dataSet,2);

clusters = cell(1,T);
qualityRLS = zeros(1,T);

for j=1:T
    X = dataSet{j}';
    X_orig = dataSet{j}';

    %% centralize and scale the data
    X = X - repmat(mean(X),size(X,1),1);
    X = X/max(max(abs(X)));
    
    %%%%%%%%%%%%%%%%% Build affinity matrices
    D = dist2(X,X);              %% Euclidean distance
    [~,A_LS,~] = scale_dist(D,floor(neighbor_num/2)); %% Locally scaled affinity matrix
    
    %% Zero out diagonal
    ZERO_DIAG = ~eye(size(X,1));
    A_LS = A_LS.*ZERO_DIAG;
    
    %%%%%%%%%%%%%%% ZelnikPerona Rotation clustering with local scaling (RLS)
    [clusts_RLS, rlsBestGroupIndex, qualityRLStmp] = cluster_rotate(A_LS,CLUSTER_NUM_CHOICES,0,1);
    qualityRLS(j) = qualityRLStmp(rlsBestGroupIndex);
    fprintf('timestep %d\n', j);
%     qualityRLS
    fprintf('Automatically chose %d clusters\n', length(clusts_RLS{rlsBestGroupIndex}));
    
    clusters{j} = cell(1,length(clusts_RLS{rlsBestGroupIndex}));
    for k = 1:length(clusts_RLS{rlsBestGroupIndex})
        clusters{j}{k} = X_orig(clusts_RLS{rlsBestGroupIndex}{k},:);
    end
    
end
end









