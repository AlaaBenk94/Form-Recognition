clear;
clc;
img_db_path = './db/';
img_db_list = glob([img_db_path, '*.gif']);
im = randi(numel(img_db_list));
impath = './db/dog-6.gif';

img = logical(imread(impath));
[fd, r, m, shape] = compute_fd3(img);

figure;
subplot(1,2,1);
imshow(img); hold on;
plot(shape(:,2),shape(:,1), 'g');
subplot(1,2,2);
plot(r);

