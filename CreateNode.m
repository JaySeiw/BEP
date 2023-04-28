function [Parent] = CreateNode(randXNode, randYNode, mat, Length)
    
    % Locating nearest point
    %make matrix where [x1-xi y1-yi] with i rows because we are not intereste in points of zero starting with starting point
    DistanceMatrix=[randXNode randYNode]-mat(:,[1 2]);
    %calculate length from new point to all points
    LengthMatrix=[sqrt(DistanceMatrix(:,1).^2+DistanceMatrix(:,2).^2)];

    %find smallest length to point
    ClosestPoint=find(LengthMatrix==min(LengthMatrix));
    %disp('long');
    if LengthMatrix(ClosestPoint)>Length
        %calculate angle
        theta=atan2(DistanceMatrix(ClosestPoint,2),DistanceMatrix(ClosestPoint,1));
        %set point in same line, but with length L
        randXNode=Length*cos(theta)+mat(ClosestPoint,1);
        randYNode=Length*sin(theta)+mat(ClosestPoint,2);
        %make matrix where [x1-xi y1-yi] with i rows because we are not intereste in points of zero starting with starting point
        DistanceMatrix=mat(:,[1 2])-[randXNode randYNode];
        %calculate length from new point to all points
        LengthMatrix=[sqrt(DistanceMatrix(:,1).^2+DistanceMatrix(:,2).^2)];
        %re-find smallest length to point
        ClosestPoint=find(LengthMatrix==min(LengthMatrix));
    end
    Parent=ClosestPoint;