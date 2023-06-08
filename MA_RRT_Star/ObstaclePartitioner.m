function [Edges] = ObstaclePartitioner(edges,VoronoiEdge)
% We look per obstacle if it crosses the voronoi region so that we can adjust the edges function per voronoi region to include only those obstacles inside or crossing this region
Edges=cell(4,1);
Edges{1}=edges;

%go per partition
for a=1:3
    EdgesCrossTemp=double.empty;
    %check if edge crosses voronoi partition
    %Convert X and Y row vectors in cell back to vector
    Xtr=[VoronoiEdge{a+1,1}(1) VoronoiEdge{a+1,3} VoronoiEdge{a+1,1}(1)];
    Ytr=[VoronoiEdge{a+1,1}(2) VoronoiEdge{a+1,4} VoronoiEdge{a+1,1}(2)];
    %go per edge
    for b=1:height(edges)
        %Determine intersection
        [xPart, yPart] = polyxpoly(Xtr,Ytr,edges(b,[1 3]),edges(b,[2 4])) ;
        %if there is nothing in the cell, then do nothing
        if isempty([xPart, yPart])
            %if intersection is true then we will add this edge to the edge matrix for the voronoi partition
        else
            EdgesCrossTemp=vertcat(EdgesCrossTemp,edges(b,:));
            %disp('polyxpoly');
        end
    end
    %EdgesCrossTemp
    %add the edges matrix to the corresponding cell for the partition we're in right now
    Edges{a+1}=vertcat(Edges{a+1},EdgesCrossTemp);
    EdgesInTemp=double.empty;
    %now we will check if obstacle is inside polygon by checking the entire obstacle through verifying that all edge points are inside
    c=1;
    while c~=height(edges)+1
        [in, on] =inpolygon(edges([c, c+1, c+2, c+3],[1 3]), edges([c, c+1, c+2, c+3],[2 4]), Xtr, Ytr);
        %[in2, on2] =inpolygon(edges(c+1,[1 3]), edges(c+1,[2 4]), Xtr, Ytr);
        %[in3, on3] =inpolygon(edges(c+2,[1 3]), edges(c+2,[2 4]), Xtr, Ytr);
        %[in4, on4] =inpolygon(edges(c+3,[1 3]), edges(c+3,[2 4]), Xtr, Ytr);
        %buzz=[in1, on1]
        for d=1:4
            if in(d)==1&on(d)==0
                %in1(d,[1 2])
                %on1(d,[1 2])
                %hush=edges(c+d-1,:)
                %disp('inpolygon')
                EdgesInTemp=vertcat(EdgesInTemp,edges(c+d-1,:));
            end
        end

        c=c+4;
    end
    %EdgesInTemp
    %add EdgesInTemp to the edges matrix
    Edges{a+1}=vertcat(Edges{a+1},EdgesInTemp);
    %Edges{a+1}
    %% add voronoi partition edges to the edges matrix
    %set lines per partition p1=[l1 l2] p2=[l2 l3] p3=[l1 l3]
    if a==1
        e=[2 3];
    elseif a==2
        e=[3 4];
    else
        e=[2 4];
    end
    %if (VoronoiEdge{e(1),2}(1)==0&VoronoiEdge{e(2),2}(2)==50)|(VoronoiEdge{e(1),2}(1)==50&VoronoiEdge{e(1),2}(2)==0)
    PartitionEdges=zeros(2,4);
    PartitionEdges(1,:)=[VoronoiEdge{e(1),1}([1 2]) VoronoiEdge{e(1),2}([1 2]) ];
    PartitionEdges(2,:)=[VoronoiEdge{e(2),1}([1 2]) VoronoiEdge{e(2),2}([1 2]) ];
    Edges{a+1}=vertcat(Edges{a+1},PartitionEdges);
    %{
    vwidth=width(cell2mat(VoronoiEdge(a+1,1)));
    voronoimatrix=zeros(2,4);
    for e=1:vwidth
        voronoi1temp=[VoronoiEdge{a+1,1}(e) VoronoiEdge{a+1,2}(e)];
        voronoi2temp=[VoronoiEdge{a+1,1}(e+1) VoronoiEdge{a+1,2}(e+1)];
        voronoitemp=horzcat(voronoi1temp,voronoi2temp);
        voronoimatrix(e,:)=voronoitemp
    end
    %Edges{a+1}=vertcat(Edges{a+1},voronoimatrix);
    %}
    %Edges{a+1}
end
end
