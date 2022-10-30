CREATE DATABASE employee;
USE employee;
SELECT * FROM emp_record_table;
ALTER TABLE employee.emp_record_table RENAME COLUMN ï»¿EMP_ID TO EMP_ID;
SELECT * FROM emp_record_table;
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT FROM employee.emp_record_table 
ORDER BY DEPT,FIRST_NAME,LAST_NAME;
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING FROM employee.emp_record_table WHERE EMP_RATING <2;
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING FROM employee.emp_record_table WHERE EMP_RATING >4;
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING FROM employee.emp_record_table WHERE EMP_RATING >=2 AND EMP_RATING <=4 ORDER BY EMP_RATING;
SELECT concat(FIRST_NAME, ' ',LAST_NAME) AS NAME FROM employee.emp_record_table WHERE DEPT = 'FINANCE';

SELECT A.`MANAGER ID`,count(A.`MANAGER ID`)AS REPORTERS, concat(b.FIRST_NAME, ' ',B.LAST_NAME) AS NAME  FROM employee.emp_record_table AS A JOIN employee.emp_record_table AS B
ON A.`MANAGER ID` = B.EMP_ID
GROUP BY A.`MANAGER ID` ORDER BY A.`MANAGER ID` ;

SELECT * FROM employee.emp_record_table AS FIN_DATA WHERE DEPT = 'FINANCE'
UNION All
SELECT * FROM employee.emp_record_table AS HC_DATA WHERE DEPT = 'HEALTHCARE'ORDER BY EMP_ID;

#SELECT * FROM employee.emp_record_table AS FIN_DATA WHERE DEPT IN ( 'FINANCE','HEALTHCARE')

SELECT 
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    `ROLE`,
    DEPT,
    EMP_RATING,
    MAX(EMP_RATING) OVER (PARTITION BY DEPT) AS MAX_RATING,
    CONCAT(EMP_RATING , "/",   MAX(EMP_RATING) OVER (PARTITION BY DEPT) )AS EFF,
    REPEAT("*", EMP_RATING) AS STARS
FROM
    employee.emp_record_table
    ORDER BY  EMP_RATING DESC;
    
SELECT 
    `ROLE`, MIN(SALARY), MAX(SALARY)
FROM
    employee.emp_record_table WHERE `ROLE` != 'PRESIDENT'
GROUP BY `ROLE`;

SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EXP,
       RANK() OVER(ORDER BY EXP DESC) AS 'Rank'
FROM employee.emp_record_table
ORDER BY 'Rank';

CREATE VIEW V_COUNTRY_SAL AS 
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EXP,COUNTRY,SALARY
FROM employee.emp_record_table
WHERE SALARY>6000;

SELECT * FROM V_COUNTRY_SAL;
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, EXP, DEPT, EMP_RATING FROM employee.emp_record_table WHERE EMP_ID IN (SELECT EMP_ID FROM  employee.emp_record_table WHERE EXP >10);


DELIMITER //
CREATE PROCEDURE EMP_DETAILS()
BEGIN
	SELECT * FROM employee.emp_record_table WHERE EXP>3;
END //
    
DELIMITER ;

CALL EMP_DETAILS();

DELIMITER $$ ;
ALTER FUNCTION Role_VERIFY (  
    EXP double
)   
RETURNS VARCHAR(200)  
DETERMINISTIC  
BEGIN  
    DECLARE Role_Validation VARCHAR(200);  
    IF EXP<=2 THEN  
        SET Role_Validation = 'JUNIOR DATA SCIENTIST';  
    ELSEIF (EXP>=2 AND   
            EXP<=5) THEN  
        SET Role_Validation = 'ASSOCIATE DATA SCIENTIST';  
    ELSEIF (EXP>=5 AND   
            EXP<=10) THEN  
        SET Role_Validation = 'SENIOR DATA SCIENTIST';  
	ELSEIF (EXP>=10 AND   
            EXP<=12) THEN  
        SET Role_Validation = 'LEAD DATA SCIENTIST';  
	ELSEIF (EXP>=12 AND   
            EXP<=16) THEN  
        SET Role_Validation = 'MANAGER';  
    END IF;  
    -- return the customer occupation  
    RETURN (Role_Validation);  
END $$
DELIMITER $$;  

SELECT *, 
CASE ROLE WHEN Role_VERIFY(EXP) 
 THEN 'VALID' ELSE 'INVALID'
 END AS VALIDATION
FROM employee.data_science_team;

#Create an index to improve the cost and performance of the query to find the employee whose FIRST_NAME is ‘Eric’ in the employee table after checking the execution plan.
ALTER TABLE employee.emp_record_table DROP INDEX idx_first_name;
CREATE INDEX idx_first_name
ON employee.emp_record_table(FIRST_NAME(20));

SELECT * FROM employee.emp_record_table
WHERE FIRST_NAME='Eric';





#Write a query to calculate the bonus for all the employees, based on their ratings and salaries (Use the formula: 5% of salary * employee rating).

SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, EXP, DEPT, EMP_RATING, 0.05*SALARY*EMP_RATING AS BONUS FROM  employee.emp_record_table ORDER BY BONUS DESC;

SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, EXP, DEPT, EMP_RATING, AVG(SALARY) AS AVG_SAL FROM  employee.emp_record_table GROUP BY CONTINENT,COUNTRY;
