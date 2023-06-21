%% MARRT* Animation 

clear variables
close all
clc

warning('off', 'MATLAB:handle_graphics:exceptions:SceneNode')
save_path = 'animation.gif';

%% Load data

% load data
load('plot_data.mat')

% unpack plot data
dim_x = plot_data.dim_x;
dim_y = plot_data.dim_y;
edge_lmax = plot_data.edge_length;
obstacle_matrix = plot_data.obstacle_mat;               % [x, y, x, y], first two elements refer to bottom-left corner of obstacle, last to to top-right corner   
rectangle_matrix = plot_data.rectangle_mat(:, 2:end);   % [x, y, delta_x, delta_y] same obstacles as above represented with side lenght instead of top-right corner
voronoi_edges = plot_data.voronoi_edges;
voronoi_center = voronoi_edges(1, 1:2);
starting_points = plot_data.start_point;
debris = plot_data.debris;
node_matrices = plot_data.node_matrices;

%% Plot parameters

% Obstacles colors
obs_color = 'k';
partition_color = [0, 0, 0, 0.5];
ship_color = 'red';

% Fonts
label_font = 20;

% Debris plot parameters
debris_marker = 'square';
debris_marker_size = 8;
debris_color = [
        56, 114, 161;
        57, 110, 71;
        150, 139, 8]/255;

% Agent plot parameters
agent_marker = 'o';
agent_marker_size = 12;
agent_color = debris_color;

%% Initialize plot

% Initialize figure 
f = figure(1);
% f.WindowState = 'maximized';
f.Position = [10, 10, 1500, 1500];    
f.Color = 'white';

% gcs properties
box on
axis equal
axis([0, dim_x, 0, dim_y])
set(gca,'XTick',[])
set(gca,'YTick',[])
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
xlabel('$\textsf{x}$', 'Interpreter', 'latex', 'FontSize', label_font)
ylabel('$\textsf{y}$', 'Interpreter', 'latex', 'FontSize', label_font)

%% Plot static objects

hold on

% obstacles
n_obs = size(rectangle_matrix, 1);
for obs_idx = 1:n_obs
    rectangle('position', rectangle_matrix(obs_idx, :), 'FaceColor', 'black');
end

% Voronoi partitions
for idx = 1:3
    x = voronoi_edges(idx, [1, 3]);
    y = voronoi_edges(idx, [2, 4]);
    plot(x, y, 'Color', partition_color, 'LineWidth', 1.1)
end

% Voronoi center
plot(voronoi_center(1), voronoi_center(2), 'Marker', 'o', 'MarkerSize', 8, ...
    'MarkerFaceColor', ship_color, 'MarkerEdgeColor', ship_color)

% Debris
deb = cell(1);
for idx = 1:3
deb{idx} = plot(debris{idx}(:,1), debris{idx}(:,2), debris_marker, ...
    'MarkerSize', debris_marker_size, 'MarkerEdgeColor', debris_color(idx, :), ...
    'MarkerFaceColor', debris_color(idx, :));
end

% Agent initial location
agent = cell(1);
for idx = 1:3
agent{idx} = plot(node_matrices{idx}(1, 1), node_matrices{idx}(1, 2), agent_marker, ...
    'MarkerSize', agent_marker_size, 'MarkerEdgeColor', 'k', ...
    'MarkerFaceColor', agent_color(idx, :));
end

% initialize GIF
frame = getframe(gcf);
im = frame2im(frame);
[imind, cm] = rgb2ind(im, 256);
imwrite(imind, cm, save_path, 'gif', 'Loopcount', 1);

%% Animate motion

simulation_ended = false;
goal_selected = [false; false; false];
backward_trip = [false; false; false];
current_goal = cell(1);
current_idx = [1, 1, 1];
current_path = cell(1);
current_path{1, 1} = [];
current_path{2, 1} = [];
current_path{3, 1} = [];

while ~simulation_ended 
    
    % Goal selection + path computation
    for agent_idx = 1:3
        if goal_selected(agent_idx) == false
            if ~isempty(debris{agent_idx})
                % Select random goal
                n_goals = size(debris{agent_idx}, 1);
                goal_idx = randi(n_goals);
                current_goal{agent_idx} = debris{agent_idx}(goal_idx, :);
                goal_selected(agent_idx) = true;

                % Remove goal from list
                debris{agent_idx}(goal_idx, :) = [];   
                
                % Find goal in the node matrix
                % Note: some nodes are present multiple times in the saved
                % data. To avoid finding multiple indexes, the goal is
                % looked for only in the last part of the matrix (where
                % they are found by construction of node_matrices)
                node_idx = find(ismember(node_matrices{agent_idx}(1002:end, 1:2), current_goal{agent_idx}, 'rows'));
                node_idx = node_idx + 1001;

                % Compute path to the goal and save it
                while node_idx ~= 0
                    current_path{agent_idx} = [current_path{agent_idx}; node_matrices{agent_idx}(node_idx, 1:2)];
                    node_idx = node_matrices{agent_idx}(node_idx, 3);             % parent node
                end
                current_path{agent_idx} = [current_path{agent_idx}; node_matrices{agent_idx}(1, 1:2)];   % add root node
                current_path{agent_idx} = flip(current_path{agent_idx});        % reverse to have start-to-goal
            else
                goal_selected(agent_idx) = false;
            end
        end
    end

    % If no robot has any more goal to reach
    if any(goal_selected) == false
        simulation_ended = true;
        break
    end

    % 1-step path execution
    for agent_idx = 1:3
        if goal_selected(agent_idx) == true
            idx = current_idx(agent_idx);
            delete(agent{agent_idx})
            agent{agent_idx} = plot(current_path{agent_idx}(idx, 1), current_path{agent_idx}(idx, 2), agent_marker, ...
                'MarkerSize', agent_marker_size, 'MarkerEdgeColor', 'k', ...
                'MarkerFaceColor', agent_color(agent_idx, :));
            if current_idx(agent_idx) == size(current_path{agent_idx}, 1) && backward_trip(agent_idx) == false
                delete(deb{agent_idx})
                deb{agent_idx} = plot(debris{agent_idx}(:,1), debris{agent_idx}(:,2), debris_marker, ...
                    'MarkerSize', debris_marker_size, 'MarkerEdgeColor', debris_color(agent_idx, :), ...
                    'MarkerFaceColor', debris_color(agent_idx, :));
                current_path{agent_idx} = flip(current_path{agent_idx});
                current_idx(agent_idx) = 1;
                backward_trip(agent_idx) = true;
            elseif current_idx(agent_idx) == size(current_path{agent_idx}, 1) && backward_trip(agent_idx) == true
                current_path{agent_idx} = [];
                current_idx(agent_idx) = 1;
                backward_trip(agent_idx) = false;
                goal_selected(agent_idx) = false;
            else
                current_idx(agent_idx) = current_idx(agent_idx) + 1;
            end
        end
    end

    % Add frame to GIF
    gif_delay = 0.003;
    frame = getframe(gcf);
    im = frame2im(frame);
    [imind, cm] = rgb2ind(im, 256);
    imwrite(imind, cm, save_path, 'gif','WriteMode', 'append', 'DelayTime', gif_delay);

end

close all


