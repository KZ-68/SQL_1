-- ETUDIANT (N°ETUDIANT, NOM, PRENOM) 
-- MATIERE (CODEMAT, LIBELLEMAT, COEFFMAT) 
-- EVALUER (N°ETUDIANT*, CODEMAT*, DATE, NOTE)

-- Affichez les résultats suivants avec une solution SQL :

-- a) Quel est le nombre total d'étudiants ?

SELECT 
    COUNT(e.numero_etudiant)
FROM 
    etudiant e

-- b) Quelles sont, parmi l'ensemble des notes, la note la plus haute et la note la plus basse ?

SELECT 
    e.numero_etudiant_id, 
    MIN(e.note) as note_min, MAX(e.note) as note_max
FROM 
    evaluer e
GROUP BY 
    e.numero_etudiant_id
-- GROUPE BY contient tous les champs présents dans SELECT à l'exception des fonctions d'agrégations.

-- c) Quelles sont les moyennes de chaque étudiant dans chacune des matières ? (utilisez CREATE VIEW)

-- Création d'un vue et on lui affecte un nom
CREATE VIEW moyennesEtudiant AS
-- Lecture et sélection des colonnes
SELECT 
    e.numero_etudiant,
    e.nom, 
    e.prenom, 
    m.libellemat,
    m.coeffmat,
    AVG(ev.note) AS moyennesMatiere -- On donne un nom personnalisée à cette sélection
-- On spécifie quelle(s) table(s) peut être sélectionnée(s) 
FROM 
    etudiant e, 
    evaluer ev, 
    matiere m
-- Fait la jointure des tables
WHERE 
    e.numero_etudiant = ev.numero_etudiant_id 
    AND m.codemat = ev.code_mat
GROUP BY 
    e.numero_etudiant, 
    e.nom, 
    e.prenom, 
    m.libellemat, 
    m.coeffmat;

-- d) Quelles sont les moyennes par matière ? (cf. question c)

CREATE OR REPLACE VIEW moyennesMatiereEtudiant AS
SELECT 
    libellemat, 
    AVG(moyennesMatiere) AS moyennesParMatiere
FROM 
    moyennesEtudiant
GROUP BY 
    libellemat;

-- e) Quelle est la moyenne générale de chaque étudiant ?(utilisez CREATE VIEW + cf. question 3)

CREATE VIEW moyennesGenerale AS
SELECT 
    numero_etudiant,
    nom, 
    prenom, 
    SUM(moyennesMatiere * coeffmat) / SUM(coeffmat) AS moyennesGeneraleEtudiants
FROM moyennesEtudiant
GROUP BY  
    numero_etudiant, 
    nom, 
    prenom;

-- f) Quelle est la moyenne générale de la promotion ?(cf. question e)

CREATE OR REPLACE VIEW moyennePromotion AS
SELECT AVG(moyennesGeneraleEtudiants)
FROM moyennesGenerale;

SELECT AVG(moyennesGeneraleEtudiants)
FROM (
        SELECT 
            numero_etudiant,
            nom, 
            prenom, 
            SUM(moyennesMatiere * coeffmat) / SUM(coeffmat) AS moyennesGeneraleEtudiants
        FROM (
                SELECT 
                    e.numero_etudiant,
                    e.nom, 
                    e.prenom, 
                    m.libellemat,
                    m.coeffmat,
                    AVG(ev.note) AS moyennesMatiere
                    FROM 
                        etudiant e, 
                        evaluer ev, 
                        matiere m
                    WHERE 
                        ev.numero_etudiant_id = e.numero_etudiant 
                        AND ev.code_mat = m.codemat
                    GROUP BY 
                        e.numero_etudiant, 
                        e.nom, 
                        e.prenom, 
                        m.libellemat, 
                        m.coeffmat;     
            ) AS vue_c
            GROUP BY 
                numero_etudiant, 
                nom, 
                prenom
    ) AS vue_e
;

-- g) Quels sont les étudiants qui ont une moyenne générale supérieure ou égale à la moyenne générale de la promotion ? (cf. question e)

CREATE OR REPLACE VIEW comparaisonMoyennesGeneral AS
SELECT 
    numero_etudiant,
    nom, 
    prenom
FROM moyennesGenerale
WHERE moyennesGeneraleEtudiants >= (
    SELECT AVG(moyennesGeneraleEtudiants)
    FROM moyennesGenerale)
GROUP BY 
    numero_etudiant,
    nom, 
    prenom
