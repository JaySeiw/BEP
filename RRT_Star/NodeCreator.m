function [Xnew, Ynew, LengthMatrix, Parent, Cost] = NodeCreator(Xmax, Ymax, NodeMatrix, Length)
% Assign random coordinates


%DiceThrow=10*rand;

%if DiceThrow>7
    %randXNode=15.5+rand;
    %randYNode=45.5+rand;
%else
    randXNode=Xmax*rand;
    randYNode=Ymax*rand;
%end
% Locating nearest point
%make matrix where [x1-xi y1-yi] with i rows because we are not intereste in points of zero starting with starting point
DistanceMatrix=[randXNode randYNode]-NodeMatrix(:,[1 2]);
%calculate length from new point to all points
LengthMatrix=[sqrt(DistanceMatrix(:,1).^2+DistanceMatrix(:,2).^2)];

%find smallest length to point
ClosestPoint=find(LengthMatrix==min(LengthMatrix));
%disp('long');
if LengthMatrix(ClosestPoint)>Length
    %calculate angle
    theta=atan2(DistanceMatrix(ClosestPoint,2),DistanceMatrix(ClosestPoint,1));
    %set point in same line, but with length L
    randXNode=Length*cos(theta)+NodeMatrix(ClosestPoint,1);
    randYNode=Length*sin(theta)+NodeMatrix(ClosestPoint,2);
    %add length of path to the cost; this is standard the Length, as we have steered this
    Cost=NodeMatrix(ClosestPoint,4) + sqrt((Length*cos(theta))^2+(Length*sin(theta)^2));
else
    %add length of path to the cost
    Cost=NodeMatrix(ClosestPoint,4) + LengthMatrix(ClosestPoint);
end
Parent=ClosestPoint;


%we are left with a point, its parent node and a length matrix
Xnew=randXNode;
Ynew=randYNode;