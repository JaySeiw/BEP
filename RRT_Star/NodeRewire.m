function [NodeMatrix] = NodeRewire(NodeMatrix, Length,i, edges)
%make a for loop to check every node with length, select new parent
% for a point we could only look in the interval of Length, saves a lot of computing.
% Use the find function and associate all locations in that area with the row from the NodeMatrix, so we do not lose its identity


% for a point we could only look in the interval of Length, saves a lot of computing*
% check if edgexobstacle is not true
% look for node with lowest cost (total path length)*


%% Select Node in row A where row 2 is node 2 and row Nodes+1 is the last of the assigned nodes
%% we make a cube with a distance of 3 units around the node, from here we discretize points
NRx=discretize(NodeMatrix(1:end,1),[NodeMatrix(i,1)-Length, NodeMatrix(i,1)+Length]);
NRy=discretize(NodeMatrix(1:end,2),[NodeMatrix(i,2)-Length, NodeMatrix(i,2)+Length]);
%find the row(s) where a node is within the interval of the selected node
FNx=find(~isnan(NRx));
FNy=find(~isnan(NRy));
%find which points are on both intervals using intersect function
Nodex=intersect(FNx, FNy);
%Remove node that has no length, and is the node investigated itself
Nodex(find(Nodex==i),:)=[];
%take height from this matrix to create a length matrix, where we can quickly filter out the node closest to the node
NodeLengthMatrix=zeros(height(Nodex),3);


%% Select row B of Nodex, where the original node number is known
for b=1:height(Nodex)
    %Make a matrix with the node number, the length to the node and the original path cost
    %Nodex(b) gives us the value of the b-th row
    L=sqrt( (NodeMatrix(Nodex(b),1)-NodeMatrix(i,1))^2+(NodeMatrix(Nodex(b),2)-NodeMatrix(i,2))^2 );
    %Only insert if length is actually <=Length, otherwise the length could be up to sqrt(2)*Length (45deg angle with sides of 3)
    if L<=Length %%eventually shrink size when more nodes are added
        NodeLengthMatrix(b,:)=[Nodex(b), L , NodeMatrix(Nodex(b),4)];
    end
end
NodeLengthMatrix( all(~NodeLengthMatrix,2),:)=[];



%% Check if there are any nodes left and then check if Cost of new node + length to nearest neighbour < cost nearest neighbour
if ~isempty(NodeLengthMatrix)
    %Determine new cost to node(s)
    NewCost=NodeMatrix(i,4)+NodeLengthMatrix(:,2);
    %cost of node that node(s) will be connected to
    Cost=NodeMatrix(i,4);
    %find row(s) in Nodelengthmatrix where the if statement mentioned above is true
    Index=find(NewCost<NodeLengthMatrix(:,3));
    if ~isempty(Index)
        %% Check if node i (parent) and new child(ren) cross an obstacle, if so, remove them from NodeLengthMatrix
        %Do this for every child that has been selected in row

        IndexDelete=zeros(1,1);
        for c=1:height(Index)
            Intersection=0;
            %Inputs are: x,y-coordinate from child node of row c of Index, node i, intersection (standard 0), edges, NodeMatrix
            [Intersection] = ThroughObstacleDetect(NodeMatrix(NodeLengthMatrix(Index(c),1),1), NodeMatrix(NodeLengthMatrix(Index(c),1),2), i, Intersection, edges, NodeMatrix);
            % When Intersecction==1 we want to remove this from Index
            if Intersection==1
                Index
                %Index(c,:)=[];
                IndexDelete(end+1)=c;
            end
        end
        if IndexDelete~=0
            IndexDelete
            Index([IndexDelete],:)=[];
            Index
        end
        if ~isempty(Index)
            %change parent of selected node(s) to the node in the i-th row
            NodeMatrix(NodeLengthMatrix(Index,1),3)=i;
            %change cost of selected node to cost of i-th row node + length to node in i-th row; this could be done for multiple nodes at once
            NodeMatrix(NodeLengthMatrix(Index,1),4)=Cost+NodeLengthMatrix(Index,2);
            %% Update children's cost by finding all changed nodes, calculating deltaC per node and applying that to the children's cost
            %do this for all nodes in row
            for d=1:height(Index)
                %deltaC is difference between old cost of changed node and the new cost; should be singular value and should always negative
                DeltaC=(Cost+NodeLengthMatrix(Index(d),2))-NodeLengthMatrix(Index(d),3);
                %find the children of the changed node; could be multiple children
                children=find(NodeMatrix(:,3)==NodeLengthMatrix(Index(d),1));
                %find children of children 
                CC=find(NodeMatrix(:,3)==children);
                %CC
                % Adjust children's cost to the cost they had to the original parent with the reduction in cost we created before
                %% find children of children
                NodeMatrix(children,4)=NodeMatrix(children,4)+DeltaC;
                %% Possibly rewire parent of all children affected to a smallest cost node?
            end
        end
    end
end

