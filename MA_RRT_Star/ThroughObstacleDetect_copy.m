function [Intersection] = ThroughObstacleDetect_copy(Xnew, Ynew, Parent, Intersection, edges, NodeMatrix)
agents=3;
% We look per obstacle if it crosses the voronoi region so that we can adjust the edges function per voronoi region to include only those obstacles inside or crossing this region
Edges=cell(agents+1,1);
Edges{1}=edges;
for a=1:height(Edges{1})/4
    %we need b to be the corresponding row numbers in the edges matrix
    for b=4*(a-1):4*a
    %c is the number of the partition we are working in
    %[Xvrn, Yvrn]=polyxpoly([xline(c)], [yline(c)], Edges{1}(b,[1 3]), Edges{1}(b,[2 4]));
    %Tvrn=[Xvrn, Yvrn]
    [in]=inpolygon(edges(:,[1 3]),edges(:,[2 4]));
    VRN=edges(in)
    end
end




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