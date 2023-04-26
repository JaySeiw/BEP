%function [outputs] = name(inputs); sample
%% Global variables:
Xmax
Ymax
global RectangleMatrix; 
RectangleMatrix=readmatrix("RectangleMatrix.csv"); % Rectanglematrix with [i,x,y,w,h]
global ObstacleMatrix;
ObstacleMatrix=readmatrix('ObstacleMap.csv'); % Map of obstacles with [x1,y1,x2,y2]
global Height;
Height=height(RectangleMatrix); % Count rows of RectangleMatrix
global Length;
Length=3; % L max length for a node to be connected to an other
global Nodes
Nodes=1000;
Start=[4,5,0];
global NodeMatrix;
NodeMatrix=zeros(1,3);
Nodematrix(1,:)=Start; % Add start to nodematrix

i=1;
% While loop node creation
while 1<Nodes+1 
    %Function for creating new nodes, 
function [Xnew, Ynew, Parent,] = Nodecreator( matrix(of all nodes, with start), Length);

function [marker] = IntersectionDetector(Xnew, Ynew, Parent, Obstaclematrix, Height, edgeXobstacle);
    %add node to matrix if marker==0
end

%% find if node is near goal, determine which node along with chain of parents gives shortest route

%% Drawing part