function [Mi, Mj] = barycenter(img)

[I, J] = find(img == 1);

if size(I,1) == 0 ||  size(I,2) == 0
    Mi = size(img,1)/2;
    Mj = size(img,2)/2;
else
    Mi = int32(mean(I));
    Mj = int32(mean(J));
end
end
