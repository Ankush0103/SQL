create table DEPT(
    DNO VARCHAR2(3) check(DNO like 'D%'),
    DNAME VARCHAR2(10) unique,
    Primary Key(DNO)
);
desc DEPT;
DROP TABLE DEPT;
DROP TABLE EMP;
DROP TABLE PROJECTS;
Create table EMP(
                 EMPNO NUMBER(4), 
                 ENAME VARCHAR2(10), 
                 EJOB VARCHAR2(9) default('CLRK') check(EJOB IN('CLRK', 'MGR', 'A.MGR', 'GM', 'CEO')),
                 MGR_ID NUMBER(4), 
                 BIRTH_DATE date,
                 SAL NUMBER(7, 2) default 20001 check(sal>20000),
                 COMM NUMBER(7, 2) default 1000,
                 DNO VARCHAR2(13), 
                 PRJ_ID VARCHAR2(9) default('CLRK') CONSTRAINT CHECK_1 check(PRJ_ID IN('CLRK', 'MGR', 'A.MGR', 'GM', 'CEO')),
                 DATE_OF_JOIN date,
                 check(BIRTH_DATE < DATE_OF_JOIN),
                 CONSTRAINT FK_EMP FOREIGN KEY(DNO) REFERENCES DEPT(DNO)
                 );
DESC EMP;
                 
create table Projects(
                DNO VARCHAR2(3) not null,
                PRJ_NO VARCHAR2(5) not null check(PRJ_NO like 'P%'),
                PRJ_NAME VARCHAR2(10),
                PRJ_CREDITS NUMBER(2) check(PRJ_CREDITS between 1 and  10),
                START_DATE DATE,
                END_DATE DATE,
                check (END_DATE > START_DATE),
                CONSTRAINT FK_PROJECTS FOREIGN KEY(DNO) REFERENCES DEPT(DNO),
                PRIMARY KEY(DNO, PRJ_NO)
                );
DESC PROJECTS;
/* 1.	Add EMPNO as a primary key constraint to EMP table.*/
ALTER TABLE EMP ADD CONSTRAINT PK_EMP PRIMARY KEY(EMPNO);
DESC EMP;
 /* 2.	Add a foreign key constraint to EMP table on MGR_ID referencing EMP. */
ALTER TABLE EMP ADD CONSTRAINT FK_EMP1 FOREIGN KEY(MGR_ID) REFERENCES EMP(EMPNO);
DESC EMP;
/* 3. Modify the column PRJ_ID in EMP table as follows-
i)	Change the data type from VARCHAR2(9) to VARCHAR2(5) . 
ii)	Drop the constraints on PRJ_ID in EMP table and add a foreign key constraint 
to EMP table on (DEPTNO, PRJ_ID) referencing PROJECTS. This foreign key indicates an employee from a particular department is working on which project(s).*/

ALTER TABLE EMP 
MODIFY PRJ_ID VARCHAR2(5);
DESC EMP;
/*PRJ_ID VARCHAR2(9) default('CLRK') check(PRJ_ID IN('CLRK', 'MGR', 'A.MGR', 'GM', 'CEO'))*/
ALTER TABLE EMP
DROP CONSTRAINT CHECK_1;

ALTER TABLE EMP ADD CONSTRAINT FK_E FOREIGN KEY(DNO, PRJ_ID) REFERENCES PROJECTS(DNO, PRJ_NO);
DESC EMP;


/*4.	Add a column to DEPT table named LOCATIONS with data type VARCHAR2(9). */
ALTER TABLE DEPT ADD LOCATIONS VARCHAR2(9);
DESC DEPT;
/* 5.	Add CHECK constraint on LOCATIONS so that allowed values will be BNG/MNG/MUB/HYD/CHN and default value is BNG. */
ALTER TABLE DEPT MODIFY LOCATIONS DEFAULT 'BNG'; 
ALTER TABLE DEPT
ADD CONSTRAINT CHK_LOCATION  check(LOCATIONS IN('BNG', 'MNG', 'MUB', 'HYD', 'CHN'));/* CHECK (Age>=18 AND City='Sandnes');*/
DESC DEPT;

SELECT * FROM DEPT;

INSERT INTO PROJECTS VALUES('D1', 'P1', 'PRJ001', 2, '01-OCT-1980', '24-DEC-1986');
INSERT INTO PROJECTS VALUES('D2', 'P1', 'PRJ001', 2, '01-OCT-1980', '24-DEC-1986');
INSERT INTO PROJECTS VALUES('D3', 'P2', 'PRJ002', 7, '01-OCT-1982', '24-DEC-1995');/* NOT INSERTED*/
INSERT INTO PROJECTS VALUES('D1', 'P3', 'PRJ003', 5, '01-OCT-1985', '24-DEC-1999');
INSERT INTO PROJECTS VALUES('D4', 'P2', 'PRJ002', 7, '01-OCT-1982', '24-DEC-1995');

INSERT INTO DEPT VALUES('D1', 'MARKETING', 'CHN');
INSERT INTO DEPT VALUES('D2', 'RESEARCH', 'MNG');
INSERT INTO DEPT(DNO, DNAME) VALUES('D3', 'ADMINISTRATOR'); /* WILL OT BE INSERTED VALUE TOO LARGE*/
INSERT INTO DEPT VALUES('D4', 'HR', 'BGG');/* CHECK CONSTRAINT VIOLATED*/
INSERT INTO DEPT(DNO, DNAME) VALUES('D5', 'IT');
INSERT INTO DEPT VALUES(NULL, 'CORPORATE', 'HYD'); /* CANNOT INSERT NULL PRIMARY KEY(DNO)*/
SELECT * FROM DEPT;
INSERT INTO DEPT VALUES('D6', 'HR', 'CHN');
INSERT INTO DEPT VALUES('D7', 'ADMIN', 'MUB');
INSERT INTO DEPT VALUES('D8', 'CORPORATE', 'HYD');
INSERT INTO DEPT VALUES('D9', 'SERVICE', 'BNG');
INSERT INTO DEPT VALUES('D10', 'CLERK', 'MNG');
SELECT * FROM DEPT WHERE LOCATIONS='CHN';
/* PROJECTS INSERTION */
INSERT INTO PROJECTS VALUES('D1', 'P1', 'Prj001', 2, '1-OCT-1980', '24-DEC-1986');
INSERT INTO PROJECTS VALUES('D2', 'P1', 'Prj001', 2, '1-OCT-1980', '24-DEC-1986');

