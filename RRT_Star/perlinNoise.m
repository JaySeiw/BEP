Xmax = 50;
Ymax = 50;
im = zeros(Xmax, Ymax);
im = perlin_noise(im);

figure; imagesc(im); %colormap gray;

% Find troughs in the Perlin noise image
thresh = 0.001; % Threshold to determine troughs
troughs = im < thresh;

[ObstacleMatrix, RectangleMatrix ,edges]=EnvironmentBuilder(Ustart); %Obstaclematrix: [x1,y1,x2,y2], edges:  N x [x1, y1, x2, y2]
Height=height(RectangleMatrix); % Count rows of RectangleMatrix


no_of_debris=100;
debris=zeros(no_of_debris,2);
i=1;
while i<no_of_debris+1
    x_debris = randi([1 Xmax],1);  % Random x-coordinate for the hotspot center
    y_debris = randi([1 Ymax],1);  % Random y-coordinate for the hotspot center
    Intersection=InObstacleDetectCopy(x_debris,y_debris,ObstacleMatrix,Height);
    if Intersection==0 && troughs(y_debris,x_debris)
        debris(i,:)=[x_debris,y_debris];
        i=i+1;
    end
end

% Draw all rectangles
for q=1:Height
    rectangle('Position', RectangleMatrix(q,[2,3,4,5]), 'FaceColor','black');
end

plot(debris(:,1),debris(:,2), 'r.');

hold off;

function im = perlin_noise(im)

    [Xmax, Ymax] = size(im);
    i = 0;
    w = sqrt(Xmax*Ymax);

    while w > 3
        i = i + 1;
        d = interp2(randn(Xmax, Ymax), i-1, 'spline');
        im = im + i * d(1:Xmax, 1:Ymax);
        w = w - ceil(w/2 - 1);
    end
end 







