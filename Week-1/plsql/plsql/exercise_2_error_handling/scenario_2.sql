-- exercise_2_error_handling/scenario_2.sql
-- Scenario 2: Stored procedure UpdateSalary with ID existence validation.
--
-- Business Logic:
-- Write a stored procedure UpdateSalary that increases the salary of an employee 
-- by a given percentage. If the employee ID does not exist, handle the exception 
-- and log an error message.
--
-- Humanized Features:
-- - Validates that the input percentage is positive/reasonable.
-- - Performs a SELECT FOR UPDATE to verify employee existence. If not found, 
--   raises NO_DATA_FOUND automatically.
-- - Logs a detailed update message showing the employee's name, old salary, and new salary.
-- - Handles the NO_DATA_FOUND exception explicitly with a user-friendly log.

CREATE OR REPLACE PROCEDURE UpdateSalary (
    p_emp_id     IN NUMBER,
    p_percentage IN NUMBER
) IS
    v_emp_name   Employees.Name%TYPE;
    v_old_salary Employees.Salary%TYPE;
    v_new_salary Employees.Salary%TYPE;
    
    e_invalid_percentage EXCEPTION;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Salary Update Request for Employee ID: ' || p_emp_id || ' ---');
    
    -- 1. Validate percentage
    IF p_percentage < -100 OR p_percentage IS NULL THEN
        RAISE e_invalid_percentage;
    END IF;
    
    -- 2. Check for employee existence and lock row
    SELECT Name, Salary INTO v_emp_name, v_old_salary
    FROM Employees
    WHERE EmployeeID = p_emp_id
    FOR UPDATE;
    
    -- 3. Calculate new salary and update
    v_new_salary := v_old_salary * (1 + (p_percentage / 100));
    
    UPDATE Employees
    SET Salary = v_new_salary
    WHERE EmployeeID = p_emp_id;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('--- Success: Salary updated for ' || v_emp_name || ' (ID: ' || p_emp_id || ') ---');
    DBMS_OUTPUT.PUT_LINE('  - Old Salary: $' || TO_CHAR(v_old_salary, 'FM999,999.00'));
    DBMS_OUTPUT.PUT_LINE('  - New Salary: $' || TO_CHAR(v_new_salary, 'FM999,999.00') || ' (' || p_percentage || '% change)');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('--- Error: Employee ID ' || p_emp_id || ' does not exist in the database. ---');
    WHEN e_invalid_percentage THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('--- Error: Invalid percentage value. Must be greater than -100%. ---');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('--- Error: Salary update failed. ---');
        DBMS_OUTPUT.PUT_LINE('Error Code: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Error Message: ' || SQLERRM);
END UpdateSalary;
/
