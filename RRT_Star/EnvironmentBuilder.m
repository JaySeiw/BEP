function [ObstacleMatrix, RectangleMatrix ,edges]= EnvironmentBuilder(scenario)
close all hidden;
%start=4,5
%goal=16,45
RectangleMatrix=scenario;
%map of obstacles with [x1,y1,x2,y2]
ObstacleMatrix = [RectangleMatrix(:,2:3), RectangleMatrix(:,2:3) + RectangleMatrix(:,4:5)];

%global edges; %edges of the obstacles will be put into a matrix, 4 lines per rectangle means 4 rows per object
% edges: a matrix representing all the lines of the obstacles. (size N x 4 in the form N x [x1, y1, x2, y2])
    % first creating a matrix with all the edges of the obstacles in the form
    % (x1,y1,x2,y2) to use in the function
    % preallocate matrix to store edges (multiplied by 4 because each rectangle has 4 edges)
    edges = zeros(size(RectangleMatrix,1)*4,4);
    for i = 1:size(RectangleMatrix,1)
        x1 = RectangleMatrix(i,2); % x coordinate of bottom left corner
        y1 = RectangleMatrix(i,3); % y coordinate of bottom left corner
        w = RectangleMatrix(i,4); % width of rectangle
        h = RectangleMatrix(i,5); % height of rectangle
        % Extract edges and store in edges matrix
        edges((i-1)*4+1,:) = [x1,y1,x1+w,y1]; % bottom edge
        edges((i-1)*4+2,:) = [x1,y1,x1,y1+h]; % left edge
        edges((i-1)*4+3,:) = [x1+w,y1,x1+w,y1+h]; % right edge
        edges((i-1)*4+4,:) = [x1,y1+h,x1+w,y1+h]; % top edge
    end

% commented out, as only for checking if obstacles are drawn correctly
%figure;
%hold on;

%for i = 1:size(RectangleMatrix, 1)
%    rectangle('Position', RectangleMatrix(i, 2:5), 'FaceColor', 'k');
%end
%xlim([0,50])
%ylim([0,50])

end