function [NodeMatrix] = NodeRewire(NodeMatrix, Length,i)
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



%% Check if there are any nodes left and then check if Cost node + length to nearest neighbour < cost nearest neighbour
if ~isempty(NodeLengthMatrix)
    %Determine new cost to node(s)
    NC=NodeMatrix(i,4)+NodeLengthMatrix(:,2);
    %cost of node that node(s) will be connected to
    cost=NodeMatrix(i,4);
    %find row in Nodelengthmatrix where if statement mentioned above is true
    row=find(NC<NodeLengthMatrix(:,3));
    if ~isempty(row)
        %change parent of selected node to the node in the i-th row
        NodeMatrix(NodeLengthMatrix(row,1),3)=i;
        %change cost of selected node to cost of i-th row node + length to node in i-th row; this could be done for multiple nodes at once
        NodeMatrix(NodeLengthMatrix(row,1),4)=cost+NodeLengthMatrix(row,2);
        %% Update children's cost by finding all changed nodes, calculating deltaC per node and applying that to the children's cost
        %do this for all nodes in row
        for d=1:height(row)
            %deltaC is difference between old cost of changed node and the new cost; should be singular value and should always negative
            deltaC=(cost+NodeLengthMatrix(row(d),2))-NodeLengthMatrix(row(d),3);
            if deltaC>0
                disp('error');%temporary error message for easy look-up in command window
            end
            %find the children of the changed node; could be multiple children
            children=find(NodeMatrix(:,3)==NodeLengthMatrix(row(d),1));
            NodeLengthMatrix(row(d),1)
            children
            % Adjust children's cost to the cost they had to the original parent with the reduction in cost we created before
            NodeMatrix(children,4)=NodeMatrix(children,4)+deltaC;
            %% Possibly rewire parent of all children affected to a smallest cost node?
        end
    end
end


end