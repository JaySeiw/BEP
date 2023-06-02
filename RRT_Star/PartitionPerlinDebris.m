function [debris, BinLocation, line1, line2, line3, Cluster1, Cluster2, Cluster3]=PartitionPerlinDebris(environment)

%rng default; % Saves the random numbers seed
Ustart= [1,1,3,2,7; 
         2,1,8,7,2;
         3,6,3,2,7;
         4,20,10,6,5;
         5,11,26,3,9;
         6,25,30,8,6;
         7,40,20,7,10;
         8,12,16,3,2;
         9,25,2,12,3];
t = 0;
while t==0
    environment = Ustart;
    A = perlin_debris(environment);
    X = A;
    %% Plot the generated debris
    %plot(X(:,1),X(:,2),'.');
    opts = statset('Display','final');
    [idx,C] = kmeans(X,3,'Distance','cityblock',...
        'Replicates',5,'Options',opts); %X=debris x-y-coordinates, 3 is no of clusters, 5 is no of iterations and picks lowest sum of distances
    
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
    CrossPoint
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

plot(line1x, line1y, 'k');
plot(line2x, line2y, 'k');
plot(line3x, line3y, 'k');
scatter(CrossPoint(1, 1), CrossPoint(1, 2), 100,  'MarkerFaceColor', 'w', 'MarkerEdgeColor', 'k', 'LineWidth', 1);
hold off