function [ C, m ] = KMeansClusteringPlusPlus( X, K, displayText, varargin )
%% K-means clustering
[n, d] = size(X);
m_old = repmat(realmax,K,d);

% Initialize means
if isempty(varargin)
    % Choose the means using the k-means++ algorithm
    perm = randperm(n);
    m = X(perm(1),:);
    C = ones(n,1);
    for i = 2:K
       % Find closest distance to already chosen means
       D =  min(dist2(X,m),[],2);
       % Find a PDF and CDF for the k-means++ D^2 weighting distribution
       pdf = D.^2./sum(D.^2);
       cdf = cumsum(pdf);
       [cdf, mask] = unique(cdf);
       % Pick a realization using the cdf inverse
       m(i,:) = interp1(cdf, X(mask,:), rand); 
    end
else
    m = varargin{1}; % User can pass in desired starting means
end

tolerance = 0;
iteration = 1;

if displayText
    disp(['Starting K-means clustering with ', num2str(K), ' clusters'])
    disp(['Algorithm terminates when ||m_new - m_old|| (Cluster change) <= ', num2str(tolerance)])
    disp('-----------------------------------------------------------')
end

while(norm(m_old - m) > tolerance)
    m_old = m;
    
    % Find cluster mappings
    [~, C] = min(dist2(X,m),[],2);
    
    % Recaclulate the cluster centroids
    for l=1:K
        indices = find(C == l);
        m(l,:) = 1/length(indices).*sum(X(indices,:));
        if any(isnan(m(l,:)))
            m(l,:) = m_old(l,:);
        end
    end
    
    if displayText
        disp(['Iteration #', num2str(iteration), '    Cluster Change: ', num2str(norm(m_old - m))])
    end
    iteration = iteration + 1; % Update iteration count
end

end

