-- exercise_6_cursors/scenario_3.sql
-- Scenario 3: Update loan interest rates based on a new policy.
--
-- Business Logic:
-- Write a PL/SQL block using an explicit cursor UpdateLoanInterestRates that 
-- fetches all loans and updates their interest rates based on the new policy.
--
-- Defined Policy:
-- - VIP customers (IsVIP = 'TRUE') receive a 1.0% interest rate reduction.
-- - Standard customers receive a 0.5% interest rate reduction.
-- - Minimum Interest Rate Floor is 2.0% (rates cannot drop below this limit).
--
-- Humanized Features:
-- - Uses an explicit cursor with a FOR UPDATE clause to fetch and lock loan records.
-- - Joins with the Customers table inside the cursor to retrieve VIP status.
-- - Applies policy conditions dynamically and updates the Loans table using WHERE CURRENT OF.
-- - Logs old vs. new rates, flagging the policy applied.
-- - Handles transactions with COMMIT and ROLLBACK.

DECLARE
    -- Explicit cursor to fetch all loans and the VIP status of the customer
    CURSOR c_loans IS
        SELECT l.LoanID, l.CustomerID, l.InterestRate, c.Name, c.IsVIP
        FROM Loans l
        JOIN Customers c ON l.CustomerID = c.CustomerID
        FOR UPDATE OF l.InterestRate;
        
    v_new_rate NUMBER;
    v_updated_count NUMBER := 0;
    
    -- Constants for policy parameters
    c_vip_discount      CONSTANT NUMBER := 1.00;
    c_standard_discount CONSTANT NUMBER := 0.50;
    c_rate_floor        CONSTANT NUMBER := 2.00;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Starting Loan Interest Rate Policy Update ---');
    
    FOR r_loan IN c_loans LOOP
        -- Determine discount based on VIP status
        IF r_loan.IsVIP = 'TRUE' THEN
            v_new_rate := r_loan.InterestRate - c_vip_discount;
            DBMS_OUTPUT.PUT_LINE('Loan ID: ' || r_loan.LoanID || ' | Customer: ' || r_loan.Name || ' (VIP)');
        ELSE
            v_new_rate := r_loan.InterestRate - c_standard_discount;
            DBMS_OUTPUT.PUT_LINE('Loan ID: ' || r_loan.LoanID || ' | Customer: ' || r_loan.Name || ' (Standard)');
        END IF;
        
        -- Enforce interest rate floor (minimum rate protection)
        IF v_new_rate < c_rate_floor THEN
            v_new_rate := c_rate_floor;
            DBMS_OUTPUT.PUT_LINE('  - Note: Rate floor enforced.');
        END IF;
        
        -- Update interest rate using WHERE CURRENT OF
        UPDATE Loans
        SET InterestRate = v_new_rate
        WHERE CURRENT OF c_loans;
        
        v_updated_count := v_updated_count + 1;
        DBMS_OUTPUT.PUT_LINE('  - Old Rate: ' || TO_CHAR(r_loan.InterestRate, 'FM99.00') || '%' || 
                             ' | New Rate: ' || TO_CHAR(v_new_rate, 'FM99.00') || '%');
    END LOOP;
    
    IF v_updated_count > 0 THEN
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('--- Success: ' || v_updated_count || ' loan(s) updated under new interest rate policy. Transaction committed. ---');
    ELSE
        DBMS_OUTPUT.PUT_LINE('--- Info: No loans found to update. ---');
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('--- Error: Loan interest rate policy update failed. Transaction rolled back. ---');
        DBMS_OUTPUT.PUT_LINE('Error Code: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Error Message: ' || SQLERRM);
END;
/
