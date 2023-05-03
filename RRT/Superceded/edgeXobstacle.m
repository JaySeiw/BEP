function [valid, intx] = edgeXobstacle(NewX, NewY, Parent, RectangleMatrix)
global NodeMatrix;
%RectangleMatrix=readmatrix('RectangleMatrix.csv'); %Rectanglematrix with [i,x,y,w,h]
% NewX:randXNode[x1]
% NewY:randYNode[y1]
%ParentNode: x and y coordinates of the parent node [x2,y2]
% edges: a matrix representing all the lines of the obstacles. (size N x 4
% in the form N x [x1, y1, x2, y2])
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

% Check if the line between NewNode and ParentNode intersects with any of the lines
intx = polyxpoly([NewX, NodeMatrix(Parent,1)], [NewY, NodeMatrix(Parent,2)], edges(:,1:2), edges(:,3:4));

% If there is an intersection point, the line is invalid
if ~isempty(intx)
    valid = false;
else
    valid = true;
end
end