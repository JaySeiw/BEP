%Rectangle matrix where columns are: index, x, y, w, h
%%Scenario with a U-shaped obstacle around the start
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


% start = [4, 5, 0];
% goal = [16, 45, 0];
% length = 3;
% nodes = 5000;
% num_runs = 10; %the number of times to run each scenario
% scenario=Ustart;

% Loop over each run for the current scenario
% for j = 1:num_runs
%     % Call the RRT function with the current scenario, start and goal positions, and other inputs
%     [node_count, no_of_nodes_path, len_path] = RRTfunction(scenario, start, goal, length, nodes);
% 
%     % Save the results in a .mat file with a unique name for each scenario and run
%     filename = sprintf('results_%s_run%d.mat', scenario, j);
%     save(filename, 'node_count', 'no_of_nodes_path',"len_path");
% end
