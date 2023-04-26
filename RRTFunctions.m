%function [outputs] = name(inputs); sample
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
Nodes=1000;
Start=[4,5,0];
global NodeMatrix;
NodeMatrix=zeros(1,3);
Nodematrix(1,:)=Start; % Add start to nodematrix


global i;
i=1;
% While loop node creation
while i<Nodes+1
    %Function for creating new nodes,
    Node=Nodecreator( NodeMatrix, Length);
    %function [intersect] = IntersectionDetector(Xnew, Ynew, Parent, Obstaclematrix, Height, edgeXobstacle);
    %add node to matrix if marker==0
    if intersect==0
        i=i+1;
    end
end

    %% find if node is near goal, determine which node along with chain of parents gives shortest route

    %% Drawing part