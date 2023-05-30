function [debris]=debrisfunction(scenario)
% Define the size and shape of your graph
Xmax = 50;  % Number of rows
Ymax = 50;  % Number of columns

[ObstacleMatrix, RectangleMatrix ,~]=EnvironmentBuilder(scenario); %Obstaclematrix: [x1,y1,x2,y2], edges:  N x [x1, y1, x2, y2]
Height=height(RectangleMatrix); % Count rows of RectangleMatrix


% Generate random points throughout the graph
numPoints = 100;  % Adjust the total number of points
randdebris=zeros(numPoints,2); %preallocate debris matrix 2 columns
i=1;
while i<numPoints+1
x = rand * Xmax;  % Generate random x-coordinates
y = rand * Ymax;  % Generate random y-coordinates
Intersection = InObstacleDetectCopy(x, y, ObstacleMatrix, Height);
    if Intersection==0
    randdebris(i,:)=[x,y];
    i=i+1;
    end
end

% Create random hotspots
numHotspots = 5;  % Adjust the number of hotspots
hotspotRadius = 5;  % Adjust the hotspot radius
numHotspotPoints = 100;  % Adjust the number of points in each hotspot

hotspotcenters=zeros((numHotspots),2); %preallocate matrix with hotspot centers
i=1;
while i<numHotspots+1
    x_hotspot = rand * Xmax;  % Random x-coordinate for the hotspot center
    y_hotspot = rand * Ymax;  % Random y-coordinate for the hotspot center
    Intersection=InObstacleDetectCopy(x_hotspot,y_hotspot,ObstacleMatrix,Height);
    if Intersection==0
        hotspotcenters(i,:)=[x_hotspot,y_hotspot];
        i=i+1;
    end
end

numPoints=numHotspotPoints*numHotspots; %total numer of points surrounding the hotspots
hotspotpoints= zeros(numPoints,2); %preallocate matrix for points surrounding the hotspots
i=1;
while i<numPoints+1
    x_hotspot=hotspotcenters(i,1);
    y_hotspot=hotspotcenters(i,2);

    %theta = 2*pi*rand(numHotspotPoints, 1);  % Generate random angles
    theta = 2*pi*rand();  % Generate random angles
    %radius = hotspotRadius*sqrt(rand(numHotspotPoints, 1));  % Generate random radii
    radius = hotspotRadius*sqrt(rand());  % Generate random radii
    x_hotspot_points = x_hotspot + radius.*cos(theta);  % Calculate x-coordinates of hotspot points
    y_hotspot_points = y_hotspot + radius.*sin(theta);  % Calculate y-coordinates of hotspot points
    Intersection=InObstacleDetectCopy(x_hotspot_points,y_hotspot_points,ObstacleMatrix,Height);
    if Intersection==0
        hotspotpoints(i,:)=[x_hotspot_points,y_hotspot_points];
        i=i+1;
    end
    % % Combine hotspot points with the original points
    % x = [x; x_hotspot_points];
    % y = [y; y_hotspot_points];
end

debris=vertcat(randdebris,hotspotcenters,hotspotpoints);

% Visualize the debris distribution
figure
scatter(debris(:,1), debris(:,2), 'filled');
xlabel('x-coordinate');
ylabel('y-coordinate');