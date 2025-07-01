%% Script to generate the 2D Firework Dataset
clear; clc;
rng(0);

%% Initialize Parameters
numPoints = 500;
numClusters = 4;
pointsPerCluster = numPoints/numClusters;
numWaypoints = 6;
numFramesPerWaypoint = 25;
mu = [0; 0];
sigma = .1;
t = 1/numFramesPerWaypoint;
dataSet = cell(1,numWaypoints*numFramesPerWaypoint); % Initialize cell to store data
clusteredPoints = cell(1,numWaypoints*numFramesPerWaypoint); % Initialize cell to store data
epsilonNoise = 1; % trajectory variation
epsilon = .2;
                          
%% Determine which type of point to add

%Create a vector of 1000 random values. Use the rand function to draw the values from a uniform distribution in the open interval, (50,100).
cases = 3;
iterations = 151;
r = randi([1,cases],151,1);

%% Set up a single cluster for the initial frame
dataSet{1} = normrnd(repmat(mu,1,numPoints),sigma);
clusteredPoints{1} = reshape(dataSet{1}(:,randperm(numPoints)),2,pointsPerCluster,numClusters);
M = 1;
for i = 1:numWaypoints
    for j=1:numFramesPerWaypoint
        for k = 1:numClusters
            index = (i-1)*numFramesPerWaypoint + j;
            points = clusteredPoints{index}(:,:,k);
                newData = normrnd(repmat([0;0],1,1),epsilonNoise);
            clusteredPoints{index+1}(:,:,k) = [points, newData];%pointsPerCluster)];
        end
        dataSet{index+1} = reshape(clusteredPoints{index+1},2,numPoints+numClusters*M);
        M=M+1;
    end
end

save('AddingdataSet','dataSet')

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

