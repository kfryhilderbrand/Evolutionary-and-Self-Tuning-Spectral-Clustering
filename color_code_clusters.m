function color_code_clusters(algorithm, dataName, clusters, T, fig, colors, symbols, axes, axesLabel, varargin)

%% color code clusters based on centroid similarity
%%   color_code_clusters(clusters,T,fig,colors)
%%  Input:
%%        clusters = 
%%        T = number of timesteps in data
%%        fig = figure number to be used
%%        colors = array of potential colors to be used
%%        axes = axes of the figure
%%
%%

if ~isempty(varargin{1})
    movie = 1;
    movieName = varargin{1};
else
    movie = 0;
end

% initialize figure
figure(fig)

% loop over each timestep 1->T
for t=1:T
    % clear the figure
    cla
    % turn on hold
    hold on
    
    % determine number of clusters (num_clusters)
    [~,num_clusters] = size(clusters{t});
    
    % initialize current timestep matrices
    centers = zeros(num_clusters,2);
    cluster_colors = -ones(num_clusters,3);

    % find centroid of each cluster
    for k = 1:num_clusters
        centers(k,:) = mean(clusters{t}{k},1);
    end
    
    % if first timestep, initialize cluster colors randomly
    if t == 1
        cluster_colors = colors(1:num_clusters,:);
        
    % else assign colors based on previous timesteps
    else
        % calculate distances between centers at current and previous
        % timesteps
        dist = dist2(centers, old_centers);
        % find indicy of closest previous center for each current center
        [~,move] = min(dist,[],2);
        
        % if number of clusters has increased
        if num_clusters > old_num_clusters
            % loop over each current cluster
            for i = 1:num_clusters
                % find how many clusters are closest to same previous
                % cluster center
                num = find(move == move(i));
                % if only one cluster corresponds to previous center
                % cluster
                if length(num) == 1 || dist(i,move(i)) == min(dist(:,move(i))) && (i == 1 || sum(ismember(cluster_colors,old_cluster_colors(move(i),:),'rows')) == 0)
                    % cluster maintains previous color
                    cluster_colors(i,:) = old_cluster_colors(move(i),:);
                    
                % if first cluster to be examined and multiple current
                % clusters correspond to same previous cluster
                elseif i == 1
                    % find currently unused colors
                    [potential_colors, ~] = find(~ismember(colors,old_cluster_colors,'rows'));
                    % assign an unused color to current cluster
                    cluster_colors(i,:) = colors(potential_colors(1),:);
                    
                % if other clusters correspond to same prior cluster by
                % same distance
                else
                    % find currently unused colors (including those
                    % assigned this timestep)
                    [potential_colors, ~] = find(~ismember(colors,[cluster_colors; old_cluster_colors],'rows'));
                    % assign an unused color to current cluster
                    cluster_colors(i,:) = colors(potential_colors(1),:);
                end
            end
        % if number of clusters has not increased
        elseif length(unique(move)) == length(move)
            % each cluster gets color of preious closest center
            cluster_colors = old_cluster_colors(move,:);
        else
            [a,b] = unique(move);
            cluster_colors(b,:) = old_cluster_colors(move(b),:);
            
            c = find(~ismember(1:num_clusters,b));
            for i = 1:(num_clusters - length(b))
                % find currently unused colors (including those
                % assigned this timestep)
                [potential_colors, ~] = find(~ismember(colors,cluster_colors,'rows'));
                % assign an unused color to current cluster
                cluster_colors(c(i),:) = colors(potential_colors(1),:);                            
            end
                
        end
    end
    
    
    % Plot each current timestep cluster
    for k = 1:num_clusters
        [~,index] = ismember(cluster_colors(k,:), colors, 'rows');
        scatter(clusters{t}{k}(:,1), clusters{t}{k}(:,2), symbols{index},'markeredgecolor', [0 0 0],'markerfacecolor', cluster_colors(k,:))
    end
    
    % Clear history from previous loop
    clear old_num_clusters old_centers old_cluster_colors
    
    % Save current cluster and color data
    old_num_clusters = num_clusters;
    old_centers = centers;
    old_cluster_colors = cluster_colors;
    
    % Clear current data holders
    clear num_clusters centers cluster_colors
    
    % set figure axes, draw, and hold for 0.1 seconds
    axis(axes)
    title({algorithm,dataName})
    xlabel(axesLabel{1}) 
    ylabel(axesLabel{2})
    grid on
    
    if movie;
        mov(t) = getframe(fig);
    end
    drawnow
    
    pause(.1)
    
end

if movie
    vidObj = VideoWriter(movieName,'Motion JPEG AVI');
    vidObj.FrameRate = 10;
    open(vidObj)
    for t=1:T
        writeVideo(vidObj,mov(t));
    end;
    close(vidObj);
end

end