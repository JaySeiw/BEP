function [intersection] = IntersectionDetector(Xnew, Ynew, Parent, ObstacleMatrix, Height, intersection)
global NodeMatrix;
global RectangleMatrix;
% set k to 1 as counter of rows starting at the first row
k=1;
%going through obstacles within row k
while k<Height+1
    % Check if node is within obstacle
    Xi=discretize(Xnew,[ObstacleMatrix(k,1),ObstacleMatrix(k,3)])==1;
    Yi=discretize(Ynew,[ObstacleMatrix(k,2),ObstacleMatrix(k,4)])==1;
    if Xi&&Yi==1
        % Set counter to break the while loop, because an intersection has been found
        k=Height+1;
        % If node is not in obstacle continue to next row
        intersection=1;
    else
        k=k+1;
    end
end
% If marker has not yet been set to 1, then we will check for crossing of veretice through edges
if intersection==0
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
    [intx, inty] = polyxpoly([Xnew, NodeMatrix(Parent,1)], [Ynew, NodeMatrix(Parent,2)], edges(:,1:2), edges(:,3:4));
    % If there is an intersection point, the line is invalid
    if isempty(intx)&isempty(inty)
       intersection=0; 
    else
       %intersection=1;
    end
end
end