DROP TABLE IF EXISTS habitant CASCADE;
DROP TABLE IF EXISTS evenement CASCADE;
DROP TABLE IF EXISTS categorie CASCADE;
DROP TABLE IF EXISTS tag CASCADE;
DROP TABLE IF EXISTS photo CASCADE;
DROP TABLE IF EXISTS partage CASCADE;
DROP TABLE IF EXISTS possede CASCADE;
DROP TABLE IF EXISTS reserve CASCADE;
DROP TABLE IF EXISTS parente CASCADE;
DROP TABLE IF EXISTS classifie CASCADE;


CREATE TABLE habitant(
    idHab serial PRIMARY KEY,
    nom varchar(25) NOT NULL,
    prenom varchar(25) NOT NULL,
    dateNais date NOT NULL,
    mdp varchar(100) NOT NULL, -- correspond au mot de passe
    mail varchar(30) UNIQUE, 
    CONSTRAINT mail_valide UNIQUE (mail)
    -- on realise des NOT NULL partout pour verifier que toute les informations sont bien remplies
);


CREATE TABLE evenement(
    idEv serial PRIMARY KEY,    
    nom varchar(50) UNIQUE,
    ageMin int DEFAULT 0,
    ageMax int DEFAULT 120, 
    prix int DEFAULT 0,
    notice text, --description du programme de l'evenement
    NbPersonne int
    CONSTRAINT age CHECK (ageMin <= ageMax), --on verifie que les ages sont bien remplie on bonne endroit sans erreur 
    CONSTRAINT age_negatif CHECK (ageMin >= 0 and ageMax >= 0)
);


CREATE TABLE categorie(
    idCat serial PRIMARY KEY,
    nom varchar(50)
);


CREATE TABLE tag(
    idTag serial PRIMARY KEY,
    contenu varchar(50) NOT NULL
);


CREATE TABLE photo(
    idPhoto serial PRIMARY KEY,
    photo varchar(50) --lien vers une image
);


CREATE TABLE partage(
    idHab int,
    idEv int,
    idPhoto int,  
    PRIMARY KEY (idHab, idEv, idPhoto),
    FOREIGN KEY (idHab) REFERENCES habitant(idHab),
    FOREIGN KEY (idEv) REFERENCES evenement(idEv),
    FOREIGN KEY (idPhoto) REFERENCES photo(idPhoto)
    ON DELETE CASCADE ON UPDATE CASCADE
);



