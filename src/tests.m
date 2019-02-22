function [recall, precision] = my_tests()
% calcul des descripteurs de Fourier de la base de données
img_db_path = './db/';
img_db_list = glob([img_db_path, '*.gif']);
img_db = cell(1);
label_db = cell(1);
fd_db = cell(1);
for im = 1:numel(img_db_list)
    img_db{im} = logical(imread(img_db_list{im}));
    label_db{im} = get_label(img_db_list{im});
    disp(label_db{im}); 
    [fd_db{im},~,~,~] = compute_fd2(img_db{im});
    % affichage de pourcentage de traitement.
    clc;fprintf("%d%% Terminé\n",round((im/numel(img_db_list))*100));
end

% importation des images de requête dans une liste
img_path = './dbq/';
img_list = glob([img_path, '*.gif']);
%t=tic()
precision = 0;

% pour chaque image de la liste...
for im = 1:numel(img_list)
    
    % initialisation des parametres de calcul de precision
    accuracy = 0;
    label = get_label(img_list{im});
    label = erase(label, '.\dbq\');
    
    % calcul du descripteur de Fourier de l'image
    img = logical(imread(img_list{im}));
    [fd,r,m,poly] = compute_fd2(img);
       
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
        if strcmp(label, erase(label_db{I(i)}, '.\db\'))
            accuracy = accuracy+1;
        end    
    end
    % calcul de precision pour la class courrente
    accuracy = accuracy/top;
    precision = precision + accuracy;
    %fprintf("Accuracy(%s) = %f",label, accuracy);
    
    % affichage
    drawnow();
    waitforbuttonpress();
end

recall = 0;
precision = precision/numel(img_list);
%fprintf("Precision = %f\n",precision);
close all;
end