INSERT INTO PROJECTS VALUES('D3', 'P2', 'Prj002', 7, '1-OCT-1982', '24-DEC-1995');/*PARENT KEY NOT FOUND*/
INSERT INTO PROJECTS VALUES('D1', 'P3', 'Prj003', 5, '1-OCT-1985', '24-DEC-1999');
INSERT INTO PROJECTS VALUES('D4', 'P2', 'Prj002', 7, '1-OCT-1982', '24-DEC-1995');/*PARENT KEY NOT FOUND*/
SELECT * FROM PROJECTS;
INSERT INTO PROJECTS VALUES('D5', 'P5', 'Prj005', 8, '1-OCT-1980', '24-DEC-1986');
INSERT INTO PROJECTS VALUES('D6', 'P6', 'Prj006', 9, '1-OCT-1980', '24-DEC-1986');
SELECT * FROM PROJECTS;
                 

INSERT INTO EMP VALUES (150, 'SOME', 'CEO', NULL, '10-OCT-1970', 60000, 30000, NULL, NULL, '03-DEC-1990');
INSERT INTO EMP VALUES (111, 'RAGHU', 'GM', 150, '10-DEC-1974', 45000, 15000, NULL, NULL, '03-DEC-1985');
INSERT INTO EMP VALUES (125, 'MANU', 'A.MGR', 150, '10-OCT-1980', 20001, 1000, 'D4', 'P2', '02-OCT-2002');/* PARENT KEY NOT FOUND */
INSERT INTO EMP VALUES (100, 'RAVI', 'MGR', 111, '10-OCT-1985', 32000, 1000, 'D1', 'P1', '02-OCT-2001');
INSERT INTO EMP VALUES (102, 'RAVIRAJ', 'CLRK', 100, '10-DEC-1980', 24000, 1000, 'D1', 'P3', '12-NOV-2000');
INSERT INTO EMP VALUES (103, 'AMIT', 'CLRK', 111, '2-OCT-1980', 20001, NULL, 'D1', 'P3', '02-OCT-2002');
INSERT INTO EMP VALUES (103, 'ANKITA', 'A.CLRK', 111, '10-OCT-1980', 20001, 1000, 'D1', 'P1', '02-OCT-2001');/*NOT INSERTED*/
INSERT INTO EMP VALUES (106, 'VARSA', 'MGR', 100, '2-OCT-1986', 20001, NULL, 'D2', 'P1', '02-OCT-2005');

INSERT INTO EMP VALUES (123, 'MAHESH', 'CLRK', 106, '10-DEC-1974', 25000, DEFAULT, 'D3', 'P2', '02-OCT-2002');
INSERT INTO EMP VALUES (108, 'TISA', 'CLRK', 125, '10-DEC-1970', 20001, 1000, 'D9', '', '02-OCT-1985');
INSERT INTO EMP VALUES (103, 'ARUN', 'CLRK', 111, '10-DEC-1980', 20001, NULL, 'D1', 'P3', '02-OCT-2001');
INSERT INTO EMP VALUES (NULL, 'RICK', 'CLRK', 106, '10-DEC-1980', 28000, 1000, 'D2', 'P2', '10-DEC-1980');
SELECT * FROM EMP;
COMMIT;
INSERT INTO EMP VALUES (121, 'RAGHAV', 'CLRK', 150, '10-DEC-1974', 45000, 15000, NULL, NULL, '03-DEC-1985');
INSERT INTO EMP VALUES (124, 'RAMAN', 'MGR', 150, '10-DEC-1974', 45000, 15000, NULL, NULL, '03-DEC-1986');
INSERT INTO EMP VALUES (131, 'RAGHU', 'GM', 100, '10-DEC-1974', 45000, 15000, 'D4', 'P3', '03-DEC-1985');
INSERT INTO EMP VALUES (141, 'RAM', 'GM', 150, '10-DEC-1974', 45000, 15000, NULL, NULL, '03-DEC-1995');
INSERT INTO EMP VALUES (150, 'ANKUR', 'MGR', 100, '10-DEC-1971', 45000, 15000, 'D2', 'P1', '03-DEC-1985');

SELECT * FROM EMP;
COMMIT;
SELECT SYSDATE FROM DUAL;
SELECT COUNT(*) "NUMBER OF RECORDS" FROM DEPT;
SELECT COUNT(*) "NUMBER OF RECORDS" FROM EMP;
SELECT COUNT(*) "NUMBER OF RECORDS" FROM PROJECTS;

SELECT COUNT(*) FROM DEPT WHERE DNAME = 'MARKETING';
SELECT LOCATIONS FROM DEPT WHERE DNAME = 'MARKETING';  

SELECT SYSDATE FROM DUAL;
SELECT * FROM DUAL;/*DUMMY  TABLE*/
SELECT 2*2 FROM DUAL;
SELECT SQRT(25) FROM DUAL;
SELECT ROUND(15.19, 1) "ROUND" FROM DUAL;
SELECT POWER(3, 2) FROM DUAL;
SELECT EXP(5) FROM DUAL;
SELECT ABS(-15) FROM DUAL;

