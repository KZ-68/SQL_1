-- 1) Soit la base relationnelle de données LIVRAISON de schéma :

-- USINE(NumU, NomU, VilleU)
CREATE TABLE usine 
(
    numU INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nomU VARCHAR(50),
    villeU VARCHAR(50)
)

-- PRODUIT(NumP, NomP, Couleur, Poids)

CREATE TABLE produit
(
   numP INT PRIMARY KEY NOT NULL AUTO_INCREMENT, 
	nomP VARCHAR(50), 
	couleur VARCHAR(50), 
	poids FLOAT
)

-- FOURNISSEUR(NumF, NomF, Statut, VilleF)

CREATE TABLE fournisseur
(
  numF INT PRIMARY KEY NOT NULL AUTO_INCREMENT, 
  nomF VARCHAR(50), 
  statut VARCHAR(10), 
  villeF VARCHAR(50)
)

-- LIVRAISON(NumP, NumU, NumF, Quantité)

CREATE TABLE livraison
(
  quantite INT,
  numP_id INT,
  numU_id INT,
  numF_id INT,
  CONSTRAINT fk_livraison_produit
  FOREIGN KEY (numP_id) REFERENCES produit(numP),
  CONSTRAINT fk_livraison_usine
  FOREIGN KEY (numU_id) REFERENCES usine(numU),
  CONSTRAINT fk_livraison_fournisseur
  FOREIGN KEY (numF_id) REFERENCES fournisseur(numF)
);

-- a) Ajouter un nouveau fournisseur avec les attributs de votre choix 

INSERT INTO fournisseur (numF, nomF, statut, villeF)
 VALUES
 (1, 'Metro', 'SAS', 'Nanterre'),
 (2, 'Husson International', 'SA', 'Lapoutroie'),
 (3, 'France Boissons Strasbourg', 'SAS', 'Geispolsheim');

-- b) Supprimer tous les produits de couleur noire et de numéros compris entre 100 et 1999

INSERT INTO produit (numP, nomP, couleur, poids)
 VALUES
(200, 'Frigo pour Boisson', 'Noir', 350.0),
(1998, 'Friteuse Professionnelle', 'Noir', 550),
(98, 'Chaise Arizona hêtre simili cuir', 'Noir', 1.2)

DELETE FROM produit
WHERE (numP BETWEEN 100 AND 1999) AND (couleur = 'Noir')

-- c) Changer la ville du fournisseur 3 par Mulhouse

UPDATE fournisseur
SET villeF = 'Mulhouse'
WHERE numF = '3';