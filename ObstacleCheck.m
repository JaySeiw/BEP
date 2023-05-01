function [marker] = ObstacleCheck(Height, randXNode, randYNode, ObstacleMatrix, marker)
% set k to 1 as counter of rows starting at the first row
k=1;
%going through obstacles within row k
while k<Height+1
    % Check if node is within obstacle
    Xi=discretize(randXNode,[ObstacleMatrix(k,1),ObstacleMatrix(k,3)])==1;
    Yi=discretize(randYNode,[ObstacleMatrix(k,2),ObstacleMatrix(k,4)])==1;
    if Xi&&Yi==1 
        % Set counter to break the while loop, because an intersection has been found
        k=Height+1;
        % If node is not in obstacle continue to next row
        marker=1;
    else
        k=k+1;
    end
end