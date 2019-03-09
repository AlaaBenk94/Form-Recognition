function [fd,r,m,poly] = compute_fd3(img)
%disp("Compute FD");
N = 512;
M = 190*150;
h = size(img,1);
w = size(img,2);

[mi, mj] = barycenter(img); % calcul de barycentre
m = [mi, mj];

poly = zeros(h,w);

for i=1:(h-1)
    for j=1:(w-1)
        if img(i,j) ~= img(i,j+1)
            if img(i,j) == 1
                poly(i,j) = 1;
            else
                poly(i,j+1) = 1;
            end
        end
        
        if img(i,j) ~= img(i+1,j)
            if img(i,j) == 1
                poly(i,j) = 1;
            else
                poly(i+1,j) = 1;
            end
        end
        
    end
end

% [i, j] = find(poly==1);
% poly = [i, j];

r = ((poly(:,1) - mean(poly(:,1))).^2 + (poly(:,2) - mean(poly(:,2))).^2).^(0.5);
ftr = fft(r);
fd = abs(ftr(1:M))/abs(ftr(1));
end
