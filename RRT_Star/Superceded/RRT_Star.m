%function [outputs] = name(inputs); i am just a sample
close all hidden;
%% Global variables:
global Xmax;
Xmax=50;
global Ymax;
Ymax=50;
global RectangleMatrix;
RectangleMatrix=readmatrix("RectangleMatrix.csv"); % Rectanglematrix with [i,x,y,w,h]
global ObstacleMatrix;
ObstacleMatrix=readmatrix('ObstacleMap.csv'); % Map of obstacles with [x1,y1,x2,y2]
global edges;
edges=readmatrix("edges.csv");% a matrix representing all the lines of the obstacles. (size N x 4 in the form N x [x1, y1, x2, y2])
global Height;
Height=height(RectangleMatrix); % Count rows of RectangleMatrix
global Length;
Length=3; % L max length for a node to be connected to an other
global Nodes
Nodes=6000; %go crazy with the numbers!
Start=[4,5,0];
global NodeMatrix; %matrix of all the nodes created with x,y coordinates and its closest parent
NodeMatrix=zeros(1,3);
NodeMatrix(1,:)=Start; % Add start to nodematrix


% Goal node
Goal=[16,45,0];


i=1;
% While loop node creation
while i<Nodes+1
    intersection=0;
    %Function for creating new nodes,
    [Xnew, Ynew, LengthMatrix, Parent] = Nodecreator(Xmax, Ymax, NodeMatrix, Length);
    %function for checking if the node/ line from node to parent node intersects with any obstacle

    [intersection] = IntersectionDetector(Xnew, Ynew, Parent, ObstacleMatrix, Height, intersection, edges, NodeMatrix);
    %[marker] = ObstacleCheck(Height, Xnew, Ynew, ObstacleMatrix, marker);
    %[valid, intx] = edgeXobstacle(Xnew, Ynew, Parent, RectangleMatrix);

    %add node to matrix if marker==0

    [intersection] = IntersectionDetector(Xnew, Ynew, Parent, ObstacleMatrix, Height, intersection, edges, NodeMatrix);
    %add node to matrix if intersection==0

    if intersection==0
        %go to the end of NodeMatrix and add a new row where the new values are inserted
        NodeMatrix(end+1,:)=[Xnew Ynew Parent];
        i=i+1;
    end
end
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
GoalLengthMatrix=zeros(height(Goalx),2);
for a=1:height(Goalx)
    GoalLengthMatrix(a,:)=[Goalx(a), sqrt( (NodeMatrix(Goalx(a),1)-Goal(1))^2+(NodeMatrix(Goalx(a),2)-Goal(2))^2 )];
end
% find the value in column 1 of the row which matches the smallest value in column 2
if ~isempty(GoalLengthMatrix)
    GoalParentNode=GoalLengthMatrix( find( GoalLengthMatrix(2) == min(GoalLengthMatrix(2)) ) , 1); %we can probably refine this part here, but it works
    NodeMatrix(end,3)=GoalParentNode;
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
%place all the nodes as red dots
scatter(NodeMatrix(2:Nodes+1,1),NodeMatrix(2:Nodes+1,2),'r.');
% Draw all rectangles
for q=1:Height
    rectangle('position', RectangleMatrix(q,[2,3,4,5]), 'FaceColor','black');
end

%set k to 2 because we need to look at the parent of the first node, which is the origin
k=2;
% look for all the points within mat. We want to make a plot that contains [X1 X2]=dx and [Y1 Y2]=dy
while k<Nodes+a+1
    %X1 is in row k and X2 is in the row of the parent (mentioned in column 3)
    dx=[NodeMatrix(k,1), NodeMatrix(NodeMatrix(k,3),1)];
    dy=[NodeMatrix(k,2), NodeMatrix(NodeMatrix(k,3),2)];
    %plot the line with a blue colour
    plot(dx, dy, 'b');
    %cycle to next row
    k=k+1;
end
scatter(NodeMatrix(1,1),NodeMatrix(1,2), 'md', "filled", 'MarkerEdgeColor', 'Black','LineWidth',3);
scatter(NodeMatrix(end,1),NodeMatrix(end,2), 'mh', "filled", 'MarkerEdgeColor', 'Black','LineWidth',3);


if NoGoal==0
    %%change road to goal from blue mark to green mark
    p=Nodes+2;
    while p>1
        dxG= [NodeMatrix(p,1), NodeMatrix(NodeMatrix(p,3),1)];
        dyG= [NodeMatrix(p,2), NodeMatrix(NodeMatrix(p,3),2)];
        plot(dxG, dyG, 'g', 'LineWidth',2);
        p=NodeMatrix(p,3);
    end
end
