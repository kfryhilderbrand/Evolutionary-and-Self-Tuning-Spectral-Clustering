function [clusters, CS_Q] = SelfTuningEvolutionary(algorithm, dataSet, removedIndices, alpha, neighbor_num, CLUSTER_NUM_CHOICES)

beta = 1-alpha;

if ~(exist('evrot','file') == 3)
    mex evrot.cpp;
end

if ~(exist('scale_dist','file') == 3)
    mex scale_dist.cpp;
end

T = size(dataSet,2);
clusters = cell(1,T);

for j=1:T
    X = dataSet{j}';
    X_orig = X;
    
    %% centralize and scale the data
    X = X - repmat(mean(X),size(X,1),1);
    X = X/max(max(abs(X)));
    
    %%%%%%%%%%%%%%%%% Build affinity matrices
    D = dist2(X,X);              %% Euclidean distance
    [~,A_LS,~] = scale_dist(D,floor(neighbor_num/2)); %% Locally scaled affinity matrix
   
    
    if j > 1
        switch algorithm
            case 'PCM'
                % Compute matrix used for PCM
                if ~isempty(removedIndices) % nodes were removed
                    old_Vr(removedIndices{j},:) = [];
                end
                
                n1 = size(old_Vr,1);
                n2 = size(A_LS,1);
                
                if n2 > n1
                    G = (1/n1)*ones(n2-n1,1)*ones(1,n1)*old_Vr;
                    old_Vr = [old_Vr;G];
                end
                
                % M = alpha*W_bar{t} + beta*Y{t-1}*Y{t-1}'
                M = alpha*A_LS + beta*(old_Vr*old_Vr');
                
                
            case 'PCQ'
                % Compute matrix used for PCQ
                
                if ~isempty(removedIndices) % nodes were removed
                    old_A_LS(removedIndices{j},:) = [];
                    old_A_LS(:,removedIndices{j}) = [];
                end
                
                n1 = size(old_A_LS,1);
                n2 = size(A_LS,1);
                
                if n2 > n1 % Nodes were added
                    E_1 = (1/n1).*old_A_LS*ones(n1,1)*ones(n2-n1,1)';
                    F_1 = (1/n1^2).*ones(n1,1)'*old_A_LS*ones(n1,1)*ones(n2-n1,1)*ones(n2-n1,1)';
                    old_A_LS = [old_A_LS,E_1;E_1',F_1];
                end
                
                % M = alpha*W_bar{t} + beta*W_bar{t-1}
                M = alpha*A_LS + beta*old_A_LS;
                
            otherwise
                disp('Unknown algorithm')
        end
    else
        M = A_LS;
        
    end
    
    old_A_LS = A_LS;
    
    %% Zero out diagonal
    ZERO_DIAG = ~eye(size(X,1));
    M = M.*ZERO_DIAG;
    
    %%%%%%%%%%%%%%% ZelnikPerona Rotation clustering with local scaling (RLS)
    [clusts_RLS, rlsBestGroupIndex, qualityRLS, Vr] = cluster_rotate(M,CLUSTER_NUM_CHOICES,0,1);
    
    if j == 1
        old_Vr = Vr{rlsBestGroupIndex};
    end
    
    fprintf('timestep %d\n', j);
    fprintf('Automatically chose %d clusters\n', length(clusts_RLS{rlsBestGroupIndex}));
    
    clusters{j} = cell(1,length(clusts_RLS{rlsBestGroupIndex}));
    for k = 1:length(clusts_RLS{rlsBestGroupIndex})
        clusters{j}{k} = X_orig(clusts_RLS{rlsBestGroupIndex}{k},:);
    end
    
    %%%%%%%%%%%%%%%%%%% Cost
    CS_Q(j) = qualityRLS(rlsBestGroupIndex);

    old_Vr = Vr{rlsBestGroupIndex};
end

end







