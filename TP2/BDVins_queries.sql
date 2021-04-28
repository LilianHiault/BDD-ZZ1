-- Q1-Créer les tables de la base de données :
CREATE TABLE VIN(
  VNUM NUMBER(2,0) CONSTRAINT PK_VIN PRIMARY KEY,
  VNOM VARCHAR2(30) CONSTRAINT VNOM_NOTNULL NOT NULL,
  CEPAGE VARCHAR2(30));

CREATE TABLE INSPECTEUR(
  INUM NUMBER(2,0) CONSTRAINT PK_INSPECTEUR PRIMARY KEY,
  INOM VARCHAR2(30) CONSTRAINT INOM_NOTNULL NOT NULL);

CREATE TABLE TEST(
  VNUM NUMBER(2,0),
  INUM NUMBER(2,0),
  NOTE NUMBER(2,0) CONSTRAINT NOTE_NOTNULL NOT NULL CONSTRAINT NOTE_CK CHECK (NOTE >= 0 AND NOTE <= 10),
  TDATE DATE,
  CONSTRAINT PK_TEST PRIMARY KEY(VNUM, INUM),
  CONSTRAINT FKVNUM_TEST FOREIGN KEY(VNUM) REFERENCES VIN(VNUM),
  CONSTRAINT FKINUM_TEST FOREIGN KEY(INUM) REFERENCES INSPECTEUR(INUM));

-- Q2-Ajouter une contrainte dans la table TEST pour indiquer que la note doit être comprise entre 0 et 10.
--CONSTRAINT NOTE_CK CHECK (NOTE >= 0 AND NOTE <= 10)

-- Q3-En utilisant la table adéquate du catalogue Oracle,
-- retrouver toutes les contraintes qui ont été définies sur la table TEST.

-- Q4-Insérer les données des tables VIN et INSPECTEUR :

INSERT INTO VIN VALUES(1,'Cave de Macon','Chardonnay');
INSERT INTO VIN VALUES(2,'Merlot','Cabernet Sauvignon');
INSERT INTO VIN VALUES(3,'Pinot Noir','Pinot Noir');

INSERT INTO INSPECTEUR VALUES(1,'Magouille');
INSERT INTO INSPECTEUR VALUES(2,'Intransigeant');
INSERT INTO INSPECTEUR VALUES(3,'Sympa');
INSERT INTO INSPECTEUR VALUES(4,'Cool');

-- Q5-Insérer les données de la table TEST (valider votre transaction à la fin).

-- Q6-Vérifier le contenu des tables.

-- Q7-Insérer le tuple (2, Rigolo) dans la table INSPECTEUR.
-- Que se passe-t-il ? Pourquoi ?

-- Q8-Insérer le tuple (5, 2, 8, 01/01/2010) dans la table TEST.
-- Que se passe-t-il ? Pourquoi ?

-- Q9-Insérer un nouvel inspecteur dans la table INSPECTEUR,
-- à savoir l’inspecteur de numéro 5 et dont on a égaré le nom.
-- Que se passe-t-il ? Pourquoi ?

-- Q10-Supprimer le vin n°2. Que se passe-t-il ?  Pourquoi ?  

-- Q11-Modifier les contraintes d’intégrité définies sur la table TEST pour
-- obtenir la suppression des tests d’un vin lorsque celui-ci est supprimé de la table VIN.

-- Q12-Supprimer à nouveau le 2 et vérifier la suppression de ses tests.

-- Q13-Réinsérer le vin 2 ainsi que ses tests dans les tables associées.

-- Q14-Faire les modifications de structure pour permettre l’insertion du numéro
-- de téléphone ’03-85-44-12-09’ pour l’inspecteur n°3.
-- Que se passe t-il pour les autres inspecteurs ?

-- Q15-Faire les modifications de structure pour réduire la longueur de INOM à 6 caractères.
-- Prévoir la récupération des valeurs de cette colonne en les tronquant à 6 caractères.