SELECT * FROM EMP WHERE SAL BETWEEN 25000 AND 50000;
SELECT * FROM EMP WHERE ENAME LIKE 'R%';
SELECT * FROM EMP WHERE ENAME LIKE 'M%' OR ENAME LIKE 'R%';
SELECT * FROM EMP WHERE ENAME LIKE 'RA_';
SELECT DISTINCT ENAME FROM EMP;
SELECT DISTINCT LOCATIONS FROM DEPT;
SELECT * FROM EMP ORDER BY ENAME;/*ASCENDING ORDER*/
SELECT * FROM EMP ORDER BY ENAME DESC;
SELECT MAX(SAL), MIN(SAL), AVG(SAL) FROM EMP;

SELECT * FROM EMP WHERE MGR_ID IN(100,125,150);
SELECT PRJ_ID, COUNT(EMPNO) FROM EMP GROUP BY PRJ_ID;

/* 20-SEP-22 */
SELECT LOWER('HERITAGE') "LOWER" FROM DUAL;
SELECT UPPER('heritage') "UPPER" FROM DUAL;
SELECT INITCAP('heritage') "INITCAPITAL" FROM DUAL;
SELECT LENGTH('HERITAGE') "Length" FROM DUAL;
SELECT SUBSTR('heritage', 3, 4) "substr" FROM DUAL;/*rita*/
SELECT SUBSTR('heritage', -5, 4) "substr" FROM DUAL;/*itag*/
SELECT LTRIM('   technology')"str" FROM DUAL;
SELECT LTRIM('NISHA', 'N')"str" FROM DUAL;
SELECT RTRIM('010198501', '01')"str" FROM DUAL;
SELECT RTRIM('   technology  ')"str" FROM DUAL;
SELECT RTRIM('NISHAN', 'N')"str" FROM DUAL;
SELECT RTRIM('010198501', '01')"str" FROM DUAL;
SELECT TRIM('  HERITAGE  ') "TRIM BOTH" FROM DUAL;
SELECT TRIM(LEADING 'X' FROM 'XXXHERITAGE') "REMOVE  PREFEIXES" FROM DUAL;
SELECT TRIM(BOTH 'X' FROM 'XXXHERITAGEXXX') "REMOVE  PREFEIXES AND SUFFIXES" FROM DUAL;
SELECT RPAD('HERITAGE', 10, '*') FROM DUAL;
SELECT LPAD('HERITAGE', 10, '*') FROM DUAL;
/* TO NUMBER CONVERSION */
SELECT TO_CHAR(17145, '$099,999') "CHAR" FROM DUAL;
/* TO DATE TO CHAR CNVERSION */
SELECT TO_CHAR(SYSDATE, 'MONTH-YY') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'DD-MM-YY') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'MONTH DD, YYYY') FROM DUAL;

SELECT ADD_MONTHS(SYSDATE, 4) "ADD MONTHS" FROM DUAL;
SELECT LAST_DAY(SYSDATE) "LAST DATE" FROM DUAL;
SELECT MONTHS_BETWEEN('02-FEB-92', '02-JAN-92') "MONTHS" FROM DUAL;
SELECT MONTHS_BETWEEN('02-FEB-93', '02-JAN-92') "MONTHS" FROM DUAL;
SELECT NEXT_DAY('24-JULY-92', 'SATURDAY') "NEXT DAY" FROM DUAL;/*WHEN WILL BE NEXT SAT AFTER THIS DATE I.E. 11-JUL-92.*/
SELECT ROUND (TO_DATE('01-JUL-04', 'DD-MM-YY')) "YEAR" FROM DUAL;
SELECT ROUND(MONTH_BETWEEN(SYSDATE, DATE_OF_BIRTH)/12); /* WLL WORK IN TABLE */
SELECT ROUND(MONTH_BETWEEN(SYSDATE, TO_DATE(02-05-99))/12); /* WILL WORK IN TABLE NOT IN DUAL */


/* SET1 */
/* 1. Display all records from EMP,DEPT and PROJECTS table*/
SELECT * FROM EMP;
SELECT * FROM DEPT;
SELECT * FROM PROJECTS;

/* 2. Display records of Employees who have salary more than 25000 or working in department D2*/
SELECT * FROM EMP WHERE SAL > 25000 OR DNO = 'D2';

/* 3. Delete employee records working on project P2 and confirm the result. Type ROLLBACK to restore records back if records are deleted. */
DELETE FROM EMP WHERE PRJ_ID = 'P2'; 

/* 4. Delete department Marketing from DEPT table, confirm the result with reason. Type ROLLBACK to restore records back if records are deleted. */
DELETE FROM DEPT WHERE DNAME = 'MARKETING';

/* 5. Delete records of employees working under Manger with ID 100 and in project P1 */
DELETE FROM EMP WHERE MGR_ID = 100 AND PRJ_ID = 'P1';

/* 6. Update the DNO of first record in PROJECTS to D5, confirm the result with reason. */
UPDATE PROJECTS SET DNO = 'D5' WHERE DNO = 'D1' AND PRJ_NO = 'P1';
SELECT * FROM PROJECTS;

/* 7. Update the Job of employee with EmpNo 123 to MGR, salary to 35000 and his manager as 111. */
UPDATE EMP SET EJOB = 'MGR', SALARY = 35000, MGR_ID = 111 WHERE EMP_NO = 123;

/* 8. List all employee names and their salaries, whose salary lies between 25200/- and 35200/- both inclusive.*/ 
SELECT * FROM EMP;
SELECT ENAME FROM EMP WHERE SAL BETWEEN 25200 AND 35200;
SELECT ENAME FROM EMP WHERE SAL BETWEEN 20000 AND 35000;

