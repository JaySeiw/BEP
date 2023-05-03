%% Obstacle builder
close all hidden;
%Graph Variables:
Xmax=50;%maximum x-dimension
Ymax=50;%maximum y-dimension

% create 0 matrix with [3 columns: C1 for ID, C2&C3 for coordinates] and 
% [N rows for the nodes]
N=10;
mat=zeros(N,3);
for i = 1:N
    randXN=Xmax*rand;
    randYN=Ymax*rand;
    new=[i randYN randXN];
    mat(i,:)=new;
    
end
figure ('Name','Nodes');
mate=mat(:,[2 3]);
plot(mat(:,2),mat(:,3),'rx')
%scatter(mat(:,2),mat(:,3));

%Bbstacle Variables:
MinObstacleCount=6;%define min amount of obstacles
MaxObstacleCount=20;
ObstacleCount=randi([MinObstacleCount,MaxObstacleCount]);%define max amount of obstacles
ObstacleMatrix=zeros(ObstacleCount,5);%create obstacle matrix for rectangles where columns are: index, x, y, w, h
ObstacleMap=zeros(ObstacleCount,4);
%figure('Name','Obstacles');
%axis([0,50,0,50])
j=1;
while j<=ObstacleCount %while loop for constructing obstacles
    x1=Xmax*rand; %random x coordinate
    y1=Xmax*rand; %random y coordinate
    w=Ymax*rand*0.2+1;  %random width
    h=Ymax*rand*0.1+1;  %random height
    k=1; 
    while k<j+1 %while loop for checking all obstacles for collission with newly made obstacle

        %Define variables
        OM2=ObstacleMatrix(k,2);
        OM3=ObstacleMatrix(k,3);
        xv=ObstacleMatrix(k,2)+ObstacleMatrix(k,4);
        yv=ObstacleMatrix(k,3)+ObstacleMatrix(k,5);
        Ow=x1+w;
        Oh=y1+h;
             %Point in obstacle
             % x and y inside obstacle
             if x1>=OM2 & x1<=xv & y1>=OM3 & y1<=yv
                    x1=Xmax*rand;
                    y1=Xmax*rand;
                    disp('If-statement 1 break');
                    k=1;

