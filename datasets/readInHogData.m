% Load in hog data
clear;clc;
[~,~,raw] = xlsread('of2014-1241_data');
dataText = raw(1,:);
raw(1,:) = [];
raw(end-3:end,:) = [];

[n,d] = size(raw);
noiseSigma = 0;
totalnumPoints = 6000;
pointsPerTimeStep = 500;
overlap = 25;
totalTimeSteps = (totalnumPoints-pointsPerTimeStep)/overlap;
assert(mod(totalTimeSteps,1) == 0)

indicesToRemove = [];
includeCollarIDs = [49250,31711,33170,33458];
for i = 1:n
   if isempty(find(cell2mat(raw(i,1)) == includeCollarIDs, 1))
      indicesToRemove = vertcat(indicesToRemove,i);
   end
end

raw(indicesToRemove,:) = [];
[n,d] = size(raw);
dataSet = cell(1,totalTimeSteps);
removedIndices = cell(1,totalTimeSteps);

i = 1;
dataIndex = 1;
timeIndex = 1;

while (timeIndex <= totalTimeSteps) && (i <= n)
    
   dataSet{timeIndex}(:,dataIndex) = [cell2mat(raw(i,4)); cell2mat(raw(i,5))] + normrnd([0;0],noiseSigma);
   dataIndex = dataIndex+1;
    
    if (dataIndex > pointsPerTimeStep) && (mod(dataIndex-1,pointsPerTimeStep) == 0)
        removedIndices{timeIndex} = 1:overlap;
        timeIndex = timeIndex + 1;
        i = i - (pointsPerTimeStep-overlap);
        dataIndex = 1;
    end
    
    i = i+1;
end

disp('Finished loading in hog data')
save('hogData','dataSet','removedIndices')