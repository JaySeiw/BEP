%function [outputs] = name(inputs); sample
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
global Height;
Height=height(RectangleMatrix); % Count rows of RectangleMatrix
global Length;
Length=3; % L max length for a node to be connected to an other
global Nodes
Nodes=500;
Start=[4,5,0];
global NodeMatrix;
NodeMatrix=zeros(1,3);
NodeMatrix(1,:)=Start; % Add start to nodematrix

Goal=[16,45,0];


i=1;
% While loop node creation
while i<Nodes+1
    intersection=0;
    %Function for creating new nodes,
    [Xnew, Ynew, LengthMatrix, Parent] = Nodecreator(Xmax, Ymax, NodeMatrix, Length);
    %function for checking if the node/ line from node to parent node intersects with any obstacle
    [intersection] = IntersectionDetector(Xnew, Ynew, Parent, ObstacleMatrix, Height, intersection);
    %[marker] = ObstacleCheck(Height, Xnew, Ynew, ObstacleMatrix, marker);
    %[valid, intx] = edgeXobstacle(Xnew, Ynew, Parent, RectangleMatrix);

    %add node to matrix if marker==0
    if intersection==0
        %go to the end of NodeMatrix and add a new row where the new values are inserted
        NodeMatrix(end+1,:)=[Xnew Ynew Parent];
        i=i+1;
    end
end
NodeMatrix(end+1,:)=Goal;



%% find if node is near goal, determine which node along with chain of parents gives shortest route
%we draw a circle of 3 units around the goal, from here we discretize points
Gx=discretize(NodeMatrix(1:end-1,1),[Goal(1)-Length, Goal(1)+Length]);
Gy=discretize(NodeMatrix(1:end-1,2),[Goal(2)-Length, Goal(2)+Length]);
%find the row(s) where a node is within the interval of the goal
FGx=find(~isnan(Gx));
FGy=find(~isnan(Gy));
%find which points are on both intervals using intersect function
Goalx=intersect(FGx, FGy);
%take height from this matrix to create a length matrix, where we can quickly filter out the node closest to the goal.... But does this mean it is also on the shortest path?
GLM=zeros(height(Goalx),2);
for a=1:height(Goalx)
    GLM(a,:)=[Goalx(a), sqrt( (NodeMatrix(Goalx(a),1)-Goal(1))^2+(NodeMatrix(Goalx(a),2)-Goal(2))^2 )];
end
% find the value in column 1 of the row which matches the smallest value in column 2
GN=GLM( find( GLM(2) == min(GLM(2)) ) , 1);
NodeMatrix(end,3)=GN;

%% Drawing part

% Hi, I have enlarged the size of the figure down here starting with 'units'

figure ('Name','Nodes', 'units', 'normalized', 'outerposition', [0.2 0.1 0.6 0.8]);
%hold on so that all further drawings are stacked on top of eachother
hold on
axis([0, Xmax, 0, Ymax]);
%place all the nodes as red crosses
scatter(NodeMatrix(2:Nodes+1,1),NodeMatrix(2:Nodes+1,2),'r.');
% Draw all rectangles
for q=1:Height
    rectangle('position', RectangleMatrix(q,[2,3,4,5]));
end
%set k to 2 because we need to look at the parent of the first node, which is the origin
k=2;
% look for all the points within mat. We want to make a plot that contains [X1 X2]=dx and [Y1 Y2]=dy
while k<Nodes+3
    %X1 is in row k and X2 is in the row of the parent (mentioned in column 3)
    dx=[NodeMatrix(k,1), NodeMatrix(NodeMatrix(k,3),1)];
    dy=[NodeMatrix(k,2), NodeMatrix(NodeMatrix(k,3),2)];
    %plot the line with a blue colour
    plot(dx, dy, 'b');
    %cycle to next row
    k=k+1;
end
scatter(NodeMatrix(1,1),NodeMatrix(1,2), 'md', "filled", 'MarkerEdgeColor', 'Black','LineWidth',2);
scatter(NodeMatrix(end,1),NodeMatrix(end,2), 'mh', "filled", 'MarkerEdgeColor', 'Black','LineWidth',2);



%%change road to goal from blue mark to green mark
p=Nodes+2;
while p>1
    dxG= [NodeMatrix(p,1), NodeMatrix(NodeMatrix(p,3),1)];
    dyG= [NodeMatrix(p,2), NodeMatrix(NodeMatrix(p,3),2)];
    plot(dxG, dyG, 'g');
    p=NodeMatrix(p,3);
end