%following drawing depicts an obstacle in our state space where every vertice is assigned a number, zo we can describe how the new obstacle could intersect.                     
%     3                 
%     __                 yv.__.                             Oh.__.
% 2  |__|  4               |__| (points on old obstacle)      |__| (points on new obstacle) 
%                       OM3'  'xv                           y1'  'Ow
%     1                    OM2                                x1


             %other possible intersections       
             else
                    % Oh inside interval of obstacle onwards
                    if Oh<=yv & Oh>= OM3
                        % y1 and Oh inside interval of obstacle
                        if y1<=yv & y1>=OM3
                            % x1 outside interval and Ow inside interval of obstacle: 2 intersection fully
                            if x1<=OM2 & x1<=xv & Ow>=OM2 & Ow>=xv 
                                x1=Xmax*rand;
                                y1=Xmax*rand;
                                disp('If-statement 2f break');
                                k=1;
                            % x1 and Ow outside interval of obstacle: 2,4 intersection
                            elseif x1<=OM2 & x1<=xv & Ow<=OM2 & Ow<=xv 
                                x1=Xmax*rand;
                                y1=Xmax*rand;
                                disp('If-statement 2,4 break');
                                k=1;
                            end
                        % Oh inside interval and y1 outside interval
                        elseif y1<=yv & y1<=OM3
                            % x1 and Ow outside interval of obstacle: 2 intersection partially down
                            if x1<=OM2 & x1<=xv & Ow<=OM2 & Ow<=xv
                                x1=Xmax*rand;
                                y1=Xmax*rand;
                                disp('If-statement 2pd break');
                                k=1;
                            % x1 outside and Ow inside interval of obstacle: 2,1 intersection 
                            elseif x1<=OM2 & x1<=xv & Ow>=OM2 & Ow<=xv
                                x1=Xmax*rand;
                                y1=Xmax*rand;
                                disp('If-statement 2,1 break');
                                k=1;
                            % x1 inside and Ow outside interval of obstacle: 1,4 intersection 
                            elseif x1>=OM2 & x1<=xv & Ow>=OM2 & Ow>=xv
                                x1=Xmax*rand;
                                y1=Xmax*rand;
                                disp('If-statement 1,4 break');
                                k=1;
                            % x1 and Ow inside interval of obstacle: 3 intersection fully
                            elseif x1>=OM2 & x1<=-xv & Ow>=OM2 & Ow<=xv
                                x1=Xmax*rand;
                                y1=Xmax*rand;
                                disp('If-statement 3f break');
                                k=1;
                            end
                        end
                    % Oh outside interval of obstacle onwards
                    % x1 inside interval of obstacle
                    elseif x1>=OM2 & x1<=xv
                        % y1 and Oh outside of interval obstacle
                        if y1<=OM3 & y1<=yv & Oh>=OM3 & Oh>=yv
                            % Ow inside interval of obstacle: 1,3 intersection
                            if Ow>=OM2 & Ow<=xv 
                                x1=Xmax*rand;
                                y1=Xmax*rand;
                                disp('If-statement 1,3 break');
                                k=1;
                            % Ow outside interval of obstacle: 1,3 intersection partially right
                            elseif Ow>=OM2 & Ow>=xv
                                x1=Xmax*rand;
                                y1=Xmax*rand;
                                disp('If-statement 1,3pr break');
                                k=1;
                            end
                        end
                    % x1 outside interval of obstacle onwards
                    elseif x1<=OM2 & x1<=xv
                        % Ow inside interval of obstacle
                        if Ow>=OM2 & Ow<=xv
                            % y1 inside and Oh outside interval of obstacle: 2,3 intersection
                            if y1>=OM3 & y1<=yv & Oh>=OM3 & Oh>=yv
                                x1=Xmax*rand;
                                y1=Xmax*rand;
                                disp('If-statement 2,3 break');
                                k=1;
                            % y1 and Oh outside interval of obstacle: 1,3 intersection partially left
                            elseif y1<=OM3 & y1<=yv & Oh>=OM3 & Oh>=yv
                                x1=Xmax*rand;
                                y1=Xmax*rand;
                                disp('If-statement 1,3pl break');
                                k=1;
                            end
                        end
                    % y1 inside and x1, Ow and Oh outside interval obstacle: 2 intersection partially up
                    elseif y1>=OM3 & y1<=yv & x1<=OM2 & x1<=xv & Ow>=OM2 & Ow>=xv & Oh>=OM3 & Oh>=yv
                        x1=Xmax*rand;
                        y1=Xmax*rand;
                        disp('If-statement 2pu break');
                        k=1;
                    %encapsulation obstacle
                    elseif y1<=OM3 & y1<=Oh & Oh>=OM3 & Oh>=yv & x1<=OM2 & x1<=xv & Ow>=OM2 & Ow>=xv
                        x1=Xmax*rand;
                        y1=Xmax*rand;
                        disp('If-statement e break');
                        k=1;
                    else
                        k=k+1;
                    end
             end
                                  
    	    k=k+1;
     end
        
    Obstacle=[j,x1,y1,w,h];
    ObstacleMatrix(j,:)=Obstacle;
    Obstaclemapper=[x1,y1,x1+w,y1+h]; %map of obstacles with [x1,y1,x2,y2]
    ObstacleMap(j,:)=Obstaclemapper;
    rectangle('position', Obstacle(:,[2,3,4,5]));
    j=j+1;
end
writematrix(ObstacleMap, 'ObstacleMap.csv');
writematrix(ObstacleMatrix, 'RectangleMatrix.csv');




 
  