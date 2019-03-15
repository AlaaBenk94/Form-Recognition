Projet M1 Informatique
======================
Représentation de Données Visuelles
Utilisation d'un descripteur de Fourier pour la reconnaissance de formes


Auteurs
=======
Alaa Eddine BENKARRAD
Walid HAFIANE


1 Méthode de base
=================
La méthode basique est décrite dans l'énnoncé comme suit :
1. Calculer le barycentre m des pixels blancs
2. calculer l'intersection p(t) entre le contour de l'objet et le rayon partant de m par la méthode suivante :
	(a) partir du barycentre m,
	(b) avancer le long du rayon d'angle t tant que le pixel est blanc
	(c) Le dernier pixel blanc rencontré le long du rayon correspond à p(t).
3. Soit r(t), profil de la forme, la distance euclidienne entre m et p(t).
Cette méthode nous a permi d'obtenir une précision de 65.43% selon ma mésure dénie en ci-aprés (section 4).



2 Amélioration
==============
La méthode de base est simple à implanter et atteint de bons resultats. Cependent, elle a quelques problemes dont celui le plus remarquable est le cas où le barycentre m est pixel noir. Dans ce cas,
l'algorithme ne rentre pas dans la boucle et passe aux points suivants qui vont avoir le même résultat, le point de barycentre m.
Afin de résoudre le problème de barycentre noir, nous proposons une modification au niveau de l'étape 2.b de l'algorithme de base. Donc au lieu d'avancer le long du rayon d'angle t tant que le pixel est blanc, on doit parcourir tous les pixels du l'angle t, de barycentre jusqu'aux extremitées de l'image et prendre le dernier point blanc rencontré. Cela a permi de donner les résultats presents sur la figure ci-dessous avec une précision de
80.29%.
Nous avons esseyé d'autres méthodes qui ont apporter des améliorations à la méthode de base, mais pas à la premiere amélioration, comme :
	- Prendre la moyenne des points du rayon d'angle t pour chaque angle (précision : 76.14%)
	- Inclure pour chaque rayon d'angle t, le premier et le dernier points blancs (précision : 72.43%)



3 Calibrage des parametres M et N
=================================
L'obtention d'un bon modèle ne dépend pas seulement de la méthode choisie, mais aussi des bons paramètres.
Par la suite, nous ajustons les paramètres M et N.
Due à l'absence d'une méthode exacte pour le réglage de ces paramètres qui sont dépendants du problème
donné, on fait recours a une approche dite "essai et erreur" ou encore, en anglais, "trial and error". Cette
dernière consiste à fixer les paramètres et varier un seul paramètre a la fois.
Avant d'entamer le réglage des parametres, on a défini une mesure d'évaluation des performances. Les valeurs
de cette derniere sont utilisées pour calibrer les parametres. Elle est definie comme suit :
	precision = 1/ReqImg * somme(mi/top)
où :
	ReqImg :- est le nombre d'image requêtes
	i :- le numéro d'image requête
	m :- ile nombre d'images de la base qui ressemblent a l'image requête i
	top :- est le nombre d'images, ordonnées par leurs score, consédérées.


3.1 Paramètre N
===============
On a fixé M = N et fait varier N sur l'ensemble {8,16,32,64,128,256,512,1024,2048,4096}. Les resultats sont illustrée sur le tableau suivant

Précision \ N 		8 		16 		32 		64 		128 	256 	512 	1024 	2048 	4096
amélioration 		50.29 	58.29 	69.43 	76.29 	79.43 	79.43 	80.29 	80.00 	80.00 	80.29

On peut remarquer que, jusqu'a N=512 la mesure de performance est croissante et elle se stabilise aprés cette valeurs. On conclue donc que la valeur 512 est une valeur raisonnable pour N.


3.2 Paramètre M
===============
Pour ce test, on a fixé la valeur de N=512 et fait varier M sur l'ensemble {8,16,32,64,128,256,512}. Les resultats sont présenté par le tableau suivant.

Précision \ M 		8 		16 		32 		64 		128 	256 	512
amélioration 		72.57 	79.43 	80.29 	80.00 	80.29 	80.29 	80.29

En analysant les resultats du tableau, on remarque que la précision atteint sa valeur maximale en M = 32. Ensuite, elle est stable juste aprés cette derniere. Ce qui nous mène a fixer la valeur de M à 32.

