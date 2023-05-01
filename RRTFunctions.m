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
Nodes=5;
Start=[4,5,0];
global NodeMatrix;
NodeMatrix=zeros(1,3);
NodeMatrix(1,:)=Start; % Add start to nodematrix


global i;
i=1;
% While loop node creation
while i<Nodes+1
    %Function for creating new nodes,
    [Xnew, Ynew, LM, Parent] = Nodecreator(Xmax, Ymax, NodeMatrix, Length);
    %function for checking if the node/ line from node to parent node intersects with any obstacle
    %function [intersect] = IntersectionDetector(Xnew, Ynew, Parent, Obstaclematrix, Height, edgeXobstacle);
    [marker] = ObstacleCheck(Height, Xnew, Ynew, ObstacleMatrix);
    [valid] = edgeXobstacle(Xnew, Ynew, Parent);

    %add node to matrix if marker==0
    if marker==0 || valid==false
        %go to the end of NodeMatrix and add a new row where the new values are inserted
        NodeMatrix(end+1,:)=[Xnew Ynew Parent];
        i=i+1;
    end
end

%% find if node is near goal, determine which node along with chain of parents gives shortest route

%% Drawing part
figure ('Name','Nodes');
%hold on so that all further drawings are stacked on top of eachother
hold on
%place the start as a blue diamond
scatter(NodeMatrix(1,1),NodeMatrix(1,2), 'bdiamond');
axis([0, Xmax, 0, Ymax]);
%place all the nodes as red crosses
scatter(NodeMatrix(2:Nodes+1,1),NodeMatrix(2:Nodes+1,2),'rx');
% Draw all rectangles
for q=1:Height
    rectangle('position', RectangleMatrix(q,[2,3,4,5]));
end
%set k to 2 because we need to look at the parent of the first node, which is the origin
k=2;
% look for all the points within mat. We want to make a plot that contains [X1 X2]=dx and [Y1 Y2]=dy
while k<Nodes+2
    %X1 is in row k and X2 is in the row of the parent (mentioned in column 3)
    dx=[NodeMatrix(k,1), NodeMatrix(NodeMatrix(k,3),1)];
    dy=[NodeMatrix(k,2), NodeMatrix(NodeMatrix(k,3),2)];
    %plot the line with a blue colour
    plot(dx, dy, 'b');
    %cycle to next row
    k=k+1;
end
