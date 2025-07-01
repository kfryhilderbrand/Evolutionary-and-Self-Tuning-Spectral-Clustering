function [ axisValues ] = findDataAxis( dataSet )

% Find Dimesions for axis
minX = realmax;
minY = realmax;
maxX = -realmax;
maxY = -realmax;

for t = 1:size(dataSet,2)
    tmpMinX = min(dataSet{t}(1,:));
    tmpMinY  = min(dataSet{t}(2,:));
    tmpMaxX = max(dataSet{t}(1,:));
    tmpMaxY  = max(dataSet{t}(2,:));
    
    if tmpMinX < minX
        minX = tmpMinX;
    end
    
    if tmpMinY < minY
        minY = tmpMinY;
    end
    
    if tmpMaxX > maxX
        maxX = tmpMaxX;
    end
    
    if tmpMaxY > maxY
        maxY = tmpMaxY;
    end
end

axisValues = [minX,maxX,minY,maxY];

end

