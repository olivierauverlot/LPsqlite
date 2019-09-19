
--
-- Base articles.sql pour SQLite
-- Auteur: Olivier Auverlot
--
-- sqlite3 base.db < articles.sql
--
-- Activation nécessaire pragma foreign_keys = ON
--

CREATE TABLE articles(
	cle INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	titre TEXT NOT NULL CHECK (length(trim(titre)) > 0),
	cle_categorie TEXT NOT NULL DEFAULT 'Divers',
	cle_numero INT NOT NULL,
	page_debut INT NOT NULL,
	page_fin INT NOT NULL,
	
	CHECK (page_debut > 0 and page_fin > page_debut),
	FOREIGN KEY(cle_categorie) REFERENCES categories(categorie) 
		ON DELETE SET DEFAULT
		ON UPDATE CASCADE,
	FOREIGN KEY(cle_numero) REFERENCES numeros(cle) ON DELETE RESTRICT
);


CREATE TABLE categories(
	categorie TEXT PRIMARY KEY NOT NULL CHECK (length(trim(categorie)) > 0)
);

CREATE TABLE numeros(
	cle INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	cle_journal TEXT NOT NULL,
	numero_journal INT NOT NULL CHECK (numero_journal > 0),
	hs INT DEFAULT 0,
	date_parution DATE NOT NULL,
	
	UNIQUE (cle_journal,numero_journal,date_parution),
	FOREIGN KEY(cle_journal) REFERENCES journaux(nom) 
		ON DELETE RESTRICT
		ON UPDATE CASCADE
);

CREATE TABLE auteurs (
	cle INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	nom TEXT NOT NULL CHECK (length(trim(nom)) > 0),
	prenom TEXT NOT NULL CHECK (length(trim(prenom)) > 0)
);

CREATE TABLE aut_art(
	cle_article INT NOT NULL,
	cle_auteur INT NOT NULL,
	
	UNIQUE(cle_article,cle_auteur),
	FOREIGN KEY(cle_article) REFERENCES articles(cle) ON DELETE CASCADE,
	FOREIGN KEY(cle_auteur) REFERENCES auteurs(cle) ON DELETE CASCADE
);

CREATE TABLE journaux(
	nom TEXT PRIMARY KEY NOT NULL CHECK (length(trim(nom)) > 0),
	cle_editeur TEXT NOT NULL,
	
	UNIQUE(nom,cle_editeur),
	FOREIGN KEY(cle_editeur) REFERENCES editeurs(editeur) 
		ON DELETE RESTRICT
		ON UPDATE CASCADE
);

CREATE TABLE editeurs(
	editeur TEXT PRIMARY KEY NOT NULL CHECK (length(trim(editeur)) > 0)
);

--
-- Création des vues
--

-- Liste des articles avec plusieurs auteurs
CREATE VIEW plusieurs_auteurs AS
	SELECT articles.titre
	FROM articles,aut_art,auteurs
	WHERE articles.cle = aut_art.cle_article
	AND auteurs.cle = aut_art.cle_auteur
	GROUP BY articles.cle
	HAVING COUNT(auteurs.cle) > 1;

-- concaténation nom et prénom d'un auteur
CREATE VIEW nom_prenom_auteur AS
	SELECT auteurs.cle,(auteurs.nom || ' ' || auteurs.prenom) AS nom_prenom FROM auteurs;

-- Nombre d'articles par auteur
-- on montre qu'un vue peut dépendre d'une autre vue
CREATE VIEW repartition_par_auteur AS
	SELECT nom_prenom,COUNT(articles.cle) AS nombre_articles
	FROM articles,aut_art,nom_prenom_auteur
	WHERE articles.cle = aut_art.cle_article
	AND nom_prenom_auteur.cle = aut_art.cle_auteur
	GROUP BY nom_prenom
	ORDER BY nombre_articles DESC;

--
-- Modification de la table auteur
-- pour stocker le nom et le prénom
-- en majuscules
--
ALTER TABLE auteurs ADD COLUMN nom_prenom TEXT;

