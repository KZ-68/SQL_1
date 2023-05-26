-- 1) Soit le schéma relationnel suivant :
-- ARTICLES(NOART, LIBELLE, STOCK, PRIXINVENT)
-- FOURNISSEURS(NOFOUR, NOMFOUR, ADRFOUR, VILLEFOUR)
-- ACHETER(NOFOUR#, NOART#, PRIXACHAT, DELAI)
-- Affichez les résultats suivants avec une solution SQL:

-- a) Numéros et libellés des articles dont le stock est inférieur à 10 ?

SELECT a.noart, a.libelle, a.stock
FROM articles a
WHERE a.stock < 10

-- b) Liste des articles dont le prix d'inventaire est compris entre 100 et 300 ?

SELECT a.noart, a.libelle, a.prixinvent
FROM articles a
WHERE a.prixinvent BETWEEN 100 AND 300

-- c) Liste des fournisseurs dont on ne connaît pas l'adresse ?

SELECT f.nofour, f.nomfour, f.adrfour, f.villefour
FROM fournisseurs f
WHERE f.adrfour IS NULL

-- d) Liste des fournisseurs dont le nom commence par "STE" ?

SELECT f.nofour, f.nomfour, f.adrfour, f.villefour
FROM fournisseurs f
WHERE f.nomfour LIKE "STE%"

-- e) Noms  et  adresses  des  fournisseurs  qui  proposent  des  articles  pour  lesquels  le  délai d'approvisionnement est supérieur à 20 jours ?

CREATE VIEW delaiFournisseurs AS
SELECT DISTINCT
    f.nofour, 
    f.nomfour, 
    f.adrfour, 
    f.villefour
FROM fournisseurs f
INNER JOIN 
    acheter ach 
    ON 
    f.nofour = ach.nofour_id
WHERE ach.delai>20
GROUP BY 
    f.nofour, 
    f.nomfour, 
    f.adrfour, 
    f.villefour

-- f) Nombre d'articles référencés ?

SELECT COUNT(a.noart)
FROM articles a
WHERE 
    a.libelle IS NOT NULL
    AND 
        a.stock IS NOT NULL
    AND 
        a.prixinvent IS NOT NULL

-- g) Valeur du stock ?

SELECT ROUND(SUM(a.prixinvent), 2)
FROM articles a

-- h) Numéros et libellés des articles triés dans l'ordre décroissant des stocks ?

SELECT 
    a.noart, 
    a.libelle
FROM 
    articles a
ORDER BY 
    a.stock DESC

-- i) Liste pour chaque article (numéro et libellé) du prix d'achat maximum, minimum et moyen ?

SELECT 
    a.noart,
    a.libelle,
    MIN(ach.prixachat) AS prix_min, 
    MAX(ach.prixachat) AS prix_max,
    AVG(ach.prixachat) AS prix_moyen
FROM
    articles a
INNER JOIN acheter ach ON a.noart = ach.noart_id
GROUP BY a.noart, a.libelle

-- j) Délai moyen pour chaque fournisseur proposant au moins 2 articles ?

CREATE OR REPLACE VIEW delaiarticlesfournisseurs AS
SELECT 
    a.libelle,
    f.nofour, 
    f.nomfour, 
    f.adrfour, 
    f.villefour, 
    AVG(ach.delai) AS moyenneDelai
FROM 
	acheter ach
INNER JOIN fournisseurs f ON f.nofour = ach.nofour_id  
INNER JOIN articles a ON a.noart = ach.noart_id
GROUP BY 
    a.libelle,
    f.nofour, 
    f.nomfour, 
    f.adrfour, 
    f.villefour