/* 9. List all employee names reporting to employees 100,125,150 */
SELECT ENAME FROM EMP WHERE MGR_ID IN (100, 125, 150);

/* 10. List all employees whose name starts with either M or R. */
SELECT * FROM EMP WHERE ENAME LIKE 'M%' OR ENAME LIKE 'R%';

/* 11. List the name of employees whose name do not starts with M */
SELECT ENAME FROM EMP WHERE ENAME NOT LIKE 'M%';

/* 12. List all kind jobs available in employee table, avoid displaying duplicates. */
SELECT DISTINCT EJOB FROM EMP;

/* 13. List minimum, maximum, average salaries in company. */
SELECT MIN(SAL), MAX(SAL), AVG(SAL) FROM EMP;

/* 14. Display the number of employees working in each project. */
SELECT PRJ_ID, COUNT(EMPNO) FROM EMP GROUP BY PRJ_ID;

/* 15. List the Employees name and their manager’s names */
SELECT A1.ENAME "NAME", A2.ENAME "MANAGER NAME" FROM EMP A1 LEFT OUTER JOIN EMP A2 ON A1.MGR_ID = A2.EMPNO; 
SELECT * FROM EMP;
SELECT * FROM DEPT;
SELECT * FROM PROJECTS;

/*16. List Employees Name, their department name and Projects Name in which they are working. */
SELECT E.ENAME, D.DNAME, P.PRJ_NAME FROM EMP E, DEPT D, PROJECTS P WHERE E.DNO = D.DNO AND E.PRJ_ID = P.PRJ_NO;

/* 17. List the employee names, salary of employees whose first character of name is R, 2nd and 3rd characters are ‘v’,’i’ and remaining characters are unknown. */
SELECT ENAME, SAL FROM EMP WHERE ENAME LIKE 'RVI%';


/* SET 2*/
/* 1. List the Projects name undertaken by Marketing Department */
SELECT PRJ_NAME FROM PROJECTS NATURAL JOIN DEPT WHERE DNAME = 'MARKETING';

/* 2. Display current date, 53, absolute value of -45 and current date as date with format MONTH-YY. */
SELECT SYSDATE FROM DUAL;
SELECT ABS(-45) FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'MONTH-YY') FROM DUAL;

/* 3. Display the employees name and salary in descending order by salary. */
SELECT ENAME, SAL FROM EMP ORDER BY SAL DESC;

/* 4. List the name of departments which are working with more than 1 projects. */
SELECT DNAME FROM DEPT WHERE DNO IN(SELECT DNO FROM EMP GROUP BY DNO HAVING COUNT(*) > 1); --Nested query

/* 5. Display department name, Max salary and Min salary in each department. */
SELECT DNAME FROM DEPT;
SELECT DNAME, MAX(SAL), MIN(SAL) FROM DEPT, EMP GROUP BY DNAME; 


/* 6. List the employees whose experience is more than 5 years. */
SELECT * FROM EMP
WHERE MONTHS_BETWEEN(SYSDATE, DATE_OF_JOIN)/12 > 5;

-- EXPERIENCE MORE THAN 25 YEARS
SELECT * FROM EMP
WHERE MONTHS_BETWEEN(SYSDATE, DATE_OF_JOIN)/12 > 25;

/* 7. List the Employees number, Name and their Age and retirement date */
SELECT * FROM EMP;
SELECT EMPNO "EMP NO", ENAME "EMPLOYEE NAME", DATE_FORMAT(FROM_DAYS(DATEDIFF(NOW(),BIRTH_DATE)), "%Y") + 0 AS AGE, TO_CHAR(BIRTH_DATE + INTERVAL "60" YEAR, "YYYY-MM-DD") "RETIREMENT DATE" FROM EMP;

SELECT EMPNO "EMP NO", ENAME "EMPLOYEE NAME", FLOOR((SYSDATE-BIRTH_DATE)/365) "AGE" FROM EMP;--MONTHS_BETWEEN(SYSDATE, DATE_OF_JOIN)/12 "RETIREMENT DATE" FROM EMP;

  

/* 8. List the Employees who born on December month. */
SELECT * FROM EMP WHERE EXTRACT(MONTH FROM BIRTH_DATE) = 12;
SELECT * FROM EMP WHERE EXTRACT(MONTH FROM BIRTH_DATE) = '12';

/* 9. List the Employees names who born on a given year. */
SELECT ENAME FROM EMP WHERE BIRTH_DATE BETWEEN '01-01-1974' AND '31-12-1974';
SELECT ENAME FROM EMP WHERE EXTRACT(YEAR FROM BIRTH_DATE) = '1974';
SELECT SYSDATE FROM DUAL;
/* 10. List the Employees names who joined on day 12. */
SELECT ENAME FROM EMP WHERE EXTRACT(DAY FROM DATE_OF_JOIN) = '12';

/* 11. List the Employees names having service experience more than 35 years. */
SELECT ENAME FROM EMP WHERE (SYSDATE-DATE_OF_JOIN)>35*365;
SELECT * FROM EMP;
/* 12. List the projects which have duration more than 1 year. */
SELECT DISTINCT PRJ_NO FROM PROJECTS WHERE MONTHS_BETWEEN(END_DATE, START_DATE)/12 > 1;