CREATE TABLE possede(
    idCat int,
    idEv int,
    PRIMARY KEY (idCat, idEv),
    FOREIGN KEY (idCat) REFERENCES categorie(idCat),
    FOREIGN KEY (idEv) REFERENCES evenement(idEv)
    ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE reserve(
    idHab int,
    idEv int,
    note int,
    avis text,
    dateEv date NOT NULL, 
    PRIMARY KEY (dateEv, idHab, idEv),
    CONSTRAINT noteMax CHECK (note <= 20), --on met une note sur 20 on pourra changer si necessaire
    CONSTRAINT noteMin CHECK (note >= 0),
    FOREIGN KEY (idHab) REFERENCES habitant(idHab),
    FOREIGN KEY (idEv) REFERENCES evenement(idEv)
    ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE parente(
    parent int,
    enfant int,
    PRIMARY KEY (parent, enfant),
    FOREIGN KEY (parent) REFERENCES habitant(idHab),
    FOREIGN KEY (enfant) REFERENCES habitant(idHab)
    ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE classifie(
    idTag int,
    idEv int,
    idHab int,  
    PRIMARY KEY(idTag, idEv, idHab),
    FOREIGN KEY (idTag) REFERENCES tag(idTag),
    FOREIGN KEY (idEv) REFERENCES evenement(idEv),
    FOREIGN KEY (idHab) REFERENCES habitant(idHab)
    ON DELETE CASCADE ON UPDATE CASCADE
);


INSERT INTO habitant(nom, prenom, dateNais, mdp, mail) VALUES ('POTTIER', 'Marc', '2001-05-15', 'XPz47y@4dsyu', 'marc.pottier@gmail.com') RETURNING idHab;
INSERT INTO habitant(nom, prenom, dateNais, mdp, mail) VALUES ('POTTIER', 'Marie', '1978-02-01', 'Petitchien780', 'm.poittier@gmail.com') RETURNING idHab;
INSERT INTO habitant(nom, prenom, dateNais, mdp, mail) VALUES ('LOUIS', 'Laura', '1999-12-21', 'guy552gf', 'laura.louis@outlook.fr') RETURNING idHab;
INSERT INTO habitant(nom, prenom, dateNais, mdp, mail) VALUES ('ARBRE', 'Jean-Michel', '1948-08-03', '12345:;', 'jean-mi.arbre@yahoo.fr') RETURNING idHab;
INSERT INTO habitant(nom, prenom, dateNais, mdp, mail) VALUES ('GOMEZ', 'Selena', '2009-11-16', '987654321', 'selena.gomez@live.fr') RETURNING idHab;
INSERT INTO habitant(nom, prenom, dateNais, mdp, mail) VALUES ('POTTIER', 'Marine', '1976-12-12', 'AkjgfT254D', 'ma.arbre@yahoo.fr') RETURNING idHab;
INSERT INTO habitant(nom, prenom, dateNais, mdp, mail) VALUES ('TOURISTE', 'Andre', '1928-01-01', 'ml;,njhbtfyuh', 'lunette.touriste@gmail.com') RETURNING idHab;
INSERT INTO habitant(nom, prenom, dateNais, mdp, mail) VALUES ('SULLIVAN', 'Josef', '1930-11-11', 'Jojosusu', 'jojo.susu@gmail.com') RETURNING idHab;
INSERT INTO habitant(nom, prenom, dateNais, mdp, mail) VALUES ('ALI', 'Preston', '2002-01-05', 'm=E=93p010Erl', 'preston.ali33@gmail.com') RETURNING idHab;
INSERT INTO habitant(nom, prenom, dateNais, mdp, mail) VALUES ('ELLIS', 'Johnson', '1958-01-01', 'ml534btfyuh', 'john.ellisf@gmail.com') RETURNING idHab;
INSERT INTO habitant(nom, prenom, dateNais, mdp, mail) VALUES ('ELLIS', 'Andrea', '1995-10-29', 'mluh5252', 'andrea31@gmail.com') RETURNING idHab;
INSERT INTO habitant(nom, prenom, dateNais, mdp, mail) VALUES ('ELLIS', 'Andrei', '1995-10-29', 'ab665m;k:!;!', 'andrei31.touriste@gmail.com') RETURNING idHab;
INSERT INTO habitant(nom, prenom, dateNais, mdp, mail) VALUES ('MORRISON', 'Haaris', '2000-01-05', '25kl45!;=5i', 'haaris.morrison@gmail.com') RETURNING idHab;
INSERT INTO habitant(nom, prenom, dateNais, mdp, mail) VALUES ('ROBBINS', 'Huw', '1974-03-22', 'ml_-(,gh', 'huw.robbins@gmail.com') RETURNING idHab;
INSERT INTO habitant(nom, prenom, dateNais, mdp, mail) VALUES ('ROBBINS', 'Huwua', '1970-08-06', 'kd:,2fyuh', 'huwua.robbins@gmail.com') RETURNING idHab;
INSERT INTO habitant(nom, prenom, dateNais, mdp, mail) VALUES ('MARQUEZ', 'Eric', '1988-02-20', '3545552', 'eric.marquez@gmail.com') RETURNING idHab;
INSERT INTO habitant(nom, prenom, dateNais, mdp, mail) VALUES ('ADMIN', 'Admin', '1919-12-25', 'admin', 'admin.admin@gmail.com') RETURNING idHab; 


INSERT INTO evenement(nom, ageMin, prix, notice, NbPersonne) VALUES('Tourcoing game week', 13, 12, 'Le rendez-vous de tout les gamers de la ville à ne surtout pas manquer !', 200) RETURNING idEv;
INSERT INTO evenement(nom, ageMax, prix, notice) VALUES('La fête de la patate', 90, 25, 'Venez goûter nos centaines de variétés de patates !') RETURNING idEv;
INSERT INTO evenement(nom, ageMin, ageMax, notice) VALUES('Fête forraine de Tourcoing', 4, 60, 'Testez nos attractions à sensations et goûtez nos fameuses sucreries !') RETURNING idEv;
INSERT INTO evenement(nom, ageMin, ageMax, prix, notice, NbPersonne) VALUES('Concert de métal', 16, 49, 30, 'Venez écouter les plus grands groupes de métal de notre génération !', 400) RETURNING idEv;
INSERT INTO evenement(nom, ageMin, ageMax, prix, notice, NbPersonne) VALUES('Concert de pop rock', 16, 49, 15, 'Concert d`artiste  de chanteur pop rock en vogue', 400) RETURNING idEv;
INSERT INTO evenement(nom, ageMin, notice, NbPersonne) VALUES('Cinéma pleine air', 10, 'Venez voir le nouveaux film d`action du moment', 400) RETURNING idEv;



INSERT INTO categorie(nom) VALUES('Gamers') RETURNING idCat;
INSERT INTO categorie(nom) VALUES('Concert') RETURNING idCat;
INSERT INTO categorie(nom) VALUES('Festival') RETURNING idCat;
INSERT INTO categorie(nom) VALUES('Musique') RETURNING idCat;
INSERT INTO categorie(nom) VALUES('Métal') RETURNING idCat;
INSERT INTO categorie(nom) VALUES('Nourriture') RETURNING idCat;
INSERT INTO categorie(nom) VALUES('Patate') RETURNING idCat;


INSERT INTO tag(contenu) VALUES ('Les gamers sont la !') RETURNING idTag;
INSERT INTO tag(contenu) VALUES ('Hardcore') RETURNING idTag;
INSERT INTO tag(contenu) VALUES ('God of war enfin') RETURNING idTag;
INSERT INTO tag(contenu) VALUES ('Hmm délicieux') RETURNING idTag;
INSERT INTO tag(contenu) VALUES ('Les auto-tamponneuse de folie') RETURNING idTag;
INSERT INTO tag(contenu) VALUES ('Les montagnes russes oui') RETURNING idTag;
INSERT INTO tag(contenu) VALUES ('Les auto-tamponneuse de folie') RETURNING idTag;
INSERT INTO tag(contenu) VALUES ('gamer') RETURNING idTag;
INSERT INTO tag(contenu) VALUES ('pop rock cest cool') RETURNING idTag;
INSERT INTO tag(contenu) VALUES ('miam') RETURNING idTag;
INSERT INTO tag(contenu) VALUES ('vive les maneges') RETURNING idTag;
INSERT INTO tag(contenu) VALUES ('Billy Billy') RETURNING idTag;


INSERT INTO photo(photo) VALUES ('tourcoing_games_week.png') RETURNING idPhoto;
INSERT INTO photo(photo) VALUES ('fete_patate.jpg') RETURNING idPhoto;
INSERT INTO photo(photo) VALUES ('concert_metal.webp') RETURNING idPhoto;
INSERT INTO photo(photo) VALUES ('concert_pop_rock.webp') RETURNING idPhoto;
INSERT INTO photo(photo) VALUES ('cinema1.png') RETURNING idPhoto;
INSERT INTO photo(photo) VALUES ('fete_foraine.jpg') RETURNING idPhoto;

INSERT INTO parente VALUES (2, 1);
INSERT INTO parente VALUES (6, 1);
INSERT INTO parente VALUES (10, 11);
INSERT INTO parente VALUES (10, 12);
INSERT INTO parente VALUES (14, 15);

INSERT INTO partage VALUES (1, 1, 1);
INSERT INTO partage VALUES (4, 2, 2);
INSERT INTO partage VALUES (1, 4, 3);
INSERT INTO partage VALUES (12, 5, 4);
INSERT INTO partage VALUES (10, 6, 5);
INSERT INTO partage VALUES (10, 3, 6);

INSERT INTO classifie VALUES (3,1,1);
INSERT INTO classifie VALUES (1,1,1);
INSERT INTO classifie VALUES (5,3,6);
INSERT INTO classifie VALUES (7,3,6);
INSERT INTO classifie VALUES (8,1,10);
INSERT INTO classifie VALUES (9,4,9);
INSERT INTO classifie VALUES (2,1,12);
INSERT INTO classifie VALUES (4,2,13);
INSERT INTO classifie VALUES (10,2,10);
INSERT INTO classifie VALUES (11,3,15);
INSERT INTO classifie VALUES (12,4,14);

INSERT INTO reserve VALUES (1, 1, 18, 'J ai beaucoup aimé ', '2019-05-12');
INSERT INTO reserve(idHab, idEv, note, dateEv) VALUES (6, 3, 15, '2015-08-25');
INSERT INTO reserve(idHab, idEv, note, avis, dateEv) VALUES (3, 3, 8, 'Pas ouf peut mieux faire...', '2015-08-25');
INSERT INTO reserve(idHab, idEv, dateEv) VALUES (7, 5, '2023-12-19');
INSERT INTO reserve(idHab, idEv, dateEv) VALUES (15, 5, '2023-12-19');
INSERT INTO reserve(idHab, idEv, dateEv) VALUES (11, 5, '2023-12-19');
INSERT INTO reserve(idHab, idEv, dateEv) VALUES (7, 2, '2024-08-11');
INSERT INTO reserve(idHab, idEv, dateEv) VALUES (13, 2, '2024-08-11');
INSERT INTO reserve(idHab, idEv, dateEv) VALUES (5, 2, '2024-08-11');
INSERT INTO reserve(idHab, idEv, note, avis, dateEv) VALUES (14, 4, 19, 'Excellent', '2019-11-18');
INSERT INTO reserve(idHab, idEv, note, avis, dateEv) VALUES (9, 4, 18, 'Magique!', '2019-11-18');

INSERT INTO possede VALUES (1, 1);
INSERT INTO possede VALUES (2, 4);
INSERT INTO possede VALUES (3, 4);
INSERT INTO possede VALUES (4, 4);
INSERT INTO possede VALUES (5, 2);
INSERT INTO possede VALUES (6, 2);
INSERT INTO possede VALUES (3, 3);


--vue pour le nombre de personne a un instant donne
CREATE VIEW nombreParticipant AS (
    SELECT nom, NbPersonne, count(idEv) AS nbInscrit
    FROM reserve NATURAL JOIN evenement
    WHERE dateEv > CURRENT_DATE
    GROUP BY NbPersonne, nom
);


--vuen annexe pour le top 5 des meuilleur event
CREATE VIEW tauxParticipation AS(
    SELECT nom, NbPersonne, count(*)*100/NbPersonne AS pourcentage
    FROM evenement NATURAL JOIN reserve
    GROUP BY nom, NbPersonne
);


CREATE VIEW commentaireParEvent AS(
    SELECT nom, count(*) AS nbCommentaire
    FROM possede NATURAL JOIN evenement
    GROUP BY nom
);


CREATE VIEW tagParEvent AS(
    SELECT nom, count(*) AS nbTag
    FROM classifie NATURAL JOIN evenement
    GROUP BY nom
);

--vue pour les 5 meuilleurs event
CREATE VIEW meilleurEvent AS(
    SELECT nom, pourcentage+nbCommentaire*5/100+nbTag*2/100 AS total
    FROM commentaireParEvent NATURAL JOIN tauxParticipation NATURAL JOIN tagParEvent
    ORDER BY pourcentage+nbCommentaire*5+nbTag*2 DESC LIMIT 5
);
