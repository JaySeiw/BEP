%%Scenario with an obstacle with many protrusions
close all hidden;
%start=4,5
%goal=16,45

%create obstacle matrix for rectangles where columns are: index, x, y, w, h
%this is a matrix with columns: x, y, w, h
ObstacleMatrix= [1,20,25,5,11;
                 2,22,31,6,4;
                 3,21,15,3,15;
                 4,14,24,8,5;
                 5,5,7,6,4;
                 6,31,2,14,4;
                 7,36,20, 2,6;
                 8,40,40,5,2;
                 9,8,35,3,4];


%map of obstacles with [x1,y1,x2,y2]
ObstacleMap = [ObstacleMatrix(:,2:3), ObstacleMatrix(:,2:3) + ObstacleMatrix(:,4:5)];

%global edges; %edges of the obstacles will be put into a matrix, 4 lines per rectangle means 4 rows per object
% edges: a matrix representing all the lines of the obstacles. (size N x 4 in the form N x [x1, y1, x2, y2])
    % first creating a matrix with all the edges of the obstacles in the form
    % (x1,y1,x2,y2) to use in the function
    % preallocate matrix to store edges (multiplied by 4 because each rectangle has 4 edges)
    edges = zeros(size(ObstacleMatrix,1)*4,4);
    for i = 1:size(ObstacleMatrix,1)
        x1 = ObstacleMatrix(i,2); % x coordinate of bottom left corner
        y1 = ObstacleMatrix(i,3); % y coordinate of bottom left corner
        w = ObstacleMatrix(i,4); % width of rectangle
        h = ObstacleMatrix(i,5); % height of rectangle
        % Extract edges and store in edges matrix
        edges((i-1)*4+1,:) = [x1,y1,x1+w,y1]; % bottom edge
        edges((i-1)*4+2,:) = [x1,y1,x1,y1+h]; % left edge
        edges((i-1)*4+3,:) = [x1+w,y1,x1+w,y1+h]; % right edge
        edges((i-1)*4+4,:) = [x1,y1+h,x1+w,y1+h]; % top edge
    end


figure;
hold on;

for i = 1:size(ObstacleMatrix, 1)
    rectangle('Position', ObstacleMatrix(i, 2:5),'FaceColor', 'k');
end
xlim([0,50])
ylim([0,50])


writematrix(ObstacleMap, 'ObstacleMap.csv');
writematrix(ObstacleMatrix, 'RectangleMatrix.csv');
writematrix(edges, 'edges.csv')