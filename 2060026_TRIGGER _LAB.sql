SET SERVEROUTPUT ON;
-- A database trigger is procedural code that is automatically executed in response to certain events on a particular table or view in a database.

CREATE TABLE CUSTOMERS(
                        ID NUMBER,
                        NAME VARCHAR2(13),
                        AGE NUMBER,
                        ADDRESS VARCHAR2(13),
                        SALARY NUMBER
                    );
DESC CUSTOMERS;
INSERT INTO CUSTOMERS VALUES(1, 'RAM', 21, 'BNG', 90000);
INSERT INTO CUSTOMERS VALUES(1, 'SHYAM', 20, 'KOL', 45000);
INSERT INTO CUSTOMERS VALUES(1, 'JADU', 17, 'HYD', 15000);

CREATE OR REPLACE TRIGGER display_salary_changes  
BEFORE DELETE OR INSERT OR UPDATE ON customers  
FOR EACH ROW  
WHEN (NEW.ID > 0)  
DECLARE  
   sal_diff number;  
BEGIN  
   sal_diff := :NEW.salary  - :OLD.salary;  
   dbms_output.put_line('Old salary: ' || :OLD.salary);  
   dbms_output.put_line('New salary: ' || :NEW.salary);  
   dbms_output.put_line('Salary difference: ' || sal_diff);  
END;  
/  

DECLARE   
   total_rows number(2);  
BEGIN  
   UPDATE  customers  
   SET salary = salary + 5000;  
   IF sql%notfound THEN  
      dbms_output.put_line('no customers updated');  
   ELSIF sql%found THEN  
      total_rows := sql%rowcount;  
      dbms_output.put_line( total_rows || ' customers updated ');  
   END IF;   
END;  
/  



CREATE OR REPLACE TRIGGER EMP_TRIG
    BEFORE INSERT ON EMP
    FOR EACH ROW

BEGIN
    IF :NEW.DNO = D1 THEN
        :NEW.comm := :NEW.sal * .4;
    END IF;
END
/
SELECT * FROM EMP;


CREATE OR REPLACE TRIGGER department_insert_update
BEFORE INSERT OR UPDATE ON dept
FOR EACH ROW
DECLARE
dup_flag  INTEGER;
BEGIN
--Force all department names to uppercase.
:NEW.dname := UPPER(:NEW.dname);
END;
/


CREATE TABLE Master
( client_no number(2) PRIMARY KEY ,
  client_name VARCHAR2(10),
  address VARCHAR2(20),
  city VARCHAR2(10) );

CREATE SEQUENCE EMP_SEQ START WITH 10
increment by 5
minvalue 10
maxvalue 500;

CREATE OR REPLACE TRIGGER C_M
AFTER
INSERT ON EMP1
FOR EACH ROW
BEGIN
INSERT INTO MASTER
VALUES(EMP_SEQ.nextval , null , null , null);
END;
/
DROP TRIGGER C_M;


CREATE TABLE EMP2(
                    EMP_NO NUMBER,
                    EMP_NAME VARCHAR2(13),
                    BIRTH_DATE DATE,
                    STREET VARCHAR2(25),
                    CITY VARCHAR2(13),
                    PRIMARY KEY(EMP_NO)
                );
DESC EMP2;

-- EMP1
select sysdate from dual;
DECLARE

EMP_NO NUMBER;
EMP_NAME VARCHAR2(13);
BIRTH_DATE DATE;
STREET VARCHAR2(25);
CITY VARCHAR2(13);
BEGIN
INSERT INTO EMP2 VALUES(100, 'RAM', '09-OCT-65', 'MG STREET', 'BNG');
INSERT INTO EMP2 VALUES(101, 'SHYAM', '19-NOV-66', 'SR STREET', 'CHN');
INSERT INTO EMP2 VALUES(102, 'JADU', '09-JUN-63', 'PARK STREET', 'KOL');

END;
/
SELECT * FROM EMP2;

INSERT INTO EMP2 VALUES(EMP_SEQ.nextval , 'KARAN' , '09-DEC-15' , 'PARK STREET' , 'KOL');
INSERT INTO EMP2 VALUES(EMP_SEQ.nextval , 'ARJUN' , '05-NOV-17' , 'NCR' , 'DEL');

INSERT INTO EMP2 VALUES(EMP_SEQ.nextval , 'RAMESH' , '10-OCT-16' , 'JH STREET' , 'BNG');


select client_no from MASTER;
select* from EMP2;

CREATE OR REPLACE TRIGGER EMP_INCOME_TAX
BEFORE INSERT ON EMP2 FOR EACH ROW
BEGIN
UPDATE WORKS
SET INCOME_TAX = 0.2*SALARY WHERE SALARY>=200000;
UPDATE WORKS
SET INCOME_TAX = 0.15*SALARY WHERE SALARY<200000 AND SALARY>=100000;
UPDATE WORKS
SET INCOME_TAX = 0.1*SALARY WHERE SALARY<100000 AND SALARY>=50000 OR SALARY IS NULL;
END;
/
SELECT * FROM EMP2;
commit;
SELECT * FROM TAB;