/* 13. List the Employees Name who is working at Locations (BNG,MUB,HYD)     */
SELECT * FROM DEPT;
SELECT ENAME FROM EMP NATURAL JOIN DEPT NATURAL JOIN PROJECTS WHERE LOCATIONS = 'MUB';
SELECT ENAME FROM EMP NATURAL JOIN DEPT NATURAL JOIN PROJECTS WHERE LOCATIONS = 'HYD';
SELECT ENAME FROM EMP, DEPT WHERE LOCATIONS = 'CHN' AND EMP.DNO = DEPT.DNO;
/* 14. . Update the COMM column of EMP table based on the SAL. Use COMM=C0MM+SAL*10/100 */
UPDATE EMP SET COMM = COMM + SAL*10/100;
SELECT * FROM EMP;
/* 15. List employee names, padded to right with a series of three periods and space up to a width of 30, and project credits of projects in which they are working.(Use RPAD,LPAD) */
SELECT RPAD(E.ENAME, 30, '*') "EMPNAME", P.PRJ_CREDITS  FROM EMP E, PROJECTS P WHERE E.PRJ_ID = P.PRJ_NO;

/* 16. List the name of employees who are working in project with credit more than 7 and display name with only first letter capital and replace the character ‘a’(if present) in the name by ‘$’.*/
SELECT REPLACE(INITCAP(E.ENAME), 'a', '$') "ENAME" FROM EMP E, PROJECTS P, DEPT D WHERE E.PRJ_ID = P.PRJ_NO AND D.DNO = E.DNO AND PRJ_CREDITS>7;
SELECT REPLACE(INITCAP(E.ENAME), 'a', '$') "ENAME" FROM EMP E, PROJECTS P, DEPT D WHERE E.PRJ_ID = P.PRJ_NO AND D.DNO = E.DNO AND PRJ_CREDITS>4; --PRJ_CREDITS>4
/* 17. Display department Name and Total amount spent on each department by the company as Salary. */
SELECT D.DNAME, SUM(E.SAL + E.COMM) "SALARY" FROM DEPT D, EMP E WHERE D.DNO = E.DNO GROUP BY D.DNAME;

/* 18. . List Employee numbers, SAL *12 (rename as ANNUAL_SAL), SAL*12 *0.1 (as TAX) , display ANNUAL_SAL and TAX in the format of $12,34,456.90 */

SELECT EMPNO, SAL*12 "ANNUAL_SAL", SAL*12*0.1 "TAX" FROM EMP;
SELECT EMPNO, TO_CHAR(SAL*12, '$12,34,456.90')  "ANNUAL_SAL", TO_CHAR(SAL*12*0.1, '$12,34,456.90')  "TAX" FROM EMP;

/* SET 3 */
/* 1. List Job category and total salary paid for the each jobs category by the company. */
SELECT EJOB, SUM(SAL) FROM EMP GROUP BY EJOB;

/* 2. Display name of the department from which maximum number of employees are working on project P1 */
SELECT DNAME FROM
(SELECT D.DNAME , COUNT(E.EMPNO) "Emp_Count_P1" FROM DEPT D , EMP E
WHERE E.DNO = D.DNO AND E.PRJ_ID = 'P1' 
GROUP BY D.DNAME) 
WHERE "Emp_Count_P1" = 
(SELECT MAX("Emp_Count_P1") "Emp_Count_P1" FROM
(SELECT D.DNAME , COUNT(E.EMPNO) "Emp_Count_P1" FROM DEPT D , EMP E
WHERE E.DNO = D.DNO AND E.PRJ_ID = 'P1' 
GROUP BY D.DNAME));
SELECT * FROM DEPT;
SELECT * FROM PROJECTS;
/* 3. Display department names and number of CLRK working in the departments. */
SELECT D.DNAME, COUNT(*) FROM EMP E, DEPT D WHERE E.DNO = D.DNO AND E.EJOB = 'CLRK' GROUP BY D.DNAME;

/* 4. Display Employee names who are not working in any of the projects. */
SELECT ENAME FROM EMP WHERE PRJ_ID IS NULL;

/*5. Create a View EMP_PRJ_VW to display records of employees of ‘marketing’ department and project in which they are working.*/
CREATE VIEW EMP_PRJ_VW AS
SELECT  EMPNO , ENAME , EJOB , MGR_ID , BIRTH_DATE , SAL , COMM , DATE_OF_JOIN , P.DNO , P.PRJ_NO , PRJ_NAME , PRJ_CREDITS
FROM EMP E , DEPT D , PROJECTS P
WHERE E.DNO = D.DNO AND E.PRJ_ID = P.PRJ_NO AND E.DNO = P.DNO AND D.DNAME = 'MARKETING';

--6. Display employee names and projects in which they are working using View EMP_PRJ_VW
SELECT ENAME , PRJ_NAME FROM EMP_PRJ_VW;

--7. Insert a record into View EMP_PRJ_VW and check the underlying tables for result and
--confirm result with reason.
INSERT INTO EMP_PRJ_VW VALUES(107 , 'ANKIT', 'CLRK' , 111 , '10-12-75' , 32000 , 2400 , '02-10-01' , 'D1' , 'P3' , 'Prj003' , 3); 
SELECT * FROM EMP_PRJ_VW;
SELECT * FROM PROJECTS;
/* 8. Create an unique index on the column name DNAME on DEPT table */
CREATE  INDEX D_NO_IDX  ON DEPT(DNAME);
SELECT * FROM DEPT;
SELECT * FROM EMP;
SELECT * FROM PROJECTS;

--9. Create an index on the columns (name and job) on EMP table. 
CREATE INDEX EMP_NAME_IDX ON EMP(ENAME, EJOB);

--10. Create a Sequence STUD_SEQ which starts from 100 to 999 with increments of 3. 
CREATE SEQUENCE STUD_SEQ START WITH 100
INCREMENT BY 3
MAXVALUE 999;
--11. Create a table STUD with columns ROLLNO and Name. Insert ROLLNO values by taking values from STUD_SEQ. 
create table STUD(
    ROLLNO NUMBER(3),
    DNAME VARCHAR2(10),
    Primary Key(ROLLNO)
);

