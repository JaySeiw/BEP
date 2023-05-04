function [Xnew, Ynew, LengthMatrix, Parent] = Nodecreator(Xmax, Ymax, NodeMatrix, Length, Goal)
% Assign random coordinates
    DiceThrow=randi(100);
    GoalSteerPerc=10;
    
    if DiceThrow<GoalSteerPerc
        randXNode=16+0.0001*rand;
        randYNode=45+0.0001*rand;
    else
        randXNode=Xmax*rand;
        randYNode=Ymax*rand;
    end
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
        %make matrix where [x1-xi y1-yi] with i rows because we are not intereste in points of zero starting with starting point
        DistanceMatrix=NodeMatrix(:,[1 2])-[randXNode randYNode];
        %calculate length from new point to all points
        LengthMatrix=[sqrt(DistanceMatrix(:,1).^2+DistanceMatrix(:,2).^2)];
        %re-find smallest length to point
        ClosestPoint=find(LengthMatrix==min(LengthMatrix));
    end
    Parent=ClosestPoint;


%we are left with a point, its parent node and a length matrix
Xnew=randXNode;
Ynew=randYNode;