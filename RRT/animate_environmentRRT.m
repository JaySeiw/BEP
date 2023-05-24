function animate_environmentRRT(plot_data)
%ANIMATE_ENVIRONMENT Generates an animation of the RRT evolution and saves it.
    
    % Retrieve data
    obs = plot_data.obstacles;
    n_obs = size(obs, 1);
    goal = plot_data.goal;
    r_goal = plot_data.r_goal;
    x0 = plot_data.x0;
    V = plot_data.V;
    N = size(V, 1);
    E = plot_data.E;
    path = plot_data.path;
    n_path = size(path, 1);
    delay = plot_data.delay;    % gif time between frames
    save_path = strcat(plot_data.save_path, '.gif');
    
    % Plot object colors
    obs_color = 'k';
    x0_color = 'red';
    goal_color = 'blue';
    goal_light_color = [[62, 120, 156]/255, 0.5]; 
    edge_color = [204, 129, 16]/255;
    node_color = [204, 94, 16]/255;

    % Create figure object
    f = figure();
    f.WindowState = 'maximized';
    f.Position = [0.05, 0.05, 0.9, 0.9];    
    f.Color = 'white';

    % Axis properties
    xlabel('$x$', 'Interpreter', 'latex')
    ylabel('$y$', 'Interpreter', 'latex')
    box on
    grid
    grid minor
    axis([0, 50, 0, 50])
    axis square
    
    % Plot environment 
    hold on
    p1 = plot(x0(1), x0(2), 's', 'MarkerSize', 10, 'MarkerFaceColor', x0_color, 'MarkerEdgeColor', x0_color);
    rectangle('Position', [goal-r_goal, 2*r_goal, 2*r_goal], 'Curvature', [1 1], ...
        'FaceColor', goal_light_color, 'EdgeColor', goal_light_color);
    p2 = plot(goal(1), goal(2), '.', 'MarkerSize', 12, 'MarkerFaceColor', goal_color, 'MarkerEdgeColor', goal_color);
    %p3 = plot(centers(1,1), centers(1,2), '.', 'MarkerSize', 12, 'Color', obs_color);
    for ii = 1:n_obs
        rectangle('Position', obs(ii, 2:5), 'FaceColor', obs_color);
    end
    for iter = 1:N-1
        iter
        N
        E(iter, 1)
        E(iter, 2)
        E
        V
        n1 = V(E(iter, 1), 1:2);
        n2 = V(E(iter, 2), 1:2);
        plot([n1(1), n2(1)], [n1(2), n2(2)], '-', 'LineWidth', 0.9, 'Color', edge_color)
        p4 = plot(V(iter+1, 1), V(iter+1, 2), '.', 'MarkerSize', 7, 'MarkerFaceColor', node_color, ...
            'MarkerEdgeColor', node_color);
        if iter == N-1
            for ii = 1:n_path-1
                n1 = path(ii, :);
                n2 = path(ii+1, :);
                plot([n1(1), n2(1)], [n1(2), n2(2)], '-', 'LineWidth', 2, 'Color', edge_color)
            end
            for ii = 1:n_path
                plot(path(ii, 1), path(ii, 2), '.', 'MarkerSize', 10, 'MarkerFaceColor', node_color, ...
                    'MarkerEdgeColor', node_color);
            end
        end
        
        % Axis labels, grid, legend etc.
        title_text = sprintf('\\textbf{RRT graph} [iteration \\#%i]', iter);
        title(title_text, 'Interpreter', 'latex')
        legend([p1, p2,  p4], '$x_0$', '$x_\textnormal{goal}$', 'obstacles', 'nodes', ...
                'Location', 'northeastoutside', 'Interpreter', 'latex')
         
        % Save animation
        pause(0.01)
        frame = getframe(gcf);
        im = frame2im(frame);
        [imind, cm] = rgb2ind(im, 256);
        if iter == 1
            imwrite(imind, cm, save_path, 'gif', 'Loopcount', 1,...
            'DelayTime', delay);
        else
            imwrite(imind, cm, save_path, 'gif','WriteMode', 'append',...
            'DelayTime', delay);
        end
    end
end

