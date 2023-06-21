function [node_count, no_of_nodes_path, len_path, NodeMatrix] = MA_RRT_star_animation(environment, Length, Nodes)

    plot_data = struct;

    % Global variables:
    Xmax=50;
    Ymax=50;
    
    [ObstacleMatrix, RectangleMatrix, edges] = EnvironmentBuilder(environment); %Obstaclematrix: [x1,y1,x2,y2], edges:  N x [x1, y1, x2, y2]
    Height=height(RectangleMatrix);
    node_count=1; %initialize node count to 1
    
    %Partition the debris into voronoi regions
    [Start, VoronoiEdge, Cluster]=PartitionPerlinDebris(Xmax,Ymax,environment, ObstacleMatrix);
    
    %divide the edges per partition
    [Edges] = ObstaclePartitioner(edges,VoronoiEdge);
    
    %set up cell for all the nodematrices
    NodeMatrices=cell(3,1);
    
    % store data in output data structure
    plot_data.dim_x = Xmax;
    plot_data.dim_y = Ymax;
    plot_data.edge_length = Length;
    plot_data.n_nodes = Nodes;
    plot_data.obstacle_mat = ObstacleMatrix;
    plot_data.rectangle_mat = RectangleMatrix;
    plot_data.start_point = Start(:, 1:2);
    plot_data.voronoi_edges = cell2mat(VoronoiEdge(2:4, 1:2));
    plot_data.debris = Cluster;

    % for loop for each partition one
    for a = 1:3
        NodeMatrix=zeros(Nodes,4);
        Goal=Cluster{a};
        NodeMatrix(1,:)=Start(a,:);
        edges=Edges{a+1};
        %edges
        i=1;
        % RRT Algorithm
        while i<Nodes+1
            %Function for creating new nodes, looks for parent with smallest cost towards start
            [Xnew, Ynew, Parent, Cost] = NodeCreator_Copy(Xmax, Ymax, NodeMatrix, Length, i, Nodes, Goal);
            %function for checking if the node/ line from node to parent node intersects with any obstacle
            [Intersection] = InObstacleDetect(Xnew, Ynew, ObstacleMatrix);
            [Intersection] = ThroughObstacleDetect(Xnew, Ynew, Parent, Intersection, edges, NodeMatrix);
            %add node to matrix if intersection==0
            if Intersection==0
                % check where to connect it to the node, connect to lowest cost around
                %go to the end of NodeMatrix and add a new row where the new values are inserted
                NodeMatrix(i+1,:)=[Xnew Ynew Parent Cost];
                %[dx dy add]
                [NodeMatrix] = NodeRewire (NodeMatrix, Length, i, edges); %something that has to do with i-rows, makes this code retstart itself sometimes at the same i value
                %[   [indexold] remove %index of all rewired nodes with old parents - remove line
                %    [indexnew] add] %index of all rewired nodes with new parent - add line
                node_count= node_count+1; %Increment node count
                i=i+1;
            end
        end
    
        % Find parent for the goal node
        [q, NoGoal, Goal] = GoalDetect_new(NodeMatrix, Goal, Length );
        NodeMatrices{a} = vertcat(NodeMatrix,Goal);
    
        % Plotting
        % Draw all rectangles
        for l=1:Height
            rectangle('position', RectangleMatrix(l,[2,3,4,5]), 'FaceColor','black');
        end
        % set k to 2 because we need to look at the parent of the first node, which is the origin
        k=2;
        % look for all the points within NodeMatrix. We want to make a plot that contains [X1 X2]=dx and [Y1 Y2]=dy
        while k<=Nodes+1
            % X1 is in row k and X2 is in the row of the parent (mentioned in column 3)
            dx=[NodeMatrix(k,1), NodeMatrix(NodeMatrix(k,3),1)];
            dy=[NodeMatrix(k,2), NodeMatrix(NodeMatrix(k,3),2)];
            % plot the line with a blue colour
            plot(dx, dy, 'b', 'HandleVisibility','off');
            % cycle to next row
            k=k+1;
        end
        % Scatter all the nodes as red dots
        scatter(NodeMatrix(2:Nodes+1,1),NodeMatrix(2:Nodes+1,2),'r.', 'DisplayName', 'Node');
        if NoGoal == 0
            while q ~= 0
                % change road to goal from blue mark to green mark
                p = Nodes+q+1;
                no_of_nodes_path = 0; % initialise counter variable
                len_path = 0; % initialise length variable
                while p>1
                    dxG= [NodeMatrices{a}(p,1), NodeMatrices{a}(NodeMatrices{a}(p,3),1)];
                    dyG= [NodeMatrices{a}(p,2), NodeMatrices{a}(NodeMatrices{a}(p,3),2)];
                    plot(dxG, dyG, 'w', 'LineWidth',2, 'HandleVisibility','off');
                    % increment the counter variable by 1 for each node in the line
                    no_of_nodes_path = no_of_nodes_path + 1;
                    % calculate the distance between the current node and the next node
                    len_path = len_path + sqrt((dxG(2)-dxG(1))^2 + (dyG(2)-dyG(1))^2);
                    p = NodeMatrices{a}(p,3);
                end
                q = q - 1;
            end
        else
            no_of_nodes_path=0;
            len_path=0;
        end
        % Plot the start
        scatter(NodeMatrix(1,1),NodeMatrix(1,2),60, 'md', "filled", 'MarkerEdgeColor', 'Black','LineWidth',1, 'DisplayName', 'Start');
        
        % Plot the goal
        scatter(Goal(:,1),Goal(:,2),90, 'mh', "filled", 'MarkerEdgeColor', 'Black','LineWidth',1, 'DisplayName', 'Goal');
    end

    % Save data
    plot_data.node_matrices = NodeMatrices;
    save('plot_data.mat', 'plot_data')
end