INSERT INTO STUD VALUES(STUD_SEQ.NEXTVAL, 'RAM');
INSERT INTO STUD VALUES(STUD_SEQ.NEXTVAL, 'SHYAM');
INSERT INTO STUD VALUES(STUD_SEQ.NEXTVAL, 'JADU');
SELECT * FROM STUD;

/* 12 Display Location of department and Employees name working in Marketing department or Research (using set operator). */
SELECT ENAME, LOCATIONS FROM EMP NATURAL JOIN DEPT WHERE DNAME = 'MARKETING' UNION SELECT ENAME, LOCATIONS FROM EMP NATURAL JOIN DEPT WHERE DNAME = 'RESEARCH';   
SELECT * FROM EMP;
SELECT * FROM DEPT;
/* 13. Display the names of the Departments undertaking both projects P1 and P3 */
SELECT  DNAME FROM DEPT NATURAL JOIN PROJECTS WHERE PRJ_NO = 'P1' UNION SELECT  DNAME FROM DEPT NATURAL JOIN PROJECTS WHERE PRJ_NO = 'P3';

-- 31/10/22
/* NTH MAXIMUM SALARY */
SELECT DISTINCT SAL FROM EMP A WHERE(SELECT COUNT(DISTINCT SAL) FROM EMP B WHERE A.SAL <= B.SAL) = &N;
SELECT DISTINCT SAL FROM EMP;
COMMIT;


-- SET 4
--1. Display the details of those who do not have any person working under them.
SELECT * FROM EMP WHERE EMPNO NOT IN (SELECT MGR_ID FROM EMP WHERE MGR_ID IS NOT NULL);

--2. Display those who are not managers and who are manager any one.
SELECT ENAME FROM EMP WHERE EMPNO
NOT IN (SELECT MGR_ID FROM EMP WHERE MGR_ID IS NOT null);

--3. Display those employees whose salary is more than 3000 after giving 20% increment.
UPDATE EMP SET SAL = SAL + SAL*20/100;
SELECT * FROM EMP WHERE SAL > 3000;

/*4.  Display the name,monthly salary,daily salary and Hourly salary for employees.Assume
that the Sal column in the table is the monthly salary,that there are 22 working days in a
month,and that there are 8 working hours in a day.Rename the columns as monthly,daily
and hourly.*/
SELECT ENAME, SAL AS MONTHLY, SAL/22 AS DAILY, (SAL/22)/24 AS HOURLY FROM EMP; 

--5. Display employee name, dept name, salary and comm. For those sal in between 32000 to 50000 while location is BNG.
SELECT ENAME, DNAME, SAL, COMM FROM EMP NATURAL JOIN DEPT WHERE SAL BETWEEN 32000 AND 50000 AND LOCATIONS = 'BNG';
SELECT ENAME, DNAME, SAL, COMM FROM EMP NATURAL JOIN DEPT WHERE SAL BETWEEN 32000 AND 50000 AND LOCATIONS = 'CHN';

--6. Display those employees whose salary is greater than his manager salary.
SELECT * FROM EMP E, EMP M WHERE E.MGR_ID = M.EMPNO AND E.SAL > M.SAL;
SELECT * FROM EMP E, EMP M WHERE E.MGR_ID = M.EMPNO AND E.SAL < M.SAL; -- SALARY OF WORKER LESS THAN MANAGER

--7. Display those employees who are working in the same dept where his manager is working.
SELECT E.* FROM EMP E, EMP E1 WHERE E.MGR_ID = E1.EMPNO AND E.DNO=E1.DNO;
--OR
SELECT * FROM EMP E WHERE E.DNO = (SELECT E1.DNO FROM EMP E1 WHERE E1.EMPNO=E.MGR_ID);

--8. Display employees name for the dept no D1 or D3 while joined the company before 31-dec-82
SELECT ENAME FROM DEPT NATURAL JOIN EMP WHERE DNO IN ('D1', 'D3') AND DATE_OF_JOIN < '31-12-82';
SELECT ENAME FROM DEPT NATURAL JOIN EMP WHERE DNO IN ('D1', 'D3') AND DATE_OF_JOIN < '31-12-2002';

--9. Update the salary of each employee by 10% increment who are not eligible for commission.
UPDATE EMP SET SAL = SAL + SAL*10/100 WHERE COMM IS NULL;
SELECT * FROM EMP;

-- 10. Find out the top 5 earners of the company.
SELECT  * FROM (SELECT ENAME, SAL from EMP ORDER BY SAL DESC) WHERE rownum <= 5  order by SAL DESC;

--11. Display name of those employees who are getting the highest salary in their department.
SELECT ENAME FROM EMP A WHERE SAL =  (SELECT MAX(SAL) FROM EMP WHERE DNO = A.DNO);

--12. Select count of employees in each department where count greater than 3.
SELECT COUNT(*) AS "NUMBER OF EMPLOYEES", DNAME FROM EMP NATURAL JOIN DEPT GROUP BY DNAME HAVING COUNT(*) > 3;
SELECT COUNT(*) AS "NUMBER OF EMPLOYEES", DNAME FROM EMP E, DEPT D  WHERE E.DNO = D.DNO GROUP BY DNAME HAVING COUNT(*) > 1 ; -- MORE THAN 1 WORKING

--13. Display department name where at least 3 employee are working, display only department name.
SELECT  DNAME FROM EMP, DEPT WHERE EMP.DNO = DEPT.DNO GROUP BY DNAME HAVING COUNT(*) > 1;
SELECT  DNAME FROM EMP,DEPT /*WHERE EMP.DNO = DEPT.DNO */ GROUP BY DNAME HAVING COUNT(*) > 1 ; -- MORE THAN 1 WORKING

