function [Start,VoronoiEdge, Cluster]=PartitionPerlinDebris(Xmax,Ymax,environment,ObstacleMatrix)

%rng default; % Sets default RNG value, does not save it
t = 0;
while t==0
    A = perlin_debris(environment);
    X = A;
    %% Plot the generated debris
    %plot(X(:,1),X(:,2),'.');
    opts = statset('Display','final');
    %X=debris x-y-coordinates, 3 is no. of clusters, 5 is no. of iterations and picks lowest sum of distances
    [idx,C] = kmeans(X,3,'Distance','cityblock','Replicates',5,'Options',opts);
    CentXCol = C(:, 1); %x-coordinates for the centroids
    CentYCol = C(:, 2); %y-coordinates for the centroids
    Cluster1 = [X(idx==1,1),X(idx==1,2)];
    Cluster2 = [X(idx==2,1),X(idx==2,2)];
    Cluster3 = [X(idx==3,1),X(idx==3,2)];
    plot(X(idx==1,1),X(idx==1,2),'r.','MarkerSize',15)  %plots the debris in the first centroid
    plot(X(idx==2,1),X(idx==2,2),'k.','MarkerSize',15)  %plots the debris in the second centroid
    plot(X(idx==3,1),X(idx==3,2),'w.','MarkerSize',15)  %plots the debris in the third centroid
    %{
    plot(C(:,1),C(:,2),'kx',...                         %plots the centroids
         'MarkerSize',15,'LineWidth',3)
    %}
    plot(C(1,1),C(1,2),'kx','MarkerSize',15,'LineWidth',3, 'MarkerEdgeColor','r') %plots the centroids separately
    plot(C(2,1),C(2,2),'kx','MarkerSize',15,'LineWidth',3, 'MarkerEdgeColor','k') %plots the centroids seperately
    plot(C(3,1),C(3,2),'kx','MarkerSize',15,'LineWidth',3, 'MarkerEdgeColor','w') %plots the centroids separately
    voronoi(CentXCol, CentYCol);% Draw Voronoi for given set points
    [vx, vy] = voronoi(CentXCol, CentYCol);
    CrossPoint = [vx(1, 1), vy(1, 1)];
    %% Make sure the starting point is inside the graph
    if vx(1, 1)<50 && vx(1, 1)>0 && vy(1, 1)<50 && vy(1, 1)>0
        t = 1;
    end
end


%% Data that could be used in the RRT

line1x = vx(2,1)-vx(1,1);
line2x = vx(2,2)-vx(1,1);
line3x = vx(2,3)-vx(1,1);
line1y = vy(2,1)-vy(1,1);
line2y = vy(2,2)-vy(1,1);
line3y = vy(2,3)-vy(1,1);
BinCoordinates = {CrossPoint, []};

