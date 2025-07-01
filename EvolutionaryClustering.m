function [clusters, CS, CT] = EvolutionaryClustering(algorithm, dataSet, removedIndices, K, alpha, graph_structure, edge_weight, varargin)
%% Set up parameters
parser = inputParser;
addRequired(parser, 'algorithm');
addRequired(parser, 'dataSet');
addRequired(parser, 'removedIndices');
addRequired(parser, 'K');
addRequired(parser, 'alpha');
addRequired(parser, 'graph_structure');
addRequired(parser, 'edge_weight');
addParameter(parser, 'KNN', 10);
addParameter(parser, 'sigma', 10);
parse(parser, algorithm, dataSet, removedIndices, K, alpha, graph_structure, edge_weight, varargin{:});
KNN = parser.Results.KNN;
sigma = parser.Results.sigma;

beta = 1-alpha;

%% Initialize cell arrays to store results
T = size(dataSet,2);
W_bar = cell(1,T);
M = cell(1,T);
Y = cell(1,T);
C = cell(1,T);
CS = zeros(1,T);
CT = zeros(1,T);

clusters = cell(1,T);

%% Initialize Algorithm using Standard Spectral Clustering
disp(['t = 1/', num2str(T)])
W = WeightedAdjacencyMatrix(dataSet{1}, graph_structure, edge_weight, 'KNN', KNN, 'sigma', sigma );
D = sum(W); % Degree matrix
invSqrtD = diag(1./sqrt(D));
W_bar{1} = invSqrtD*W*invSqrtD;

% Find the k smalles eigenvalues of L
[V, E] = eig(W_bar{1});
E = diag(E);
[~, I] = sort(E,'descend');
Y{1} = V(:,I(1:K));
C{1} = KMeansClusteringPlusPlus(Y{1},K,false);

clusters{1} = cell(1,K);
for k = 1:K
    clusters{1}{k} = dataSet{1}(:, C{1} == k)';
end

%% Iterate through time and perform evolutionary spectral clustering

for t = 2:T
    disp(['t = ', num2str(t), '/', num2str(T)])
    W = WeightedAdjacencyMatrix(dataSet{t}, graph_structure, edge_weight, 'KNN', KNN, 'sigma', sigma );
    D = sum(W); % Degree vector
    invSqrtD = diag(1./sqrt(D));
    W_bar{t} = invSqrtD*W*invSqrtD;

    switch algorithm
        case 'PCM'
            % Compute matrix used for PCM
            if ~isempty(removedIndices) % nodes were removed
                Y{t-1}(removedIndices{t},:) = [];
            end
            
            n1 = size(Y{t-1},1);
            n2 = size(W_bar{t},1);
            
            if n2 > n1
                G = (1/n1)*ones(n2-n1,1)*ones(1,n1)*Y{t-1};
                Y{t-1} = [Y{t-1};G];
            end
            
            M{t} = alpha*W_bar{t} + beta*Y{t-1}*Y{t-1}';
            
            
        case 'PCQ'
            % Compute matrix used for PCQ
           
            if ~isempty(removedIndices) % nodes were removed
                W_bar{t-1}(removedIndices{t},:) = [];
                W_bar{t-1}(:,removedIndices{t}) = [];
            end
            
            n1 = size(W_bar{t-1},1);
            n2 = size(W_bar{t},1);
          
            if n2 > n1 % Nodes were added
                E_1 = (1/n1).*W_bar{t-1}*ones(n1,1)*ones(n2-n1,1)';
                F_1 = (1/n1^2).*ones(n1,1)'*W_bar{t-1}*ones(n1,1)*ones(n2-n1,1)*ones(n2-n1,1)';
                W_bar{t-1} = [W_bar{t-1},E_1;E_1',F_1];
            end
            
            M{t} = alpha*W_bar{t} + beta*W_bar{t-1};
            
            
        otherwise
            disp('Unknown algorithm')
    end
    
        
    % Find the k largest eigenvalues of M
    [V, E] = eig(M{t});
    E = diag(E);
    E = real(E);
    [~, I] = sort(E,'descend');
    Y{t} = V(:,I(1:K));
    
    switch algorithm
        case 'PCM'
            % Calculate Temporal and Snapshot Costs
            CS(t) = K-trace(Y{t}'*W_bar{t}*Y{t});
            CT(t) = (1/2)*norm(Y{t}*Y{t}'-Y{t-1}*Y{t-1}','fro')^2;
        case 'PCQ'
            % Calculate Temporal and Snapshot Costs
            CS(t) = K-trace(Y{t}'*W_bar{t}*Y{t});
            CT(t) = K-trace(Y{t}'*W_bar{t-1}*Y{t});
        otherwise
            disp('Unknown algorithm')
    end
    
    % Perform K-means clustering on Y
    C{t} = KMeansClusteringPlusPlus(Y{t},K,false);

    clusters{t} = cell(1,K);
    for k = 1:K
        clusters{t}{k} = dataSet{t}(:, C{t} == k)';
    end
   
end

% No costs on the first node
CS(1) = [];
CT(1) = [];


end
