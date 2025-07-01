function [ W ] = WeightedAdjacencyMatrix( X, graph_structure, edge_weight, varargin )

% ---------------------  Setup --------------------------------------
parser = inputParser;
addRequired(parser, 'X');
addRequired(parser, 'graph_structure');
addRequired(parser, 'edge_weight');
addParameter(parser, 'KNN', 10);
addParameter(parser, 'sigma', 10);
parse(parser, X, graph_structure, edge_weight, varargin{:});
k = parser.Results.KNN;
sigma = parser.Results.sigma;

switch graph_structure
    case 'k-nearest neighbor'
        ComputeGraph = @KNearestNeighborGraph;        
    case 'complete graph'
        ComputeGraph = @CompleteGraph;
    otherwise
        error('Unknown edge weight structure')
end

switch edge_weight
    case 'constant'
        ComputeEdgeWeights = @ConstantEdgeWeight;
    case 'gaussian'
        ComputeEdgeWeights = @GaussianEdgeWeight;
    otherwise
        error('Unknown edge weight structure')
end


% ---------------------  Compute W --------------------------------------
graph = ComputeGraph(X); 
W = ComputeEdgeWeights(X, graph);


%% Extra function definitions
function [ graph ] = KNearestNeighborGraph(X)
    n = size(X,2);
    graph = eye(n);
    
    d = dist2(X',X') + realmax*eye(n); % compute distance between points
    [~, indices] = sort(d,2); % sort distances from smallest to largest
    indices = indices(:,1:k); % take the first k indices
    
    % Comptute graph
    for i=1:n
        graph(i,indices(i,:)) = 1;
    end
    
end

function [ graph ] = CompleteGraph(X)
    % All points are connected
    graph = ones(size(X,2));
end


function [ W ] = ConstantEdgeWeight(~, graph)
    W = graph;
end

function [ W ] = GaussianEdgeWeight(X, graph)
    d = dist2(X',X');
    W = graph.*exp(-d.^2./(2*sigma^2));
end


end





