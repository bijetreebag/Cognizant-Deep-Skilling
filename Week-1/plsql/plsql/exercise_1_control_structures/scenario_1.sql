-- exercise_1_control_structures/scenario_1.sql
-- Scenario 1: Apply a discount to loan interest rates for customers above 60 years old.
--
-- Business Logic:
-- Write a PL/SQL block that loops through all customers, checks their age, and if they 
-- are above 60, applies a 1% discount to their current loan interest rates.
--
-- Humanized Features:
-- - Standard PL/SQL block utilizing an explicit cursor with a FOR loop (cleanest cursor handling).
-- - Age calculation uses MONTHS_BETWEEN to calculate exact age in years, avoiding leap year bugs.
-- - Logs detailed messages about which customers qualify, their current interest rate, and the new interest rate.
-- - Includes transactional security: updates are committed if they succeed, and rollback is handled in the exception block.

DECLARE
    -- Cursor to fetch customers and their corresponding loans
    CURSOR c_elderly_customer_loans IS
        SELECT c.CustomerID, c.Name, c.DOB, l.LoanID, l.InterestRate
        FROM Customers c
        JOIN Loans l ON c.CustomerID = l.CustomerID;
        
    v_age NUMBER;
    v_updated_count NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Starting Interest Rate Discount Process for Elderly Customers (> 60 years old) ---');
    
    -- Iterate through all customer-loan records
    FOR r_loan IN c_elderly_customer_loans LOOP
        -- Calculate age in years
        v_age := MONTHS_BETWEEN(SYSDATE, r_loan.DOB) / 12;
        
        -- Check if the customer is above 60
        IF v_age > 60 THEN
            DBMS_OUTPUT.PUT_LINE('Customer: ' || r_loan.Name || ' (Age: ' || ROUND(v_age, 1) || ')');
            DBMS_OUTPUT.PUT_LINE('  - Loan ID: ' || r_loan.LoanID || ' | Current Interest Rate: ' || r_loan.InterestRate || '%');
            
            -- Apply the 1% discount
            UPDATE Loans
            SET InterestRate = InterestRate - 1
            WHERE LoanID = r_loan.LoanID;
            
            v_updated_count := v_updated_count + 1;
            DBMS_OUTPUT.PUT_LINE('  - Interest Rate updated to: ' || (r_loan.InterestRate - 1) || '%');
        END IF;
    END LOOP;
    
    -- Commit the changes if updates were made
    IF v_updated_count > 0 THEN
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('--- Success: Interest rates updated for ' || v_updated_count || ' loan(s). Transaction committed. ---');
    ELSE
        DBMS_OUTPUT.PUT_LINE('--- Info: No loans found for customers above 60 years of age. ---');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('--- Error: Process failed. Transaction rolled back. ---');
        DBMS_OUTPUT.PUT_LINE('Error Code: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Error Message: ' || SQLERRM);
END;
/
