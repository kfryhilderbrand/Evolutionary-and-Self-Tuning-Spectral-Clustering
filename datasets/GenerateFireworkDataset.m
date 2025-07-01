%% Script to generate the 2D Firework Dataset
clear; clc;
rng(0);

%% Initialize Parameters
numPoints = 500;
numClusters = 4;
pointsPerCluster = numPoints/numClusters;
numWaypoints = 3;
numFramesPerWaypoint = 30;
mu = [0; 0];
sigma = .05;
t = 1/numFramesPerWaypoint;
dataSet = cell(1,numWaypoints*numFramesPerWaypoint+1); % Initialize cell to store data
clusteredPoints = cell(1,numWaypoints*numFramesPerWaypoint+1); % Initialize cell to store data
randomizeTrajectory = true;
epsilon = .075; % trajectory variation
removedIndices = cell(1,numWaypoints*numFramesPerWaypoint+1);

%% Define Desired Cluster Positions at Each split
desiredClusterPositions = cell(1,numWaypoints);

%% 1
% initialClusterPosition = [0, 0, 0, 0; ...
%                           0, 0, 0, 0];
% 
% desiredClusterPositions{1} = [1,  1, -1, -1; ...
%                               0,  0,  0,  0];
% desiredClusterPositions{2} = [1,  1, -1, -1; ...
%                               1, -1, -1,  1];                         
% desiredClusterPositions{3} = [ 0,  0, -1,  1; ...
%                                1, -1,  0,  0];   
% desiredClusterPositions{4} = [ 0,  0, -1,  0; ...
%                                0, -1,  0,  0];   
% desiredClusterPositions{5} = [ 0,  0,  0,  0; ...
%                                0,  0,  0,  0];   
% desiredClusterPositions{6} = [1,  1, -1, -1; ...
%                               1, -1, -1,  1]; 
                          
%% 2
initialClusterPosition = [1, -1, -1, 1; ...
                         -1,  1, -1, 1];

desiredClusterPositions{1} = [1, -1, -1, 1; ...
                             -1,  1, -1, 1];
                          
desiredClusterPositions{2} = [1, -1, -1, 1; ...
                             -1,  1, -1, 1];                      
                          
desiredClusterPositions{3} = [1, -1, -1, 1; ...
                             -1,  1, -1, 1]; 
                          
%% A few assertions
assert(mod(pointsPerCluster,1) == 0, 'The number of points must be divisible by the number of clusters.')
for i=1:numWaypoints
    assert(all(size(desiredClusterPositions{i}) == [2,numClusters]), 'Desired cluster positions must be defined for all clusters, and for all waypoints')
end

%% Set up a single cluster for the initial frame
for i = 1:numClusters
    mu(:,(i-1)*pointsPerCluster+1:i*pointsPerCluster) = repmat(initialClusterPosition(:,i),1,pointsPerCluster);
end
dataSet{1} = normrnd(mu,sigma);
clusteredPoints{1} = reshape(dataSet{1},2,pointsPerCluster,numClusters);

for i = 1:numWaypoints
    for j=1:numFramesPerWaypoint
        for k = 1:numClusters
            index = (i-1)*numFramesPerWaypoint + j;
            points = clusteredPoints{index}(:,:,k);
            delta = desiredClusterPositions{i}(:,k) - mean(clusteredPoints{(i-1)*numFramesPerWaypoint+1}(:,:,k),2);
            clusteredPoints{index+1}(:,:,k) = points + repmat(t*delta, 1, pointsPerCluster);
            if randomizeTrajectory
                clusteredPoints{index+1}(:,:,k) = clusteredPoints{index+1}(:,:,k) + normrnd(repmat([0;0],1,pointsPerCluster),epsilon);
            end
        end
        dataSet{index+1} = reshape(clusteredPoints{index+1},2,numPoints);
    end
end

save('fourGaussianData','dataSet','removedIndices')

%% Display 
figure(1)

for k = 1:numWaypoints
    for j = 1:numFramesPerWaypoint
        scatter(dataSet{(k-1)*numFramesPerWaypoint + j}(1,:),dataSet{(k-1)*numFramesPerWaypoint + j}(2,:))
        axis([-2,2,-2,2])
        drawnow
        pause(.1)
    end
end










