SET SERVEROUTPUT ON;
--1. Create a cursor for the EMP table, that produce the output in following format: Employee {emp_name} working in company {company_name} and earns Rs. {salary}.
-- EXPLICIT CURSORS
SELECT * FROM EMP;

DECLARE
    ENAME EMP1.EMP_NAME%TYPE;
    CNAME COMPANY.COMPANY_NAME%TYPE;
    SAL WORKS.SALARY%TYPE;
    CURSOR E_EMP IS
        SELECT EMP_NAME, COMPANY_NAME, SALARY FROM EMP1 NATURAL JOIN COMPANY NATURAL JOIN WORKS;
BEGIN
    OPEN E_EMP;
    LOOP
        FETCH E_EMP INTO ENAME, CNAME, SAL;
        EXIT WHEN E_EMP%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(ENAME|| ' ' || CNAME || ' ' || SAL);
    END LOOP;
    CLOSE E_EMP;
END;
/

/*2. Create a cursor for updating the salary of employee working in company with company_id 202(INSERTED IN COMPANY ID IS 200, 201, 202)
by 20%. If any rows are affected than display the no of rows affected. Use implicit cursor.*/

DECLARE
    TROWS NUMBER(2);
BEGIN
    UPDATE WORKS 
    SET SALARY = SALARY + SALARY*20/100 WHERE COMPANY_ID = 202;
    IF SQL%NOTFOUND THEN
        DBMS_OUTPUT.PUT_LINE('NO EMP UPDATED');
    ELSIF SQL%FOUND THEN
        TROWS := SQL%ROWCOUNT;
        DBMS_OUTPUT.PUT_LINE(TROWS||' WORKS UPDATED ');

    END IF;
END;
/
SELECT * FROM WORKS; -- EMP_NO = 102 WORKING IN COMPANY_ID = 202 HAS UPDATION IN SALARY.
/

/*3. Create a cursor for updating the salary of employee working in company with company_id 202(INSERTED IN COMPANY ID IS 200, 201, 202)
by 20%. If any rows are affected than display the no of rows affected. Use explicit cursor.*/
DECLARE
    TROWS NUMBER(2);
    ENO WORKS.EMP_NO%TYPE;
    CID WORKS.COMPANY_ID%TYPE;
    SAL WORKS.SALARY%TYPE;
    CURSOR E_WORKS IS
        SELECT EMP_NO, COMPANY_ID, SALARY FROM WORKS;
BEGIN
    OPEN E_WORKS;
    LOOP
        FETCH E_WORKS INTO ENO, CID, SAL;
        UPDATE WORKS SET SALARY = SALARY +SALARY*20/100 WHERE COMPANY_ID = 202;
        EXIT WHEN E_WORKS%NOTFOUND;
        IF SQL%NOTFOUND THEN
            DBMS_OUTPUT.PUT_LINE('NO EMP UPDATED');
        ELSIF SQL%FOUND THEN
            TROWS := SQL%ROWCOUNT;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(TROWS||'WORKS UPDATED');
    DBMS_OUTPUT.PUT_LINE('NO CO_ID SALARY');
    DBMS_OUTPUT.PUT_LINE(ENO|| ' ' || CID || ' ' || SAL);
    CLOSE E_WORKS;
END;
/
SELECT * FROM WORKS; -- EMP_NO = 102 WORKING IN COMPANY_ID = 202 HAS UPDATION IN SALARY.

--4. Create a cursor that will display the employee name, company name and salary of the first 2(EMP_1 HAS 3 EMPLOYEES) employees getting the highest salary. Use for cursor.
DECLARE
    CURSOR E_ECW IS
        SELECT * FROM (SELECT EMP_NAME, COMPANY_NAME, SALARY from EMP1 NATURAL JOIN COMPANY NATURAL JOIN WORKS ORDER BY SALARY DESC) WHERE rownum <= 2  order by SALARY DESC;
        EMP_REC E_ECW%ROWTYPE;
BEGIN
    FOR EMP_REC IN E_ECW
    LOOP
        DBMS_OUTPUT.PUT_LINE(EMP_REC.EMP_NAME||'  '||EMP_REC.COMPANY_NAME||'  '||EMP_REC.SALARY);
    END LOOP;
END;
/


--5. Write a PL/SQL program using parameterized cursor to display all the information of employee living in specified address. Address (street and city) taken from keyboard.
SELECT * FROM EMP1;
DECLARE
    ENAME EMP1.EMP_NAME%TYPE;
    STR EMP1.STREET%TYPE;
    CT   EMP1.CITY%TYPE;
    CURSOR E_EMP IS
        SELECT EMP_NAME, STREET, CITY FROM EMP1;
