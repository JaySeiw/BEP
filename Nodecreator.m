
function [LM, Parent] = Nodecreator(Xmax, Ymax, mat, Length)
randXNode=Xmax*rand;
randYNode=Ymax*rand;
% Locating nearest point
%make matrix where [x1-xi y1-yi] with i rows because we are not intereste in points of zero starting with starting point
DM=mat(:,[1 2])-[randXNode randYNode];
%calculate length from new point to all points
LM=[sqrt(DM(:,1).^2+DM(:,2).^2)];
%find closest point that is max 5 in length
%if d is empty (there are no points within limit) then make point on the line of closest point where the new length is 5
if isempty(find(LM<=Length))
    %find smallest length to point
    ClosestPoint=find(LM==min(LM));
    %disp('long');
    %calculate angle
    theta=atan(DM(ClosestPoint,2)/DM(ClosestPoint,1));
    %set point in same line, but with length L
    randXNode=Length*cos(theta)+mat(ClosestPoint,1);
    randYNode=Length*sin(theta)+mat(ClosestPoint,2);
    %make matrix where [x1-xi y1-yi] with i rows because we are not intereste in points of zero starting with starting point
    DM=mat(:,[1 2])-[randXNode randYNode];
    %calculate length from new point to all points
    LM=[sqrt(DM(:,1).^2+DM(:,2).^2)];
    %re-find smallest length to point
    ClosestPoint=find(LM==min(LM));
    Parent=ClosestPoint;
else
    %determine row where parent node is
    Parent=find(LM==min(LM));
end


