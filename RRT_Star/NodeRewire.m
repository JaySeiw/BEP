function [NodeMatrix, NodeLengthMatrix] = NodeRewire(NodeMatrix, Nodes, Length)
%make a for loop to check every node with length, select new parent
% for a point we could only look in the interval of Length, saves a lot of computing.
% Use the find function and associate all locations in that area with the row from the NodeMatrix, so we do not lose its identity


% for a point we could only look in the interval of Length, saves a lot of computing.
% check if edgexobstacle is not true
% look for node with lowest cost (total path length)
%Select Node in row A
for a=2:Nodes+1
    %we make a cube with a distance of 3 units around the node, from here we discretize points
    NRx=discretize(NodeMatrix(1:end-1,1),[NodeMatrix(a,1)-Length, NodeMatrix(a,1)+Length]);
    NRy=discretize(NodeMatrix(1:end-1,2),[NodeMatrix(a,2)-Length, NodeMatrix(a,2)+Length]);
    %find the row(s) where a node is within the interval of the selected node
    FNx=find(~isnan(NRx));
    FNy=find(~isnan(NRy));
    %find which points are on both intervals using intersect function
    Nodex=intersect(FNx, FNy);
    %take height from this matrix to create a length matrix, where we can quickly filter out the node closest to the node
    NodeLengthMatrix=zeros(height(Nodex),3);
    %Select row B of Nodex, where the original node number is known
    for b=1:height(Nodex)
    %Make a matrix with the node number, the length to the node and the original path cost
        NodeLengthMatrix(a,:)=[Nodex(b), sqrt( (NodeMatrix(Nodex(b),1)-NodeMatrix(a,1))^2+(NodeMatrix(Nodex(b),2)-NodeMatrix(a,2))^2 ), NodeMatrix(Nodex(b),4)];
    end
    NodeLengthMatrix
%recalculate the path cost?

end

end