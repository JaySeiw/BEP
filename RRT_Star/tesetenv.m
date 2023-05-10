%Rectangle matrix where columns are: index, x, y, w, h
%% Scenario with a U-shaped obstacle around the start
Ustart= [1,1,3,2,7; 
         2,1,8,7,2;
         3,6,3,2,7;
         4,20,10,6,5;
         5,11,26,3,9;
         6,25,30,8,6;
         7,40,20,7,10;
         8,12,16,3,2;
         9,25,2,12,3];
%%Scenario with a U-shaped obstacle around the goal
Ugoal= [1,12,41,2,7; 
         2,12,41,7,2;
         3,6,3,2,7;
         4,20,10,6,5;
         5,11,26,3,9;
         6,25,30,8,6;
         7,40,20,7,10;
         8,12,16,3,2;
         9,25,2,12,3;
        10,17,41,2,7];
%%Scenario with an obstacle with many protrusions
protruding= [1,20,25,5,11;
             2,22,31,6,4;
             3,21,15,3,15;
             4,14,24,8,5;
             5,5,7,6,4;
             6,31,2,14,4;
             7,36,20, 2,6;
             8,40,40,5,2;
             9,8,35,3,4];

%%Scenario with a a large obstacle through the middle of the graph
bigobstacle= [1,1.5,25,45,7;
             2,6,8,4,9;
             3,20,37,3,8;
             4,7,40,4,9;
             5,20,8,10,5;
             6,29,17,7,5;
             7,34,38,8,8;];

%%Scenario with a narrow gap between some obstacles
narrowgap=[1,12,41,2,7; 
             2,6,3,2,7;
             3,20,10,6,5;
             4,11,26,3,9;
             5,25,30,8,6;
             6,40,20,7,10;
             7,14,6,3,12;
             8,25,2,12,3;
             9,0,18.5,20,7];
%% Input values

start = [4, 5, 0, 0];
goal = [16, 45, 0, 0];
length = 3;
nodes = 1000;
num_runs = 1; %the number of times to run each scenario
environment=Ustart;

<<<<<<< HEAD

start = [4, 5, 0];
goal = [16, 45, 0];
length = 3;
nodes = 3000;
num_runs = 10; %the number of times to run each scenario
=======
results = cell(num_runs, 3);
for i = 1:num_runs
    [node_count, no_of_nodes_path, len_path] = RRT_star_function(environment, start, goal, length, nodes);
    results{i} = [node_count, no_of_nodes_path, len_path];
end
>>>>>>> 540a9e5ec649e2cf1f0cc3ad8c07820e74dc9de4

scenarios={Ustart, Ugoal, protruding,bigobstacle,narrowgap} ;

% Initialize a structure variable to hold the results
results = struct();

for i = 1:5 % loop through each environment
    [rows, ~] = size(scenarios{i}); % get the number of rows in the current environment
    
    for j = 1:num_runs % loop through each run
        % call the RRT function here and save the results
        [node_count, no_of_nodes_path, len_path] = RRT_star_function(scenarios{i},start,goal,length,nodes);
        
        % Add the results to the structure variable
        results(i,j).node_count = node_count;
        results(i,j).no_of_nodes_path = no_of_nodes_path;
        results(i,j).len_path = len_path;
    end
    
    % Save the structure variable to a file
    save(sprintf('rrt_star_results_env%d.mat', i), 'results');
end