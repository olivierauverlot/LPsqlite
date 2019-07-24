
--
-- Base articles.sql pour SQLite
-- Auteur: Olivier Auverlot
--

CREATE TABLE articles(
	cle INT PRIMARY KEY AUTOINCREMENT NOT NULL,
	titre TEXT NOT NULL CHECK (length(trim(titre)) > 0),
	cle_categorie TEXT NOT NULL,
	cle_numero INT NOT NULL,
	page_debut INT NOT NULL,
	page_fin INT NOT NULL,
	
	CHECK (page_debut > 0 anf page_fin > page_debut),
	FOREIGN KEY(cle_categorie) REFERENCES categories(categorie) ON DELETE SET DEFAULT 'Divers',
	FOREIGN KEY(cle_categorie) REFERENCES categories(categorie) ON UPDATE CASCADE,
	FOREIGN KEY(cle_numero) REFERENCES numeros(cle) ON DELETE RESTRICT
);


CREATE TABLE categories(
	categorie TEXT PRIMARY KEY NOT NULL
);

CREATE TABLE numeros(
	cle INT PRIMARY KEY AUTOINCREMENT NOT NULL,
	cle_journal TEXT NOT NULL,
	numero_journal INT NOT NULL CHECK (numero_journal > 0),
	date_parution DATE NOT NULL,
	
	UNIQUE (cle_journal,numero_journal,date_parution),
	FOREIGN KEY(cle_journal) REFERENCES journaux(nom) ON DELETE RESTRICT
);

CREATE TABLE auteurs (
	cle INT PRIMARY KEY AUTOINCREMENT NOT NULL,
	nom TEXT NOT NULL CHECK (length(trim(nom)) > 0),
	prenom TEXT NOT NULL CHECK (length(trim(nom)) > 0)
);

CREATE TABLE aut_art(
	cle_article INT NOT NULL,
	cle_auteur INT NOT NULL,
	
	PRIMARY KEY(cle_article,cle_auteur),
	FOREIGN KEY(cle_article) REFERENCES articles(cle) ON DELETE RESTRICT,
	FOREIGN KEY(cle_auteur) REFERENCES auteurs(cle) ON DELETE RESTRICT
);

CREATE TABLE journaux(
	nom TEXT PRIMARY KEY NOT NULL CHECK (length(trim(titre)) > 0),
	cle_editeur INT NOT NULL,
	
	FOREIGN KEY(cle_editeur) REFERENCES editeurs(editeur) ON DELETE RESTRICT
);

CREATE TABLE editeurs(
	editeur TEXT PRIMARY KEY NOT NULL
);

--
-- Initialisation du contenu des tables
--
INSERT INTO categories VALUES('Divers');

INSERT INTO editeurs VALUES('Éditions Diamond');

INSERT INTO journaux VALUES('GNU/Linux Magazine','Éditions Diamond');
INSERT INTO journaux VALUES('GNU/Linux Pratique','Éditions Diamond');
INSERT INTO journaux VALUES('MISC','Éditions Diamond');
INSERT INTO journaux VALUES('Hackable Magazine','Éditions Diamond');