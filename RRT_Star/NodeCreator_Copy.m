function [Xnew, Ynew, Parent, Cost] = NodeCreator_Copy(Xmax, Ymax, NodeMatrix, Length, i, Nodes, Goal)

% Assign random coordinates


DiceThrow=100*rand;
Percentage=1-(i/Nodes);
if DiceThrow<Percentage%||i==1
    randXNode=Goal(1,1)+0*rand;
    randYNode=Goal(1,2)+0*rand;
else
    randXNode=Xmax*rand;
    randYNode=Ymax*rand;
end

randXNode
randYNode

%% Locating nearest point
%make matrix where [x1-xi y1-yi] with i rows because we are not intereste in points of zero starting with starting point
DistanceMatrix=[randXNode randYNode]-NodeMatrix([1 i-1],[1 2]);
%calculate length from new point to all points
LengthMatrix=[sqrt(DistanceMatrix(:,1).^2+DistanceMatrix(:,2).^2)];

%find smallest length to point
ClosestPoint=find(LengthMatrix==min(LengthMatrix));
%disp('long');
ClosestPoint

%% Steering-part
if LengthMatrix(ClosestPoint)>Length
    %calculate angle
    theta=atan2(DistanceMatrix(ClosestPoint,2),DistanceMatrix(ClosestPoint,1));
    %set point in same line, but with length L
    randXNode=Length*cos(theta)+NodeMatrix(ClosestPoint,1);
    randYNode=Length*sin(theta)+NodeMatrix(ClosestPoint,2);
end


%% Assign parent with lowest cost-part
randXNode
randYNode
% Select node within interval of +- Length and select node with smallest cost
NRx=discretize(NodeMatrix(1:i,1),[randXNode-Length, randXNode+Length]);
NRy=discretize(NodeMatrix(1:i,2),[randYNode-Length, randYNode+Length]);
%find the row(s) where a node is within the interval of the selected node
FNx=find(~isnan(NRx));
FNy=find(~isnan(NRy));
%find which points are on both intervals using intersect function
Nodex=intersect(FNx, FNy);
%Nodex
%Make a matrix where we have nodes within range, their distance to the newly made node, and the cost to the newlt made node
NodeLengthMatrix=zeros(height(Nodex),3);


%% Select row B of Nodex, where the original node number is known
for b=1:height(Nodex)
    %Make a matrix with the node number, the length to the node and the original path cost
    %Nodex(b) gives us the value of the b-th row
    L=sqrt( (NodeMatrix(Nodex(b),1)-randXNode)^2+(NodeMatrix(Nodex(b),2)-randYNode)^2 );
    %Only insert if length is actually <=Length, making this interval where max length could be sqrt(2)*Length (45deg angle with sides of 3)
    if L<=Length %%eventually shrink size when more nodes are added
        NodeLengthMatrix(b,:)=[Nodex(b), L , NodeMatrix(Nodex(b),4)+L];
    end
end
%Remove all rows with zeros
NodeLengthMatrix( all(~NodeLengthMatrix,2),:)=[];


%% Check if there are any nodes left and then find the node where the cost is smallest, make that the parent
%check if there are any nodes in the matrix
if ~isempty(NodeLengthMatrix)
    %find the row where the cost is smallest
    [val, row]=min(NodeLengthMatrix(:,3));
    %check if there is a 
    if ~isempty(row)
        Parent=NodeLengthMatrix(row,1);
        Cost=NodeLengthMatrix(row,3);
    %otherwise the parent will be the closest point, that we have steered towards and the cost will be its total cost+ the length, because that is what we made the length to be
    elseif NodeLengthMatrix(1,3)==0
        Parent=NodeLengthMatrix(1,1);
        Cost=NodeLengthMatrix(1,3);
    end
%otherwise the parent will be the closest point, that we have steered towards and the cost will be its total cost+ the length, because that is what we made the length to be
else
    Parent=ClosestPoint;
    Cost=NodeMatrix(ClosestPoint,4) + Length;
end
%we are left with a point, its parent node and a length matrix
Xnew=randXNode;
Ynew=randYNode;