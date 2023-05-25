-- ETUDIANT (N°ETUDIANT, NOM, PRENOM) 
-- MATIERE (CODEMAT, LIBELLEMAT, COEFFMAT) 
-- EVALUER (N°ETUDIANT*, CODEMAT*, DATE, NOTE)

-- Affichez les résultats suivants avec une solution SQL :

-- a) Quel est le nombre total d'étudiants ?

SELECT COUNT(r.numero_etudiant)
FROM evaluer r

-- b) Quelles sont, parmi l'ensemble des notes, la note la plus haute et la note la plus basse ?

SELECT MIN(r.note), MAX(r.note)
FROM evaluer r

-- c) Quelles sont les moyennes de chaque étudiant dans chacune des matières ? (utilisez CREATE VIEW)

-- Création d'un vue et on lui affecte un nom
CREATE VIEW moyennesEtudiant AS
-- Lecture et sélection des colonnes
SELECT r.nom, 
r.prenom, 
s.libellemat, 
AVG(t.note * s.coeffmat / s.coeffmat) AS moyennesGeneraleEtudiants -- On donne un nom personnalisée à cette sélection
-- On spécifie quelle(s) table(s) peut être sélectionnée(s) 
FROM etudiant r, evaluer t, matiere s
-- Fait la jointure des tables
WHERE r.numero_etudiant = t.numero_etudiant_id AND s.codemat = t.code_mat
GROUP BY r.numero_etudiant, r.nom, r.prenom, s.libellemat;

-- d) Quelles sont les moyennes par matière ? (cf. question c)

CREATE VIEW moyennesMatiere AS
SELECT s.libellemat, 
AVG(t.note * s.coeffmat / s.coeffmat) AS moyennesGeneraleEtudiants
FROM etudiant r, evaluer t, matiere s
WHERE r.numero_etudiant = t.numero_etudiant_id AND s.codemat = t.code_mat
GROUP BY s.libellemat;

-- e) Quelle est la moyenne générale de chaque étudiant ?(utilisez CREATE VIEW + cf. question 3)

CREATE VIEW moyennesGenerale AS
SELECT r.numero_etudiant,
r.nom, 
r.prenom, 
AVG(t.note * s.coeffmat / s.coeffmat) AS moyennesGeneraleEtudiants
FROM etudiant r, evaluer t, matiere s
WHERE r.numero_etudiant = t.numero_etudiant_id AND s.codemat = t.code_mat
GROUP BY  r.numero_etudiant, r.nom, r.prenom;

-- f) Quelle est la moyenne générale de la promotion ?(cf. question e)

CREATE VIEW moyennesGenerale AS
SELECT r.numero_etudiant,
r.nom, 
r.prenom, 
AVG(t.note * s.coeffmat / s.coeffmat) AS moyennesGeneraleEtudiants
FROM etudiant r, evaluer t, matiere s
WHERE r.numero_etudiant = t.numero_etudiant_id AND s.codemat = t.code_mat
GROUP BY  r.numero_etudiant, r.nom, r.prenom;

SELECT AVG(moyennesGeneraleEtudiants)
FROM moyennesGenerale;

-- g) Quels sont les étudiants qui ont une moyenne générale supérieure ou égale à la moyenne générale de la promotion ? (cf. question e)

CREATE VIEW moyennesGenerale AS
SELECT r.numero_etudiant,
r.nom, 
r.prenom, 
AVG(t.note * s.coeffmat / s.coeffmat) AS moyennesGeneraleEtudiants
FROM etudiant r, evaluer t, matiere s
WHERE r.numero_etudiant = t.numero_etudiant_id AND s.codemat = t.code_mat
GROUP BY  r.numero_etudiant, r.nom, r.prenom;
