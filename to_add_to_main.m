%% IN THE MAIN FILE

%% Animation

% Create images folder
folder_name = 'Images/';
mkdir(folder_name)

% Set plot data and properties
plot_properties.obstacles = O;	% obstacle matrix
plot_properties.x0 = x0;		% initial location
plot_properties.goal = goal;	% goal
plot_properties.r_goal = r_goal;% goal radius
plot_properties.V = V;			% nodes
plot_properties.E = E;			% edges
plot_properties.path = path_to_goal;	% path from start to goal
plot_properties.delay = 0.05; 
plot_properties.save_path = strcat(folder_name, 'environment_animation');
animate_environment(plot_properties)


%% Notes:
% - The obstacle matrix should be a column matrix where every row 
%   corresponds to one rectangle. The plot is on line 49 of the animation
%   file, i.e.: rectangle('Position', obs, 'FaceColor', obs_color);
%   Check that the formatting of the obstacles is the one required by the
%   rectangle() function;
% - x0 is a row vector [x, y] of the initial position. Same for the goal.
% - Goal radius is a scalar corresponding to the area in which the goal is
%   considered reached.
% - The node matrix V is a column matrix with 3 columns. Each row is a
%   node, saved as [x, y, parent_index]. Note that for me the parent index
%   is 0 and all the other indexes refer exactly to the matrix row in which
%   the corresponding node is saved. If this is not the case for you, just
%   subtracting 1 from the last column should do the trick.
% - The edge matrix is a column matrix with one row less than the nodes.
%   Each row has 2 elements wich are [index_node_1, index_node_2], i.e., 
%   the indexes (with respect to the V matrix) of the 2 nodes being .
%   connected.
% - path to goal is a column matrix, each row is a pair [x, y] with the
%   coordinates of the nodes which are part of the final path to goal.

% In the plot, on line 38: axis([0, 50, 0, 50]), you will also need to 
% change the plot size if not correct.