%Make a cell to export for future use
VoronoiEdge=cell(4,4);
%starting point of all lines
VoronoiEdge(1,[1 2])=BinCoordinates;
%coordinates of lines 1, 2 and 3
VoronoiEdge(2,[1 2])={[vx(1,1) vy(1,1)], [vx(2,1) vy(2,1)]};
VoronoiEdge(3,[1 2])={[vx(1,2) vy(1,2)], [vx(2,2) vy(2,2)]};
VoronoiEdge(4,[1 2])={[vx(1,3) vy(1,3)], [vx(2,3) vy(2,3)]};
% calculate angles of lines
Theta=zeros(3,1);
Theta(1)=atan2(line1y,line1x);
Theta(2)=atan2(line2y,line2x);
Theta(3)=atan2(line3y,line3x);
%convert all lines to within interval [0 Xmax 0 Ymax]
sectors=zeros(3,5);
for g=1:3
    q=1;
    % if x-coordinate surpasses 50
    if VoronoiEdge{g+1,2}(1)>50
        %set new y
        VoronoiEdge{g+1,2}(2)=CrossPoint(2) + (Xmax-CrossPoint(1)) * tan(Theta(g));
        %set new x
        VoronoiEdge{g+1,2}(1)=50;
        %if x-coordinate surpasses 0
    elseif VoronoiEdge{g+1,2}(1)<0
        %set new y
        VoronoiEdge{g+1,2}(2)=CrossPoint(2)-CrossPoint(1)*tan(Theta(g));
        %set new x
        VoronoiEdge{g+1,2}(1)=0;
        %if y-coordinate surpasses 50
    end
    if VoronoiEdge{g+1,2}(2)>50
        %set new x
        VoronoiEdge{g+1,2}(1)=CrossPoint(1)+(Ymax-CrossPoint(2))/tan(Theta(g));
        %set new y
        VoronoiEdge{g+1,2}(2)=50;
        %if y-coordinate surpasses 0
    elseif VoronoiEdge{g+1,2}(2)<0
        %set new x
        VoronoiEdge{g+1,2}(1)=CrossPoint(1)-CrossPoint(2)/tan(Theta(g));
        %set new y
        VoronoiEdge{g+1,2}(2)=0;
        %elseif any(VoronoiEdge{g+1,2(1) VoronoiEdge}
    end
%{
    while q~=0
        if all([any(VoronoiEdge{g+1,2}>=0) any(VoronoiEdge{g+1,2}<=50)]==false)
            disp('niet goed')
            VoronoiEdge{g+1,2}=VoronoiEdge{g+1,2}+[0.1*cos(Theta(g)) 0.1*sin(Theta(g))];
        else
            q=0;
        end
    end
%}
    if Theta(g)<0
        Theta(g)=2*pi+Theta(g);
    end

    if discretize(Theta(g),[(7/4)*pi, 2*pi])==1||discretize(Theta(g),[0, (1/4)*pi])==1
        sectors(g,1)=1;
    elseif discretize(Theta(g),[(1/4)*pi, (3/4)*pi])==1
        sectors(g,1)=2;
    elseif discretize(Theta(g),[(3/4)*pi, (5/4)*pi])==1
        sectors(g,1)=3;
    elseif discretize(Theta(g),[(5/4)*pi, (7/4)*pi])==1
        sectors(g,1)=4;
    end
end
%we fill in the rest of the data: column two is destination of travel and column 3 is the amount of lines needed to reach column two
sectors(1,2)=sectors(2,1);
sectors(2,2)=sectors(3,1);
sectors(3,2)=sectors(1,1);
sectors(1,3)=abs(sectors(1)-sectors(2));
sectors(2,3)=abs(sectors(2)-sectors(3));
sectors(3,3)=abs(sectors(3)-sectors(1));
sectors(1,[4 5])=[1 2];
sectors(2,[4 5])=[2 3];
sectors(3,[4 5])=[3 1];
for g=1:3
    if sectors(g,3)==3
        sectors(g,3)=1;
    end
    sectors(g,3)=sectors(g,3)+1;
    avg=0.5*(sectors(g,1)+sectors(g,2));
    d=[3 1 2];
    if  sectors(g,[1 2]) == [4 1]

    elseif sectors(g,[1 2]) == [1 4]
        sectors(g,[1 2])=sectors(g,[2 1]);
        sectors(g,[4 5])=sectors(g,[5 4]);
        %skips sector 1 4 situations, but checks if a line is within the sector sequence

    elseif sectors(d(g),1)==avg|sectors(d(g),2)==avg
        if sectors(g,1)>sectors(g,2)
        else
            sectors(g,[1 2])=sectors(g,[2 1]);
            sectors(g,[4 5])=sectors(g,[5 4]);
        end

    elseif sectors(g,1)>sectors(g,2)
        sectors(g,[1 2])=sectors(g,[2 1]);
        sectors(g,[4 5])=sectors(g,[5 4]);
    end
end

Journey=cell(3,2);
sequence=cell(4,1);
sequence{1}=[[50 0]  ; [50 50]];
sequence{2}=[[0  0]  ; [50 0]];
sequence{3}=[[0 50]  ; [0 0]];
sequence{4}=[[50 50] ; [0 50]];
for a=1:3
    %journey starts in a sector, and goes counterclockwise to the final sector
    b=0;
    %go until all lines (b) are added to vector
    while b<sectors(a,3)
        if b==0
            %add coordinates of first point
            xjourney=VoronoiEdge{sectors(a,4)+1,2}(1);
            yjourney=VoronoiEdge{sectors(a,4)+1,2}(2);
        else
            %move through the sequence
            xjourney=horzcat(xjourney,sequence{sectors(a,1)}(1,b));
            yjourney=horzcat(yjourney,sequence{sectors(a,1)}(2,b));

        end
        b=b+1;


    end
    %add coordinates of final point
    xjourney=horzcat(xjourney,VoronoiEdge{sectors(a,5)+1,2}(1));
    yjourney=horzcat(yjourney,VoronoiEdge{sectors(a,5)+1,2}(2));
    %write down x-sequence and y-sequence seperately
    VoronoiEdge{a+1,3}=xjourney;
    VoronoiEdge{a+1,4}=yjourney;
    Journey{a,1}=xjourney;
    Journey{a,2}=yjourney;
    plot(Journey{a,1},Journey{a,2},'k', 'linewidth',3)
end

Clusters=cell(3,1);
Clusters{1}=Cluster1;
Clusters{2}=Cluster2;
Clusters{3}=Cluster3;
Cluster=cell(3,1);
for k=1:3
    Xtr=[VoronoiEdge{k+1,1}(1) VoronoiEdge{k+1,3} VoronoiEdge{k+1,1}(1)];
    Ytr=[VoronoiEdge{k+1,1}(2) VoronoiEdge{k+1,4} VoronoiEdge{k+1,1}(2)];
    m=1;
    while m<4
        [in, ~] =inpolygon(C(m,1),C(m,2), Xtr, Ytr);
        if in==1
            Cluster{k}=Clusters{m};
            m=4;
        else
            m=m+1;
        end
    end
end



%% calculating middle angles between lines
%a lot of different angle configurations. This is probably also doable with cross and dot product, but it has some constraints to the lines we are using
% and I am too lazy to do that, so this is easy copy pasting, just a lot of code
Middle=zeros(3);
if Theta(1)>Theta(2) & Theta(1)>Theta(3)
    if Theta(2)>Theta(3)
        %angles between lines 1 and 3
        Middle(1,3)=0.6*(Theta(1)+Theta(3)-2*pi);
        Middle(3,1)=Middle(1,3);
        %angles between lines 1 and 2
        Middle(1,2)=0.5*(Theta(1)+Theta(2));
        Middle(2,1)=Middle(1,2);
        %angles between lines 2 and 3
        Middle(2,3)=0.5*(Theta(2)+Theta(3));
        Middle(3,2)=Middle(2,3);
    elseif Theta(2)<Theta(3)
        %angles between lines 1 and 2
        Middle(1,2)=0.5*(Theta(1)+Theta(2)-2*pi);
        Middle(2,1)=Middle(1,2);
        %angles between lines 1 and 3
        Middle(1,3)=0.5*(Theta(1)+Theta(3));
        Middle(3,1)=Middle(1,3);
        %angles between lines 2 and 3
        Middle(2,3)=0.5*(Theta(2)+Theta(3));
        Middle(3,2)=Middle(2,3);
    else
        disp('Error if 1')
    end
elseif Theta(1)>Theta(2) & Theta(1)<Theta(3)
    %angles between lines 2 and 3
    Middle(2,3)=0.5*(Theta(2)+Theta(3)-2*pi);
    Middle(3,2)=Middle(2,3);
    %angles between lines 1 and 2
    Middle(1,2)=0.5*(Theta(1)+Theta(2));
    Middle(2,1)=Middle(1,2);
    %angles between lines 1 and 3
    Middle(1,3)=0.5*(Theta(1)+Theta(3));
    Middle(3,1)=Middle(1,3);
elseif Theta(1)<Theta(2) & Theta(1)<Theta(3)
    if Theta(2)<Theta(3)
        %angles between lines 1 and 3
        Middle(1,3)=0.6*(Theta(1)+Theta(3)-2*pi);
        Middle(3,1)=Middle(1,3);
        %angles between lines 1 and 2
        Middle(1,2)=0.5*(Theta(1)+Theta(2));
        Middle(2,1)=Middle(1,2);
        %angles between lines 2 and 3
        Middle(2,3)=0.5*(Theta(2)+Theta(3));
        Middle(3,2)=Middle(2,3);
    elseif Theta(2)>Theta(3)
        %angles between lines 1 and 2
        Middle(1,2)=0.5*(Theta(1)+Theta(2)-2*pi);
        Middle(2,1)=Middle(1,2);
        %angles between lines 1 and 3
        Middle(1,3)=0.5*(Theta(1)+Theta(3));
        Middle(3,1)=Middle(1,3);
        %angles between lines 2 and 3
        Middle(2,3)=0.5*(Theta(2)+Theta(3));
        Middle(3,2)=Middle(2,3);
    else
        disp('Error if 3')
    end
elseif Theta(1)<Theta(2) & Theta(1)>Theta(3)
    Middle(1,2)=0.5*(Theta(1)+Theta(2));
    Middle(2,1)=Middle(1,2);

    Middle(1,3)=0.5*(Theta(1)+Theta(3));
    Middle(3,1)=Middle(1,3);

    Middle(2,3)=0.5*(Theta(2)+Theta(3)-2*pi);
    Middle(3,2)=Middle(2,3);
else
    disp('Error')
end
%% Making starting locations

Start=zeros(3,2);
%start between lines 1 and 2
Start(1,:)=(0.5*[cos(Middle(1,2)) sin(Middle(1,2))])+CrossPoint;
%start between lines 2 and 3
Start(2,:)=(0.5*[cos(Middle(2,3)) sin(Middle(2,3))])+CrossPoint;
%start between lines 3 and 1
Start(3,:)=(0.5*[cos(Middle(3,1)) sin(Middle(3,1))])+CrossPoint;
a=1;
d=1;
while a<4
    [Intersection] = InObstacleDetect(Start(a,1),Start(a,2), ObstacleMatrix);
    if Intersection==1
        Start(a,:)=Start(a,:)+[0.1 0.1]*d*((-1)^d);
        d=d+1;
    else
        a=a+1;
        d=1;
    end
end
Start=horzcat(Start,zeros(3,2));


%{
BinCoordinates
line1
line2
line3


%Gives the centroids as goals for the RRT if we want to use that
Centroid1 = C(1,:);
Goal1 = Centroid1;

Centroid2 = C(2,:);
Goal2 = Centroid2;

Centroid3 = C(3,:);
Goal3 = Centroid3;
%}
%% Plot Voronoi lines in white
plot([VoronoiEdge{2,1}(1) VoronoiEdge{2,2}(1)], [VoronoiEdge{2,1}(2) VoronoiEdge{2,2}(2)], 'k', 'LineWidth',3);
plot([VoronoiEdge{3,1}(1) VoronoiEdge{3,2}(1)], [VoronoiEdge{3,1}(2) VoronoiEdge{3,2}(2)], 'k', 'LineWidth',3);
plot([VoronoiEdge{4,1}(1) VoronoiEdge{4,2}(1)], [VoronoiEdge{4,1}(2) VoronoiEdge{4,2}(2)], 'k', 'LineWidth',3);
scatter(CrossPoint(1, 1), CrossPoint(1, 2), 100,  'MarkerFaceColor', 'w', 'MarkerEdgeColor', 'k', 'LineWidth', 1);
plot(Start(1,1),Start(1,2), 'md')%, "filled")
plot(Start(2,1),Start(2,2), 'md')%, "filled")
plot(Start(3,1),Start(3,2), 'md')%, "filled")
