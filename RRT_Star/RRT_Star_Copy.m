
%function [outputs] = name(inputs); i am just a sample
close all hidden;
rng shuffle
seed_obj = rng;
seed = seed_obj.Seed;
%% Global variables:

Xmax=50;
Ymax=50;
RectangleMatrix=readmatrix("RectangleMatrix.csv"); % Rectanglematrix with [i,x,y,w,h]
ObstacleMatrix=readmatrix('ObstacleMap.csv'); % Map of obstacles with [x1,y1,x2,y2]
Height=height(RectangleMatrix); % Count rows of RectangleMatrix
Length=3; % L max length for a node to be connected to an other
Nodes=2000; %go crazy with the numbers!
Start=[4,5,0,0]; %matrix of all the nodes created with x,y coordinates its closest parent and the cost (total path length to the start)
NodeMatrix=zeros(1,4);
NodeMatrix(1,:)=Start; % Add start to nodematrix

% the edges part should be moved towards obstacle creator so an export of edges can be made. Not at the top of our list, but it slims down the main RRT code

%edges of the obstacles will be put into a matrix, 4 lines per rectangle means 4 rows per object
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

% Goal node
Goal=[16,45,0,0];


i=1;
%% RRT Algorithm
while i<Nodes+1
    %Function for creating new nodes, looks for parent with smallest cost towards start
    [Xnew, Ynew, LengthMatrix, Parent, Cost] = NodeCreator_Copy(Xmax, Ymax, NodeMatrix, Length, i, Nodes, Goal);
    %function for checking if the node/ line from node to parent node intersects with any obstacle
    [Intersection] = InObstacleDetect(Xnew, Ynew, ObstacleMatrix, Height);
    [Intersection] = ThroughObstacleDetect(Xnew, Ynew, Parent, Intersection, edges, NodeMatrix);
    %add node to matrix if intersection==0
    if Intersection==0
        %% check where to connect it to the node, connect to lowest cost around
        %go to the end of NodeMatrix and add a new row where the new values are inserted
        NodeMatrix(end+1,:)=[Xnew Ynew Parent Cost];
        [NodeMatrix] = NodeRewire (NodeMatrix, Length,i); %something that has to do with i-rows, makes this code retstart itself sometimes at the same i value
        i=i+1;
    end
end
%Lastly, add goal to the matrix
NodeMatrix(end+1,:)=Goal;


%% Find parent for the goal node
[a, NoGoal, NodeMatrix] = GoalDetect(NodeMatrix, Goal, Length );


%% Drawing part

% Hi, I have enlarged the size of the figure down here starting from 'units'
figure ('Name','Nodes', 'units', 'normalized', 'outerposition', [0.2 0.1 0.6 0.8]);
%hold on so that all further drawings are stacked on top of eachother
hold on
axis([0, Xmax, 0, Ymax]);
axis padded
% Draw all rectangles
for q=1:Height
    rectangle('position', RectangleMatrix(q,[2,3,4,5]), 'FaceColor','black');
end
%set k to 2 because we need to look at the parent of the first node, which is the origin
k=2;
% look for all the points within NodeMatrix. We want to make a plot that contains [X1 X2]=dx and [Y1 Y2]=dy
while k<Nodes+a+1
    %X1 is in row k and X2 is in the row of the parent (mentioned in column 3)
    dx=[NodeMatrix(k,1), NodeMatrix(NodeMatrix(k,3),1)];
    dy=[NodeMatrix(k,2), NodeMatrix(NodeMatrix(k,3),2)];
    %plot the line with a blue colour
    plot(dx, dy, 'b', 'HandleVisibility','off');
    %cycle to next row
    k=k+1;
end
legend
%Scatter all the nodes as red dots
scatter(NodeMatrix(2:Nodes+1,1),NodeMatrix(2:Nodes+1,2),'r.', 'DisplayName', 'Node');
if NoGoal==0
    %%change road to goal from blue mark to green mark
    p=Nodes+2;
    while p>1
        dxG= [NodeMatrix(p,1), NodeMatrix(NodeMatrix(p,3),1)];
        dyG= [NodeMatrix(p,2), NodeMatrix(NodeMatrix(p,3),2)];
        plot(dxG, dyG, 'g', 'LineWidth',2, 'HandleVisibility','off');
        p=NodeMatrix(p,3);
    end
end
%Scatter the start
scatter(NodeMatrix(1,1),NodeMatrix(1,2),60, 'md', "filled", 'MarkerEdgeColor', 'Black','LineWidth',1, 'DisplayName', 'Start');
%Scatter the goal
scatter(NodeMatrix(end,1),NodeMatrix(end,2),90, 'mh', "filled", 'MarkerEdgeColor', 'Black','LineWidth',1, 'DisplayName', 'Goal');