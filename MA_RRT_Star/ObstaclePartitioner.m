function [Edges] = ObstaclePartitioner(edges,agents,voronoiedge)
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
            %if intersection is true then we will add this edge to the edge matrix for the voronoi partition
        else
            EdgesCrossTemp=vertcat(EdgesCrossTemp,edges(b,:));
            %disp('added edge to partition');
        end
    end
    %EdgesCrossTemp
    %add the edges matrix to the corresponding cell for the partition we're in right now
    Edges{a+1}=vertcat(Edges{a+1},EdgesCrossTemp);
    EdgesInTemp=double.empty;
    %now we will check if obstacle is inside polygon by checking the entire obstacle through verifying that all edge points are inside
    c=1;
    while c+3~=height(edges)
        [in1, on1] =inpolygon(edges([c, c+1, c+2, c+3],[1 3]), edges([c, c+1, c+2, c+3],[2 4]), Xtr, Ytr);
        %[in2, on2] =inpolygon(edges(c+1,[1 3]), edges(c+1,[2 4]), Xtr, Ytr);
        %[in3, on3] =inpolygon(edges(c+2,[1 3]), edges(c+2,[2 4]), Xtr, Ytr);
        %[in4, on4] =inpolygon(edges(c+3,[1 3]), edges(c+3,[2 4]), Xtr, Ytr);
        %buzz=[in1, on1]
        for d=1:4
            if in1(d)==1&on1(d)==0
                %in1(d,[1 2])
                %on1(d,[1 2])
                %hush=edges(c+d-1,:)
                EdgesInTemp=vertcat(EdgesInTemp,edges(c+d-1,:));
            end
        end
        %EdgesInTemp

        c=c+4;
    end
    Edges{a+1}=vertcat(Edges{a+1},EdgesInTemp);
    %cell2mat(Edges(2,:))
    %Edges{a+1}
    %hoogte=height(Edges(2))
    %Edges
    vwidth=width(cell2mat(voronoiedge(a,1)))-1;
    voronoimatrix=zeros(vwidth,4);
    for e=1:vwidth
        %voronoiedge{a}(1,e)
        voronoi1temp=[voronoiedge{a,1}(e) voronoiedge{a,2}(e)];
        voronoi2temp=[voronoiedge{a,1}(e+1) voronoiedge{a,2}(e+1)];
        voronoitemp=horzcat(voronoi1temp,voronoi2temp);
        voronoimatrix(e,:)=voronoitemp;
    end
    Edges{a+1}=vertcat(Edges{a+1},voronoimatrix);
    %cell2mat(Edges(2,:))
end
end
