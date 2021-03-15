-- Bases de données - TD1
-- Lilian HIAULT ZZ1 G2

-- Q1-Donner les différents jobs des employés.
SELECT DISTINCT JOB FROM EMP;

-- Q2-Donner le numéro des projets auxquels participe l'employé numéro 7900 avec le nombre d’heures.
SELECT PNO, HOURS
FROM PARTICIPATION
WHERE EMPNO IS 7900;

-- Q3-Donner le nom et la catégorie des projets avec des employés.
SELECT DISTINCT PNAME, CAT
FROM PROJECT NATURAL JOIN PARTICIPATION;

-- Q4-Donner le numéro des projets auxquels participent ADAMS ou MARTIN.
SELECT DISTINCT PNO
FROM EMP NATURAL JOIN PARTICIPATION
WHERE (ENAME IS "ADAMS" OR ENAME IS "MARTIN");

-- Q5-Donner le nom des départements avec des clerk qui travaillent sur le projet 2.
SELECT DISTINCT DNAME
FROM EMP NATURAL JOIN DEPT NATURAL JOIN PARTICIPATION
WHERE (JOB IS "CLERK" AND PNO IS 2);

-- Q6-Donner le nom des employés dirigés directement par KING.
SELECT E.ENAME FROM
EMP AS E LEFT OUTER JOIN EMP AS M ON E.MGR = M.EMPNO
WHERE M.ENAME = "KING";

-- Q7-Donner le numéro des employés embauchés avant leur manager.
SELECT E.EMPNO
FROM EMP AS E LEFT OUTER JOIN EMP AS M ON E.MGR = M.EMPNO
WHERE E.HIREDATE  < M.HIREDATE;

-- Q8-Donner la requête SQL correspondant à la requête algébrique.
-- Le numéro et nom des employés qui gagnent le même salaire et ont le même COMM
SELECT EMPNO, ENAME
FROM
	(SELECT * FROM EMP WHERE EMPNO != 7654)
	NATURAL JOIN
	(SELECT SAL, COMM FROM EMP WHERE EMPNO  = 7654);

-- Q9-Donner le numéro et le nom de tous les départements avec leurs jobs.
SELECT DISTINCT DEPTNO, DNAME, JOB
FROM DEPT NATURAL JOIN EMP ORDER BY DEPTNO;

-- Q10-Donner le numéro des départements qui n'ont pas d'employé.
SELECT DISTINCT DEPTNO FROM DEPT
EXCEPT
SELECT DISTINCT DEPTNO FROM EMP;

-- Q11-Donner le nom des projets auxquels participent l'employé numéro 7900 et l'employé numéro 7521.
 SELECT DISTINCT PNAME
 FROM PROJECT NATURAL JOIN PARTICIPATION
 WHERE (EMPNO IS 7521 OR 7900);

-- Q12-Donner le numéro des projets de la catégorie A ou mobilisant l'employé numéro 7876.
SELECT DISTINCT PNO
FROM PARTICIPATION NATURAL JOIN PROJECT
WHERE (CAT IS 'A' OR EMPNO IS 7876);

-- Q13-Donner le nombre de jobs différents.
SELECT COUNT(DISTINCT JOB)
FROM EMP;

-- Q14-Donner le salaire moyen et la commission moyenne pour chaque job.
SELECT AVG(SAL), AVG(COMM)
FROM EMP GROUP BY JOB;

-- Q15-Donner le numéro des projets avec au moins 4 participants.
SELECT PNO
FROM PARTICIPATION GROUP BY PNO
HAVING COUNT(PNO) >= 4;

-- Q16-Donner le nom des employés dont le nom commence par A et participant à au moins 2 projets.
SELECT ENAME
FROM PARTICIPATION NATURAL JOIN EMP GROUP BY EMPNO
HAVING (COUNT(EMPNO) >= 2 AND SUBSTR(ENAME, 1, 1) IS A);

-- Q17-Donner le nombre de projets par employés (afficher leur numéro et leur nom).
SELECT COUNT(PNO), EMPNO, ENAME
FROM EMP NATURAL JOIN PARTICIPATION GROUP BY EMPNO;

-- Q18-Donner le nombre d'employés moyen par job.
SELECT AVG(COMP)
FROM (SELECT COUNT(EMPNO) AS COMP FROM EMP GROUP BY JOB);

-- Q19-Donner le job ayant le salaire moyen le plus faible.
SELECT JOB, MIN(MOY)
FROM (SELECT JOB, AVG(SAL) AS MOY FROM EMP GROUP BY JOB);

-- Q20-Donner le numéro des employés qui participent à tous les projets.
SELECT ENAME, EMPNO
FROM EMP NATURAL JOIN PARTICIPATION GROUP BY EMPNO
HAVING COUNT(PNO) > (SELECT COUNT(PNO) FROM PROJECT);

-- Q21-Donner le numéro des employés qui participent à tous les projets de la catégorie C.
SELECT DISTINCT EMPNO
FROM PARTICIPATION
WHERE PNO IN (SELECT PNO FROM PROJECT WHERE CAT IS "C")
GROUP BY EMPNO
HAVING COUNT(PNO) = (SELECT COUNT(PNO)
       		     FROM PROJECT
		     WHERE CAT='C');

-- Q22-Donner le nom des projets de la catégorie B qui mobilisent tous les employés.
SELECT PNAME
FROM PROJECT
WHERE CAT IS "B" AND PNO = (SELECT PNO
      	     	     	    FROM PARTICIPATION GROUP BY PNO
			    HAVING COUNT(DISTINCT EMPNO) = (SELECT COUNT(EMPNO )
			    	   		  	    FROM EMP));

-- Q23-Donner le nom des employés qui dépendent (directement ou non) de JONES.
SELECT ENAME
FROM EMP
WHERE ENAME != 'JONES'
CONNECT BY PRIOR EMPNO = MGR
START WITH ENAME IS 'JONES';

-- Q24-Donner le nom des employés dirigés directement par KING.
-- Requête Q6 mais en utilisant CONNECT BY et LEVEL.

-- Q25-Donner le nom des supérieurs de SMITH.

-- Q26-Donner le numéro, le nom et la date d'embauche (formatée en DD/MM)
-- des employés embauchés entre le 01/04/1981 et le 30/09/1981
-- par ordre décroissant de la date puis nom croissant.

-- Q27-Donner le numéro, le nom et le revenu total des employés embauchés un 13/05
-- par ordre croissant de la date puis revenu décroissant.
