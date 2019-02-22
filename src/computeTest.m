clear;
clc;
img_db_path = './db/';
img_db_list = glob([img_db_path, '*.gif']);
im = randi(numel(img_db_list));
img = logical(imread(img_db_list{im}));
[fd, r, m, shape] = compute_fd(img);

mi = m(1);
mj = m(2);

out = single(img);
out = insertMarker(out, [mj, mi], 'color','red'); 
for i=1:size(shape,1)
   out = insertMarker(out, [shape(i,2), shape(i,1)]); 
end
figure; imshow(out);

figure; plot([1:size(r,1)], r);