function [recall, precision] = my_tests()
% calcul des descripteurs de Fourier de la base de données
img_db_path = strcat('.',filesep,'db',filesep);
img_db_list = glob([img_db_path, '*.gif']);
img_db = cell(1);
label_db = cell(1);
fd_db = cell(1);
for im = 1:numel(img_db_list)
    img_db{im} = logical(imread(img_db_list{im}));
    label_db{im} = get_label(img_db_list{im});
    [fd_db{im},~,~,~] = compute_fd(img_db{im});
    % affichage de pourcentage de traitement.
    clc;fprintf("%d%% Terminé\n",round((im/numel(img_db_list))*100));
end

% importation des images de requête dans une liste
img_path = strcat('.',filesep,'dbq',filesep);
img_list = glob([img_path, '*.gif']);
precision = 0;

% pour chaque image de la liste...
for im = 1:numel(img_list)
    
    % initialisation des parametres de calcul de precision
    accuracy = 0;
    label = get_label(img_list{im});
    label = strrep(label,img_path,'');
    
    % calcul du descripteur de Fourier de l'image
    img = logical(imread(img_list{im}));
    [fd,r,m,poly] = compute_fd(img);
       
    % calcul et tri des scores de distance aux descripteurs de la base
    for i = 1:length(fd_db)
        scores(i) = norm(fd-fd_db{i});
    end
    [scores, I] = sort(scores);
       
    % affichage des résultats    
    close all;
    %figure(1);
    figure('units','normalized','outerposition',[0 0 1 1])
    top = 5; % taille du top-rank affiché
    subplot(2,top,1);
    imshow(img), hold on;
    plot(m(2),m(1),'+b'); % affichage du barycentre
    plot(poly(:,2),poly(:,1),'v-g','MarkerSize',1,'LineWidth',1); % affichage du contour calculé
    subplot(2,top,2:top);
    plot(r); % affichage du profil de forme
    
    for i = 1:top
        subplot(2,top,top+i);
        imshow(img_db{I(i)}); % affichage des top plus proches images
        
        % calculer le nombre de "vraie ressemblance"
        %fprintf("im = %d, %s == %s ?\n",im, label, erase(label_db{I(i)}, '.\db\'));
        if strcmp(label, strrep(label_db{I(i)}, img_db_path,''))
            accuracy = accuracy+1;
        end    
    end
    % calcul de precision pour la class courrente
    accuracy = accuracy/top;
    precision = precision + accuracy;
    
    % affichage
    drawnow();
    waitforbuttonpress();
end

recall = 0;
precision = precision/numel(img_list);
fprintf("Précision = %f%%\n",round(precision*100,2));
close all;
end

function [fd,r,m,poly] = compute_fd(img)
N = 512;
M = 32;
h = size(img,1);
w = size(img,2);

[mi, mj] = barycenter(img); % calcul de barycentre
m = [mi, mj];
t = linspace(0,2*pi,N); % génération de N angles entre 0 et 2pi

k = 1;
poly = zeros(N, 2);

for x = 1:N
    % initialiser les points de depart au barycentre.
    i = mi; j = mj;
    poly(k,1) = int32(i); poly(k,2) = int32(j);
    a = 1;
    
    % se déplacer tout au long du rayon courant jusqu'a arriver au
    % extrimité de l'image. garder toujours le dernier point blanc.
    while (i<=h && i>0) && (j<=w && j>0)    
        if img(i,j)==1
            poly(k,1) = int32(i);
            poly(k,2) = int32(j);
        end
        j = mj + a*cos(t(1,x));
        i = mi + a*sin(t(1,x));
        a=a+1;
    end
    k = k+1;
end

r = ((poly(:,1) - mean(poly(:,1))).^2 + (poly(:,2) - mean(poly(:,2))).^2).^(0.5); % vecteur descripteur
ftr = fft(r); % transformé de fourier de r
fd = abs(ftr(1:M))/abs(ftr(1));
end

% methode pour calculer le barycentre
function [Mi, Mj] = barycenter(img)

% extraction des pixels blancs
[I, J] = find(img == 1);

% si l'image n'a pas de pixels blanc le barycentre est le centre d'image.
% sinon c'est la moyenne des coordonnées des points blancs.
if size(I,1) == 0 ||  size(I,2) == 0
    Mi = size(img,1)/2;
    Mj = size(img,2)/2;
else
    Mi = int32(mean(I));
    Mj = int32(mean(J));
end
end
