
%% Global variables:
Xmax
Ymax
global Height;
global Rectanglematrix readmatrix("RectangleMatrix.csv");
Obstaclematrix;
Length;
Nodes;
Start;
NodeMatrix;

%Variables
% Import ObstacleMatrix and rectanglematrix from ObstacleBuilder
ObstacleMatrix=readmatrix('ObstacleMap.csv'); %map of obstacles with [x1,y1,x2,y2]
RectangleMatrix=readmatrix('RectangleMatrix.csv'); %Rectanglematrix with [i,x,y,w,h]
Height=height(RectangleMatrix); %count rows of matrix

%function [outputs] = name(inputs); sample

while loop node creation
function [Xnew, Ynew, Parent,] = Nodecreator( matrix(of all nodes, with start), Length);

function [marker] = IntersectionDetector(Xnew, Ynew, Parent, Obstaclematrix, Height, edgeXobstacle);
    %add node to matrix if marker==0
end

%% find if node is near goal, determine which node along with chain of parents gives shortest route

%% Drawing part