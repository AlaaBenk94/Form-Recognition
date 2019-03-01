clear;
clc;
img_db_path = './db/';
img_db_list = glob([img_db_path, '*.gif']);
im = randi(numel(img_db_list));
impath = './db/bat-16.gif';

img = logical(imread(impath));
[fd, r, m, shape] = compute_fd1(img);

figure;
subplot(1,2,1);
imshow(img);
subplot(1,2,2);
plot(r);

