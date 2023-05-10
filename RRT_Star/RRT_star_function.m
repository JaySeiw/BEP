function [node_count, no_of_nodes_path, len_path]=RRT_star_function(environment, Start, Goal, Length, Nodes)


%function [outputs] = name(inputs); i am just a sample
close all hidden;
rng shuffle
seed_obj = rng;
seed = seed_obj.Seed;
%% Global variables:

Xmax=50;
Ymax=50;

[ObstacleMatrix, RectangleMatrix ,edges]=EnvironmentBuilder(environment); %Obstaclematrix: [x1,y1,x2,y2], edges:  N x [x1, y1, x2, y2]

Height=height(RectangleMatrix); % Count rows of RectangleMatrix

NodeMatrix=zeros(1,4);
NodeMatrix(1,:)=Start; % Add start to nodematrix

node_count=1; %initialize node count to 1


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
        node_count= node_count+1; %Increment node count
        i=i+1;
    end
end
%Lastly, add goal to the matrix
NodeMatrix(end+1,:)=Goal;



%% find if node is near goal, determine which node along with chain of parents gives shortest route
%we make a cube with a distance of 3 units around the goal, from here we discretize points
GoalIntx=discretize(NodeMatrix(1:end-1,1),[Goal(1)-Length, Goal(1)+Length]);
GoalInty=discretize(NodeMatrix(1:end-1,2),[Goal(2)-Length, Goal(2)+Length]);
%find the row(s) where a node is within the interval of the goal
FGx=find(~isnan(GoalIntx));
FGy=find(~isnan(GoalInty));
%find which points are on both intervals using intersect function
Goalx=intersect(FGx, FGy);
%take height from this matrix to create a length matrix, where we can quickly filter out the node closest to the goal.... But does this mean it is also on the shortest path?
GoalLengthMatrix=zeros(height(Goalx),3);
for a=1:height(Goalx)
    L=sqrt( (NodeMatrix(Goalx(a),1)-Goal(1))^2+(NodeMatrix(Goalx(a),2)-Goal(2))^2 );
    GoalLengthMatrix(a,:)=[Goalx(a), L, NodeMatrix(Goalx(a),4)+L];
end
% find the value in column 1 of the row which matches the smallest value in column 2
if ~isempty(GoalLengthMatrix)
    [val, row]=min(GoalLengthMatrix(:,3));
    %row
    GoalParentNode=GoalLengthMatrix(row , 1); %we can probably refine this part here, but it works
    NodeMatrix(end,[3, 4])=[GoalParentNode, GoalLengthMatrix(row,3)];
    %Have to set some variables here to draw right amount of lines and declare that a path to the goal has been found
    a=2;
    NoGoal=0;
else
    NoGoal=1;
    a=1;
    disp('No goal found');
end



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
    no_of_nodes_path=0; %initialise counter variable
    len_path=0; %initialise length variable
    while p>1
        dxG= [NodeMatrix(p,1), NodeMatrix(NodeMatrix(p,3),1)];
        dyG= [NodeMatrix(p,2), NodeMatrix(NodeMatrix(p,3),2)];
        plot(dxG, dyG, 'g', 'LineWidth',2, 'HandleVisibility','off');
        % increment the counter variable by 1 for each node in the line
        no_of_nodes_path = no_of_nodes_path + 1; 
        % calculate the distance between the current node and the next node
        len_path = len_path + sqrt((dxG(2)-dxG(1))^2 + (dyG(2)-dyG(1))^2);
        p=NodeMatrix(p,3);
    end
end
%Scatter the start
scatter(NodeMatrix(1,1),NodeMatrix(1,2),60, 'md', "filled", 'MarkerEdgeColor', 'Black','LineWidth',1, 'DisplayName', 'Start');
%Scatter the goal
scatter(NodeMatrix(end,1),NodeMatrix(end,2),90, 'mh', "filled", 'MarkerEdgeColor', 'Black','LineWidth',1, 'DisplayName', 'Goal');