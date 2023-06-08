function [q, NoGoal, Goal] = GoalDetect_new(NodeMatrix, Goal, Length )
%% find if node is near goal, determine which node along with chain of parents gives shortest route
Index=double.empty;
q=0;
for b=1:height(Goal)
    %we make a cube with a distance of 3 units around the goal, from here we discretize points
    GoalIntx=discretize(NodeMatrix(:,1),[Goal(b,1)-Length, Goal(b,1)+Length]);
    GoalInty=discretize(NodeMatrix(:,2),[Goal(b,2)-Length, Goal(b,2)+Length]);
    %find the row(s) where a node is within the interval of the goal
    FGx=find(~isnan(GoalIntx));
    FGy=find(~isnan(GoalInty));
    %find which points are on both intervals using intersect function
    Goalx=intersect(FGx, FGy);
    %take height from this matrix to create a length matrix, where we can quickly filter out the node closest to the goal.... But does this mean it is also on the shortest path?
    GoalLengthMatrix=double.empty;
    for a=1:height(Goalx)
        L=sqrt( (NodeMatrix(Goalx(a),1)-Goal(b,1))^2+(NodeMatrix(Goalx(a),2)-Goal(b,2))^2 );
        if L<=Length
        GoalLengthMatrix=vertcat(GoalLengthMatrix,[Goalx(a), L, NodeMatrix(Goalx(a),4)+L]);
        end
    end
    %GoalLengthMatrix
    % find the value in column 1 of the row which matches the smallest value in column 2
    if ~isempty(GoalLengthMatrix)
        [~, row]=min(GoalLengthMatrix(:,3));
        GoalParentNode=GoalLengthMatrix(row , 1); %we can probably refine this part here, but it works
        Goal(b,[3, 4])=[GoalParentNode, GoalLengthMatrix(row,3)];
        %Have to set some variables here to draw right amount of lines and declare that a path to the goal has been found
        q=q+1;
    else
        %disp('No goal found for goal'); Goal(b,[1,2])
        Index=vertcat(Index, b);
    end
end
NoGoalMatrix=Goal(Index,[1 2]);
Goal(Index,:)=[];
if ~isempty(Goal)
    NoGoal=0;
else
    NoGoal=1;
end
end