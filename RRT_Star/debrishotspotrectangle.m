% Define the size and shape of your graph
Xmax = 50;  % Number of rows
Ymax = 50;  % Number of columns

% Generate random points throughout the graph
numPoints = 100;  % Adjust the total number of points
x = rand(numPoints, 1) * Xmax;  % Generate random x-coordinates
y = rand(numPoints, 1) * Ymax;  % Generate random y-coordinates

% Create random hotspots
numHotspots = 5;  % Adjust the number of hotspots
hotspotWidth = 2;  % Adjust the hotspot width
hotspotHeight = 8;  % Adjust the hotspot height

for i = 1:numHotspots
    x_hotspot = rand * (Xmax - hotspotWidth);  % Random x-coordinate for the hotspot center
    y_hotspot = rand * (Ymax - hotspotHeight);  % Random y-coordinate for the hotspot center
    
    numHotspotPoints = 100;  % Adjust the number of points in each hotspot
    x_hotspot_points = x_hotspot + rand(numHotspotPoints, 1) * hotspotWidth;  % Generate random x-coordinates within the hotspot width
    y_hotspot_points = y_hotspot + rand(numHotspotPoints, 1) * hotspotHeight;  % Generate random y-coordinates within the hotspot height
    
    % Combine hotspot points with the original points
    x = [x; x_hotspot_points];
    y = [y; y_hotspot_points];
end

% Visualize the debris distribution
figure;
scatter(x, y, '.');
title('Debris Distribution in the Bottom of the Ocean');
xlabel('x-coordinate');
ylabel('y-coordinate');