-- Q16-Créer la vue SYNTHESE09 regroupant les attributs CEPAGE, VNUM, VNOM, INOM, NOTE et TDATE pour tous les tests effectués en 2009.
-- Vérifier que la vue a bien été créée.
-- Afficher le contenu de cette vue.
-- Donner la note moyenne de chaque vin en 2009. On précisera le nom du vin.

-- Q17-Afin d’optimiser les temps de réponse, indexer les cépages dans la table VIN.

-- Q18-Afin d’optimiser les temps de réponse, indexer également les cépages dans la vue SYNTHESE09.
-- Que se passe t’il ? Pourquoi ?

-- Q19-Insérer les trois tuples (10, Relax), (11, Pointu) et (12, Odieux) dans la table INSPECTEUR.
-- Vérifier que tout s’est bien passé.
-- Annuler la dernière transaction et vérifier à nouveau le contenu de la table INSPECTEUR. 

-- Q20-Modifier les instructions de Q15 de manière à ce que la table INSPECTEUR
-- contienne les inspecteurs Pointu et Relax suite à l’annulation de la dernière transaction.
-- Vous devez conserver les 3 ordres insert. 

-- Q21-Executer le trigger suivant :
CREATE OR REPLACE TRIGGER VerifCepage
BEFORE INSERT OR UPDATE OF CEPAGE ON VIN FOR EACH ROW
BEGIN
  IF :NEW.CEPAGE = 'Pinot' THEN :NEW.CEPAGE := 'Pinot Noir';
  END IF;
END VerifCepage;
/

-- Q22-Insérer le tuple (5, 'Cotes de la Charité', 'Pinot') dans la table VIN.
-- Que se passe-t-il ? Pourquoi ?

-- Q23-Modifier le tuple pour mettre Pinot.

-- Q24-Executer le trigger suivant :
CREATE OR REPLACE TRIGGER VerifChardonnay
BEFORE INSERT OR UPDATE ON TEST FOR EACH ROW
DECLARE
      V_CEPAGE VARCHAR2(30);
      V_INOM VARCHAR2(30);
BEGIN
  SELECT CEPAGE INTO V_CEPAGE
  FROM VIN
  WHERE VNUM=:NEW.VNUM;
  IF V_CEPAGE='Chardonnay' THEN
    SELECT INOM INTO V_INOM
    FROM INSPECTEUR
    WHERE INUM=:NEW.INUM;
    IF (V_INOM!='Cool' AND V_INOM!='Sympa') THEN
      RAISE_APPLICATION_ERROR(-20000,'Seuls les inspecteurs Cool et Sympa peuvent attribuer une note aux vins Chardonnay.');
    END IF;
  END IF;
END VerifChardonnay;
/
-- si erreur : SHOW ERRORS

-- Q25-Insérer le tuple (1, 2, 6, 10/04/2009) dans la table TEST.
-- Que se passe-t-il ? Pourquoi ?

-- Q26-Insérer le tuple (3, 3, 8, 15/04/2009) dans la table TEST.
-- Que se passe-t-il ? Pourquoi ?

-- Q27-Insérer le tuple (1, 3, 6, 20/04/2009) dans la table TEST.
-- Que se passe-t-il ? Pourquoi ?

-- Q28-Nous avons fait une erreur, en fait c'était l'inspecteur 2 qui avait mis la note.
-- Corriger. Que se passe-t-il ? Pourquoi ?

-- Q29-De quelles tables êtes-vous propriétaire ?

-- Q30-Supprimer la table INSPECTEUR. Que se passe-t'il ? Pourquoi ?

-- Q31-Supprimer la table TEST puis interroger la vue SYNTHESE09.
-- Que se passe-t'il ?

-- Q32-Vider la table VIN. Vérifier que tout s’est bien passé.

-- Q33-Supprimer les tables VIN et INSPECTEUR. Vérifier que tout s’est bien passé.
