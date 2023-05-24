function [Intersection] = ThroughObstacleDetect(Xnew, Ynew, Parent, Intersection, edges, NodeMatrix)
%% Vertice through obstacle part
% If marker has not yet been set to 1, then we will check for crossing of vertice through edges
if Intersection~=1
    i=1;
    %count up until last row of edges
    while i < height(edges)+1
        % Check if the line between NewNode and ParentNode intersects with any of the lines
        [Xi, Yi] = polyxpoly([NodeMatrix(Parent,1), Xnew], [NodeMatrix(Parent,2), Ynew], edges(i,[1 3]), edges(i,[2 4]));
        Test=[Xi, Yi];
        % If there is an intersection point, the line is invalid
        if isempty(Test)
            Intersection=0;
            i=i+1;
        else
            i=height(edges)+1;
            Intersection=1;
        end
    end
else
    Intersection=1;
end
end