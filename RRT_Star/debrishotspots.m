% Define the size and shape of your graph
Xmax = 50;  % Number of rows
Ymax = 50;  % Number of columns

% Generate random points throughout the graph
numPoints = 100;  % Adjust the total number of points
x = rand(numPoints, 1) * Xmax;  % Generate random x-coordinates
y = rand(numPoints, 1) * Ymax;  % Generate random y-coordinates

% Create random hotspots
numHotspots = 5;  % Adjust the number of hotspots
hotspotRadius = 5;  % Adjust the hotspot radius

for i = 1:numHotspots
    x_hotspot = rand * Xmax;  % Random x-coordinate for the hotspot center
    y_hotspot = rand * Ymax;  % Random y-coordinate for the hotspot center
    
    numHotspotPoints = 100;  % Adjust the number of points in each hotspot
    theta = 2*pi*rand(numHotspotPoints, 1);  % Generate random angles
    radius = hotspotRadius*sqrt(rand(numHotspotPoints, 1));  % Generate random radii
    x_hotspot_points = x_hotspot + radius.*cos(theta);  % Calculate x-coordinates of hotspot points
    y_hotspot_points = y_hotspot + radius.*sin(theta);  % Calculate y-coordinates of hotspot points
    
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
