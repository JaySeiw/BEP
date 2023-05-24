rng default; % Saves the random numbers seed
%% Debris generation
%X = [randn(100,2)*0.75+ones(100,2);
%    randn(100,2)*0.5-ones(100,2)];

k = 1;
maxdebris = 20;
X = zeros(maxdebris,2);
while k<=21
    X(k,:) = [50*rand, 50*rand];
    k = k+1;
end 
%% Plot the generated debris
figure;
plot(X(:,1),X(:,2),'.');

opts = statset('Display','final');
[idx,C] = kmeans(X,3,'Distance','cityblock',...
    'Replicates',5,'Options',opts); %X=debris x-y-coordinates, 3 is no of clusters, 5 is no of iterations and picks lowest sum of distances
%{
%Gives the centroids as goals for the RRT if we want to use that
Centroid1 = C(1,:);
Goal1 = Centroid1;

Centroid2 = C(2,:);
Goal2 = Centroid2;

Centroid3 = C(3,:);
Goal3 = Centroid3;
%}
CentXCol = C(:, 1); %x-coordinates for the centroids
CentYCol = C(:, 2); %y-coordinates for the centroids

figure;
plot(X(idx==1,1),X(idx==1,2),'r.','MarkerSize',12)  %plots the debris in the first centroid              
hold on
plot(X(idx==2,1),X(idx==2,2),'b.','MarkerSize',12)  %plots the debris in the second centroid  
plot(X(idx==3,1),X(idx==3,2),'g.','MarkerSize',12)  %plots the debris in the third centroid  
plot(C(:,1),C(:,2),'kx',...                         %plots the centroids
     'MarkerSize',15,'LineWidth',3)
%% Draw Voronoi for given set points
voronoi(CentXCol, CentYCol)
%% Get edge coordinates for the voronoi
[vx, vy] = voronoi(CentXCol, CentYCol)
line1x = [vx(1, 1), vx(2, 1)];
line2x = [vx(1, 2), vx(2, 2)];
line3x = [vx(1, 3), vx(2, 3)];
line1y = [vy(1, 1), vy(2, 1)];
line2y = [vy(1, 2), vy(2, 2)];
line3y = [vy(1, 3), vy(2, 3)];

line1 = [vx(1, 1), vy(1, 1), vx(2,1), vy(2,1)];
line2 = [vx(1, 2), vy(1, 2), vx(2,2), vy(2,2)];
line3 = [vx(1, 3), vy(1, 3), vx(2,3), vy(2,3)];

hold off
