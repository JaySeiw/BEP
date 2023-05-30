n = 64;
m = 64;
im = zeros(n, m);
im = perlin_noise(im);

figure; imagesc(im); %colormap gray;

function im = perlin_noise(im)

    [n, m] = size(im);
    i = 0;
    w = sqrt(n*m);

    while w > 3
        i = i + 1;
        d = interp2(randn(n, m), i-1, 'spline');
        im = im + i * d(1:n, 1:m);
        w = w - ceil(w/2 - 1);
    end
end