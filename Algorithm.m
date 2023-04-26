%%Algorithm

close all hidden;
% Graph Variables:
Xmax=50;% Maximum x-dimension
Ymax=50;% Maximum y-dimension

% Import ObstacleMatrix and rectanglematrix from ObstacleBuilder
ObstacleMatrix=readmatrix('ObstacleMap.csv'); %map of obstacles with [x1,y1,x2,y2]
RectangleMatrix=readmatrix('RectangleMatrix.csv'); %Rectanglematrix with [i,x,y,w,h]
Height=height(RectangleMatrix); %count rows of matrix
% Create 0 matrix with [3 columns: C1&C2 for coordinates and C3 for parent node]
Nodes=1000; %N number of nodes
Length=3; %L max length for a node to be connected to an other
mat=zeros(1,3);
%% Node creation
start=[4,5,0];
%add the start to mat
mat(1,:)=start;
%set i to one for the node counter starting in row 1
i=1;
%going through all the nodes from i to nodes+1
while i<Nodes+1
    % Assign random coordinates
    randXNode=Xmax*rand;
    randYNode=Ymax*rand;
    % Locating nearest point
    %make matrix where [x1-xi y1-yi] with i rows because we are not intereste in points of zero starting with starting point
    DM=mat(:,[1 2])-[randXNode randYNode];
    %calculate length from new point to all points
    LM=[sqrt(DM(:,1).^2+DM(:,2).^2)];
    %find closest point that is max 5 in length
    InRangePoint=find(LM<=Length);
    %if d is empty (there are no points within limit) then make point on the line of closest point where the new length is 5
    if isempty(InRangePoint)
        %find smallest length to point
        ClosestPoint=find(LM==min(LM));
        %disp('long');
        %calculate angle
        theta=atan(DM(ClosestPoint,2)/DM(ClosestPoint,1));
        %set point in same line, but with length L
        randXNode=Length*cos(theta)+mat(ClosestPoint,1);
        randYNode=Length*sin(theta)+mat(ClosestPoint,2);
        %make matrix where [x1-xi y1-yi] with i rows because we are not intereste in points of zero starting with starting point
        DM=mat(:,[1 2])-[randXNode randYNode];
        %calculate length from new point to all points
        LM=[sqrt(DM(:,1).^2+DM(:,2).^2)];
        %re-find smallest length to point
        ClosestPoint=find(LM==min(LM));
        Parent=ClosestPoint;
    else
        %determine row where parent node is
        Parent=find(LM==min(LM));
    end

    
    %Set marker to 0
    marker=0;
    % set k to 1 as counter of rows starting at the first row
    k=1;
    %going through obstacles within row k
    while k<Height+1
        % Check if node is within obstacle
        Xi=discretize(randXNode,[ObstacleMatrix(k,1),ObstacleMatrix(k,3)])==1;
        Yi=discretize(randYNode,[ObstacleMatrix(k,2),ObstacleMatrix(k,4)])==1;
        %check if edge intersects with obstacle
        [valid] = edgeXobstacle(randXNode,randYNode, Parent);

        if (Xi&&Yi==1)||valid==false
            %disp('crossing');
            % Re-assign new random coordinates
            randXNode=Xmax*rand;
            randYNode=Ymax*rand;
            % Reset row counter back to first entry
            k=1;
            % If node is not in obstacle continue to next row
            marker=1;
        else
            k=k+1;
        end

    end


    %if any alteration has been made in the obstacle while loop, then the random point will have been changed. This means we need to re-evaluate the parent and possibly reposition the point completely
    if marker==0
        %disp('pass'); % Expecting N-1 passes with a few extra crossings maybe
        %go to the end of mat and add a new row where the new values are inserted
        mat(end+1,:)=[randXNode randYNode Parent];
        %cycle to next point
        i=i+1;
    else

    end
end



%% drawing everything
figure ('Name','Nodes');
%hold on so that all further drawings are stacked on top of eachother
hold on
%place the start as a blue diamond
scatter(mat(1,1),mat(1,2), 'bdiamond');
axis([0, Xmax, 0, Ymax]);
%place all the nodes as red crosses
scatter(mat(2:Nodes+1,1),mat(2:Nodes+1,2),'rx');
% Draw all rectangles
for q=1:Height
    rectangle('position', RectangleMatrix(q,[2,3,4,5]));
end
%set k to 2 because we need to look at the parent of the first node, which is the origin
k=2;
% look for all the points within mat. We want to make a plot that contains [X1 X2]=dx and [Y1 Y2]=dy
while k<Nodes+2
    %X1 is in row k and X2 is in the row of the parent (mentioned in column 3)
    dx=[mat(k,1), mat(mat(k,3),1)];
    dy=[mat(k,2), mat(mat(k,3),2)];
    %plot the line with a blue colour
    plot(dx, dy, 'b');
    %cycle to next row
    k=k+1;
end



%function to check if the edge connecting the new node to the parent node doesnt intersect with any obstacles


function [valid] = edgeXobstacle(NewX,NewY, ParentNode)
% NewNode:(randXNode and randYNode) [x1,y1]
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
[intx, inty] = polyxpoly([NewX, ParentNode(1)], [NewY, ParentNode(2)], edges(:,1:2), edges(:,3:4));

% If there is an intersection point, the line is invalid
if ~isempty(intx)
    valid = false;
else
    valid = true;
end
end
