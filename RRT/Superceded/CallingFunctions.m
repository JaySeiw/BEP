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
Length=2.5; %L max length for a node to be connected to an other
mat=zeros(1,3);
% Node creation
start=[4,5,0];
%add the start to mat
mat(1,:)=start;
%set i to one for the node counter starting in row 1
i=1;
%going through all the nodes from i to nodes+1
while i<Nodes+1
    %Set marker to 0
    marker=0;
    % Assign random coordinates
    randXNode=Xmax*rand;
    randYNode=Ymax*rand;
    CreateNode(Xmax, Ymax, mat, Length)
    ObstacleCheck(Height, randXNode, randYNode, ObstacleMatrix)
    if marker==0
        %disp('pass'); % Expecting N-1 passes with a few extra crossings maybe
        %go to the end of mat and add a new row where the new values are inserted
        mat(end+1,:)=[randXNode randYNode Parent];
        %cycle to next point
        i=i+1;

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