--
-- Définition d'un trigger AFTER pour mettre à jour
-- le nombre d'articles écrit par un auteur
--
CREATE TRIGGER t_insert_nom_prenom
AFTER INSERT ON auteurs FOR EACH ROW
BEGIN
	UPDATE auteurs SET nom_prenom = upper(nom) || ' ' || upper(prenom) WHERE cle = NEW.cle;
END;

CREATE TRIGGER t_update_nom_prenom
AFTER UPDATE ON auteurs FOR EACH ROW
BEGIN
	UPDATE auteurs SET nom_prenom = upper(nom) || ' ' || upper(prenom) WHERE cle = NEW.cle;
END;


--
-- Initialisation du contenu des tables
--

INSERT INTO editeurs VALUES('Éditions Diamond');

INSERT INTO categories VALUES('Divers');
INSERT INTO categories VALUES('Développement');
INSERT INTO categories VALUES('Système');
INSERT INTO categories VALUES('Outils');
INSERT INTO categories VALUES('Réglementation');
INSERT INTO categories VALUES('Sécurité');
INSERT INTO categories VALUES('Electronique');

INSERT INTO journaux VALUES('GNU/Linux Magazine','Éditions Diamond');
INSERT INTO journaux VALUES('GNU/Linux Pratique','Éditions Diamond');
INSERT INTO journaux VALUES('misc','Éditions Diamond');
INSERT INTO journaux VALUES('Hackable Magazine','Éditions Diamond');

INSERT INTO auteurs(nom,prenom) VALUES('Auverlot','Olivier');
INSERT INTO auteurs(nom,prenom) VALUES('Bera','Clément');
INSERT INTO auteurs(nom,prenom) VALUES('Delplanque','Julien');

INSERT INTO numeros(cle_journal,numero_journal,date_parution) VALUES('GNU/Linux Pratique',114,'2019-07-01');

INSERT INTO numeros(cle_journal,numero_journal,hs,date_parution) VALUES('GNU/Linux Pratique',45,1,'2019-06-01');

INSERT INTO numeros(cle_journal,numero_journal,date_parution) VALUES('GNU/Linux Pratique',111,'2019-01-01');

INSERT INTO numeros(cle_journal,numero_journal,date_parution) VALUES('GNU/Linux Pratique',108,'2019-07-01');

INSERT INTO numeros(cle_journal,numero_journal,date_parution) VALUES('GNU/Linux Magazine',214,'2019-04-01');

INSERT INTO articles(titre,cle_categorie,cle_numero,page_debut,page_fin) VALUES(
	'Le RGPD expliqué aux informaticiens',
	'Réglementation',
	1,
	80,92
);

INSERT INTO aut_art VALUES(1,1);
	
INSERT INTO articles(titre,cle_categorie,cle_numero,page_debut,page_fin) VALUES(
	'A la découverte de Smalltalk',
	'Développement',
	2,
	112,130
);

INSERT INTO aut_art VALUES(2,1);
INSERT INTO aut_art VALUES(2,3);

INSERT INTO articles(titre,cle_categorie,cle_numero,page_debut,page_fin) VALUES(
	'Utiliser des applications Android sous Chrome OS',
	'Système',
	3,
	86,91
);

INSERT INTO aut_art VALUES(3,1);

INSERT INTO articles(titre,cle_categorie,cle_numero,page_debut,page_fin) VALUES(
	'A la découverte de Basic',
	'Développement',
	4,
	58,66
);

INSERT INTO aut_art VALUES(4,1);


INSERT INTO articles(titre,cle_categorie,cle_numero,page_debut,page_fin) VALUES(
	'Rédiger avec Markdown',
	'Outils',
	4,
	28,35
);

INSERT INTO aut_art VALUES(5,1);

INSERT INTO articles(titre,cle_categorie,cle_numero,page_debut,page_fin) VALUES(
	'Faites vos jeux avec Pharo',
	'Développement',
	5,
	86,91
);

INSERT INTO aut_art VALUES(6,1);
INSERT INTO aut_art VALUES(6,2);

