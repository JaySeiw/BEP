function [node_count, no_of_nodes_path, len_path, NodeMatrix]=RRT_star_function(environment, Start, Length, Nodes)
close all hidden
%function [outputs] = name(inputs); i am just a sample

%% Variables:

Xmax=50;
Ymax=50;

[ObstacleMatrix, RectangleMatrix ,edges]=EnvironmentBuilder(environment); %Obstaclematrix: [x1,y1,x2,y2], edges:  N x [x1, y1, x2, y2]

Height=height(RectangleMatrix); % Count rows of RectangleMatrix

[debris,im]=perlin_debris(environment);

goal= debris(1,:);
Goal=[goal,0,0];

NodeMatrix=zeros(Nodes,4);
NodeMatrix(1,:)=Start; % Add start to nodematrix

node_count=1; %initialize node count to 1

%% AnimationCode START
% Initialize the figure for animation
figure('Name', 'RRT* Animation', 'units', 'normalized', 'outerposition', [0.2 0.1 0.6 0.8]);
axis([0, Xmax, 0, Ymax]);
hold on

%plot perlin noise
imagesc(im)

% Plot the obstacles
for q = 1:Height
    rectangle('Position', RectangleMatrix(q, [2, 3, 4, 5]), 'FaceColor', 'black');
end

%plot debris
plot(debris(:,1),debris(:,2), 'w.');
%set(gca, 'YDir','reverse')
ax = gca;
ax.YDir = 'normal';
% Plot the start and goal positions
scatter(NodeMatrix(1, 1), NodeMatrix(1, 2), 'md', 'filled', 'MarkerEdgeColor', 'black', 'LineWidth', 3);
scatter(Goal(1, 1), Goal(1, 2), 'mh', 'filled', 'MarkerEdgeColor', 'black', 'LineWidth', 3);



% Initialize an empty array to store line handles
linesDraw = [];
% Create a cell array to store frames for GIF
frames = {};

%% AnimmationCode END


%% RRT Algorithm
i=1;
while i<Nodes+1
    %Function for creating new nodes, looks for parent with smallest cost towards start
    [Xnew, Ynew, Parent, Cost] = NodeCreator_Copy(Xmax, Ymax, NodeMatrix, Length, i, Nodes, Goal);
    %function for checking if the node/ line from node to parent node intersects with any obstacle
    [Intersection] = InObstacleDetect(Xnew, Ynew, ObstacleMatrix, Height);
    [Intersection] = ThroughObstacleDetect(Xnew, Ynew, Parent, Intersection, edges, NodeMatrix);
    %add node to matrix if intersection==0
    if Intersection==0
        %% check where to connect it to the node, connect to lowest cost around
        %go to the end of NodeMatrix and add a new row where the new values are inserted
        NodeMatrix(i+1,:)=[Xnew Ynew Parent Cost];
        [NodeMatrix] = NodeRewire (NodeMatrix, Length,i, edges); %something that has to do with i-rows, makes this code retstart itself sometimes at the same i value
        node_count= node_count+1; %Increment node count
        %% AnimationCode START
        % Add the new node to the plot
        nodeDraw = scatter(Xnew, Ynew, 'r.');

        % Plot the line between the new node and its parent
        
        parentX = NodeMatrix(Parent, 1);
        parentY = NodeMatrix(Parent, 2);
        lineDraw = plot([parentX, Xnew], [parentY, Ynew], 'b');
        linesDraw = [linesDraw, lineDraw];
    
        % Update the plot
        drawnow
        % Capture the frame for GIF
        frames{i} = getframe(gcf);
        %% AnimationCode END
        %% Loop Continue
        i=i+1;
    end
end
%Lastly, add goal to the matrix
NodeMatrix(end+1,:)=Goal;



%% Find parent for the goal node
[~, NoGoal, NodeMatrix] = GoalDetect(NodeMatrix, Goal, Length );


%% Drawing part
%{
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
%}
if NoGoal==0
    %%change road to goal from blue mark to green mark
    p=Nodes+2;
    no_of_nodes_path=0; %initialise counter variable
    len_path=0; %initialise length variable
    while p>1
        dxG= [NodeMatrix(p,1), NodeMatrix(NodeMatrix(p,3),1)];
        dyG= [NodeMatrix(p,2), NodeMatrix(NodeMatrix(p,3),2)];
        plot(dxG, dyG, 'g', 'LineWidth',2, 'HandleVisibility','off');
        %% AnimationCode START
        drawnow
        frames{i} = getframe(gcf);
        %% AnimationCode END
        %% Continuation of loop
        % increment the counter variable by 1 for each node in the line
        no_of_nodes_path = no_of_nodes_path + 1; 
        % calculate the distance between the current node and the next node
        len_path = len_path + sqrt((dxG(2)-dxG(1))^2 + (dyG(2)-dyG(1))^2);
        p=NodeMatrix(p,3);
    end
end
%{
%Scatter the start
scatter(NodeMatrix(1,1),NodeMatrix(1,2),60, 'md', "filled", 'MarkerEdgeColor', 'Black','LineWidth',1, 'DisplayName', 'Start');
%Scatter the goal
scatter(NodeMatrix(end,1),NodeMatrix(end,2),90, 'mh', "filled", 'MarkerEdgeColor', 'Black','LineWidth',1, 'DisplayName', 'Goal');
%}
%% AnimationCode START
filename = 'C:\Users\Frank\Documents\GitHub\BEP\RRT_Star\Images\RRTStarAnimation.gif';
for i = 1:Nodes+no_of_nodes_path
    frame = frames{i};
    im = frame2im(frame);
    [imind, cm] = rgb2ind(im, 256);
    if i == 1
        imwrite(imind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', 0.0000001);
    else
        imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.0000001);
    end
end
