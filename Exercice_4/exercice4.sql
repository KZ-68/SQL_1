-- a)Liste de tous les étudiants

SELECT 
	e.numetu,
	e.nom,
	e.prenom,
	e.datenaiss,
	e.rue,
	e.cp,
	e.ville
FROM etudiant e

-- b)Liste de tous les étudiants, classée par ordre alphabétique inverse

SELECT 
	e.numetu,
	e.nom,
	e.prenom,
	e.datenaiss,
	e.rue,
	e.cp,
	e.ville
FROM etudiant e
ORDER BY e.numetu DESC

-- c) Libellé et coefficient (exprimé en pourcentage) de chaque matière

SELECT 
	m.libelle,
	m.coef*100
FROM matiere m


-- d) Nom et prénom de chaque étudiant

SELECT e.nom, e.premon
FROM etudiant e;
    
-- e) Nom et prénom des étudiants domiciliés à Lyon

SELECT 
    e.nom, 
    e.premon, 
    e.ville
FROM etudiant e
WHERE e.ville = "Lyon";

-- f) Liste des notes supérieures ou égales à 10

SELECT
	n.numetu_id,
	n.numepreuve_id,
	n.note
FROM notation n
WHERE n.note > 10

-- g) Liste des épreuves dont la date se situe entre le 1er janvier et le 30juin 2014

SELECT 
	ep.numepreuve,
	ep.dateepreuve,
	ep.lieu
FROM epreuve ep
WHERE ep.dateepreuve BETWEEN '2014-01-26' AND '2014-06-30'

-- h) Nom, prénom et ville des étudiants dont la ville contient la chaîne "ll"(LL)

SELECT 
	e.nom,
	e.prenom,
	e.rue,
	e.cp,
	e.ville
FROM etudiant e
WHERE e.ville LIKE '%ll%'

-- i) Prénoms des étudiants de nom Dupont, Durand ou Martin

SELECT 
	e.numetu,
	e.nom,
	e.prenom,
	e.rue,
	e.cp,
	e.ville
FROM etudiant e
WHERE (e.nom LIKE '%Durand%') OR (e.nom LIKE '%Dupont%') OR (e.nom LIKE '%Martin%')
ORDER BY e.numetu ASC

-- j) Somme des coefficients de toutes les matières

CREATE VIEW coefmatiere AS
SELECT 
	m.codemat,
	m.libelle,
	ROUND(SUM(m.coef), 2) AS sommeCoef
FROM matiere m
GROUP BY 
	m.codemat,
	m.libelle

CREATE VIEW sommeCoefMatiere AS
SELECT 
	SUM(sommeCoef)
FROM coefmatiere

SELECT SUM(coef) 
FROM matiere

-- k) Nombre total d'épreuves

SELECT COUNT(*) 
FROM epreuve

-- l) Nombre de notes indéterminées (NULL)

SELECT 
	n.numetu_id,
	n.numepreuve_id,
	n.note
FROM 
	notation n
WHERE n.note IS NULL

-- m) Liste des épreuves (numéro, date et lieu) incluant le libellé de la matière

SELECT 
	numepreuve, 
	dateepreuve, 
	lieu, 
	libelle 
FROM epreuve e, matiere m 
WHERE e.codemat_id = m.codemat

-- n) Liste des notes en précisant pour chacune le nom et le prénom de l'étudiant qui l'a obtenue

SELECT
	n.note,
	e.nom,
	e.prenom
FROM notation n
INNER JOIN etudiant e ON e.numetu = n.numetu_id 

-- o) Liste des notes en précisant pour chacune le nom et le prénom de l'étudiant qui l'a obtenue et le libellé de la matière concernée

SELECT
	nom, 
	prenom, 
	note, 
	libelle
FROM 
	etudiant e
INNER JOIN notation n ON n.numetu_id = e.numetu
INNER JOIN epreuve ep ON ep.numepreuve = n.numepreuve_id 
INNER JOIN matiere m ON m.codemat = ep.codemat_id
-- p) Nom et prénom des étudiants qui ont obtenu au moins une note égale à 20

SELECT 
    e.nom, 
    e.prenom,
    n.note
FROM etudiant e
INNER JOIN notation n ON n.numetu_id = e.numetu
WHERE n.note = 20

-- q) Moyennes des notes de chaque étudiant (indiquer le nom et le prénom)

CREATE VIEW moyennes AS  
SELECT 
	e.nom, 
	e.prenom, 
	AVG(n.note) AS moyennesNote
FROM etudiant e
INNER JOIN notation n ON e.numetu = n.numetu_id
GROUP BY 
	e.nom, 
	e.prenom

-- r) Moyennes des notes de chaque étudiant (indiquer le nom et le prénom), classées de la meilleure à la moins bonne

SELECT
	nom, 
	prenom,
	moyennesNote
FROM 
	moyennes
GROUP BY 
	nom, 
	prenom,
	moyennesNote
ORDER BY 
	moyennesNote DESC

-- s) Moyennes des notes pour les matières(indiquer le libellé) comportant plus d'une épreuve

CREATE VIEW moyenneEpreuve AS
SELECT
	ep.numepreuve  AS nb_epreuve,
	m.libelle,
	AVG(n.note) AS moyennesNote
FROM
	matiere m
INNER JOIN epreuve ep ON ep.codemat_id = m.codemat
INNER JOIN notation n ON ep.numepreuve = n.numepreuve_id
GROUP BY 
	ep.numepreuve,
	m.libelle

SELECT 
	nb_epreuve,
	libelle,
	moyennesNote
FROM moyenneepreuve
WHERE nb_epreuve > 1
GROUP BY 
	libelle, 
	nb_epreuve,
	moyennesNote

-- t) Moyennes des notes obtenues aux épreuves(indiquer le numéro d'épreuve) où moins de 6 étudiants ont été notés

SELECT
numepreuve, AVG(note)FROMnotation
WHERE note IS NOT NULL
GROUP BY
numepreuve
HAVING COUNT(*)<6