--14. Display those managers name whose salary is more than average salary of employees working under him/her.
SELECT * FROM EMP M WHERE M.EMPNO IN (SELECT MGR_ID FROM EMP) AND M.SAL > (SELECT AVG(E.SAL) FROM EMP E WHERE E.MGR_ID = M.EMPNO );

-- 15 . Display those employees whose salary is odd value.
SELECT * FROM EMP WHERE MOD(SAL, 2) = 1;

-- 16. List of employees who do not get any commission.
SELECT * FROM EMP WHERE COMM  IS NULL;

-- 17.  Display those employees whose salary contains at least 3 digi
SELECT * FROM EMP WHERE LENGTH(TRIM(TO_CHAR(SAL,'9999'))) > 3;

-- 18. Delete those employees who joined the company 10 years back from today.
DELETE EMP
WHERE (SYSDATE-DATE_OF_JOIN)/365 > 10;
ROLLBACK;
-- 19. Display the name of employees who joined on the same date.
SELECT * FROM EMP E WHERE DATE_OF_JOIN IN (SELECT DATE_OF_JOIN FROM EMP WHERE E.EMPNO <> EMPNO);
SELECT * FROM EMP;

-- 20. Display the manager who is having maximum number of employees working under him.
SELECT MGR_ID, COUNT(EMPNO) as TOTAL_EMPLOYEES FROM EMP GROUP BY MGR_ID
HAVING COUNT(EMPNO)=(SELECT MAX(COUNT(EMPNO))FROM EMP GROUP BY MGR_ID);

COMMIT;


/* SET 5 */
--1. Print a list of employees displaying “Just Salary” if more than 25000 if exactly 25000 display “On target” if less ‘Below target’.
SELECT ENAME, (CASE WHEN SAL>25000 THEN 'JUST SALARY' WHEN SAL = 25000 THEN 'ON TARGET' WHEN SAL < 25000 THEN 'BELOW TARGET' END) AS SALSCOND FROM EMP;

--2. Define a variable representing the expression used to calculate on employees total Annual Remuneration.
SET DEFINE ON
DEFINE ANNUAL = 12*nvl2(COMM.,SAL+COMM.,SAL)
SELECT * FROM EMP WHERE &ANNUAL > 30000;

--3. Find out how many managers are there without listing them.
SELECT COUNT(DISTINCT (MGR_ID)) FROM EMP;

--4. List out the lowest paid employees working for each manager; exclude any groups where minimum salary is less than Rs. 21000. Sort the output by salary.
SELECT MGR_ID, MIN(SAL) FROM EMP WHERE MGR_ID IS NOT NULL GROUP BY MGR_ID ORDER BY MIN(SAL) DESC;

--5. Find out the all employees who joined the company before their managers.
SELECT * FROM EMP E WHERE DATE_OF_JOIN IN (SELECT DATE_OF_JOIN FROM EMP M WHERE E.MGR_ID = M.EMPNO AND E.DATE_OF_JOIN = M.DATE_OF_JOIN);
SELECT * FROM EMP;
--6. List out the all employees by name and number along with their manager’s name and number; also display “KING” who has no manager.
SELECT ENAME, EMPNO, MGR_ID FROM EMP WHERE MGR_ID IN (SELECT EMPNO FROM EMP WHERE ENAME <> 'KING'); --IC

--7. Find out the employees who earn the highest salary in each job type. Sort in descending salary order
SELECT * FROM EMP WHERE SAL IN (SELECT MAX(SAL) FROM EMP GROUP BY EJOB) ORDER BY SAL DESC;

--8. Find out the employees who earn the minimum salary for their job in ascending order.
SELECT * FROM EMP WHERE SAL IN (SELECT MIN(SAL) FROM EMP GROUP BY EJOB) ORDER BY SAL ASC;

--9. In which year did most people join the company. Display the year and number of employees.
SELECT TO_CHAR(DATE_OF_JOIN,’YYYY’) “YEAR”, COUNT(EMPNO) “NO. OF EMPLOYEES” FROM EMP
GROUP BY TO_CHAR(DATE_OF_JOIN,’YYYY’) HAVING COUNT(EMPNO) = (SELECT MAX(COUNT(EMPNO)) FROM EMP GROUP BY TO_CHAR(DATE_OF_JOIN,’YYYY’));

--10. Display average salary for each department
SELECT AVG(SAL), DNAME FROM EMP, DEPT  GROUP BY DNAME;

