function [Intersection] = ThroughObstacleDetect(Xnew, Ynew, Parent, Intersection, edges, NodeMatrix)
agents=3;
% We look per obstacle if it crosses the voronoi region so that we can adjust the edges function per voronoi region to include only those obstacles inside or crossing this region
Edges=cell(agents+1,1);
voronoiedge=cell(agents,2);
voronoiedge(1,:)={[0 25 50 0], [50 25 50 50]};
voronoiedge(2,:)={[0 25 25 0 0], [50 25 0 0 50]};
voronoiedge(3,:)={[25 25 50 50 25], [0 25 50 0 0]};
Edges{1}=edges;

%go per partition
for a=1:agents
    EdgesCrossTemp=double.empty;
    %go per edge
    for b=1:height(edges)
        %check if edge crosses voronoi partition
        %Convert X and Y row vectors in cell back to vector
        Xtr=cell2mat(voronoiedge(a,1));
        Ytr=cell2mat(voronoiedge(a,2));
        %Determine intersection
        [xPart, yPart] = polyxpoly(Xtr,Ytr,edges(b,[1 3]),edges(b,[2 4])) ;
        %if there is nothing in the cell, then do nothing
        if isempty([xPart, yPart])
        %if intersection is true then we will add this edge to the edge matrix for the voronoi partitio
        else
            EdgesCrossTemp=vertcat(EdgesCrossTemp,edges(b,:));
            %disp('added edge to partition');
        end
    end
    %add the edges matrix to the corresponding cell for the partition we're in right now
    Edges{a+1}=vertcat(Edges{a+1},EdgesCrossTemp);
    EdgesInTemp=double.empty;
    %now we will check if obstacle is inside polygon by checking the entire obstacle through verifying that all edge points are inside
    for c=1:height(edges)/4
        c
    [in1, on1] =inpolygon(edges(c,[1 3]), edges(c,[2 4]), Xtr, Ytr);
    [in2, on2] =inpolygon(edges(c+1,[1 3]), edges(c+1,[2 4]), Xtr, Ytr);
    [in3, on3] =inpolygon(edges(c+2,[1 3]), edges(c+2,[2 4]), Xtr, Ytr);
    [in4, on4] =inpolygon(edges(c+3,[1 3]), edges(c+3,[2 4]), Xtr, Ytr);
    %testers=[in1]
    %in2
    %in3
    %in4
    if in1(1)==1&in2(1)==1&in3(1)==1&in4(1)==1
        %edges(c:c+3,:)
        %EdgesInTemp
        EdgesInTemp=vertcat(EdgesInTemp,edges(c:c+3,:));
    end
    EdgesInTemp
    Edges{a+1}=vertcat(Edges{a+1},EdgesInTemp);
    %Edges{a+1}=vertcat(Edges{a+1},EdgesInTemp);
    end
    %cell2mat(Edges(2,:))
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