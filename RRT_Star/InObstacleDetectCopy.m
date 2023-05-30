function [Intersection] = InObstacleDetectCopy(Xnew, Ynew, ObstacleMatrix, Height)
    Intersection = 0;
    % Set k to 1 as counter of rows starting at the first row
    k = 1;
    % Going through obstacles within row k
    while k < Height + 1
        % Check if node is within obstacle
        Xi = any(discretize(Xnew, [ObstacleMatrix(k,1), ObstacleMatrix(k,3)]) == 1);
        Yi = any(discretize(Ynew, [ObstacleMatrix(k,2), ObstacleMatrix(k,4)]) == 1);
        if Xi && Yi
            % Set counter to break the while loop because an intersection has been found
            k = Height + 1;
            % If node is not in obstacle, continue to the next row
            Intersection = 1;
        else
            k = k + 1;
        end
    end
end
