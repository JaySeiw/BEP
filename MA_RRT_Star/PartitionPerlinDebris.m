function [Start,VoronoiEdge, Cluster1, Cluster2, Cluster3]=PartitionPerlinDebris(environment)

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

line1x = [vx(1, 1), vx(2, 1)];
line2x = [vx(1, 2), vx(2, 2)];
line3x = [vx(1, 3), vx(2, 3)];
line1y = [vy(1, 1), vy(2, 1)];
line2y = [vy(1, 2), vy(2, 2)];
line3y = [vy(1, 3), vy(2, 3)];

BinCoordinates = [vx(1, 1), vy(1, 1)];
line1 = [vx(1, 1), vy(1, 1), vx(2,1), vy(2,1)];
line2 = [vx(1, 2), vy(1, 2), vx(2,2), vy(2,2)];
line3 = [vx(1, 3), vy(1, 3), vx(2,3), vy(2,3)];
Cluster1 = [X(idx==1,1),X(idx==1,2)];
Cluster2 = [X(idx==2,1),X(idx==2,2)];
Cluster3 = [X(idx==3,1),X(idx==3,2)];
line1x = vx(2,1)-vx(1,1);
line2x = vx(2,2)-vx(1,1);
line3x = vx(2,3)-vx(1,1);
line1y = vy(2,1)-vy(1,1);
line2y = vy(2,2)-vy(1,1);
line3y = vy(2,3)-vy(1,1);

BinCoordinates = {CrossPoint, []};
line1 = [vx(1,1) vy(1,1) vy(2,1) vx(2,1)];
line2 = [vx(1,2) vy(1,2) vx(2,2) vy(2,2)];
line3 = [vx(1,3) vy(1,3) vx(2,3) vy(2,3)];


%Make a cell to export for future use
VoronoiEdge=cell(4,2);
%starting point of all lines
VoronoiEdge(1,:)=BinCoordinates;
%coordinates of lines 1, 2 and 3
VoronoiEdge(2,:)={[vx(1,1) vy(1,1)], [vx(2,1) vy(2,1)]};
VoronoiEdge(3,:)={[vx(1,2) vy(1,2)], [vx(2,2) vy(2,2)]};
VoronoiEdge(4,:)={[vx(1,3) vy(1,3)], [vx(2,3) vy(2,3)]};
% calculate angles of lines
Theta=zeros(3,1);
Theta(1)=atan2(line1y,line1x);
Theta(2)=atan2(line2y,line2x);
Theta(3)=atan2(line3y,line3x);
%convert all lines to an interval of [0,2*pi)
for g=1:3
    if Theta(g)<0
        Theta(g)=2*pi+Theta(g);
    end
    for e=1:2
    if VoronoiEdge{g+1,2}(e)>50
        
    elseif VoronoiEdge{g+1,2}(e)<0
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
plot([VoronoiEdge{2,1}(1) VoronoiEdge{2,2}(1)], [VoronoiEdge{2,1}(2) VoronoiEdge{2,2}(2)], 'k');
plot([VoronoiEdge{3,1}(1) VoronoiEdge{3,2}(1)], [VoronoiEdge{3,1}(2) VoronoiEdge{3,2}(2)], 'k');
plot([VoronoiEdge{4,1}(1) VoronoiEdge{4,2}(1)], [VoronoiEdge{4,1}(2) VoronoiEdge{4,2}(2)], 'k');
scatter(CrossPoint(1, 1), CrossPoint(1, 2), 100,  'MarkerFaceColor', 'w', 'MarkerEdgeColor', 'k', 'LineWidth', 1);
plot(Start(1,1),Start(1,2), 'md')%, "filled")
plot(Start(2,1),Start(2,2), 'md')%, "filled")
plot(Start(3,1),Start(3,2), 'md')%, "filled")
