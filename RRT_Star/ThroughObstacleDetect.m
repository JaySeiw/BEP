function [intersection] = ThroughObstacleDetect(Xnew, Ynew, Parent, intersection, edges, NodeMatrix)
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
        end
    end
end
end