--11.  Display employees who can earn more than lowest salary in department no D3.
SELECT * FROM EMP WHERE SAL > (SELECT MIN(SAL) FROM EMP WHERE DNO = 'D3');
SELECT * FROM EMP WHERE SAL > (SELECT MIN(SAL) FROM EMP WHERE DNO = 'D1'); --DEPARTMENT NO D1
SELECT * FROM EMP;
--12. Display the half of the employee name in upper case & remaining lower case?
-- NOT SOLVED
select upper(substr(ename,0,3))||lower(substr(ename,3)) from emscs;
SELECT UPPER(SUBSTR(ENAME) WHERE ENAME IN ROWNUM<=4) FROM EMP;--||( LOWER(SUBSTR(ENAME) WHERE ENAME IN ROWNUM>4)  FROM EMP;

--13. Create a copy of EMP table without any data(records)
-- CREATE TABLE EMP_NEW AS SELECT * FROM EMP; WITH RECORDS
CREATE TABLE EMP_NEW AS SELECT * FROM EMP WHERE 1=0; -- WITHOUT RECORDS
SELECT * FROM EMP_NEW;

--14. List the details of the employees in Departments D1 and D2 in alphabetical order of Name
SELECT * FROM EMP WHERE DNO IN ('D1', 'D2') ORDER BY ENAME ASC;
SELECT * FROM EMP;

--15. List all rows from EMP table, by converting the null values in COMM column to 0.
SELECT * FROM EMP;
UPDATE EMP SET COMM = 0 WHERE COMM IS NULL;
SELECT * FROM EMP;

--16. Find the average salary per job in each Dept
SELECT AVG(SAL), EJOB FROM EMP GROUP BY EJOB;

--17. Find the job with the highest average salary.
SELECT  EJOB, AVG(SAL)  FROM EMP GROUP BY EJOB ORDER BY AVG(SAL) DESC;

COMMIT;

    
SELECT * FROM DBA_USERS; -- LIST OF USERS IN OUR DATABASE
SELECT * FROM TAB; -- NAME OF ALL TABLES IN CURRENT USER
SHOW USER; -- SHOWS NAME OF CURRENT USER
    

--Display the name of the employee along with their annual salary (Sal * 12). The name of the employee earning highest annual salary should appear first.   
SELECT ENAME, 12*(SAL+NVL(COMM, 0)) "ANNUAL" FROM EMP ORDER BY 12*(SAL+NVL(COMM,0)) DESC;   
SELECT ENAME, 12*SAL "ANNUAL" FROM EMP ORDER BY 12*SAL DESC;

--Display name, Sal, hra, pf, da, total Sal for each employee. The output should be in the order of total Sal, hra 15% of Sal, da 10% of sal, pf 5% of sal total salary will be (sal*hra*da)-pf.
select ename,sal,sal*15/100 HRA, sal*5/100 PF, sal*10/100 DA,sal+sal*15/100- sal*5/100+sal*10/100 TOTAL_SALARY from emp ;
SELECT ENAME, SAL, SAL*15/100 HRA, SAL*10/100 DA, SAL*5/100 PF, ((SAL + SAL*15/100 + SAL*10/100) - SAL*5/100) TOTAL_SALARY FROM EMP; 
   
--Display the name of emp who earns highest sal.   
SELECT ENAME FROM EMP WHERE SAL = (SELECT MAX(SAL) FROM EMP);

-- Display the employee number and name of employee working as CLERK and earning highest salary among CLERKS.
SELECT EMPNO, ENAME FROM EMP WHERE EJOB = 'CLRK' AND SAL = (SELECT MAX(SAL) FROM EMP WHERE EJOB = 'CLRK');

-- Find the sum of the salaries and number of employees of all employees of the ‘Marketing’ department, as well as the maximum salary, the minimum salary, and the average salary in this department
SELECT SUM(SAL), COUNT(*), MAX(SAL), MIN(SAL), AVG(SAL) FROM EMP NATURAL JOIN DEPT WHERE DEPT.DNAME = 'MARKETING';
SELECT * FROM DEPT;
SELECT * FROM EMP;

-- Display the job groups having total salary greater then the maximum salary for managers.
SELECT EJOB, SUM(SAL) FROM EMP GROUP BY EJOB HAVING SUM(SAL)> (SELECT MAX(SAL) FROM EMP WHERE EJOB = 'MGR'); 

-- Display the names of employees from department number 10 with salary greater than that of any employee working in other departments.
select ename,sal,dno from emp e where dno='d1' and sal > any(select sal from emp where e.dno!=dno); 

Find out the length of your name using appropriate function. 
select LENGTH('ANKUSH') FROM DUAL;

12. Display the length of all employees? names. 
select sum(length(ename)) from emp;

13. Display the name of the employee concatenate with EMP no.
select ename||empno from emp; --(or) select 
SELECT CONCAT(ENAME, EMPNO) FROM EMP;

-- 4 MONTHS FROM NOW
SELECT ADD_MONTHS(SYSDATE, 4) FROM DUAL;

-- Use appropriate function and extract 3 characters starting from 2 characters from the following String 'Oracle' i.e. the output should be rac.
SELECT SUBSTR('ORACLE', 2, 3) FROM DUAL;

-- Replace every occurrence of alphabet A with B in the string Allen?s (user translate function).
SELECT REPLACE('ALLENS', 'A', 'B') FROM DUAL;

-- Display the information from EMP table. Wherever job ?manager? is found it should be displayed as boss(replace function).
select ename replace(ejob, 'mgr', 'Boss') JOB from emp;
SELECT ENAME REPLACE(EJOB, 'MGR', 'BOSS') EJOB FROM EMP;

-- Display your age in days.
SELECT ROUND(SYSDATE - TO_DATE('01-03-2001')) FROM DUAL;
20. Display your age in months.
select floor(months_between(sysdate,'01-03-2001')) "age in months" from dual;
BIRTH_DATE := TO_DATE('&indate', 'DD-MM-YYYY');
AGE := FLOOR((SYSDATE-BIRTH_DATE)/365);

-- DISPLAY NEXT SATURDAY
SELECT NEXT_DAY(SYSDATE, 'SATURDAY') FROM DUAL;

--Display those employees whose name contains not less than 4 chars.
SELECT * FROM EMP WHERE LENGTH(ENAME)>4;

-- 33. Display those departments whose name start with m? while location name end with g.
SELECT * FROM DEPT WHERE DNAME LIKE 'S5' AND LOCATIONS LIKE '%G';

-- 34. Display those employees whose manager name is JONES.
SELECT * FROM EMP WHERE EJOB = (SELECT EMPNO FROM EMP WHERE EJOB = 'MGR' );


--Find the most recently hired employee in each department.
SELECT * FROM EMP WHERE (DNO, DATE_OF_JOIN) IN (SELECT DNO, MAX(DATE_OF_JOIN) FROM EMP GROUP BY DNO);

commit;
