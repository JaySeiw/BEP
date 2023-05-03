function [intersection, Test] = IntersectionDetector(Xnew, Ynew, Parent, ObstacleMatrix, edges, Height, intersection)
global NodeMatrix;



%% Point in obstacle part
% set k to 1 as counter of rows starting at the first row
k=1;
%going through obstacles within row k
while k<Height+1
    % Check if node is within obstacle
    Xi=discretize(Xnew,[ObstacleMatrix(k,1),ObstacleMatrix(k,3)])==1;
    Yi=discretize(Ynew,[ObstacleMatrix(k,2),ObstacleMatrix(k,4)])==1;
    if Xi&&Yi==1
        % Set counter to break the while loop, because an intersection has been found
        k=Height+1;
        % If node is not in obstacle continue to next row
        intersection=1;
    else
        k=k+1;
    end
end

%% Vertice through obstacle part

% If marker has not yet been set to 1, then we will check for crossing of vertice through edges
if intersection~=1
    i=1;
    %count up until last row of edges
    while i < size(edges,1)+1
        % Check if the line between NewNode and ParentNode intersects with any of the lines
        [xi, yi] = polyxpoly([NodeMatrix(Parent,1), Xnew], [NodeMatrix(Parent,2), Ynew], edges(i,[1 3]), edges(i,[2 4]));
        Test=[xi, yi];
        % If there is an intersection point, the line is invalid
        if isempty(Test)
            intersection=0;
            i=i+1;
        else
            i=size(edges,1)+1;
            intersection=1;
            disp('intersection');
        end
    end
end
end