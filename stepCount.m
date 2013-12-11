function [count steps] = stepCount (vec, threshold, timeMin, timeMax )
    edges = diff(vec > threshold);
    edgeTimes = find(edges == 1 | edges == -1);
    posEdges = find(edges == 1);
    if( posEdges(1) == edgeTimes(1) )
        edgeTimes = downsample(edgeTimes, 2);
    else
        edgeTimes = downsample(edgeTimes(2:end), 2);
    end
    countLoc = find((diff(edgeTimes) > timeMin & diff(edgeTimes) < timeMax) == 1 );
    count = numel(countLoc);
    
    steps = zeros(size(vec));
    steps(edgeTimes(countLoc)) = 1;


    
end