BEGIN
    OPEN E_EMP;
    LOOP
        FETCH E_EMP INTO ENAME, STR, CT;
        EXIT WHEN E_EMP%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(ENAME|| ' ' || STR || ' ' || CT);
    END LOOP;
    CLOSE E_EMP;
END;
/

--6. Create a cursor which display the sum of salary, company wise.
DECLARE
    CNAME COMPANY.COMPANY_NAME%TYPE;
    SAL WORKS.SALARY%TYPE;
    CURSOR E_WORKS IS
        SELECT COMPANY_NAME, SALARY FROM COMPANY NATURAL JOIN WORKS;
BEGIN
    OPEN E_WORKS;
    LOOP
        FETCH E_WORKS INTO CNAME, SAL;
        EXIT WHEN E_WORKS%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(CNAME || ' ' || SAL);
    END LOOP;
    CLOSE E_WORKS;
END;
/

--7. Create a cursor to accept a range of salary (that is lower boundary and higher boundary) and display the details of employees along with designation and experience.
SELECT * FROM EMP;
CREATE TABLE EMPLOYEE(
                        EMPNO NUMBER(4),
                        ENAME VARCHAR2(10),
                        EXP NUMBER(3),
                        DESG VARCHAR2(10),
                        SAL NUMBER(6)
                    );
DESC EMPLOYEE;
SELECT * FROM EMPLOYEE;
INSERT INTO EMPLOYEE VALUES(100, 'RAM', 10, 'MGR', 50000);
INSERT INTO EMPLOYEE VALUES(110, 'SHYAM', 2, 'CLRK', 15000);
INSERT INTO EMPLOYEE VALUES(120, 'JADU', 5, 'CLRK', 30000);
SELECT * FROM EMPLOYEE;
DROP TABLE EMPLOYEE;
DECLARE
    DESIGNATION EMPLOYEE.DESG%TYPE;
    SALARY EMPLOYEE.SAL%TYPE;
    EXPERIENCE EMPLOYEE.EXP%TYPE;
    NO EMPLOYEE.EMPNO%TYPE;
    NAME EMPLOYEE.ENAME%TYPE;
    SAL1 NUMBER(8):= &SAL1;
    SAL2 NUMBER(8):= &SAL2;
    CURSOR E_EMPLOYEE IS
        SELECT EMPNO, ENAME, DESG, SAL, EXP FROM EMPLOYEE WHERE SAL BETWEEN SAL1 AND SAL2;
BEGIN
    OPEN E_EMPLOYEE;
    DBMS_OUTPUT.PUT_LINE('NUM NAME DESG EXP SALARY');
    LOOP
        FETCH E_EMPLOYEE INTO NO, NAME, DESIGNATION, SALARY, EXPERIENCE;
        EXIT WHEN E_EMPLOYEE%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(NO|| ' ' ||   NAME   || ' ' ||   DESIGNATION   || ' ' ||   EXPERIENCE   || ' ' ||  SALARY  );
    END LOOP;
    CLOSE E_EMPLOYEE;
END;
/
COMMIT;

/*8. Write a nested cursor in which the parent cursor SELECTs information about each manager of a company. The child cursor counts the number of employee.
The only output is one line for each company, with the company name, manager name, and total employee.*/

DECLARE
    V_CID WORKS.COMPANY_ID%TYPE;
    CURSOR C_MANAGER IS SELECT MANAGER_NAME, COMPANY_NAME, WORKS.COMPANY_ID AS CID FROM MANAGES, WORKS, COMPANY WHERE WORKS.COMPANY_ID = COMPANY.COMPANY_ID AND WORKS.EMP_NO = MANAGES.EMP_NO;
    CURSOR C_ENROLLMENT IS SELECT COUNT(COMPANY_ID) AS TOTAL_EMPLOYEE FROM WORKS WHERE COMPANY_ID = V_CID GROUP BY COMPANY_ID;
BEGIN
    FOR TEMP IN C_MANAGER LOOP
        V_CID := TEMP.CID;
        FOR Z IN C_ENROLLMENT LOOP
            DBMS_OUTPUT.PUT_LINE(TEMP.COMPANY_NAME||' '||TEMP.MANAGER_NAME||' '||Z.TOTAL_EMPLOYEE);
        END LOOP;
    END LOOP;
END;
/
SELECT * FROM EMP1;
SELECT * FROM WORKS;
SELECT * FROM COMPANY;
COMMIT;



