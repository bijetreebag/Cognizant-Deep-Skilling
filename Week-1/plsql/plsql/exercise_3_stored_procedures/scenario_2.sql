-- exercise_3_stored_procedures/scenario_2.sql
-- Scenario 2: Update employee salaries with a bonus percentage.
--
-- Business Logic:
-- Write a stored procedure UpdateEmployeeBonus that updates the salary of employees 
-- in a given department by adding a bonus percentage passed as a parameter.
--
-- Humanized Features:
-- - Validates that the bonus percentage is non-negative and department is not null.
-- - Employs a cursor loop to fetch and lock the matching employees.
-- - Provides clear logging of old vs. new salaries for each affected employee.
-- - Gracefully handles cases where the department has no employees.

CREATE OR REPLACE PROCEDURE UpdateEmployeeBonus (
    p_department       IN VARCHAR2,
    p_bonus_percentage IN NUMBER
) IS
    v_updated_count    NUMBER := 0;
    
    -- Custom Exceptions
    e_invalid_bonus    EXCEPTION;
    e_null_department  EXCEPTION;
    
    -- Cursor to select employees in the department
    CURSOR c_dept_employees IS
        SELECT EmployeeID, Name, Salary
        FROM Employees
        WHERE Department = p_department
        FOR UPDATE;
BEGIN
    -- 1. Validations
    IF p_department IS NULL THEN
        RAISE e_null_department;
    END IF;
    
    IF p_bonus_percentage IS NULL OR p_bonus_percentage < 0 THEN
        RAISE e_invalid_bonus;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('--- Processing Bonus for Department: ' || p_department || ' (' || p_bonus_percentage || '% Bonus) ---');
    
    FOR r_emp IN c_dept_employees LOOP
        DECLARE
            v_bonus_amount NUMBER;
            v_new_salary   NUMBER;
        BEGIN
            v_bonus_amount := r_emp.Salary * (p_bonus_percentage / 100);
            v_new_salary   := r_emp.Salary + v_bonus_amount;
            
            UPDATE Employees
            SET Salary = v_new_salary
            WHERE EmployeeID = r_emp.EmployeeID;
            
            v_updated_count := v_updated_count + 1;
            DBMS_OUTPUT.PUT_LINE('Employee: ' || r_emp.Name || ' (ID: ' || r_emp.EmployeeID || ')');
            DBMS_OUTPUT.PUT_LINE('  - Old Salary: $' || TO_CHAR(r_emp.Salary, 'FM999,999.00'));
            DBMS_OUTPUT.PUT_LINE('  - New Salary: $' || TO_CHAR(v_new_salary, 'FM999,999.00') || ' (+$' || TO_CHAR(v_bonus_amount, 'FM999,999.00') || ')');
        END;
    END LOOP;
    
    IF v_updated_count > 0 THEN
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('--- Success: Salaries updated for ' || v_updated_count || ' employee(s). ---');
    ELSE
        DBMS_OUTPUT.PUT_LINE('--- Info: No employees found in department: ' || p_department || ' ---');
    END IF;

EXCEPTION
    WHEN e_null_department THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('--- Error: Department name cannot be null. ---');
    WHEN e_invalid_bonus THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('--- Error: Bonus percentage must be positive and non-null. ---');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('--- Error: Failed to update employee bonuses. ---');
        DBMS_OUTPUT.PUT_LINE('Error Code: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Error Message: ' || SQLERRM);
END UpdateEmployeeBonus;
/
