-- exercise_7_packages/scenario_2.sql
-- Scenario 2: EmployeeManagement package specification and body.
--
-- Business Logic:
-- Write a package EmployeeManagement with:
-- 1. Procedure HireEmployee to insert a new employee.
-- 2. Procedure UpdateEmployee to update an employee's details (Name, Position, Salary, Department).
-- 3. Function CalculateAnnualSalary to get the annual salary (Salary * 12) of a given employee.
--
-- Humanized Features:
-- - Separates package specification (interface) and body (implementation).
-- - Validates employee inputs (e.g. salary cannot be negative).
-- - Traps duplicates and missing records, throwing clear log warnings.
-- - Includes transactional safety (COMMIT/ROLLBACK).

CREATE OR REPLACE PACKAGE EmployeeManagement AS
    -- Procedure to hire a new employee
    PROCEDURE HireEmployee(
        p_emp_id      IN NUMBER,
        p_name        IN VARCHAR2,
        p_position    IN VARCHAR2,
        p_salary      IN NUMBER,
        p_department  IN VARCHAR2,
        p_hire_date   IN DATE
    );

    -- Procedure to update employee details
    PROCEDURE UpdateEmployee(
        p_emp_id      IN NUMBER,
        p_name        IN VARCHAR2,
        p_position    IN VARCHAR2,
        p_salary      IN NUMBER,
        p_department  IN VARCHAR2
    );

    -- Function to calculate the annual salary of an employee
    FUNCTION CalculateAnnualSalary(
        p_emp_id      IN NUMBER
    ) RETURN NUMBER;
END EmployeeManagement;
/

CREATE OR REPLACE PACKAGE BODY EmployeeManagement AS

    -- Implementation of HireEmployee
    PROCEDURE HireEmployee(
        p_emp_id      IN NUMBER,
        p_name        IN VARCHAR2,
        p_position    IN VARCHAR2,
        p_salary      IN NUMBER,
        p_department  IN VARCHAR2,
        p_hire_date   IN DATE
    ) IS
        e_negative_salary EXCEPTION;
    BEGIN
        IF p_salary < 0 THEN
            RAISE e_negative_salary;
        END IF;

        INSERT INTO Employees (EmployeeID, Name, Position, Salary, Department, HireDate)
        VALUES (p_emp_id, p_name, p_position, p_salary, p_department, p_hire_date);
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('EmployeeManagement.HireEmployee: Successfully hired employee ID ' || p_emp_id || ' (' || p_name || ')');
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('EmployeeManagement.HireEmployee: Error - Employee with ID ' || p_emp_id || ' already exists.');
        WHEN e_negative_salary THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('EmployeeManagement.HireEmployee: Error - Employee salary cannot be negative.');
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('EmployeeManagement.HireEmployee: Unexpected Error - ' || SQLERRM);
    END HireEmployee;

    -- Implementation of UpdateEmployee
    PROCEDURE UpdateEmployee(
        p_emp_id      IN NUMBER,
        p_name        IN VARCHAR2,
        p_position    IN VARCHAR2,
        p_salary      IN NUMBER,
        p_department  IN VARCHAR2
    ) IS
        e_negative_salary EXCEPTION;
    BEGIN
        IF p_salary < 0 THEN
            RAISE e_negative_salary;
        END IF;

        UPDATE Employees
        SET Name = p_name,
            Position = p_position,
            Salary = p_salary,
            Department = p_department
        WHERE EmployeeID = p_emp_id;
        
        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('EmployeeManagement.UpdateEmployee: Warning - No employee found with ID ' || p_emp_id);
        ELSE
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('EmployeeManagement.UpdateEmployee: Successfully updated employee ID ' || p_emp_id);
        END IF;
    EXCEPTION
        WHEN e_negative_salary THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('EmployeeManagement.UpdateEmployee: Error - Employee salary cannot be negative.');
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('EmployeeManagement.UpdateEmployee: Unexpected Error - ' || SQLERRM);
    END UpdateEmployee;

    -- Implementation of CalculateAnnualSalary
    FUNCTION CalculateAnnualSalary(
        p_emp_id      IN NUMBER
    ) RETURN NUMBER IS
        v_monthly_salary NUMBER;
    BEGIN
        SELECT Salary INTO v_monthly_salary
        FROM Employees
        WHERE EmployeeID = p_emp_id;
        
        -- Annual Salary = Monthly Salary * 12
        RETURN v_monthly_salary * 12;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('EmployeeManagement.CalculateAnnualSalary: Error - Employee ID ' || p_emp_id || ' not found.');
            RETURN NULL;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('EmployeeManagement.CalculateAnnualSalary: Unexpected Error - ' || SQLERRM);
            RETURN NULL;
    END CalculateAnnualSalary;

END EmployeeManagement;
/
