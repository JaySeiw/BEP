function [debris, BinLocation, line1, line2, line3]=PartitionPerlinDebris(environment)
%rng default; % Saves the random numbers seed
environment=[
1,2,3,4,4;
2,45,45,5,5;
3,35,2,4,4;
4,30,24,6,6];
t = 0;
while t==0
    %environment = Ustart;
    A = perlin_debris(environment);
    X = A;
    %% Plot the generated debris
    %plot(X(:,1),X(:,2),'.');
   
    opts = statset('Display','final');
    [idx,C] = kmeans(X,3,'Distance','cityblock','Replicates',5,'Options',opts); %X=debris x-y-coordinates, 3 is no of clusters, 5 is no of iterations and picks lowest sum of distances
    CentXCol = C(:, 1); %x-coordinates for the centroids
    CentYCol = C(:, 2); %y-coordinates for the centroids 
    
    plot(X(idx==1,1),X(idx==1,2),'r.','MarkerSize',15)  %plots the debris in the first centroid              
    plot(X(idx==2,1),X(idx==2,2),'k.','MarkerSize',15)  %plots the debris in the second centroid  
    plot(X(idx==3,1),X(idx==3,2),'w.','MarkerSize',15)  %plots the debris in the third centroid  
    plot(C(:,1),C(:,2),'kx','MarkerSize',15,'LineWidth',3)%plots the centroids
    voronoi(CentXCol, CentYCol);% Draw Voronoi for given set points
    [vx, vy] = voronoi(CentXCol, CentYCol);
    [vx vy]
    CrossPoint = [vx(1, 1), vy(1, 1)];
    %CrossPoint
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
line1 = [vx(1,1) vy(1,1) vy(2,1) vx(2,1)];
line2 = [vx(1,2) vy(1,2) vx(2,2) vy(2,2)];
line3 = [vx(1,3) vy(1,3) vx(2,3) vy(2,3)];



VoronoiEdge=cell(4,2);
VoronoiEdge(1,:)=BinCoordinates;
VoronoiEdge(2,:)={[vx(1,1) vy(1,1)], [vx(2,1) vy(2,1)]};
VoronoiEdge(3,:)={[vx(1,2) vy(1,2)], [vx(2,2) vy(2,2)]};
VoronoiEdge(4,:)={[vx(1,3) vy(1,3)], [vx(2,3) vy(2,3)]};
VoronoiEdge
%{
    for l=2:4
for d=1:2
    if VoronoiEdge{l,2}(d)<0
        VoronoiEdge{l,2}(d)=0;
    elseif VoronoiEdge{l,2}(d)>50
        VoronoiEdge{l,2}(d)=50;
    end
end
end
%}
 %make a check if angle is negative, then make angle absolute and add pi
Theta=zeros(3,1);
Theta(1)=atan2(line1y,line1x);
Theta(2)=atan2(line2y,line2x);
Theta(3)=atan2(line3y,line3x);
Theta

for g=1:3
if Theta(g)<0
    Theta(g)=2*pi+Theta(g);
end
end
Theta

Middle=zeros(3,1);
if Theta(1)<pi&Theta(2)<pi
    Middle(1)=0.5*(Theta(1)+Theta(2));
elseif Theta(1)>pi&Theta(2)>pi
    Middle(1)=0.5*(Theta(1)+Theta(2));
else
    Middle(1)=Theta(1)+0.5*(Theta(2)-Theta(1));
end

if Theta(2)<pi&Theta(3)<pi
    Middle(2)=0.5*(Theta(2)+Theta(3));
elseif Theta(2)>pi&Theta(3)>pi
    Middle(2)=0.5*(Theta(2)+Theta(3));
else
    Middle(2)=Theta(2)+0.5*(Theta(3)-Theta(2));
end

if Theta(1)<pi&Theta(3)<pi
    Middle(3)=0.5*(Theta(1)+Theta(3));
elseif Theta(1)>pi&Theta(3)>pi
    Middle(3)=0.5*(Theta(1)+Theta(3));
else
    Middle(3)=Theta(3)+0.5*(Theta(3)-Theta(1));
end
%Middle(1)=0.5*(Theta(1)+Theta(2));
%Middle(2)=0.5*(Theta(2)+Theta(3));
%Middle(3)=0.5*(Theta(1)+Theta(3));
Middle
Start=zeros(3,2);
Start(1,:)=(0.5*[cos(Middle(1)) sin(Middle(1))])+CrossPoint;
Start(2,:)=(0.5*[cos(Middle(2)) sin(Middle(2))])+CrossPoint;
Start(3,:)=(0.5*[cos(Middle(3)) sin(Middle(3))])+CrossPoint;
Start





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
hold off