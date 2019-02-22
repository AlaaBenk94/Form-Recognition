function [fd,r,m,poly] = compute_fd(img)
%disp("Compute FD");
N = 512; % à modifier !!!
M = 100; % à modifier !!!
h = size(img,1);
w = size(img,2);

[mi, mj] = barycenter(img); % calcul de barycentre
m = [mi, mj];
t = linspace(0,2*pi,N);

k = 1;
poly = zeros(N, 2);

for x = 1:N
    %disp("FOR Loop");
    i = mi;
    j = mj;
    a = 1;
    p = 1;
    %fprintf("i=%i, j=%i, h=%d, w=%d, img(i,j)=%d\n",i,j,h,w,img(i,j));
    while (i<=h && i>0) && (j<=w && j>0) && (img(i,j)==1)    
        j = mj + a*p*cos(t(1,x));
        i = mi + a*p*sin(t(1,x));
        %fprintf("WHILE Values k=%d, i=%d, j=%d\n",k, int32(i),int32(j));
        poly(k,1) = int32(i);
        poly(k,2) = int32(j);
        a=a+1;
    end
    k = k+1;
end

r = ((poly(:,1) - mean(poly(:,1))).^2 + (poly(:,2) - mean(poly(:,2))).^2).^(0.5); % vecteur descripteur !!!
fd = fft(r,M);
end