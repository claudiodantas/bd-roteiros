-- -------------- QUESTÃO 1 --------------

-- A:
CREATE VIEW vw_dptmgr AS
SELECT dnumber, mgrssn
FROM department;


-- B:
CREATE VIEW vw_empl_houston AS
SELECT ssn, fname
FROM employee
WHERE address LIKE '%Houston%';


-- C:
CREATE VIEW vw_deptstats AS
SELECT d.dnumber, d.dname, COUNT(e)
FROM department as d, employee as e
WHERE e.dno = d.dnumber
GROUP BY d.dnumber;


-- D:
CREATE VIEW vw_projstats AS
SELECT p.pnumber, COUNT(w)
FROM project as p, works_on as w
WHERE w.pno = p.pnumber
GROUP BY p.pnumber;


-- -------------- QUESTÃO 2 --------------

-- VIEW vw_dptmgr
SELECT *
FROM vw_dptmgr;


-- VIEW vw_empl_houston
SELECT *
FROM vw_empl_houston;


-- VIEW vw_deptstats
SELECT *
FROM vw_deptstats;


-- VIEW vw_projstats
SELECT *
FROM vw_projstats;


-- -------------- QUESTÃO 3 --------------

DROP VIEW vw_dptmgr;

DROP VIEW vw_empl_houston;

DROP VIEW vw_deptstats;

DROP VIEW vw_projstats;


-- -------------- QUESTÃO 4 --------------

CREATE OR REPLACE FUNCTION check_age(essn VARCHAR(11))
RETURNS VARCHAR(7) AS
$$

DECLARE
    data_nascimento DATE;

BEGIN
    SELECT bdate INTO data_nascimento FROM employee WHERE essn = ssn;
    IF (data_nascimento > now()) THEN 
        RETURN 'INVALID';
    ELSIF (data_nascimento is NULL) THEN 
        RETURN 'UNKNOWN';
    ELSIF (date_part('year', age(data_nascimento)) >= 50) THEN 
        RETURN 'SENIOR';
    ELSIF (date_part('year', age(data_nascimento)) < 50) THEN 
        RETURN 'YOUNG';
    END IF;      
END;
$$  LANGUAGE plpgsql;



-- -------------- QUESTÃO 5 --------------

-- Obs.: A funcao da QUESTAO 4 foi reutilizada aqui

CREATE OR REPLACE FUNCTION check_mgr() RETURNS trigger AS $$
DECLARE
    current_deptno INTEGER;
    qnt_subordinados INTEGER;
BEGIN
    SELECT dno INTO current_deptno FROM employee WHERE ssn = NEW.mgrssn;
    SELECT count(*) INTO qnt_subordinados FROM employee WHERE superssn = NEW.mgrssn;
    IF (current_deptno is NULL OR current_deptno <> NEW.dnumber) THEN
        RAISE EXCEPTION 'manager must be a department''s employee';
    ELSIF (qnt_subordinados < 1) THEN
        RAISE EXCEPTION 'manager must have supevisees';
    ELSIF (check_age(NEW.mgrssn) <> 'SENIOR') THEN
        RAISE EXCEPTION 'manager must be a SENIOR employee';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER check_mgr BEFORE INSERT OR UPDATE ON department
    FOR EACH ROW EXECUTE PROCEDURE check_mgr();
