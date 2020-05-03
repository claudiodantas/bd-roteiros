--Q1
SELECT COUNT(*)
FROM employee
WHERE sex = 'F';

--Q2
SELECT AVG(salary) AS avg 
FROM employee
WHERE sex = 'M' AND address LIKE '%TX';

--Q3
SELECT e1.ssn AS ssn_supervisor, COUNT(e2) AS qtd_supervisionados
FROM employee AS e1 RIGHT JOIN employee AS e2 ON e2.superssn = e1.ssn
GROUP BY e1.ssn
ORDER BY qtd_supervisionados;

--Q4
SELECT e1.fname AS nome_supervisor, COUNT(e2) AS qtd_supervisionados
FROM employee AS e1 JOIN employee AS e2 ON e2.superssn = e1.ssn
GROUP BY e1.fname
ORDER BY qtd_supervisionados;

--Q5
SELECT e1.fname AS nome_supervisor, COUNT(e2) AS qtd_supervisionados
FROM employee AS e1 RIGHT JOIN employee AS e2 ON e2.superssn = e1.ssn
GROUP BY e1.fname
ORDER BY qtd_supervisionados;

--Q6
SELECT MIN(w.qtd) AS qtd
FROM (SELECT COUNT(e) AS qtd
	FROM employee e, works_on w
	WHERE e.ssn = w.essn
	GROUP BY w.pno) AS w;

--Q7
SELECT w2.pno AS num_projeto, MIN(w1.qtd) AS qtd_func
FROM (SELECT w.pno, COUNT(e) AS qtd
	FROM employee e, works_on w
	WHERE e.ssn = w.essn
	GROUP BY w.pno) AS w1,
	(SELECT w.pno, COUNT(e) AS qtd
	FROM employee e, works_on w
	WHERE e.ssn = w.essn
	GROUP BY w.pno) AS w2
GROUP BY w2.pno, w2.qtd
HAVING w2.qtd = MIN(w1.qtd);

--Q8
SELECT w.pno AS num_proj, AVG(e.salary) AS media_sal
FROM works_on AS w, employee as e
WHERE w.essn = e.ssn
GROUP BY w.pno;

--Q9
SELECT w.pno AS num_proj, p.pname AS proj_nome, AVG(e.salary) AS media_sal
FROM works_on AS w, employee as e, project AS p
WHERE w.essn = e.ssn AND p.pnumber = w.pno 
GROUP BY w.pno, p.pname;

--Q10
SELECT e1.fname, e1.salary
FROM employee AS e1, 
	(SELECT e.salary
	FROM works_on as w, employee as e 
	WHERE pno = 92 AND w.essn = e.ssn) AS e2
GROUP BY e1.fname, e1.salary
HAVING e1.salary > MAX(e2.salary);

--Q11
SELECT e.ssn AS ssn,
	CASE
		WHEN COUNT(w) IS NULL THEN 0
		ELSE COUNT(w)
		END AS qtd_proj
FROM employee AS e LEFT JOIN works_on AS w ON e.ssn = w.essn
GROUP BY e.ssn
ORDER BY COUNT(w);

--Q12
SELECT w.pno AS num_proj, COUNT(e) AS qtd_func
FROM works_on AS w RIGHT JOIN employee AS e ON w.essn = e.ssn
GROUP BY w.pno
HAVING COUNT(e) < 5;

--Q13
SELECT e.fname
FROM employee AS e, works_on AS w, project AS p
WHERE e.ssn = w.essn AND w.pno = p.pnumber 
AND p.plocation = 'Sugarland' 
AND e.ssn IN (SELECT d.essn FROM dependent AS d);

--Q14
SELECT d.dname
FROM department AS d 
WHERE NOT EXISTS (SELECT p.dnum
	FROM project AS p
	WHERE p.dnum = d.dnumber);

--Q15
SELECT e.fname, e.lname
FROM employee AS e 
WHERE NOT EXISTS ((SELECT w1.pno
		FROM works_on AS w1
		WHERE w1.essn = '123456789')
		EXCEPT
		(SELECT w.pno
		FROM works_on AS w
		WHERE w.essn = e.ssn)) 
		AND NOT(e.ssn = '123456789');